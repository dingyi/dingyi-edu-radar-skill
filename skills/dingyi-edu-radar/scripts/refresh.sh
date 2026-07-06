#!/usr/bin/env bash
# refresh.sh — 重新抓取 edumails.cn 的多个分类并重建 dingyi-edu-radar skill 的内容。
#
# 覆盖分类:
#   /us  — edu 国外教育优惠（用 edu 邮箱能享受的产品优惠）
#   /edu — edu 邮箱申请教程（各大学/机构的 edu 邮箱申请方法）
#
# 用法:
#   ./scripts/refresh.sh           # 增量更新（只下载新的/变更的文章）
#   ./scripts/refresh.sh --full    # 全量重建（删除 references/ 后重新抓取全部）
#
# 退出码: 0 成功; 非 0 失败（见末尾输出）。
set -euo pipefail

# --- 解析脚本所在位置，定位 skill 根目录 ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REF_DIR="$SKILL_DIR/references"

# --- 依赖检查 ---
command -v curl  >/dev/null || { echo "ERROR: 需要 curl"; exit 1; }
PYTHON="${PYTHON:-python3}"
"$PYTHON" -c "import bs4, lxml" 2>/dev/null || {
  echo "ERROR: python3 缺少 bs4 / lxml，请运行: pip3 install --user --break-system-packages beautifulsoup4 lxml"
  exit 1
}

# --- 工作目录（临时） ---
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/articles"

UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
BASE="https://www.edumails.cn"
# 要抓取的分类（slug）。/us = 国外优惠, /edu = edu邮箱申请教程
CATEGORIES=(us edu)

echo "[1/5] 抓取分类列表页..."
# 抓取每个分类的所有列表页，聚合去重
: > "$WORK/links.txt"
for cat in "${CATEGORIES[@]}"; do
  rm -f "$WORK"/list_${cat}_*.html
  curl -sL -A "$UA" "$BASE/$cat" -o "$WORK/list_${cat}_1.html"
  idx=2
  while :; do
    code=$(curl -s -o "$WORK/list_${cat}_${idx}.html" -w "%{http_code}" -A "$UA" "$BASE/$cat/page/$idx")
    sz=$(wc -c < "$WORK/list_${cat}_${idx}.html" || echo 0)
    if [ "$code" != "200" ] || [ "$sz" -lt 1000 ]; then
      rm -f "$WORK/list_${cat}_${idx}.html"
      break
    fi
    idx=$((idx + 1))
  done
  # 注意: /edu 分类下很多文章的 slug 是中文 URL（百分号编码，如 %e7%be%8e...），
  # 正则必须包含 % 字符才能匹配；并排除 wp-* 等非文章链接。
  cnt=$(grep -hoE "$BASE/[a-z0-9%_-]+\.html" "$WORK"/list_${cat}_*.html \
        | grep -vE 'wp-content|wp-json|wp-includes|wp-admin|/themes/|/assets/' \
        | sort -u | tee -a "$WORK/links_cat_${cat}.txt" | wc -l | tr -d ' ')
  echo "    分类 /$cat: $cnt 篇"
done
sort -u "$WORK"/links_cat_*.txt -o "$WORK/links.txt"
TOTAL=$(wc -l < "$WORK/links.txt" | tr -d ' ')
echo "    合计去重: $TOTAL 篇"

# --- 全量模式: 清空 references ---
if [ "${1:-}" = "--full" ]; then
  echo "[!] 全量模式: 清空 references/"
  rm -rf "$REF_DIR"
  mkdir -p "$REF_DIR"
fi
mkdir -p "$REF_DIR"

echo "[2/5] 抓取文章 HTML（增量，仅新增/变更）..."
count=0
new=0
while IFS= read -r url; do
  slug="$(basename "$url" .html)"
  out="$REF_DIR/$slug.md"          # 最终产物
  html="$WORK/articles/$slug.html"
  curl -sL -A "$UA" "$url" -o "$html"
  count=$((count + 1))
  [ $((count % 25)) -eq 0 ] && echo "    $count / $TOTAL"
  sleep 0.25
done < "$WORK/links.txt"
echo "    抓取完成: $count 篇"

echo "[3/5] 解析为 Markdown..."
PARSE="$WORK/parse.py"
cat > "$PARSE" <<'PYEOF'
import os, re, json, sys
from bs4 import BeautifulSoup, NavigableString

WORK = os.environ['WORK']; REF_DIR = os.environ['REF_DIR']
links = {}
with open(os.path.join(WORK, 'links.txt')) as f:
    for line in f:
        line = line.strip()
        if not line: continue
        slug = line.rsplit('/', 1)[-1].replace('.html', '')
        links[slug] = line

def get_article(soup):
    art = soup.find('article')
    if not art:
        for sel in ('.article-content', '.entry-content', '.post-content', '.article', '#content'):
            art = soup.select_one(sel)
            if art: return art
    return art

def clean(t):
    t = t.replace('\xa0', ' ')
    t = re.sub(r'[ \t]+', ' ', t)
    t = re.sub(r'\n{3,}', '\n\n', t)
    return t.strip()

def to_md(node):
    out = []
    for c in node.children:
        if isinstance(c, NavigableString):
            t = str(c).strip()
            if t: out.append(t)
            continue
        n = c.name
        if n in ('script', 'style', 'nav', 'noscript', 'iframe'): continue
        if n in ('h1','h2','h3','h4'):
            t = c.get_text(' ', strip=True)
            if t: out.append('\n' + '#'*int(n[1]) + ' ' + t + '\n')
        elif n == 'p':
            i = to_md(c).strip()
            if i: out.append(i + '\n')
        elif n == 'li':
            i = to_md(c).strip()
            if i: out.append('- ' + i)
        elif n in ('ul','ol'):
            i = to_md(c).strip()
            if i: out.append(i + '\n')
        elif n in ('strong','b'):
            i = c.get_text(' ', strip=True)
            if i: out.append('**' + i + '**')
        elif n in ('em','i'):
            i = c.get_text(' ', strip=True)
            if i: out.append('*' + i + '*')
        elif n == 'a':
            i = c.get_text(' ', strip=True); href = c.get('href','')
            if i and href: out.append(f'[{i}]({href})')
            elif i: out.append(i)
        elif n == 'br': out.append('\n')
        elif n == 'blockquote':
            i = to_md(c).strip()
            if i: out.append('> ' + i + '\n')
        elif n == 'table':
            rows = []
            for tr in c.find_all('tr'):
                cells = [td.get_text(' ', strip=True) for td in tr.find_all(['td','th'])]
                rows.append(' | '.join(x for x in cells if x is not None))
            if rows: out.append('\n'.join(rows) + '\n')
        else:
            i = to_md(c)
            if i.strip(): out.append(i)
    return clean('\n'.join(out))

def kw(title):
    t = re.sub(r'[（(].*?[)）]', '', title)
    t = re.sub(r'(教育优惠|教育版|教育计划|教育认证|教程|攻略|申请|注册|图文|详解|全攻略|免费|原创|首发|最新|本站|独家|永久更新|购买指南)', '', t)
    return t.strip()

results = []
for slug, url in sorted(links.items()):
    html_path = os.path.join(WORK, 'articles', slug + '.html')
    if not os.path.exists(html_path): continue
    try:
        with open(html_path, encoding='utf-8', errors='ignore') as f:
            soup = BeautifulSoup(f.read(), 'lxml')
    except Exception as e:
        print(f'ERR {slug}: {e}', file=sys.stderr); continue

    title = None
    og = soup.find('meta', property='og:title')
    if og: title = og.get('content','').strip()
    if not title:
        t = soup.find('title')
        if t: title = t.text.split('-EDU')[0].split(' - ')[0].strip()
    if not title:
        h1 = soup.find('h1')
        if h1: title = h1.text.strip()

    desc = ''
    dm = soup.find('meta', attrs={'name':'description'}) or soup.find('meta', property='og:description')
    if dm: desc = dm.get('content','').strip()

    art = get_article(soup)
    body = ''
    if art:
        body = to_md(art)
        lines = []
        for ln in body.split('\n'):
            s = ln.strip()
            if s in ('**](#)', '**文章目录**', '文章目录'): continue
            if re.fullmatch(r'\[隐藏\]\(#[A-Za-z0-9_]*\)', s): continue
            if re.fullmatch(r'\[[^\]]*\]\(#[A-Za-z0-9_]+\)', s): continue
            if s.startswith('文章目录'): continue
            lines.append(ln)
        body = re.sub(r'\n{3,}', '\n\n', '\n'.join(lines)).strip()

    md = f'# {title}\n\n'
    if desc: md += f'> {desc}\n\n'
    md += f'来源: {url}\n\n---\n\n{body}\n'
    with open(os.path.join(REF_DIR, slug + '.md'), 'w', encoding='utf-8') as f:
        f.write(md)

    results.append({'slug': slug, 'title': title or slug, 'kw': kw(title or slug),
                    'desc': desc, 'file': 'references/' + slug + '.md'})

results.sort(key=lambda r: r['slug'])
print(f'    解析: {len(results)} 篇, {sum(len(r["desc"]) for r in results)} chars desc')

# 写 catalog.json 到 skill 根
cat = [{'slug': r['slug'], 'title': r['title'], 'kw': r['kw'], 'file': r['file']} for r in results]
with open(os.path.join(REF_DIR, '..', 'catalog.json'), 'w', encoding='utf-8') as f:
    json.dump(cat, f, ensure_ascii=False, indent=2)

# 保存结果给 shell 用
with open(os.path.join(WORK, 'result.json'), 'w') as f:
    json.dump({'count': len(results)}, f)
PYEOF

WORK="$WORK" REF_DIR="$REF_DIR" "$PYTHON" "$PARSE"
RES="$(cat "$WORK/result.json")"
echo "    $RES"

echo "[4/5] 清理已失效文章..."
# 删除 references/ 里不在最新链接列表里的旧 .md
comm -23 \
  <(ls "$REF_DIR"/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort) \
  <(sed 's#.*/##; s/\.html$//' "$WORK/links.txt" | sort) \
  | while IFS= read -r stale; do
      rm -f "$REF_DIR/$stale.md"
      echo "    - 删除失效: $stale"
    done
echo "    references/ 现存: $(ls "$REF_DIR"/*.md | wc -l | tr -d ' ') 篇"

echo "[5/5] 完成。"
echo "  skill 目录: $SKILL_DIR"
echo "  文章数: $(ls "$REF_DIR"/*.md | wc -l | tr -d ' ')"
echo "  下次自动刷新由 launchd 周一 03:00 触发 (cn.bao.edumails-radar-refresh)。"
