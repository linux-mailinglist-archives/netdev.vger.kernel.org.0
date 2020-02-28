Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8052173120
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 07:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgB1Gez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 01:34:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35923 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgB1Gey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 01:34:54 -0500
Received: by mail-wr1-f67.google.com with SMTP id j16so1671468wrt.3
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 22:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZYfU/suYA10Js77ADxKgj+uBzhoqwsZXzCNSC96+acY=;
        b=dnsdfZnM2sQq/kc97ASCVy1mFob9YQsQP49tkbIlZrZmV26EU5KBsxnyR1MN4pt/jt
         xqW0Z4yUr/+5yfxieUNT6fe1knNyTaBjuB8xej3o6F1sbbco1xtXDGVhCIY9/yaYWp8o
         /IkEok+RF1j6bJWnSfjR86z2iIpHAzSul8ZBdz4U5gIpLPCt24PIlp7OCmWCDYywbph2
         kZNDCGYeAotcF5ul6wVKAhC5ftkPxJ7hgL/MrbHTWUfDOZFuc133KEtUyHO+LPbVSgI5
         fV7WffVNXZ3+hNqrZNst0uKTg+nPpE1obo/H+0JFpus/ZTjSGPmMvRXRhyAtsTbTOEmI
         Sl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZYfU/suYA10Js77ADxKgj+uBzhoqwsZXzCNSC96+acY=;
        b=d9DLhlJJWLrANXzG2dczNROUhVueP1YA4q6MWw7sYCkCEDKZYeVbpaB3ML2nmGrwUK
         /rkE66bLR7NhPLcWBxjYqAc/FHh+RC31/Eq1mULumE080pjwgFOZk9Evxbry4S03XLpV
         QNxtDtKv7+am2m1z7ouhnbYfY+ePfkmH7rdSot4MkdbScW0tGMjMm2omFgSqu9WgYiFM
         Ga08viHxjJHE+SvS8dMyMpjyC4HkV8fwpknsBwN1VCAjJEYmPtmMaKLb7G/NKneH3xSS
         vMFmm3O4PHwHsZa0EIY3BSrRe/iATnls/2aOerxvOiYXP5xYXYWj5+BT2pbEpx3Sf/Hg
         xIRg==
X-Gm-Message-State: APjAAAUvpxDumQjfrJ+F1Yl5fUC32gdYRlIOslBM0guI9vtXnOiWTqk8
        ZM0iNRo6t6WQLQIA5eWdVoXOog==
X-Google-Smtp-Source: APXvYqwY5Vm4r+HiSlCbifsLcVw86JzB9YFJ2kZR04EDnSc7AHw6NhkPbsTXBR+WcI6YnD4zRukmnA==
X-Received: by 2002:adf:8382:: with SMTP id 2mr3000703wre.243.1582871692663;
        Thu, 27 Feb 2020 22:34:52 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g206sm748034wme.46.2020.02.27.22.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 22:34:52 -0800 (PST)
Date:   Fri, 28 Feb 2020 07:34:51 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Message-ID: <20200228063451.GH26061@nanopsycho>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200226155423.GC26061@nanopsycho>
 <20200227213150.GA9372@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227213150.GA9372@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 27, 2020 at 10:32:00PM CET, vadym.kochan@plvision.eu wrote:
>Hi Jiri,
>
>On Wed, Feb 26, 2020 at 04:54:23PM +0100, Jiri Pirko wrote:
>> Tue, Feb 25, 2020 at 05:30:54PM CET, vadym.kochan@plvision.eu wrote:
>> >Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
>> >ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
>> >wireless SMB deployment.
>> >
>> >This driver implementation includes only L1 & basic L2 support.
>> >
>> >The core Prestera switching logic is implemented in prestera.c, there is
>> >an intermediate hw layer between core logic and firmware. It is
>> >implemented in prestera_hw.c, the purpose of it is to encapsulate hw
>> >related logic, in future there is a plan to support more devices with
>> >different HW related configurations.
>> >
>> >The following Switchdev features are supported:
>> >
>> >    - VLAN-aware bridge offloading
>> >    - VLAN-unaware bridge offloading
>> >    - FDB offloading (learning, ageing)
>> >    - Switchport configuration
>> >
>> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>> >Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
>> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>> >Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
>> >Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
>> >Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
>> >Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
>> >---
>> > drivers/net/ethernet/marvell/Kconfig          |    1 +
>> > drivers/net/ethernet/marvell/Makefile         |    1 +
>> > drivers/net/ethernet/marvell/prestera/Kconfig |   13 +
>> > .../net/ethernet/marvell/prestera/Makefile    |    3 +
>> > .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
>> > .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
>> > .../marvell/prestera/prestera_drv_ver.h       |   23 +
>> > .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
>> > .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
>> > .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
>> > 10 files changed, 4257 insertions(+)
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_ver.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
>> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
>> >
>> >diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
>> >index 3d5caea096fb..74313d9e1fc0 100644
>> >--- a/drivers/net/ethernet/marvell/Kconfig
>> >+++ b/drivers/net/ethernet/marvell/Kconfig
>> >@@ -171,5 +171,6 @@ config SKY2_DEBUG
>> > 
>> > 
>> > source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
>> >+source "drivers/net/ethernet/marvell/prestera/Kconfig"
>> > 
>> > endif # NET_VENDOR_MARVELL
>> >diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
>> >index 89dea7284d5b..9f88fe822555 100644
>> >--- a/drivers/net/ethernet/marvell/Makefile
>> >+++ b/drivers/net/ethernet/marvell/Makefile
>> >@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) += pxa168_eth.o
>> > obj-$(CONFIG_SKGE) += skge.o
>> > obj-$(CONFIG_SKY2) += sky2.o
>> > obj-y		+= octeontx2/
>> >+obj-y		+= prestera/
>> >diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
>> >new file mode 100644
>> >index 000000000000..d0b416dcb677
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
>> >@@ -0,0 +1,13 @@
>> >+# SPDX-License-Identifier: GPL-2.0-only
>> >+#
>> >+# Marvell Prestera drivers configuration
>> >+#
>> >+
>> >+config PRESTERA
>> >+	tristate "Marvell Prestera Switch ASICs support"
>> >+	depends on NET_SWITCHDEV && VLAN_8021Q
>> >+	---help---
>> >+	  This driver supports Marvell Prestera Switch ASICs family.
>> >+
>> >+	  To compile this driver as a module, choose M here: the
>> >+	  module will be called prestera_sw.
>> >diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
>> >new file mode 100644
>> >index 000000000000..9446298fb7f4
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/Makefile
>> >@@ -0,0 +1,3 @@
>> >+# SPDX-License-Identifier: GPL-2.0
>> >+obj-$(CONFIG_PRESTERA)	+= prestera_sw.o
>> >+prestera_sw-objs	:= prestera.o prestera_hw.o prestera_switchdev.o
>> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera.c b/drivers/net/ethernet/marvell/prestera/prestera.c
>> >new file mode 100644
>> >index 000000000000..12d0eb590bbb
>> >--- /dev/null
>> >+++ b/drivers/net/ethernet/marvell/prestera/prestera.c
>> >@@ -0,0 +1,1502 @@
>> >+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
>> >+ *
>> >+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved.
>> >+ *
>> >+ */
>> >+#include <linux/kernel.h>
>> >+#include <linux/module.h>
>> >+#include <linux/list.h>
>> >+#include <linux/netdevice.h>
>> >+#include <linux/netdev_features.h>
>> >+#include <linux/etherdevice.h>
>> >+#include <linux/ethtool.h>
>> >+#include <linux/jiffies.h>
>> >+#include <net/switchdev.h>
>> >+
>> >+#include "prestera.h"
>> >+#include "prestera_hw.h"
>> >+#include "prestera_drv_ver.h"
>> >+
>> >+#define MVSW_PR_MTU_DEFAULT 1536
>> >+
>> >+#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
>> >+#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u64))
>> 
>> Keep the prefix for all defines withing the file. "PORT_STATS_CNT"
>> looks way to generic on the first look.
>> 
>> 
>> >+#define PORT_STATS_IDX(name) \
>> >+	(offsetof(struct mvsw_pr_port_stats, name) / sizeof(u64))
>> >+#define PORT_STATS_FIELD(name)	\
>> >+	[PORT_STATS_IDX(name)] = __stringify(name)
>> >+
>> >+static struct list_head switches_registered;
>> >+
>> >+static const char mvsw_driver_kind[] = "prestera_sw";
>> 
>> Please be consistent. Make your prefixes, name, filenames the same.
>> For example:
>> prestera_driver_kind[] = "prestera";
>> 
>> Applied to the whole code.
>> 
>So you suggested to use prestera_ as a prefix, I dont see a problem
>with that, but why not mvsw_pr_ ? So it has the vendor, device name parts

Because of "sw" in the name. You have the directory named "prestera",
the modules are named "prestera_*", for the consistency sake the
prefixes should be "prestera_". "mvsw_" looks totally unrelated.


>together as a key. Also it is necessary to apply prefix for the static
>names ?

Yes please. Be consistent within the whole code. This is handy when
seeing traces.


>
>> 
>> >+static const char mvsw_driver_name[] = "mvsw_switchdev";
>> 
>> Why is this different from kind?
>> 
>> Also, don't mention "switchdev" anywhere.
>> 
>> 
>> >+static const char mvsw_driver_version[] = PRESTERA_DRV_VER;
>> 
>> [...]
>> 
>> 
>> >+static void mvsw_pr_port_remote_cap_get(struct ethtool_link_ksettings *ecmd,
>> >+					struct mvsw_pr_port *port)
>> >+{
>> >+	u64 bitmap;
>> >+
>> >+	if (!mvsw_pr_hw_port_remote_cap_get(port, &bitmap)) {
>> >+		mvsw_modes_to_eth(ecmd->link_modes.lp_advertising,
>> >+				  bitmap, 0, MVSW_PORT_TYPE_NONE);
>> >+	}
>> 
>> Don't use {} for single statement. checkpatch.pl should warn you about
>> this.
>> 
>> 
>> 
>> >+}
>> >+
>> >+static void mvsw_pr_port_duplex_get(struct ethtool_link_ksettings *ecmd,
>> >+				    struct mvsw_pr_port *port)
>> >+{
>> >+	u8 duplex;
>> >+
>> >+	if (!mvsw_pr_hw_port_duplex_get(port, &duplex)) {
>> >+		ecmd->base.duplex = duplex == MVSW_PORT_DUPLEX_FULL ?
>> >+				    DUPLEX_FULL : DUPLEX_HALF;
>> >+	} else {
>> >+		ecmd->base.duplex = DUPLEX_UNKNOWN;
>> >+	}
>> 
>> Same here.
>> 
>> 
>> >+}
>> 
>> [...]
>> 
>> 
>> >+static void __exit mvsw_pr_module_exit(void)
>> >+{
>> >+	destroy_workqueue(mvsw_pr_wq);
>> >+
>> >+	pr_info("Unloading Marvell Prestera Switch Driver\n");
>> 
>> No prints like this please.
>> 
>> 	
>> 	
>> >+}
>> >+
>> >+module_init(mvsw_pr_module_init);
>> >+module_exit(mvsw_pr_module_exit);
>> >+
>> >+MODULE_AUTHOR("Marvell Semi.");
>> 
>> Does not look so :)
>> 
>> 
>> >+MODULE_LICENSE("GPL");
>> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
>> >+MODULE_VERSION(PRESTERA_DRV_VER);
>> 
>> [...]
>
>Thank you for the comments and suggestions!
>
>Regards,
>Vadym Kochan
