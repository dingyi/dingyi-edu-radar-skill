# CIBERSORTx免疫细胞浸润分析工具edu教育邮箱注册申请原创教程

> CIBERSORTx免疫细胞浸润分析工具edu教育邮箱

来源: https://www.edumails.cn/cibersortx.html

---

# 前言介绍

CIBERSORT 由斯坦福大学研究团队开发，采用去卷积的算法，基于转录组数据，在混合的细胞中估算出免疫细胞的组成和丰度，目前已经引用近千次。第一版本的CIBERSORT于2015年发表在Nature Methods上，目前升级版本的CIBERSORTx于2019年发表在Nature Biotechnonogy上。

CIBERSORT 是基于线性支持向量回归（linear support vector regression）的原理对人类白细胞亚型的表达矩阵进行去卷积的一个网页版工具。多用于芯片表达矩阵，对未知混合物和含有相近的细胞类型的表达矩阵的去卷积分析优于其他方法 (LLSR,LLSR,PERT,RLR,MMAD,DSA) 。该方法仍然是基于已知参考集，提供了22种白细胞亚型的基因表达特征集—LM22. 网址链接：http://cibersort.stanford.edu/

CIBERSORT是基于线性支持向量回归的原理对免疫细胞亚型的表达矩阵进行去卷积的一个工具，可用RNA-Seq的数据来估计免疫细胞浸润情况。 用户只需要注册一个账号，就可获得500M存储数据和结果的空间。操作时，只需上传标准的表达矩阵文件即可分析免疫浸润；如果想要分析包含其他细胞类型的浸润比例，则需按照官网提示的格式上传相应的文件。

# 工具特点

单细胞 RNA 测序已成为现代医学研究的有力技术，使得科学家可以研究单个细胞的表达及行为，比如癌症等疾病。但是该项技术还无法用于保存的组织样本，并且价格昂贵，无法大规模应用于临床常规检测。

为了解决这些缺点，斯坦福大学医学院的研究人员发明了一种名为 CIBERSORTx 的计算软件，可以直接从全组织样本或数据集中分析单个细胞基因表达。

**明确细胞类型及状态**
CIBERSORTx 在团队之前开发的软件 CIBERSORT 的基础上有了大的飞跃。Alizadeh 说到，“在原先的 CIBERSORT 版本中，可以分析一群细胞中特定分子的频率，在无需进行细胞的物理分离的情况下，告诉我们这群细胞中有哪些细胞”。“我们可以做一个类比，这就像分析水果奶昔”，纽曼说，“看不到奶昔里有什么水果，但是你可以通过品尝，知道里面有很多苹果、一点香蕉，还看到一些草莓的红色”。CIBERSORTx 进一步采用了这种原理，研究人员首先对少量的组织进行单细胞 RNA 分析，比如肿瘤组织，他们将肿瘤细胞分开，仔细观察每个细胞产生的 RNA （以及蛋白质）。通过此过程，可以得到细胞类型的 RNA 表达模式：一种“条形码”，不仅可以识别细胞类型，还可以识别它所处的亚型或工作模式。例如，相同的免疫细胞浸润肿瘤后，会产生不同的 RNA 和蛋白质，因此就会产生与外周血不同的 RNA 条形码。“ CIBERSORTx 所做的是让我们不仅知道奶昔里有多少苹果，还要告诉我们多少是小青苹果，有多少是红苹果，有多少是绿色的，有多少是紫色的”，Alizadeh 说，“同样，从肿瘤中混合的 RNA 条形码开始，可以让我们深入了解这些肿瘤中细胞类型和受影响的细胞的状态，以及我们如何解决这些缺陷用于癌症治疗”。科学家表示，这种工具不仅能够识别细胞类型，还能识别特定环境中细胞的状态或行为，进而发现新的作用机制，改善治疗方法。
研究小组用该技术分析了 1000 多个肿瘤样本，不仅发现预期中的癌细胞与正常细胞不同，而且发现浸润肿瘤的免疫细胞与循环免疫细胞的作用也不同，甚至癌细胞周围的正常结构细胞也与器官其他部位的相同类型的细胞不同。

“癌细胞正在改变肿瘤中的所有其它的细胞”，纽曼说。研究人员甚至发现，相同免疫细胞侵润不同类型肺癌后有较大差异。

CIBERSORTx 的主要优势在于它可以应用于 FFPE 组织样本（绝大多数肿瘤样本类型）。大多数的 FFPE 样品不能通过单细胞 RNA 测序进行分析，因为细胞膜被破坏或细胞不能彼此分离，由此，导致单细胞 RNA 分析对于大多数大型研究和临床试验而言是不切实际或不可能的。
**预测治疗应答**
研究人员还通过分析黑色素瘤来测试该工具的诊断能力。对于转移性黑素瘤或其他一些癌症来说，利用药物阻断侵润 T 细胞的 PD-1 和 CTLA4 蛋白是最有效的治疗手段之一，但是这些“检查点抑制剂”药物只在少数患者中效果较好，并且没有简易的方法来判断哪些患者会有应答。
之前的假设认为，如果患者的浸润 T 细胞有高水平的 PD-1 和 CTLA4 ，这些药物更有可能起作用，但研究人员难以确定这是否属实。CIBERSORTx 可以探究这个问题。在对来自少量的黑色素瘤样本的单细胞 RNA 数据进行算法训练后，研究人员分析了以前已公开的黑色素瘤肿瘤组织和测试固定样本数据集。他们证实了这一假设，发现某些 T 细胞中 PD-1 和 CTLA4 的高表达与 PD-1 阻断药物治疗患者的死亡率降低相关。研究人员说，CIBERSORTx 还可能帮助发现新的细胞标记物，为癌症治疗提供途径。使用该工具分析保存的组织样本，将细胞类型与临床结果关联起来，可能会发现对癌症生长很重要的基因和蛋白质。“发现 PD-1 和 CTLA4 为重要靶标蛋白，花费了30年时间，但使用 CIBERSORTx 将肿瘤细胞基因表达与治疗结果相关联时，这些标记物就会立即跳出来”，Alizadeh说。“我们看到了这么多新的分子，可能会被证明是有趣的”，纽曼说，“这是一个宝藏”。

# 注册流程

**CIBERSORT**
数据库需要一个非营利性机构edu教育邮箱来注册，我们打开注册地址https://cibersort.stanford.edu/register.php

如下图所示：

For Non-Commercial use only. Non-academic and commercial users should go
[here](https://cibermed.com/)
. If you are a member of an academic or non-commercial organization, please use your organization’s email. Personal (e.g. Gmail, Yahoo, Hotmail, etc.) and commercial emails ending in .com will be automatically rejected.

仅用于非商业用途。非学术和商业用户应该去
[这里](https://cibermed.com/)
。如果您是学术或非商业组织的成员，请使用您所在组织的电子邮件。以 .com 结尾的个人（例如 Gmail、Yahoo、Hotmail 等）和商业电子邮件将被自动拒绝。

我们填写信息的时候：

姓名部分：First Name* Last Name*

邮箱部分：Email* 学校名称：Organization*您的工作地点或您所属的研究机构。

组织所在城市：City* 所在街道：State or Province* 组织所属国家：Country*

## 账号验证

感谢您注册！确认电子邮件已发送至 ljaime4698@xxxx.edu

请点击激活链接来激活您的帐户。请注意，该链接将在 1 小时后过期。如果您的链接已过期，当您点击旧链接时，您将收到另一个激活链接。

我们填写完信息点击提交后，我们的edu邮箱会收到来自cibersortx的标题为：“CIBERSORTx Registration Confirmation”的验证邮件。

To activate your account, please click on this link:Activation Link，If clicking on this link does not work, please copy the link below and paste it into your browser。

## 审核成功

我们验证完后，账号并不能马上使用，需要cibersortx的官方人工审核批准，等人工审核批准通过后才能登录使用，同时会收到通知邮件。
我们如果使用美国edu邮箱是直接秒过cibersortx的。

Approved: CIBERSORTx Account Activation Request

Your request for CIBERSORTx account activation has been approved. You may now log in to the
[CIBERSORTx website](https://cibersortx.stanford.edu/)
.

## 简单使用

第一步，上传数据，如下图所示，点击
**Menu—Upload files—Add files**
上传txt数据，数据格式详见示例数据。

**第二步**
，配置参数，准备运行，点击
**Menu—Run CIBERSORTx—2.Impute Cell Fractions**
，具体的配置如下：

为了加速运行的速度，Permutations for significance analysis这里选择了50次：

**第三步**
，运行一段时间之后，可以看到结果，
**Menu—Job Results**
，点击CSV或者XLSX可得到预测的结果，即为
**模块一**
的输出数据。

## 邮箱获取

本教程采用的的edumail.vip官方购买平台的美国系列教育邮箱，终身使用，免FQ，国内可登录使用，平台还顺便帮忙注册cibersortx账号，所以很方便快捷。

[edu教育网邮箱代注册代申请购买价格](https://www.stulink.cn/edu.html)
