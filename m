Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05F570994
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732189AbfGVTRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:17:06 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:35147 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfGVTRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:17:06 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MGA0o-1hdaZz2K44-00Gd6p; Mon, 22 Jul 2019 21:16:51 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        tglx@linutronix.de, davem@davemloft.net,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Trensch <MTrensch@hilscher.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] uio: remove netx driver
Date:   Mon, 22 Jul 2019 21:15:05 +0200
Message-Id: <20190722191552.252805-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190722191552.252805-1-arnd@arndb.de>
References: <20190722191552.252805-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:00sVbYfrpoKwOnMbAleVAvbSIJM5BWQIsOng1dX0ePzyszDnE0p
 /3CLzCNzgue1lSUEvLBSBh9c26J3ym78MdKTtcDg0lrr+o46P+hNSh3wqqiscPusb00Key4
 UCe3rn2D5Afu6oWjAERKqTSyhskx4M4nohjCLFwwLoN4pa3ThokAdgzMmYbtGn99Vx/YKlQ
 gLOx8kNwl8eEg5UlHQauA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fhQWfFvCMCo=:wffhrZiYImFmn2Ebqh2eut
 qNoDKZfsBLGfI5/BXxQX19GMz60sK5ODqBmu6HLHNTUUztRW+8tPq8+U1Ktl0VC/YTT+abX7M
 kqy7QoEDbS7R8ctvaluiw4ZmXxp6S5j//sAeBkgFjIhM1zsZbVA8RVlIDnbW8AUi67UmFBE/A
 aOaOKZ14IL/d+4HW4/LTL3J0yS7Oh7luk08OprbmQCV6RTj9dmtYplUBzTfAjkpuXuDFCQBNN
 lL1ig3SC0UAG+iTxnvod7R1tiCSP4qZIV4hqEuiF3UxUpI4y6RGFu2VEqNHGS86BTao1hUm0u
 4sFSHPgdKO33h1sD5zYPcSTzPEBUpRcw6L2Msv4uqc8QIgecCf0rgdQXZZ0M6tfYcKqQsfnfP
 O/8zRj6bAwDmaVUJyTZs5nBHKceBGQdHY3F6aHs0mNZcsKOYvaJmVQnMZHaPF143Cl/RQzRoY
 iEeUpj1CotLsPmy+fTUgyKJp4JPgq1ppcnZv19+iX7I/9cA96P9nVwiYSfbmdeRF1sgnlrGFk
 BpJJdfZVOdcFot0QxISiIRvFToET6vc2/jJoT4n7Gt0oPnEuQ6StPdGyLFO628s8IGplYmqe3
 d60jBSh0tgkevXcVUoGQke5WBqjgV1Hyn6a2rE49SQwwv7+uj5vWZBwQXTD47xcB/HXDcEYdk
 rv6qJiHAY6VkA+Za2a7s4BlLhpCROJr2mDd43h4UW7KadYEJ4MTSY3aYkk7Rd56ddJYYjxmP0
 Rx00hifgbMI9DjhyvDKyMIw19H9hLELpxND/VQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netx platform got removed, so this driver is now
useless.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/uio/Kconfig    |  11 ---
 drivers/uio/Makefile   |   1 -
 drivers/uio/uio_netx.c | 178 -----------------------------------------
 3 files changed, 190 deletions(-)
 delete mode 100644 drivers/uio/uio_netx.c

diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
index 202ee81cfc2b..abc8dd97b474 100644
--- a/drivers/uio/Kconfig
+++ b/drivers/uio/Kconfig
@@ -94,17 +94,6 @@ config UIO_PCI_GENERIC
 	  primarily, for virtualization scenarios.
 	  If you compile this as a module, it will be called uio_pci_generic.
 
-config UIO_NETX
-	tristate "Hilscher NetX Card driver"
-	depends on PCI
-	help
-	  Driver for Hilscher NetX based fieldbus cards (cifX, comX).
-	  This driver requires a userspace component that comes with the card
-	  or is available from Hilscher (http://www.hilscher.com).
-
-	  To compile this driver as a module, choose M here; the module
-	  will be called uio_netx.
-
 config UIO_FSL_ELBC_GPCM
 	tristate "eLBC/GPCM driver"
 	depends on FSL_LBC
diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
index c285dd2a4539..d94012263a42 100644
--- a/drivers/uio/Makefile
+++ b/drivers/uio/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_UIO_DMEM_GENIRQ)	+= uio_dmem_genirq.o
 obj-$(CONFIG_UIO_AEC)	+= uio_aec.o
 obj-$(CONFIG_UIO_SERCOS3)	+= uio_sercos3.o
 obj-$(CONFIG_UIO_PCI_GENERIC)	+= uio_pci_generic.o
-obj-$(CONFIG_UIO_NETX)	+= uio_netx.o
 obj-$(CONFIG_UIO_PRUSS)         += uio_pruss.o
 obj-$(CONFIG_UIO_MF624)         += uio_mf624.o
 obj-$(CONFIG_UIO_FSL_ELBC_GPCM)	+= uio_fsl_elbc_gpcm.o
diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
deleted file mode 100644
index 9ae29ffde410..000000000000
--- a/drivers/uio/uio_netx.c
+++ /dev/null
@@ -1,178 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * UIO driver for Hilscher NetX based fieldbus cards (cifX, comX).
- * See http://www.hilscher.com for details.
- *
- * (C) 2007 Hans J. Koch <hjk@hansjkoch.de>
- * (C) 2008 Manuel Traut <manut@linutronix.de>
- *
- */
-
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <linux/uio_driver.h>
-
-#define PCI_VENDOR_ID_HILSCHER		0x15CF
-#define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
-#define PCI_DEVICE_ID_HILSCHER_NETPLC	0x0010
-#define PCI_SUBDEVICE_ID_NETPLC_RAM	0x0000
-#define PCI_SUBDEVICE_ID_NETPLC_FLASH	0x0001
-#define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
-#define PCI_SUBDEVICE_ID_NXPCA		0x3335
-
-#define DPM_HOST_INT_EN0	0xfff0
-#define DPM_HOST_INT_STAT0	0xffe0
-
-#define DPM_HOST_INT_MASK	0xe600ffff
-#define DPM_HOST_INT_GLOBAL_EN	0x80000000
-
-static irqreturn_t netx_handler(int irq, struct uio_info *dev_info)
-{
-	void __iomem *int_enable_reg = dev_info->mem[0].internal_addr
-					+ DPM_HOST_INT_EN0;
-	void __iomem *int_status_reg = dev_info->mem[0].internal_addr
-					+ DPM_HOST_INT_STAT0;
-
-	/* Is one of our interrupts enabled and active ? */
-	if (!(ioread32(int_enable_reg) & ioread32(int_status_reg)
-		& DPM_HOST_INT_MASK))
-		return IRQ_NONE;
-
-	/* Disable interrupt */
-	iowrite32(ioread32(int_enable_reg) & ~DPM_HOST_INT_GLOBAL_EN,
-		int_enable_reg);
-	return IRQ_HANDLED;
-}
-
-static int netx_pci_probe(struct pci_dev *dev,
-					const struct pci_device_id *id)
-{
-	struct uio_info *info;
-	int bar;
-
-	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	if (pci_enable_device(dev))
-		goto out_free;
-
-	if (pci_request_regions(dev, "netx"))
-		goto out_disable;
-
-	switch (id->device) {
-	case PCI_DEVICE_ID_HILSCHER_NETX:
-		bar = 0;
-		info->name = "netx";
-		break;
-	case PCI_DEVICE_ID_HILSCHER_NETPLC:
-		bar = 0;
-		info->name = "netplc";
-		break;
-	default:
-		bar = 2;
-		info->name = "netx_plx";
-	}
-
-	/* BAR0 or 2 points to the card's dual port memory */
-	info->mem[0].addr = pci_resource_start(dev, bar);
-	if (!info->mem[0].addr)
-		goto out_release;
-	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, bar),
-						pci_resource_len(dev, bar));
-
-	if (!info->mem[0].internal_addr)
-			goto out_release;
-
-	info->mem[0].size = pci_resource_len(dev, bar);
-	info->mem[0].memtype = UIO_MEM_PHYS;
-	info->irq = dev->irq;
-	info->irq_flags = IRQF_SHARED;
-	info->handler = netx_handler;
-	info->version = "0.0.1";
-
-	/* Make sure all interrupts are disabled */
-	iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
-
-	if (uio_register_device(&dev->dev, info))
-		goto out_unmap;
-
-	pci_set_drvdata(dev, info);
-	dev_info(&dev->dev, "Found %s card, registered UIO device.\n",
-				info->name);
-
-	return 0;
-
-out_unmap:
-	iounmap(info->mem[0].internal_addr);
-out_release:
-	pci_release_regions(dev);
-out_disable:
-	pci_disable_device(dev);
-out_free:
-	kfree(info);
-	return -ENODEV;
-}
-
-static void netx_pci_remove(struct pci_dev *dev)
-{
-	struct uio_info *info = pci_get_drvdata(dev);
-
-	/* Disable all interrupts */
-	iowrite32(0, info->mem[0].internal_addr + DPM_HOST_INT_EN0);
-	uio_unregister_device(info);
-	pci_release_regions(dev);
-	pci_disable_device(dev);
-	iounmap(info->mem[0].internal_addr);
-
-	kfree(info);
-}
-
-static struct pci_device_id netx_pci_ids[] = {
-	{
-		.vendor =	PCI_VENDOR_ID_HILSCHER,
-		.device =	PCI_DEVICE_ID_HILSCHER_NETX,
-		.subvendor =	0,
-		.subdevice =	0,
-	},
-	{
-		.vendor =       PCI_VENDOR_ID_HILSCHER,
-		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
-		.subvendor =    PCI_VENDOR_ID_HILSCHER,
-		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_RAM,
-	},
-	{
-		.vendor =       PCI_VENDOR_ID_HILSCHER,
-		.device =       PCI_DEVICE_ID_HILSCHER_NETPLC,
-		.subvendor =    PCI_VENDOR_ID_HILSCHER,
-		.subdevice =    PCI_SUBDEVICE_ID_NETPLC_FLASH,
-	},
-	{
-		.vendor =	PCI_VENDOR_ID_PLX,
-		.device =	PCI_DEVICE_ID_PLX_9030,
-		.subvendor =	PCI_VENDOR_ID_PLX,
-		.subdevice =	PCI_SUBDEVICE_ID_NXSB_PCA,
-	},
-	{
-		.vendor =	PCI_VENDOR_ID_PLX,
-		.device =	PCI_DEVICE_ID_PLX_9030,
-		.subvendor =	PCI_VENDOR_ID_PLX,
-		.subdevice =	PCI_SUBDEVICE_ID_NXPCA,
-	},
-	{ 0, }
-};
-
-static struct pci_driver netx_pci_driver = {
-	.name = "netx",
-	.id_table = netx_pci_ids,
-	.probe = netx_pci_probe,
-	.remove = netx_pci_remove,
-};
-
-module_pci_driver(netx_pci_driver);
-MODULE_DEVICE_TABLE(pci, netx_pci_ids);
-MODULE_LICENSE("GPL v2");
-MODULE_AUTHOR("Hans J. Koch, Manuel Traut");
-- 
2.20.0

