Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD3816A08C
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgBXIyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:54:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgBXIx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:53:59 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFEAC24653;
        Mon, 24 Feb 2020 08:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534438;
        bh=obzD3YOnPuqozcEN8xr2dA4n4QK18kO5UXenYEtt98A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCCPT44g3+YPfmrOt5X5sXSLDjEfeUqqtbcV1sQS12ah6ISXFe/ae0yohwTUKhj+y
         eNqQboXA6qjXbkR1JAC4PENa42O4UmMQzLhyfVoSf15Ky7KxmlGqEH12nAm+2X2n6P
         KMCjTvfLDiRDIlOgcTOLkLg/FnaHtNTM9qPyxR10=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v1 13/18] net/amd: Remove useless driver version
Date:   Mon, 24 Feb 2020 10:53:06 +0200
Message-Id: <20200224085311.460338-14-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert AMD drivers to respect universal linux kernel version.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/amd/amd8111e.c          |  5 +----
 drivers/net/ethernet/amd/au1000_eth.c        |  5 -----
 drivers/net/ethernet/amd/nmclan_cs.c         |  9 +++------
 drivers/net/ethernet/amd/pcnet32.c           |  7 -------
 drivers/net/ethernet/amd/sunlance.c          | 10 ----------
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c    |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h         |  1 -
 8 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 0f3b743425e8..7a1286f8e983 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -84,9 +84,8 @@ Revision History:

 #include "amd8111e.h"
 #define MODULE_NAME	"amd8111e"
-#define MODULE_VERS	"3.0.7"
 MODULE_AUTHOR("Advanced Micro Devices, Inc.");
-MODULE_DESCRIPTION ("AMD8111 based 10/100 Ethernet Controller. Driver Version "MODULE_VERS);
+MODULE_DESCRIPTION("AMD8111 based 10/100 Ethernet Controller.");
 MODULE_LICENSE("GPL");
 module_param_array(speed_duplex, int, NULL, 0);
 MODULE_PARM_DESC(speed_duplex, "Set device speed and duplex modes, 0: Auto Negotiate, 1: 10Mbps Half Duplex, 2: 10Mbps Full Duplex, 3: 100Mbps Half Duplex, 4: 100Mbps Full Duplex");
@@ -1366,7 +1365,6 @@ static void amd8111e_get_drvinfo(struct net_device *dev,
 	struct amd8111e_priv *lp = netdev_priv(dev);
 	struct pci_dev *pci_dev = lp->pci_dev;
 	strlcpy(info->driver, MODULE_NAME, sizeof(info->driver));
-	strlcpy(info->version, MODULE_VERS, sizeof(info->version));
 	snprintf(info->fw_version, sizeof(info->fw_version),
 		"%u", chip_version);
 	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
@@ -1875,7 +1873,6 @@ static int amd8111e_probe_one(struct pci_dev *pdev,

 	/*  display driver and device information */
     	chip_version = (readl(lp->mmio + CHIPID) & 0xf0000000)>>28;
-	dev_info(&pdev->dev, "AMD-8111e Driver Version: %s\n", MODULE_VERS);
 	dev_info(&pdev->dev, "[ Rev %x ] PCI 10/100BaseT Ethernet %pM\n",
 		 chip_version, dev->dev_addr);
 	if (lp->ext_phy_id)
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 089a4fbc61a0..9f6e3cc2ce80 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -63,14 +63,12 @@ static int au1000_debug = 3;
 				NETIF_MSG_LINK)

 #define DRV_NAME	"au1000_eth"
-#define DRV_VERSION	"1.7"
 #define DRV_AUTHOR	"Pete Popov <ppopov@embeddedalley.com>"
 #define DRV_DESC	"Au1xxx on-chip Ethernet driver"

 MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);

 /* AU1000 MAC registers and bits */
 #define MAC_CONTROL		0x0
@@ -656,7 +654,6 @@ au1000_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct au1000_private *aup = netdev_priv(dev);

 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info), "%s %d", DRV_NAME,
 		 aup->mac_id);
 }
@@ -1290,8 +1287,6 @@ static int au1000_probe(struct platform_device *pdev)
 	netdev_info(dev, "Au1xx0 Ethernet found at 0x%lx, irq %d\n",
 			(unsigned long)base->start, irq);

-	pr_info_once("%s version %s %s\n", DRV_NAME, DRV_VERSION, DRV_AUTHOR);
-
 	return 0;

 err_out:
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 023aecf6ab30..11c0b13edd30 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -114,8 +114,6 @@ Log: nmclan_cs.c,v
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"nmclan_cs"
-#define DRV_VERSION	"0.16"
-

 /* ----------------------------------------------------------------------------
 Conditional Compilation Options
@@ -367,7 +365,7 @@ typedef struct _mace_private {

     char tx_free_frames; /* Number of free transmit frame buffers */
     char tx_irq_disabled; /* MACE TX interrupt disabled */
-
+
     spinlock_t bank_lock; /* Must be held if you step off bank 0 */
 } mace_private;

@@ -444,7 +442,7 @@ static int nmclan_probe(struct pcmcia_device *link)
     lp = netdev_priv(dev);
     lp->p_dev = link;
     link->priv = dev;
-
+
     spin_lock_init(&lp->bank_lock);
     link->resource[0]->end = 32;
     link->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
@@ -817,7 +815,6 @@ static void netdev_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	snprintf(info->bus_info, sizeof(info->bus_info),
 		"PCMCIA 0x%lx", dev->base_addr);
 }
@@ -1110,7 +1107,7 @@ static int mace_rx(struct net_device *dev, unsigned char RxCnt)
 	if (pkt_len & 1)
 	    *(skb_tail_pointer(skb) - 1) = inb(ioaddr + AM2150_RCV);
 	skb->protocol = eth_type_trans(skb, dev);
-
+
 	netif_rx(skb); /* Send the packet to the upper (protocol) layers. */

 	dev->stats.rx_packets++;
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index dc7d88227e76..07e8211eea51 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -24,13 +24,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #define DRV_NAME	"pcnet32"
-#define DRV_VERSION	"1.35"
 #define DRV_RELDATE	"21.Apr.2008"
 #define PFX		DRV_NAME ": "

-static const char *const version =
-    DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " tsbogend@alpha.franken.de\n";
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -809,7 +805,6 @@ static void pcnet32_get_drvinfo(struct net_device *dev,
 	struct pcnet32_private *lp = netdev_priv(dev);

 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	if (lp->pci_dev)
 		strlcpy(info->bus_info, pci_name(lp->pci_dev),
 			sizeof(info->bus_info));
@@ -3006,8 +3001,6 @@ MODULE_LICENSE("GPL");

 static int __init pcnet32_init_module(void)
 {
-	pr_info("%s", version);
-
 	pcnet32_debug = netif_msg_init(debug, PCNET32_MSG_DEFAULT);

 	if ((tx_start_pt >= 0) && (tx_start_pt <= 3))
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index b00e00881253..a21b2e60157e 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -105,14 +105,9 @@ static char lancestr[] = "LANCE";
 #include <asm/irq.h>

 #define DRV_NAME	"sunlance"
-#define DRV_VERSION	"2.02"
 #define DRV_RELDATE	"8/24/03"
 #define DRV_AUTHOR	"Miguel de Icaza (miguel@nuclecu.unam.mx)"

-static char version[] =
-	DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " " DRV_AUTHOR "\n";
-
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION("Sun Lance ethernet driver");
 MODULE_LICENSE("GPL");
@@ -1282,7 +1277,6 @@ static void lance_free_hwresources(struct lance_private *lp)
 static void sparc_lance_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	strlcpy(info->driver, "sunlance", sizeof(info->driver));
-	strlcpy(info->version, "2.02", sizeof(info->version));
 }

 static const struct ethtool_ops sparc_lance_ethtool_ops = {
@@ -1305,7 +1299,6 @@ static int sparc_lance_probe_one(struct platform_device *op,
 				 struct platform_device *lebuffer)
 {
 	struct device_node *dp = op->dev.of_node;
-	static unsigned version_printed;
 	struct lance_private *lp;
 	struct net_device *dev;
 	int    i;
@@ -1316,9 +1309,6 @@ static int sparc_lance_probe_one(struct platform_device *op,

 	lp = netdev_priv(dev);

-	if (sparc_lance_debug && version_printed++ == 0)
-		printk (KERN_INFO "%s", version);
-
 	spin_lock_init(&lp->lock);

 	/* Copy the IDPROM ethernet address to the device structure, later we
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 8083173f1a8f..b23c8ee24ee3 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -405,7 +405,6 @@ static void xgbe_get_drvinfo(struct net_device *netdev,
 	struct xgbe_hw_features *hw_feat = &pdata->hw_feat;

 	strlcpy(drvinfo->driver, XGBE_DRV_NAME, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, XGBE_DRV_VERSION, sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, dev_name(pdata->dev),
 		sizeof(drvinfo->bus_info));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version), "%d.%d.%d",
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 7ce9c69e9c44..2a70714a791d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -127,7 +127,6 @@

 MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(XGBE_DRV_VERSION);
 MODULE_DESCRIPTION(XGBE_DRV_DESC);

 static int debug = -1;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 47bcbcf58048..5897e46faca5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -135,7 +135,6 @@
 #include <linux/list.h>

 #define XGBE_DRV_NAME		"amd-xgbe"
-#define XGBE_DRV_VERSION	"1.0.3"
 #define XGBE_DRV_DESC		"AMD 10 Gigabit Ethernet Driver"

 /* Descriptor related defines */
--
2.24.1

