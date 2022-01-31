Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C64A4D23
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380854AbiAaRZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380913AbiAaRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:25:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34699C06174A;
        Mon, 31 Jan 2022 09:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B925660FE5;
        Mon, 31 Jan 2022 17:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E931C340E8;
        Mon, 31 Jan 2022 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643649919;
        bh=XSduWaK481QLOHIWwc3CoeiVv92KkSUihbEuADOZqQA=;
        h=From:To:Cc:Subject:Date:From;
        b=TA/nuxt77ACTVa2Vmbl9pwM3b1YMULE82qg6XvniluNqw59+Z51PGrqHHkXID++nI
         QAh6KO2mKJBkMViv8RsGIqXjkhs2U6RvPQwQtYb2lSw+eiXnZBGLU+rKpERzDIu1yn
         H55aLdRu0CJtI0uaiap8wGcw1aRK+OxwiD94W6hiTAexRdM/gyA5YgjElDWpNY6N0V
         eD2Zc9FaNcVBZuK+hNkh+vPy0jRlYtgK/U+au4SpLGn/m4w0OjCb8e9tKUs0/p+jgt
         iIcZyCZ8t8w6TXR8+w7dyzQ7lxQIXNk5d3mXchmPlTaQNcQYbfnXltjccCDYZRX7e3
         7PRC0YDHErmNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Florian Fainelli <f.fainelli@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH net-next] net: kbuild: Don't default net vendor configs to y
Date:   Mon, 31 Jan 2022 09:24:50 -0800
Message-Id: <20220131172450.4905-1-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

NET_VENDOR_XYZ were defaulted to 'y' for no technical reason.

Since all drivers belonging to a vendor are supposed to default to 'n',
defaulting all vendors to 'n' shouldn't be an issue, and aligns well
with the 'no new drivers' by default mentality.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/3com/Kconfig          | 1 -
 drivers/net/ethernet/8390/Kconfig          | 1 -
 drivers/net/ethernet/adaptec/Kconfig       | 1 -
 drivers/net/ethernet/agere/Kconfig         | 1 -
 drivers/net/ethernet/alacritech/Kconfig    | 1 -
 drivers/net/ethernet/allwinner/Kconfig     | 1 -
 drivers/net/ethernet/alteon/Kconfig        | 1 -
 drivers/net/ethernet/amazon/Kconfig        | 1 -
 drivers/net/ethernet/amd/Kconfig           | 1 -
 drivers/net/ethernet/apple/Kconfig         | 1 -
 drivers/net/ethernet/aquantia/Kconfig      | 1 -
 drivers/net/ethernet/arc/Kconfig           | 1 -
 drivers/net/ethernet/asix/Kconfig          | 1 -
 drivers/net/ethernet/atheros/Kconfig       | 1 -
 drivers/net/ethernet/broadcom/Kconfig      | 1 -
 drivers/net/ethernet/brocade/Kconfig       | 1 -
 drivers/net/ethernet/cadence/Kconfig       | 1 -
 drivers/net/ethernet/cavium/Kconfig        | 1 -
 drivers/net/ethernet/chelsio/Kconfig       | 1 -
 drivers/net/ethernet/cirrus/Kconfig        | 1 -
 drivers/net/ethernet/cisco/Kconfig         | 1 -
 drivers/net/ethernet/cortina/Kconfig       | 1 -
 drivers/net/ethernet/dec/Kconfig           | 1 -
 drivers/net/ethernet/dlink/Kconfig         | 1 -
 drivers/net/ethernet/emulex/Kconfig        | 1 -
 drivers/net/ethernet/engleder/Kconfig      | 1 -
 drivers/net/ethernet/ezchip/Kconfig        | 1 -
 drivers/net/ethernet/faraday/Kconfig       | 1 -
 drivers/net/ethernet/freescale/Kconfig     | 1 -
 drivers/net/ethernet/fujitsu/Kconfig       | 1 -
 drivers/net/ethernet/google/Kconfig        | 1 -
 drivers/net/ethernet/hisilicon/Kconfig     | 1 -
 drivers/net/ethernet/huawei/Kconfig        | 1 -
 drivers/net/ethernet/i825xx/Kconfig        | 1 -
 drivers/net/ethernet/ibm/Kconfig           | 1 -
 drivers/net/ethernet/intel/Kconfig         | 1 -
 drivers/net/ethernet/litex/Kconfig         | 1 -
 drivers/net/ethernet/marvell/Kconfig       | 1 -
 drivers/net/ethernet/mellanox/Kconfig      | 1 -
 drivers/net/ethernet/micrel/Kconfig        | 1 -
 drivers/net/ethernet/microchip/Kconfig     | 1 -
 drivers/net/ethernet/microsoft/Kconfig     | 1 -
 drivers/net/ethernet/moxa/Kconfig          | 1 -
 drivers/net/ethernet/mscc/Kconfig          | 1 -
 drivers/net/ethernet/myricom/Kconfig       | 1 -
 drivers/net/ethernet/natsemi/Kconfig       | 1 -
 drivers/net/ethernet/neterion/Kconfig      | 1 -
 drivers/net/ethernet/netronome/Kconfig     | 1 -
 drivers/net/ethernet/ni/Kconfig            | 1 -
 drivers/net/ethernet/nvidia/Kconfig        | 1 -
 drivers/net/ethernet/oki-semi/Kconfig      | 1 -
 drivers/net/ethernet/packetengines/Kconfig | 1 -
 drivers/net/ethernet/pasemi/Kconfig        | 1 -
 drivers/net/ethernet/pensando/Kconfig      | 1 -
 drivers/net/ethernet/qlogic/Kconfig        | 1 -
 drivers/net/ethernet/qualcomm/Kconfig      | 1 -
 drivers/net/ethernet/rdc/Kconfig           | 1 -
 drivers/net/ethernet/realtek/Kconfig       | 1 -
 drivers/net/ethernet/renesas/Kconfig       | 1 -
 drivers/net/ethernet/rocker/Kconfig        | 1 -
 drivers/net/ethernet/samsung/Kconfig       | 1 -
 drivers/net/ethernet/seeq/Kconfig          | 1 -
 drivers/net/ethernet/sfc/Kconfig           | 1 -
 drivers/net/ethernet/sgi/Kconfig           | 1 -
 drivers/net/ethernet/silan/Kconfig         | 1 -
 drivers/net/ethernet/sis/Kconfig           | 1 -
 drivers/net/ethernet/smsc/Kconfig          | 1 -
 drivers/net/ethernet/socionext/Kconfig     | 1 -
 drivers/net/ethernet/stmicro/Kconfig       | 1 -
 drivers/net/ethernet/sun/Kconfig           | 1 -
 drivers/net/ethernet/synopsys/Kconfig      | 1 -
 drivers/net/ethernet/tehuti/Kconfig        | 1 -
 drivers/net/ethernet/ti/Kconfig            | 1 -
 drivers/net/ethernet/toshiba/Kconfig       | 1 -
 drivers/net/ethernet/tundra/Kconfig        | 1 -
 drivers/net/ethernet/vertexcom/Kconfig     | 1 -
 drivers/net/ethernet/via/Kconfig           | 1 -
 drivers/net/ethernet/wiznet/Kconfig        | 1 -
 drivers/net/ethernet/xilinx/Kconfig        | 1 -
 drivers/net/ethernet/xircom/Kconfig        | 1 -
 drivers/net/ethernet/xscale/Kconfig        | 1 -
 81 files changed, 81 deletions(-)

diff --git a/drivers/net/ethernet/3com/Kconfig b/drivers/net/ethernet/3com/Kconfig
index 706bd59bf645..a48e879b941e 100644
--- a/drivers/net/ethernet/3com/Kconfig
+++ b/drivers/net/ethernet/3com/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_3COM
 	bool "3Com devices"
-	default y
 	depends on ISA || EISA || PCI || PCMCIA
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index a4130e643342..e2fd9bd0bf15 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_8390
 	bool "National Semiconductor 8390 devices"
-	default y
 	depends on NET_VENDOR_NATSEMI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/adaptec/Kconfig b/drivers/net/ethernet/adaptec/Kconfig
index c96edc2e582f..06664de54b34 100644
--- a/drivers/net/ethernet/adaptec/Kconfig
+++ b/drivers/net/ethernet/adaptec/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ADAPTEC
 	bool "Adaptec devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/agere/Kconfig b/drivers/net/ethernet/agere/Kconfig
index 9cd750184947..623cedaeba4a 100644
--- a/drivers/net/ethernet/agere/Kconfig
+++ b/drivers/net/ethernet/agere/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_AGERE
 	bool "Agere devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/alacritech/Kconfig b/drivers/net/ethernet/alacritech/Kconfig
index 5f285e18faf7..7ed4dbb6a4b2 100644
--- a/drivers/net/ethernet/alacritech/Kconfig
+++ b/drivers/net/ethernet/alacritech/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_ALACRITECH
 	bool "Alacritech devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/allwinner/Kconfig b/drivers/net/ethernet/allwinner/Kconfig
index 3e81059f8693..c5e86a908e89 100644
--- a/drivers/net/ethernet/allwinner/Kconfig
+++ b/drivers/net/ethernet/allwinner/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ALLWINNER
 	bool "Allwinner devices"
-	default y
 
 	depends on ARCH_SUNXI
 	help
diff --git a/drivers/net/ethernet/alteon/Kconfig b/drivers/net/ethernet/alteon/Kconfig
index cfe1f3159d61..eebf3a225f05 100644
--- a/drivers/net/ethernet/alteon/Kconfig
+++ b/drivers/net/ethernet/alteon/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ALTEON
 	bool "Alteon devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
index c37fa393b99e..9d0a862feace 100644
--- a/drivers/net/ethernet/amazon/Kconfig
+++ b/drivers/net/ethernet/amazon/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_AMAZON
 	bool "Amazon Devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 899c8a2a34b6..78b8fcddf734 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_AMD
 	bool "AMD devices"
-	default y
 	depends on DIO || MACH_DECSTATION || MVME147 || ATARI || SUN3 || \
 		   SUN3X || SBUS || PCI || ZORRO || (ISA && ISA_DMA_API) || \
 		   ISA || EISA || PCMCIA || ARM64
diff --git a/drivers/net/ethernet/apple/Kconfig b/drivers/net/ethernet/apple/Kconfig
index a4176d2ecec6..769411fad5f0 100644
--- a/drivers/net/ethernet/apple/Kconfig
+++ b/drivers/net/ethernet/apple/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_APPLE
 	bool "Apple devices"
-	default y
 	depends on (PPC_PMAC && PPC32) || MAC
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/aquantia/Kconfig b/drivers/net/ethernet/aquantia/Kconfig
index cec2018c84a9..8db49cd12cfb 100644
--- a/drivers/net/ethernet/aquantia/Kconfig
+++ b/drivers/net/ethernet/aquantia/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_AQUANTIA
 	bool "aQuantia devices"
-	default y
 	help
 	  Set this to y if you have an Ethernet network cards that uses the aQuantia
 	  AQC107/AQC108 chipset.
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 0a67612af228..2b94bd928772 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ARC
 	bool "ARC devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/asix/Kconfig b/drivers/net/ethernet/asix/Kconfig
index eed02453314c..8c03ef3b1852 100644
--- a/drivers/net/ethernet/asix/Kconfig
+++ b/drivers/net/ethernet/asix/Kconfig
@@ -4,7 +4,6 @@
 
 config NET_VENDOR_ASIX
 	bool "Asix devices"
-	default y
 	help
 	  If you have a network (Ethernet, non-USB, not NE2000 compatible)
 	  interface based on a chip from ASIX, say Y.
diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
index 482c58c4c584..27719e5a2898 100644
--- a/drivers/net/ethernet/atheros/Kconfig
+++ b/drivers/net/ethernet/atheros/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ATHEROS
 	bool "Atheros devices"
-	default y
 	depends on (PCI || ATH79)
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 56e0fb07aec7..b4634c175091 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_BROADCOM
 	bool "Broadcom devices"
-	default y
 	depends on (SSB_POSSIBLE && HAS_DMA) || PCI || BCM63XX || \
 		   SIBYTE_SB1xxx_SOC
 	help
diff --git a/drivers/net/ethernet/brocade/Kconfig b/drivers/net/ethernet/brocade/Kconfig
index fb4c3cdf7233..b8c71e98d81e 100644
--- a/drivers/net/ethernet/brocade/Kconfig
+++ b/drivers/net/ethernet/brocade/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_BROCADE
 	bool "QLogic BR-series devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 5b2a461dfd28..9e1698fccd2c 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -6,7 +6,6 @@
 config NET_VENDOR_CADENCE
 	bool "Cadence devices"
 	depends on HAS_IOMEM
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/cavium/Kconfig b/drivers/net/ethernet/cavium/Kconfig
index 1c76c95b0b27..0ee3f99e0b68 100644
--- a/drivers/net/ethernet/cavium/Kconfig
+++ b/drivers/net/ethernet/cavium/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_CAVIUM
 	bool "Cavium ethernet drivers"
-	default y
 	help
 	  Select this option if you want enable Cavium network support.
 
diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
index c931ec8cac40..6377430f519a 100644
--- a/drivers/net/ethernet/chelsio/Kconfig
+++ b/drivers/net/ethernet/chelsio/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_CHELSIO
 	bool "Chelsio devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/cirrus/Kconfig b/drivers/net/ethernet/cirrus/Kconfig
index 5bdf731d9503..bebfc95fae0f 100644
--- a/drivers/net/ethernet/cirrus/Kconfig
+++ b/drivers/net/ethernet/cirrus/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_CIRRUS
 	bool "Cirrus devices"
-	default y
 	depends on ISA || EISA || ARM || MAC || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/cisco/Kconfig b/drivers/net/ethernet/cisco/Kconfig
index 18c3a0718d6f..64353561fb52 100644
--- a/drivers/net/ethernet/cisco/Kconfig
+++ b/drivers/net/ethernet/cisco/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_CISCO
 	bool "Cisco devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/cortina/Kconfig b/drivers/net/ethernet/cortina/Kconfig
index aaf9e294b70b..0da6ddd9ac89 100644
--- a/drivers/net/ethernet/cortina/Kconfig
+++ b/drivers/net/ethernet/cortina/Kconfig
@@ -3,7 +3,6 @@
 
 config NET_VENDOR_CORTINA
 	bool "Cortina Gemini devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from
diff --git a/drivers/net/ethernet/dec/Kconfig b/drivers/net/ethernet/dec/Kconfig
index 9e5e5f10bd19..1cfe23876f70 100644
--- a/drivers/net/ethernet/dec/Kconfig
+++ b/drivers/net/ethernet/dec/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_DEC
 	bool "Digital Equipment devices"
-	default y
 	depends on PCI || EISA || CARDBUS
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/dlink/Kconfig b/drivers/net/ethernet/dlink/Kconfig
index 0d77f84c8e7b..f383aaabfa10 100644
--- a/drivers/net/ethernet/dlink/Kconfig
+++ b/drivers/net/ethernet/dlink/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_DLINK
 	bool "D-Link devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/emulex/Kconfig b/drivers/net/ethernet/emulex/Kconfig
index 5797a76dc731..18ec22423d79 100644
--- a/drivers/net/ethernet/emulex/Kconfig
+++ b/drivers/net/ethernet/emulex/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_EMULEX
 	bool "Emulex devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/engleder/Kconfig b/drivers/net/ethernet/engleder/Kconfig
index f4e2b1102d8f..dbbc6b8943e3 100644
--- a/drivers/net/ethernet/engleder/Kconfig
+++ b/drivers/net/ethernet/engleder/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ENGLEDER
 	bool "Engleder devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/ezchip/Kconfig b/drivers/net/ethernet/ezchip/Kconfig
index 9241b9b1c7a3..411217ba51ea 100644
--- a/drivers/net/ethernet/ezchip/Kconfig
+++ b/drivers/net/ethernet/ezchip/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_EZCHIP
 	bool "EZchip devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
index 3d1e9a302148..c6f2ac2bb153 100644
--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_FARADAY
 	bool "Faraday devices"
-	default y
 	depends on ARM || NDS32 || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index e04e1c5cb013..336fee3bb012 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_FREESCALE
 	bool "Freescale devices"
-	default y
 	depends on FSL_SOC || QUICC_ENGINE || CPM1 || CPM2 || PPC_MPC512x || \
 		   M523x || M527x || M5272 || M528x || M520x || M532x || \
 		   ARCH_MXC || ARCH_MXS || (PPC_MPC52xx && PPC_BESTCOMM) || \
diff --git a/drivers/net/ethernet/fujitsu/Kconfig b/drivers/net/ethernet/fujitsu/Kconfig
index 0a1400cb410a..435037e34efd 100644
--- a/drivers/net/ethernet/fujitsu/Kconfig
+++ b/drivers/net/ethernet/fujitsu/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_FUJITSU
 	bool "Fujitsu devices"
-	default y
 	depends on PCMCIA
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/google/Kconfig b/drivers/net/ethernet/google/Kconfig
index 8641a00f8e63..ababdcb01bbb 100644
--- a/drivers/net/ethernet/google/Kconfig
+++ b/drivers/net/ethernet/google/Kconfig
@@ -4,7 +4,6 @@
 
 config NET_VENDOR_GOOGLE
 	bool "Google Devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/hisilicon/Kconfig
index 3312e1d93c3b..0445aa064a20 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_HISILICON
 	bool "Hisilicon devices"
-	default y
 	depends on OF || ACPI
 	depends on ARM || ARM64 || COMPILE_TEST
 	help
diff --git a/drivers/net/ethernet/huawei/Kconfig b/drivers/net/ethernet/huawei/Kconfig
index c05fce15eb51..a5b2f00403df 100644
--- a/drivers/net/ethernet/huawei/Kconfig
+++ b/drivers/net/ethernet/huawei/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_HUAWEI
 	bool "Huawei devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 	  Note that the answer to this question doesn't directly affect the
diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
index 3b5fab123824..3812783a804b 100644
--- a/drivers/net/ethernet/i825xx/Kconfig
+++ b/drivers/net/ethernet/i825xx/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_I825XX
 	bool "Intel (82586/82593/82596) devices"
-	default y
 	depends on NET_VENDOR_INTEL
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/ibm/Kconfig b/drivers/net/ethernet/ibm/Kconfig
index c0c112d95b89..dc2098fb1c8f 100644
--- a/drivers/net/ethernet/ibm/Kconfig
+++ b/drivers/net/ethernet/ibm/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_IBM
 	bool "IBM devices"
-	default y
 	depends on PPC_PSERIES || PPC_DCR || (IBMEBUS && SPARSEMEM)
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 3facb55b7161..b9fdf2a835b0 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_INTEL
 	bool "Intel devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index f99adbf26ab4..417129027b9a 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -4,7 +4,6 @@
 
 config NET_VENDOR_LITEX
 	bool "LiteX devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index fe0989c0fc25..2a3f06b9f4f7 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MARVELL
 	bool "Marvell devices"
-	default y
 	depends on PCI || CPU_PXA168 || PPC32 || PLAT_ORION || INET || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/mellanox/Kconfig b/drivers/net/ethernet/mellanox/Kconfig
index b4f66eb9ddb9..d2dd728bb016 100644
--- a/drivers/net/ethernet/mellanox/Kconfig
+++ b/drivers/net/ethernet/mellanox/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MELLANOX
 	bool "Mellanox devices"
-	default y
 	depends on PCI || I2C
 	help
 	  If you have a network (Ethernet or RDMA) device belonging to this
diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 93df3049cdc0..bf0c84117f8b 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MICREL
 	bool "Micrel devices"
-	default y
 	depends on (HAS_IOMEM && DMA_ENGINE) || SPI || PCI || HAS_IOMEM
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index ed7a35c3ceac..cfcd4cf3e14b 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MICROCHIP
 	bool "Microchip devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index fe4e7a7d9c0b..b651441c83b6 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -4,7 +4,6 @@
 
 config NET_VENDOR_MICROSOFT
 	bool "Microsoft Network Devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/moxa/Kconfig b/drivers/net/ethernet/moxa/Kconfig
index 134802b521cb..0cccb1a39ef5 100644
--- a/drivers/net/ethernet/moxa/Kconfig
+++ b/drivers/net/ethernet/moxa/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MOXART
 	bool "MOXA ART devices"
-	default y
 	depends on (ARM && ARCH_MOXART)
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index 8dd8c7f425d2..8d3e50e253d6 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: (GPL-2.0 OR MIT)
 config NET_VENDOR_MICROSEMI
 	bool "Microsemi devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/myricom/Kconfig b/drivers/net/ethernet/myricom/Kconfig
index 81267fd72dbf..fd3497219b14 100644
--- a/drivers/net/ethernet/myricom/Kconfig
+++ b/drivers/net/ethernet/myricom/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_MYRI
 	bool "Myricom devices"
-	default y
 	depends on PCI && INET
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/natsemi/Kconfig b/drivers/net/ethernet/natsemi/Kconfig
index 0a92101aa3f1..8938ac439257 100644
--- a/drivers/net/ethernet/natsemi/Kconfig
+++ b/drivers/net/ethernet/natsemi/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_NATSEMI
 	bool "National Semiconductor devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/neterion/Kconfig b/drivers/net/ethernet/neterion/Kconfig
index 0c0d127906dd..27e3dd441e31 100644
--- a/drivers/net/ethernet/neterion/Kconfig
+++ b/drivers/net/ethernet/neterion/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_NETERION
 	bool "Neterion (Exar) devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index 8844d1ac053a..c48999fd1bf0 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_NETRONOME
 	bool "Netronome(R) devices"
-	default y
 	help
 	  If you have a Netronome(R) network (Ethernet) card or device, say Y.
 
diff --git a/drivers/net/ethernet/ni/Kconfig b/drivers/net/ethernet/ni/Kconfig
index dcfbfa516e67..63edc754e4ec 100644
--- a/drivers/net/ethernet/ni/Kconfig
+++ b/drivers/net/ethernet/ni/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_NI
 	bool "National Instruments Devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/nvidia/Kconfig b/drivers/net/ethernet/nvidia/Kconfig
index c653786b1d05..80ea04280302 100644
--- a/drivers/net/ethernet/nvidia/Kconfig
+++ b/drivers/net/ethernet/nvidia/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_NVIDIA
 	bool "NVIDIA devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/oki-semi/Kconfig b/drivers/net/ethernet/oki-semi/Kconfig
index c2fff04ba7b6..6965467a4250 100644
--- a/drivers/net/ethernet/oki-semi/Kconfig
+++ b/drivers/net/ethernet/oki-semi/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_OKI
 	bool "OKI Semiconductor devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/packetengines/Kconfig b/drivers/net/ethernet/packetengines/Kconfig
index de91331dcb7d..05a185bc5e3c 100644
--- a/drivers/net/ethernet/packetengines/Kconfig
+++ b/drivers/net/ethernet/packetengines/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_PACKET_ENGINES
 	bool "Packet Engines devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/pasemi/Kconfig b/drivers/net/ethernet/pasemi/Kconfig
index cd68ebcf3e47..8b2c89961562 100644
--- a/drivers/net/ethernet/pasemi/Kconfig
+++ b/drivers/net/ethernet/pasemi/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_PASEMI
 	bool "PA Semi devices"
-	default y
 	depends on PPC_PASEMI && PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 3f7519e435b8..332cb71061d8 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -6,7 +6,6 @@
 
 config NET_VENDOR_PENSANDO
 	bool "Pensando devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 1203353238e5..8c0605424406 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_QLOGIC
 	bool "QLogic devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
index a4434eb38950..c764d73bca24 100644
--- a/drivers/net/ethernet/qualcomm/Kconfig
+++ b/drivers/net/ethernet/qualcomm/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_QUALCOMM
 	bool "Qualcomm devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/rdc/Kconfig b/drivers/net/ethernet/rdc/Kconfig
index 6884c7864bb9..59e4f08b5840 100644
--- a/drivers/net/ethernet/rdc/Kconfig
+++ b/drivers/net/ethernet/rdc/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_RDC
 	bool "RDC devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 93d9df55b361..62d4ed369dcd 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_REALTEK
 	bool "Realtek devices"
-	default y
 	depends on PCI || (PARPORT && X86)
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/renesas/Kconfig b/drivers/net/ethernet/renesas/Kconfig
index 8008b2f45934..09f406d80e51 100644
--- a/drivers/net/ethernet/renesas/Kconfig
+++ b/drivers/net/ethernet/renesas/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_RENESAS
 	bool "Renesas devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/rocker/Kconfig b/drivers/net/ethernet/rocker/Kconfig
index 2318811ff75a..e3c28ecca99c 100644
--- a/drivers/net/ethernet/rocker/Kconfig
+++ b/drivers/net/ethernet/rocker/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_ROCKER
 	bool "Rocker devices"
-	default y
 	help
 	  If you have a network device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/samsung/Kconfig b/drivers/net/ethernet/samsung/Kconfig
index 2a6c2658d284..d6646b2c85fd 100644
--- a/drivers/net/ethernet/samsung/Kconfig
+++ b/drivers/net/ethernet/samsung/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SAMSUNG
 	bool "Samsung Ethernet devices"
-	default y
 	help
 	  If you have a network (Ethernet) chipset belonging to this class,
 	  say Y.
diff --git a/drivers/net/ethernet/seeq/Kconfig b/drivers/net/ethernet/seeq/Kconfig
index ad1df37571dd..f3b7d0e71032 100644
--- a/drivers/net/ethernet/seeq/Kconfig
+++ b/drivers/net/ethernet/seeq/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SEEQ
 	bool "SEEQ devices"
-	default y
 	depends on HAS_IOMEM
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 97ce64079855..29c79a42b2ac 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SOLARFLARE
 	bool "Solarflare devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/sgi/Kconfig b/drivers/net/ethernet/sgi/Kconfig
index af66bb0a20d1..49ea41c80fbc 100644
--- a/drivers/net/ethernet/sgi/Kconfig
+++ b/drivers/net/ethernet/sgi/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SGI
 	bool "SGI devices"
-	default y
 	depends on (PCI && SGI_MFD_IOC3) ||  SGI_IP32
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/silan/Kconfig b/drivers/net/ethernet/silan/Kconfig
index 7ed08d588ac2..fe85c23ebf86 100644
--- a/drivers/net/ethernet/silan/Kconfig
+++ b/drivers/net/ethernet/silan/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SILAN
 	bool "Silan devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/sis/Kconfig b/drivers/net/ethernet/sis/Kconfig
index 775d76d9890e..5aa21a750add 100644
--- a/drivers/net/ethernet/sis/Kconfig
+++ b/drivers/net/ethernet/sis/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SIS
 	bool "Silicon Integrated Systems (SiS) devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/smsc/Kconfig b/drivers/net/ethernet/smsc/Kconfig
index 72e42a868346..ed7c3d0b4bbb 100644
--- a/drivers/net/ethernet/smsc/Kconfig
+++ b/drivers/net/ethernet/smsc/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SMSC
 	bool "SMC (SMSC)/Western Digital devices"
-	default y
 	depends on ARM || ARM64 || ATARI_ETHERNAT || COLDFIRE || \
 		   ISA || MAC || MIPS || NIOS2 || PCI || \
 		   PCMCIA || SUPERH || XTENSA || H8300 || COMPILE_TEST
diff --git a/drivers/net/ethernet/socionext/Kconfig b/drivers/net/ethernet/socionext/Kconfig
index 48298389851d..f00270bcd93c 100644
--- a/drivers/net/ethernet/socionext/Kconfig
+++ b/drivers/net/ethernet/socionext/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_SOCIONEXT
 	bool "Socionext ethernet drivers"
-	default y
 	help
 	  Option to select ethernet drivers for Socionext platforms.
 
diff --git a/drivers/net/ethernet/stmicro/Kconfig b/drivers/net/ethernet/stmicro/Kconfig
index cc136b4c9afd..d9bd40d0b4a4 100644
--- a/drivers/net/ethernet/stmicro/Kconfig
+++ b/drivers/net/ethernet/stmicro/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_STMICRO
 	bool "STMicroelectronics devices"
-	default y
 	depends on HAS_IOMEM
 	help
 	  If you have a network (Ethernet) card based on Synopsys Ethernet IP
diff --git a/drivers/net/ethernet/sun/Kconfig b/drivers/net/ethernet/sun/Kconfig
index b0d3f9a2950c..a7c7ac62c909 100644
--- a/drivers/net/ethernet/sun/Kconfig
+++ b/drivers/net/ethernet/sun/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SUN
 	bool "Sun devices"
-	default y
 	depends on SUN3 || SBUS || PCI || SUN_LDOMS
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/synopsys/Kconfig b/drivers/net/ethernet/synopsys/Kconfig
index f2a4287c48b8..ba48dc425d35 100644
--- a/drivers/net/ethernet/synopsys/Kconfig
+++ b/drivers/net/ethernet/synopsys/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_SYNOPSYS
 	bool "Synopsys devices"
-	default y
 	help
 	  If you have a network (Ethernet) device belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/tehuti/Kconfig b/drivers/net/ethernet/tehuti/Kconfig
index 8735633765a1..1e1adf005732 100644
--- a/drivers/net/ethernet/tehuti/Kconfig
+++ b/drivers/net/ethernet/tehuti/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_TEHUTI
 	bool "Tehuti devices"
-	default y
 	depends on PCI
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index affcf92cd3aa..cff101c1b822 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_TI
 	bool "Texas Instruments (TI) devices"
-	default y
 	depends on PCI || EISA || AR7 || ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/toshiba/Kconfig b/drivers/net/ethernet/toshiba/Kconfig
index 701e9b7c1c3b..710eab65312b 100644
--- a/drivers/net/ethernet/toshiba/Kconfig
+++ b/drivers/net/ethernet/toshiba/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_TOSHIBA
 	bool "Toshiba devices"
-	default y
 	depends on PCI && (PPC_IBM_CELL_BLADE || MIPS) || PPC_PS3
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/tundra/Kconfig b/drivers/net/ethernet/tundra/Kconfig
index edd52b2bd135..f0f5598610ff 100644
--- a/drivers/net/ethernet/tundra/Kconfig
+++ b/drivers/net/ethernet/tundra/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_TUNDRA
 	bool "Tundra devices"
-	default y
 	depends on TSI108_BRIDGE
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/vertexcom/Kconfig b/drivers/net/ethernet/vertexcom/Kconfig
index 4184a635fe01..f0a2c2a68059 100644
--- a/drivers/net/ethernet/vertexcom/Kconfig
+++ b/drivers/net/ethernet/vertexcom/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_VERTEXCOM
 	bool "Vertexcom devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/via/Kconfig b/drivers/net/ethernet/via/Kconfig
index da287ef65be7..7021eac0403b 100644
--- a/drivers/net/ethernet/via/Kconfig
+++ b/drivers/net/ethernet/via/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_VIA
 	bool "VIA devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/wiznet/Kconfig b/drivers/net/ethernet/wiznet/Kconfig
index 4bac2ad2d6a1..1f4749bde571 100644
--- a/drivers/net/ethernet/wiznet/Kconfig
+++ b/drivers/net/ethernet/wiznet/Kconfig
@@ -6,7 +6,6 @@
 config NET_VENDOR_WIZNET
 	bool "WIZnet devices"
 	depends on HAS_IOMEM
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 911b5ef9e680..85b18c7b3fac 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
-	default y
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
diff --git a/drivers/net/ethernet/xircom/Kconfig b/drivers/net/ethernet/xircom/Kconfig
index 7497b9bea511..985b23591f44 100644
--- a/drivers/net/ethernet/xircom/Kconfig
+++ b/drivers/net/ethernet/xircom/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_XIRCOM
 	bool "Xircom devices"
-	default y
 	depends on PCMCIA
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 0e878fa6e322..bfe23ceaacad 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -5,7 +5,6 @@
 
 config NET_VENDOR_XSCALE
 	bool "Intel XScale IXP devices"
-	default y
 	depends on NET_VENDOR_INTEL && (ARM && ARCH_IXP4XX && \
 		   IXP4XX_NPE && IXP4XX_QMGR)
 	help
-- 
2.34.1

