Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03391C23E5
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 09:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgEBHm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 03:42:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgEBHm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 03:42:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0427WhUk029695;
        Sat, 2 May 2020 03:41:43 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s38n9ncv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 03:41:42 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0427YiZt033464;
        Sat, 2 May 2020 03:41:42 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30s38n9nce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 03:41:42 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0427eHrf019578;
        Sat, 2 May 2020 07:41:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30s0g5gd34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 02 May 2020 07:41:39 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0427eSsQ59965934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 May 2020 07:40:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E744A4054;
        Sat,  2 May 2020 07:41:37 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EADCA405F;
        Sat,  2 May 2020 07:41:35 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.204.17])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat,  2 May 2020 07:41:35 +0000 (GMT)
Date:   Sat, 2 May 2020 10:41:33 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Tejun Heo <tj@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ia64@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 07/14] docs: add IRQ documentation at the core-api book
Message-ID: <20200502074133.GC342687@linux.ibm.com>
References: <cover.1588345503.git.mchehab+huawei@kernel.org>
 <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2da7485c3718e1442e6b4c2dd66857b776e8899b.1588345503.git.mchehab+huawei@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_04:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 adultscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Mauro,

On Fri, May 01, 2020 at 05:37:51PM +0200, Mauro Carvalho Chehab wrote:
> There are 4 IRQ documentation files under Documentation/*.txt.
> 
> Move them into a new directory (core-api/irq) and add a new
> index file for it.

Just curious, why IRQ docs got their subdirectory and DMA didn't :)

> While here, use a title markup for the Debugging section of the
> irq-domain.rst file.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/admin-guide/hw-vuln/l1tf.rst            |  2 +-
>  Documentation/admin-guide/kernel-per-CPU-kthreads.rst |  2 +-
>  Documentation/core-api/index.rst                      |  1 +
>  Documentation/{IRQ.txt => core-api/irq/concepts.rst}  |  0
>  Documentation/core-api/irq/index.rst                  | 11 +++++++++++
>  .../irq/irq-affinity.rst}                             |  0
>  .../{IRQ-domain.txt => core-api/irq/irq-domain.rst}   |  3 ++-
>  .../irq/irqflags-tracing.rst}                         |  0
>  Documentation/ia64/irq-redir.rst                      |  2 +-
>  Documentation/networking/scaling.rst                  |  4 ++--
>  Documentation/translations/zh_CN/IRQ.txt              |  4 ++--
>  MAINTAINERS                                           |  2 +-
>  12 files changed, 22 insertions(+), 9 deletions(-)
>  rename Documentation/{IRQ.txt => core-api/irq/concepts.rst} (100%)
>  create mode 100644 Documentation/core-api/irq/index.rst
>  rename Documentation/{IRQ-affinity.txt => core-api/irq/irq-affinity.rst} (100%)
>  rename Documentation/{IRQ-domain.txt => core-api/irq/irq-domain.rst} (99%)
>  rename Documentation/{irqflags-tracing.txt => core-api/irq/irqflags-tracing.rst} (100%)
> 
> diff --git a/Documentation/admin-guide/hw-vuln/l1tf.rst b/Documentation/admin-guide/hw-vuln/l1tf.rst
> index f83212fae4d5..3eeeb488d955 100644
> --- a/Documentation/admin-guide/hw-vuln/l1tf.rst
> +++ b/Documentation/admin-guide/hw-vuln/l1tf.rst
> @@ -268,7 +268,7 @@ Guest mitigation mechanisms
>     /proc/irq/$NR/smp_affinity[_list] files. Limited documentation is
>     available at:
>  
> -   https://www.kernel.org/doc/Documentation/IRQ-affinity.txt
> +   https://www.kernel.org/doc/Documentation/core-api/irq/irq-affinity.rst
>  
>  .. _smt_control:
>  
> diff --git a/Documentation/admin-guide/kernel-per-CPU-kthreads.rst b/Documentation/admin-guide/kernel-per-CPU-kthreads.rst
> index 21818aca4708..dc36aeb65d0a 100644
> --- a/Documentation/admin-guide/kernel-per-CPU-kthreads.rst
> +++ b/Documentation/admin-guide/kernel-per-CPU-kthreads.rst
> @@ -10,7 +10,7 @@ them to a "housekeeping" CPU dedicated to such work.
>  References
>  ==========
>  
> --	Documentation/IRQ-affinity.txt:  Binding interrupts to sets of CPUs.
> +-	Documentation/core-api/irq/irq-affinity.rst:  Binding interrupts to sets of CPUs.
>  
>  -	Documentation/admin-guide/cgroup-v1:  Using cgroups to bind tasks to sets of CPUs.
>  
> diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
> index ab056b3626f4..49a885e83a55 100644
> --- a/Documentation/core-api/index.rst
> +++ b/Documentation/core-api/index.rst
> @@ -52,6 +52,7 @@ How Linux keeps everything from happening at the same time.  See
>  
>     atomic_ops
>     refcount-vs-atomic
> +   irq/index
>     local_ops
>     padata
>     ../RCU/index
> diff --git a/Documentation/IRQ.txt b/Documentation/core-api/irq/concepts.rst
> similarity index 100%
> rename from Documentation/IRQ.txt
> rename to Documentation/core-api/irq/concepts.rst
> diff --git a/Documentation/core-api/irq/index.rst b/Documentation/core-api/irq/index.rst
> new file mode 100644
> index 000000000000..0d65d11e5420
> --- /dev/null
> +++ b/Documentation/core-api/irq/index.rst
> @@ -0,0 +1,11 @@
> +====
> +IRQs
> +====
> +
> +.. toctree::
> +   :maxdepth: 1
> +
> +   concepts
> +   irq-affinity
> +   irq-domain
> +   irqflags-tracing
> diff --git a/Documentation/IRQ-affinity.txt b/Documentation/core-api/irq/irq-affinity.rst
> similarity index 100%
> rename from Documentation/IRQ-affinity.txt
> rename to Documentation/core-api/irq/irq-affinity.rst
> diff --git a/Documentation/IRQ-domain.txt b/Documentation/core-api/irq/irq-domain.rst
> similarity index 99%
> rename from Documentation/IRQ-domain.txt
> rename to Documentation/core-api/irq/irq-domain.rst
> index 507775cce753..096db12f32d5 100644
> --- a/Documentation/IRQ-domain.txt
> +++ b/Documentation/core-api/irq/irq-domain.rst
> @@ -263,7 +263,8 @@ needs to:
>  Hierarchy irq_domain is in no way x86 specific, and is heavily used to
>  support other architectures, such as ARM, ARM64 etc.
>  
> -=== Debugging ===
> +Debugging
> +=========
>  
>  Most of the internals of the IRQ subsystem are exposed in debugfs by
>  turning CONFIG_GENERIC_IRQ_DEBUGFS on.
> diff --git a/Documentation/irqflags-tracing.txt b/Documentation/core-api/irq/irqflags-tracing.rst
> similarity index 100%
> rename from Documentation/irqflags-tracing.txt
> rename to Documentation/core-api/irq/irqflags-tracing.rst
> diff --git a/Documentation/ia64/irq-redir.rst b/Documentation/ia64/irq-redir.rst
> index 39bf94484a15..6bbbbe4f73ef 100644
> --- a/Documentation/ia64/irq-redir.rst
> +++ b/Documentation/ia64/irq-redir.rst
> @@ -7,7 +7,7 @@ IRQ affinity on IA64 platforms
>  
>  By writing to /proc/irq/IRQ#/smp_affinity the interrupt routing can be
>  controlled. The behavior on IA64 platforms is slightly different from
> -that described in Documentation/IRQ-affinity.txt for i386 systems.
> +that described in Documentation/core-api/irq/irq-affinity.rst for i386 systems.
>  
>  Because of the usage of SAPIC mode and physical destination mode the
>  IRQ target is one particular CPU and cannot be a mask of several
> diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
> index f78d7bf27ff5..8f0347b9fb3d 100644
> --- a/Documentation/networking/scaling.rst
> +++ b/Documentation/networking/scaling.rst
> @@ -81,7 +81,7 @@ of queues to IRQs can be determined from /proc/interrupts. By default,
>  an IRQ may be handled on any CPU. Because a non-negligible part of packet
>  processing takes place in receive interrupt handling, it is advantageous
>  to spread receive interrupts between CPUs. To manually adjust the IRQ
> -affinity of each interrupt see Documentation/IRQ-affinity.txt. Some systems
> +affinity of each interrupt see Documentation/core-api/irq/irq-affinity.rst. Some systems
>  will be running irqbalance, a daemon that dynamically optimizes IRQ
>  assignments and as a result may override any manual settings.
>  
> @@ -160,7 +160,7 @@ can be configured for each receive queue using a sysfs file entry::
>  
>  This file implements a bitmap of CPUs. RPS is disabled when it is zero
>  (the default), in which case packets are processed on the interrupting
> -CPU. Documentation/IRQ-affinity.txt explains how CPUs are assigned to
> +CPU. Documentation/core-api/irq/irq-affinity.rst explains how CPUs are assigned to
>  the bitmap.
>  
>  
> diff --git a/Documentation/translations/zh_CN/IRQ.txt b/Documentation/translations/zh_CN/IRQ.txt
> index 956026d5cf82..9aec8dca4fcf 100644
> --- a/Documentation/translations/zh_CN/IRQ.txt
> +++ b/Documentation/translations/zh_CN/IRQ.txt
> @@ -1,4 +1,4 @@
> -Chinese translated version of Documentation/IRQ.txt
> +Chinese translated version of Documentation/core-api/irq/index.rst
>  
>  If you have any comment or update to the content, please contact the
>  original document maintainer directly.  However, if you have a problem
> @@ -9,7 +9,7 @@ or if there is a problem with the translation.
>  Maintainer: Eric W. Biederman <ebiederman@xmission.com>
>  Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
>  ---------------------------------------------------------------------
> -Documentation/IRQ.txt 的中文翻译
> +Documentation/core-api/irq/index.rst 的中文翻译
>  
>  如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
>  交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a1d7af532950..6eb3d85a646f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8974,7 +8974,7 @@ IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
>  M:	Marc Zyngier <maz@kernel.org>
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
> -F:	Documentation/IRQ-domain.txt
> +F:	Documentation/core-api/irq/irq-domain.rst
>  F:	include/linux/irqdomain.h
>  F:	kernel/irq/irqdomain.c
>  F:	kernel/irq/msi.c
> -- 
> 2.25.4
> 

-- 
Sincerely yours,
Mike.
