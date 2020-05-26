Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D2F1E298E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgEZSDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:03:20 -0400
Received: from mout.gmx.net ([212.227.15.18]:40313 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbgEZSDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1590516184;
        bh=MY7YNt+ltFF5RF4DIj4TEfuPS4HyV96ZiJkulZT91wc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ldkHwG6fKQjp6ndhz14MVt3EEJi1zIpZMc6auJpzg9MI/sq2IGHbD0VJ0hmosVAcP
         3Ti97ghBg5xJaJzoK2DOLkhU5N+vcBwMtRv2saQ1cMcQsN6AWw8VfyuHWakpRMDOBX
         xYgWfWBrj8KwWrFhYFDpSXpivoltlbni3uMQW1u4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([79.242.188.87]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTzf6-1jVMRR3eK2-00QypQ; Tue, 26
 May 2020 20:03:04 +0200
Date:   Tue, 26 May 2020 20:03:02 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH v3 net-next] ne2k-pci: Fix various coding-style issues and
 improve printk() usage
Message-ID: <20200526180302.GA5340@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:GYBDKtom0L5W/KG6BKAL0hikLv+DkDB6lxfnPD0TagDEX2f12Pq
 gc3yFxLA2wUFRQxDGZKtDb3Tqq8USVmtXXC/Mjf9BJDiZvMuPWdZrynoBxU/aHaALTFlebu
 LeaSjv5QSbvhm3SOUMitu3HYFLr8IrI9Lj1/yK0cr41JwcofmYpo6e/7ZbY+75C8sUucGgo
 1B55xUg4uyU1yGrOyiBVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kbz5J6toF7I=:8UZtlh1ocaVcLakLj/Queo
 t8raxv5S+x0mXt/ddEd5E/ykCTw0O0ft4d+P+xGPKDrAnnkBtAil7l06FIHdgflMcj/L9lerf
 EZNwGrZUFf+j/QTXJ9v6oB4Q6dZA4VP0I8P2Oox2EolQ4ApM/k9NDa1T5s9lvLlrLcrnYw3xi
 RKXnmcB3rSTPnPO6JaWHZ9yf6e2c3f1jxBZw1dyQAW9dSAeoZhHEfqncwQRwZGVlAeqBrSUp5
 Q5xfOovPIfO9tJ4F/uk5QsIJ4j87+UmOuNYZMGJvCMEDu59aAvi+hACT+A39foU7tdran3N2h
 debXimCYV6Owa1UXqAnUAHqsflEiBu5Cj/GLJcMRhqmfe3ni3f7gCzsxbqVP/OujXz33Mv4R2
 kRvobGVenxpdBtkJJRCTgUdXv82zo6o8a34ykxEIC83oBS1w4zMcHr6JaQguHjqWRs9iQKzEC
 sMF7p5OwX9O7o42bQR7RFx/1iPf+wEJKSK8+adecXVQQakfBggiOvryo075kclaJaT5ssr+MG
 6MpAds5Kg/eo2KMCV5Lm3K04LMkv5V73CJ2p5i2/qULtc8HK3PdSV76SzzgApY6v/L5j28YPT
 mUqdsETGPKa+ozUmRrH6EHUdsVcBr3qfnyg41NKQ6AJUrYYwM4HCNVHSl0kaArV2JwVeWb453
 RcD6SDDQvKlAeVMw/xXxs3SBACMsUTZhoDqIAt/qmlkM1EzthnpfmfbAms0iIm9/ae9KXPrk6
 vfkBrlRPFxSPSUcpUidJHZHFrJqfyuLwVfyl9lRt8Gje0bhd/JSGB/6LCZ5rEWQmzMh06BB2h
 aAMX6biWRDeOyBNgECAcOZ+UjJ376OTJERfK6msDwDmFs56uiugt7ncRQV/bh7LjnSq5CRZqW
 AxI0jyVarasuzmMicg4quU+65lFzS2StoZOdrbJEJW+zVll8JDpqEH1Ez9NR3q79d85ZZn9Ty
 /App2IJGTq6PnE1gUhkMdxW2R07MGGP6xMtjL4xuiFROjidU+V9NZjunl2xZ8blKOF/PDCuKy
 /KXZFmuIreFvt2mj67kZW/Vra3wOVW49A4EaN8O0vGXR5gHgz1yDvq32n4nI2YaEDzD/CkGZu
 2ISyGKwHzQyF1a10T5YEqb3kTAkPF8imkVK505iYnx6mkhf9TJ6gxk5X71lAZKlreZJ9Lf+F6
 SejtKV7Wzi/PXfTC3C66IBQ023jIwWcVmii8M1xX2iFrM5RWzrFh/lPXiw5AGIfVmiXXyAYoU
 2sF/UwlKJeuMY/ffI
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed a ton of minor checkpatch errors/warnings and remove version
printing at module init/when device is found and use MODULE_VERSION
instead. Also modifying the RTL8029 PCI string to include the compatible
RTL8029AS nic.
The only mayor issue remaining is the missing SPDX tag, but since the
exact version of the GPL is not stated anywhere inside the file, its
impossible to add such a tag at the moment.
But maybe it is possible, since 8390.h states Donald Becker's 8390
drivers are licensed under GPL 2.2 only (=3D GPL-2.0-only ?).
The kernel module containing this patch compiles and runs without
problems on a RTL8029AS-based NE2000 clone card with kernel 5.7.0-rc6.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
Cganges in v3:
	- Improve patch format
Changes in v2:
	- Remove version printing and use MODULE_VERSION instead
=2D--
 drivers/net/ethernet/8390/ne2k-pci.c | 345 ++++++++++++++-------------
 1 file changed, 182 insertions(+), 163 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8=
390/ne2k-pci.c
index 42985a82321a..77d78b4c59c4 100644
=2D-- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -1,39 +1,43 @@
-/* ne2k-pci.c: A NE2000 clone on PCI bus driver for Linux. */
-/*
-	A Linux device driver for PCI NE2000 clones.
-
-	Authors and other copyright holders:
-	1992-2000 by Donald Becker, NE2000 core and various modifications.
-	1995-1998 by Paul Gortmaker, core modifications and PCI support.
-	Copyright 1993 assigned to the United States Government as represented
-	by the Director, National Security Agency.
-
-	This software may be used and distributed according to the terms of
-	the GNU General Public License (GPL), incorporated herein by reference.
-	Drivers based on or derived from this code fall under the GPL and must
-	retain the authorship, copyright and license notice.  This file is not
-	a complete program and may only be used when the entire operating
-	system is licensed under the GPL.
-
-	The author may be reached as becker@scyld.com, or C/O
-	Scyld Computing Corporation
-	410 Severn Ave., Suite 210
-	Annapolis MD 21403
-
-	Issues remaining:
-	People are making PCI ne2000 clones! Oh the horror, the horror...
-	Limited full-duplex support.
-*/
+/* A Linux device driver for PCI NE2000 clones.
+ *
+ * Authors and other copyright holders:
+ * 1992-2000 by Donald Becker, NE2000 core and various modifications.
+ * 1995-1998 by Paul Gortmaker, core modifications and PCI support.
+ * Copyright 1993 assigned to the United States Government as represented
+ * by the Director, National Security Agency.
+ *
+ * This software may be used and distributed according to the terms of
+ * the GNU General Public License (GPL), incorporated herein by reference=
.
+ * Drivers based on or derived from this code fall under the GPL and must
+ * retain the authorship, copyright and license notice.  This file is not
+ * a complete program and may only be used when the entire operating
+ * system is licensed under the GPL.
+ *
+ * The author may be reached as becker@scyld.com, or C/O
+ * Scyld Computing Corporation
+ * 410 Severn Ave., Suite 210
+ * Annapolis MD 21403
+ *
+ * Issues remaining:
+ * People are making PCI NE2000 clones! Oh the horror, the horror...
+ * Limited full-duplex support.
+ */

 #define DRV_NAME	"ne2k-pci"
+#define DRV_DESCRIPTION	"PCI NE2000 clone driver"
+#define DRV_AUTHOR	"Donald Becker / Paul Gortmaker"
 #define DRV_VERSION	"1.03"
 #define DRV_RELDATE	"9/22/2003"

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 /* The user-configurable values.
-   These may be modified when a driver module is loaded.*/
+ * These may be modified when a driver module is loaded.
+ */
+
+/* More are supported, limit only on options */
+#define MAX_UNITS 8

-#define MAX_UNITS 8				/* More are supported, limit only on options */
 /* Used to pass the full-duplex flag, etc. */
 static int full_duplex[MAX_UNITS];
 static int options[MAX_UNITS];
@@ -52,7 +56,7 @@ static int options[MAX_UNITS];
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>

-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/uaccess.h>

@@ -60,20 +64,14 @@ static int options[MAX_UNITS];

 static u32 ne2k_msg_enable;

-/* These identify the driver base version and may not be removed. */
-static const char version[] =3D
-	KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE
-	" D. Becker/P. Gortmaker\n";
-
 #if defined(__powerpc__)
 #define inl_le(addr)  le32_to_cpu(inl(addr))
 #define inw_le(addr)  le16_to_cpu(inw(addr))
 #endif

-#define PFX DRV_NAME ": "
-
-MODULE_AUTHOR("Donald Becker / Paul Gortmaker");
-MODULE_DESCRIPTION("PCI NE2000 clone driver");
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");

 module_param_named(msg_enable, ne2k_msg_enable, uint, 0444);
@@ -83,7 +81,8 @@ MODULE_PARM_DESC(msg_enable, "Debug message level (see l=
inux/netdevice.h for bit
 MODULE_PARM_DESC(options, "Bit 5: full duplex");
 MODULE_PARM_DESC(full_duplex, "full duplex setting(s) (1)");

-/* Some defines that people can play with if so inclined. */
+/* Some defines that people can play with if so inclined.
+ */

 /* Use 32 bit data-movement operations instead of 16 bit. */
 #define USE_LONGIO
@@ -91,14 +90,18 @@ MODULE_PARM_DESC(full_duplex, "full duplex setting(s) =
(1)");
 /* Do we implement the read before write bugfix ? */
 /* #define NE_RW_BUGFIX */

-/* Flags.  We rename an existing ei_status field to store flags! */
-/* Thus only the low 8 bits are usable for non-init-time flags. */
+/* Flags.  We rename an existing ei_status field to store flags!
+ * Thus only the low 8 bits are usable for non-init-time flags.
+ */
 #define ne2k_flags reg0
+
 enum {
-	ONLY_16BIT_IO=3D8, ONLY_32BIT_IO=3D4,	/* Chip can do only 16/32-bit xfer=
s. */
-	FORCE_FDX=3D0x20,						/* User override. */
-	REALTEK_FDX=3D0x40, HOLTEK_FDX=3D0x80,
-	STOP_PG_0x60=3D0x100,
+	/* Chip can do only 16/32-bit xfers. */
+	ONLY_16BIT_IO =3D 8, ONLY_32BIT_IO =3D 4,
+	/* User override. */
+	FORCE_FDX =3D 0x20,
+	REALTEK_FDX =3D 0x40, HOLTEK_FDX =3D 0x80,
+	STOP_PG_0x60 =3D 0x100,
 };

 enum ne2k_pci_chipsets {
@@ -120,7 +123,7 @@ static struct {
 	char *name;
 	int flags;
 } pci_clone_list[] =3D {
-	{"RealTek RTL-8029", REALTEK_FDX},
+	{"RealTek RTL-8029(AS)", REALTEK_FDX},
 	{"Winbond 89C940", 0},
 	{"Compex RL2000", 0},
 	{"KTI ET32P2", 0},
@@ -149,13 +152,14 @@ static const struct pci_device_id ne2k_pci_tbl[] =3D=
 {
 	{ 0x8c4a, 0x1980, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CH_Winbond_89C940_8c4a }=
,
 	{ 0, }
 };
+
 MODULE_DEVICE_TABLE(pci, ne2k_pci_tbl);


 /* ---- No user-serviceable parts below ---- */

 #define NE_BASE	 (dev->base_addr)
-#define NE_CMD	 	0x00
+#define NE_CMD		0x00
 #define NE_DATAPORT	0x10	/* NatSemi-defined port window offset. */
 #define NE_RESET	0x1f	/* Issue a read to reset, a write to clear. */
 #define NE_IO_EXTENT	0x20
@@ -168,18 +172,20 @@ static int ne2k_pci_open(struct net_device *dev);
 static int ne2k_pci_close(struct net_device *dev);

 static void ne2k_pci_reset_8390(struct net_device *dev);
-static void ne2k_pci_get_8390_hdr(struct net_device *dev, struct e8390_pk=
t_hdr *hdr,
-			  int ring_page);
+static void ne2k_pci_get_8390_hdr(struct net_device *dev,
+				  struct e8390_pkt_hdr *hdr, int ring_page);
 static void ne2k_pci_block_input(struct net_device *dev, int count,
-			  struct sk_buff *skb, int ring_offset);
+				 struct sk_buff *skb, int ring_offset);
 static void ne2k_pci_block_output(struct net_device *dev, const int count=
,
-		const unsigned char *buf, const int start_page);
+				  const unsigned char *buf,
+				  const int start_page);
 static const struct ethtool_ops ne2k_pci_ethtool_ops;



 /* There is no room in the standard 8390 structure for extra info we need=
,
-   so we build a meta/outer-wrapper structure.. */
+ * so we build a meta/outer-wrapper structure..
+ */
 struct ne2k_pci_card {
 	struct net_device *dev;
 	struct pci_dev *pci_dev;
@@ -187,18 +193,17 @@ struct ne2k_pci_card {



-/*
-  NEx000-clone boards have a Station Address (SA) PROM (SAPROM) in the pa=
cket
-  buffer memory space.  By-the-spec NE2000 clones have 0x57,0x57 in bytes
-  0x0e,0x0f of the SAPROM, while other supposed NE2000 clones must be
-  detected by their SA prefix.
-
-  Reading the SAPROM from a word-wide card with the 8390 set in byte-wide
-  mode results in doubled values, which can be detected and compensated f=
or.
-
-  The probe is also responsible for initializing the card and filling
-  in the 'dev' and 'ei_status' structures.
-*/
+/* NEx000-clone boards have a Station Address (SA) PROM (SAPROM) in the p=
acket
+ * buffer memory space.  By-the-spec NE2000 clones have 0x57,0x57 in byte=
s
+ * 0x0e,0x0f of the SAPROM, while other supposed NE2000 clones must be
+ * detected by their SA prefix.
+ *
+ * Reading the SAPROM from a word-wide card with the 8390 set in byte-wid=
e
+ * mode results in doubled values, which can be detected and compensated =
for.
+ *
+ * The probe is also responsible for initializing the card and filling
+ * in the 'dev' and 'ei_status' structures.
+ */

 static const struct net_device_ops ne2k_netdev_ops =3D {
 	.ndo_open		=3D ne2k_pci_open,
@@ -208,7 +213,7 @@ static const struct net_device_ops ne2k_netdev_ops =3D=
 {
 	.ndo_get_stats		=3D ei_get_stats,
 	.ndo_set_rx_mode	=3D ei_set_multicast_list,
 	.ndo_validate_addr	=3D eth_validate_addr,
-	.ndo_set_mac_address 	=3D eth_mac_addr,
+	.ndo_set_mac_address	=3D eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller =3D ei_poll,
 #endif
@@ -227,28 +232,21 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	int flags =3D pci_clone_list[chip_idx].flags;
 	struct ei_device *ei_local;

-/* when built into the kernel, we only print version if device is found *=
/
-#ifndef MODULE
-	static int printed_version;
-	if (!printed_version++)
-		printk(version);
-#endif
-
 	fnd_cnt++;

-	i =3D pci_enable_device (pdev);
+	i =3D pci_enable_device(pdev);
 	if (i)
 		return i;

-	ioaddr =3D pci_resource_start (pdev, 0);
+	ioaddr =3D pci_resource_start(pdev, 0);
 	irq =3D pdev->irq;

-	if (!ioaddr || ((pci_resource_flags (pdev, 0) & IORESOURCE_IO) =3D=3D 0)=
) {
+	if (!ioaddr || ((pci_resource_flags(pdev, 0) & IORESOURCE_IO) =3D=3D 0))=
 {
 		dev_err(&pdev->dev, "no I/O resource at PCI BAR #0\n");
 		goto err_out;
 	}

-	if (request_region (ioaddr, NE_IO_EXTENT, DRV_NAME) =3D=3D NULL) {
+	if (!request_region(ioaddr, NE_IO_EXTENT, DRV_NAME)) {
 		dev_err(&pdev->dev, "I/O resource 0x%x @ 0x%lx busy\n",
 			NE_IO_EXTENT, ioaddr);
 		goto err_out;
@@ -261,14 +259,17 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	/* Do a preliminary verification that we have a 8390. */
 	{
 		int regd;
-		outb(E8390_NODMA+E8390_PAGE1+E8390_STOP, ioaddr + E8390_CMD);
+
+		outb(E8390_NODMA + E8390_PAGE1 + E8390_STOP, ioaddr + E8390_CMD);
 		regd =3D inb(ioaddr + 0x0d);
 		outb(0xff, ioaddr + 0x0d);
-		outb(E8390_NODMA+E8390_PAGE0, ioaddr + E8390_CMD);
-		inb(ioaddr + EN0_COUNTER0); /* Clear the counter by reading. */
+		outb(E8390_NODMA + E8390_PAGE0, ioaddr + E8390_CMD);
+		/* Clear the counter by reading. */
+		inb(ioaddr + EN0_COUNTER0);
 		if (inb(ioaddr + EN0_COUNTER0) !=3D 0) {
 			outb(reg0, ioaddr);
-			outb(regd, ioaddr + 0x0d);	/* Restore the old values. */
+			/*  Restore the old values. */
+			outb(regd, ioaddr + 0x0d);
 			goto err_out_free_res;
 		}
 	}
@@ -291,9 +292,9 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,

 		outb(inb(ioaddr + NE_RESET), ioaddr + NE_RESET);

-		/* This looks like a horrible timing loop, but it should never take
-		   more than a few cycles.
-		*/
+		/* This looks like a horrible timing loop, but it should never
+		 * take more than a few cycles.
+		 */
 		while ((inb(ioaddr + EN0_ISR) & ENISR_RESET) =3D=3D 0)
 			/* Limit wait: '2' avoids jiffy roll-over. */
 			if (jiffies - reset_start_time > 2) {
@@ -301,42 +302,53 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 					"Card failure (no reset ack).\n");
 				goto err_out_free_netdev;
 			}
-
-		outb(0xff, ioaddr + EN0_ISR);		/* Ack all intr. */
+		/* Ack all intr. */
+		outb(0xff, ioaddr + EN0_ISR);
 	}

 	/* Read the 16 bytes of station address PROM.
-	   We must first initialize registers, similar to NS8390_init(eifdev, 0)=
.
-	   We can't reliably read the SAPROM address without this.
-	   (I learned the hard way!). */
+	 * We must first initialize registers, similar
+	 * to NS8390_init(eifdev, 0).
+	 * We can't reliably read the SAPROM address without this.
+	 * (I learned the hard way!).
+	 */
 	{
 		struct {unsigned char value, offset; } program_seq[] =3D {
-			{E8390_NODMA+E8390_PAGE0+E8390_STOP, E8390_CMD}, /* Select page 0*/
-			{0x49,	EN0_DCFG},	/* Set word-wide access. */
-			{0x00,	EN0_RCNTLO},	/* Clear the count regs. */
+			/* Select page 0 */
+			{E8390_NODMA + E8390_PAGE0 + E8390_STOP, E8390_CMD},
+			/* Set word-wide access */
+			{0x49,	EN0_DCFG},
+			/* Clear the count regs. */
+			{0x00,	EN0_RCNTLO},
+			/* Mask completion IRQ */
 			{0x00,	EN0_RCNTHI},
-			{0x00,	EN0_IMR},	/* Mask completion irq. */
+			{0x00,	EN0_IMR},
 			{0xFF,	EN0_ISR},
-			{E8390_RXOFF, EN0_RXCR},	/* 0x20  Set to monitor */
-			{E8390_TXOFF, EN0_TXCR},	/* 0x02  and loopback mode. */
+			/* 0x20 Set to monitor */
+			{E8390_RXOFF, EN0_RXCR},
+			/* 0x02 and loopback mode */
+			{E8390_TXOFF, EN0_TXCR},
 			{32,	EN0_RCNTLO},
 			{0x00,	EN0_RCNTHI},
-			{0x00,	EN0_RSARLO},	/* DMA starting at 0x0000. */
+			/* DMA starting at 0x0000 */
+			{0x00,	EN0_RSARLO},
 			{0x00,	EN0_RSARHI},
 			{E8390_RREAD+E8390_START, E8390_CMD},
 		};
 		for (i =3D 0; i < ARRAY_SIZE(program_seq); i++)
-			outb(program_seq[i].value, ioaddr + program_seq[i].offset);
+			outb(program_seq[i].value,
+			     ioaddr + program_seq[i].offset);

 	}

 	/* Note: all PCI cards have at least 16 bit access, so we don't have
-	   to check for 8 bit cards.  Most cards permit 32 bit access. */
+	 * to check for 8 bit cards.  Most cards permit 32 bit access.
+	 */
 	if (flags & ONLY_32BIT_IO) {
 		for (i =3D 0; i < 4 ; i++)
 			((u32 *)SA_prom)[i] =3D le32_to_cpu(inl(ioaddr + NE_DATAPORT));
 	} else
-		for(i =3D 0; i < 32 /*sizeof(SA_prom)*/; i++)
+		for (i =3D 0; i < 32 /* sizeof(SA_prom )*/; i++)
 			SA_prom[i] =3D inb(ioaddr + NE_DATAPORT);

 	/* We always set the 8390 registers for word mode. */
@@ -356,7 +368,7 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	ei_status.word16 =3D 1;
 	ei_status.ne2k_flags =3D flags;
 	if (fnd_cnt < MAX_UNITS) {
-		if (full_duplex[fnd_cnt] > 0  ||  (options[fnd_cnt] & FORCE_FDX))
+		if (full_duplex[fnd_cnt] > 0 || (options[fnd_cnt] & FORCE_FDX))
 			ei_status.ne2k_flags |=3D FORCE_FDX;
 	}

@@ -388,16 +400,15 @@ static int ne2k_pci_init_one(struct pci_dev *pdev,
 	return 0;

 err_out_free_netdev:
-	free_netdev (dev);
+	free_netdev(dev);
 err_out_free_res:
-	release_region (ioaddr, NE_IO_EXTENT);
+	release_region(ioaddr, NE_IO_EXTENT);
 err_out:
 	pci_disable_device(pdev);
 	return -ENODEV;
 }

-/*
- * Magic incantation sequence for full duplex on the supported cards.
+/* Magic incantation sequence for full duplex on the supported cards.
  */
 static inline int set_realtek_fdx(struct net_device *dev)
 {
@@ -431,7 +442,9 @@ static int ne2k_pci_set_fdx(struct net_device *dev)

 static int ne2k_pci_open(struct net_device *dev)
 {
-	int ret =3D request_irq(dev->irq, ei_interrupt, IRQF_SHARED, dev->name, =
dev);
+	int ret =3D request_irq(dev->irq, ei_interrupt, IRQF_SHARED,
+			      dev->name, dev);
+
 	if (ret)
 		return ret;

@@ -450,7 +463,8 @@ static int ne2k_pci_close(struct net_device *dev)
 }

 /* Hard reset the card.  This used to pause for the same period that a
-   8390 reset command required, but that shouldn't be necessary. */
+ * 8390 reset command required, but that shouldn't be necessary.
+ */
 static void ne2k_pci_reset_8390(struct net_device *dev)
 {
 	unsigned long reset_start_time =3D jiffies;
@@ -467,31 +481,34 @@ static void ne2k_pci_reset_8390(struct net_device *d=
ev)
 	/* This check _should_not_ be necessary, omit eventually. */
 	while ((inb(NE_BASE+EN0_ISR) & ENISR_RESET) =3D=3D 0)
 		if (jiffies - reset_start_time > 2) {
-			netdev_err(dev, "ne2k_pci_reset_8390() did not complete.\n");
+			netdev_err(dev, "%s did not complete.\n", __func__);
 			break;
 		}
-	outb(ENISR_RESET, NE_BASE + EN0_ISR);	/* Ack intr. */
+	/* Ack intr. */
+	outb(ENISR_RESET, NE_BASE + EN0_ISR);
 }

 /* Grab the 8390 specific header. Similar to the block_input routine, but
-   we don't need to be concerned with ring wrap as the header will be at
-   the start of a page, so we optimize accordingly. */
+ * we don't need to be concerned with ring wrap as the header will be at
+ * the start of a page, so we optimize accordingly.
+ */

-static void ne2k_pci_get_8390_hdr(struct net_device *dev, struct e8390_pk=
t_hdr *hdr, int ring_page)
+static void ne2k_pci_get_8390_hdr(struct net_device *dev,
+				  struct e8390_pkt_hdr *hdr, int ring_page)
 {

 	long nic_base =3D dev->base_addr;

-	/* This *shouldn't* happen. If it does, it's the last thing you'll see *=
/
+	/* This *shouldn't* happen. If it does, it's the last thing you'll see
+	 */
 	if (ei_status.dmaing) {
-		netdev_err(dev, "DMAing conflict in ne2k_pci_get_8390_hdr "
-			   "[DMAstat:%d][irqlock:%d].\n",
-			   ei_status.dmaing, ei_status.irqlock);
+		netdev_err(dev, "DMAing conflict in %s [DMAstat:%d][irqlock:%d].\n",
+			   __func__, ei_status.dmaing, ei_status.irqlock);
 		return;
 	}

 	ei_status.dmaing |=3D 0x01;
-	outb(E8390_NODMA+E8390_PAGE0+E8390_START, nic_base+ NE_CMD);
+	outb(E8390_NODMA + E8390_PAGE0 + E8390_START, nic_base + NE_CMD);
 	outb(sizeof(struct e8390_pkt_hdr), nic_base + EN0_RCNTLO);
 	outb(0, nic_base + EN0_RCNTHI);
 	outb(0, nic_base + EN0_RSARLO);		/* On page boundary */
@@ -499,20 +516,22 @@ static void ne2k_pci_get_8390_hdr(struct net_device =
*dev, struct e8390_pkt_hdr *
 	outb(E8390_RREAD+E8390_START, nic_base + NE_CMD);

 	if (ei_status.ne2k_flags & ONLY_16BIT_IO) {
-		insw(NE_BASE + NE_DATAPORT, hdr, sizeof(struct e8390_pkt_hdr)>>1);
+		insw(NE_BASE + NE_DATAPORT, hdr,
+		     sizeof(struct e8390_pkt_hdr) >> 1);
 	} else {
-		*(u32*)hdr =3D le32_to_cpu(inl(NE_BASE + NE_DATAPORT));
+		*(u32 *)hdr =3D le32_to_cpu(inl(NE_BASE + NE_DATAPORT));
 		le16_to_cpus(&hdr->count);
 	}
-
-	outb(ENISR_RDC, nic_base + EN0_ISR);	/* Ack intr. */
+	/* Ack intr. */
+	outb(ENISR_RDC, nic_base + EN0_ISR);
 	ei_status.dmaing &=3D ~0x01;
 }

 /* Block input and output, similar to the Crynwr packet driver.  If you
-   are porting to a new ethercard, look at the packet driver source for h=
ints.
-   The NEx000 doesn't share the on-board packet memory -- you have to put
-   the packet out through the "remote DMA" dataport using outb. */
+ *are porting to a new ethercard, look at the packet driver source for hi=
nts.
+ *The NEx000 doesn't share the on-board packet memory -- you have to put
+ *the packet out through the "remote DMA" dataport using outb.
+ */

 static void ne2k_pci_block_input(struct net_device *dev, int count,
 				 struct sk_buff *skb, int ring_offset)
@@ -520,30 +539,30 @@ static void ne2k_pci_block_input(struct net_device *=
dev, int count,
 	long nic_base =3D dev->base_addr;
 	char *buf =3D skb->data;

-	/* This *shouldn't* happen. If it does, it's the last thing you'll see *=
/
+	/* This *shouldn't* happen.
+	 * If it does, it's the last thing you'll see.
+	 */
 	if (ei_status.dmaing) {
-		netdev_err(dev, "DMAing conflict in ne2k_pci_block_input "
-			   "[DMAstat:%d][irqlock:%d].\n",
-			   ei_status.dmaing, ei_status.irqlock);
+		netdev_err(dev, "DMAing conflict in %s [DMAstat:%d][irqlock:%d]\n",
+			   __func__, ei_status.dmaing, ei_status.irqlock);
 		return;
 	}
 	ei_status.dmaing |=3D 0x01;
 	if (ei_status.ne2k_flags & ONLY_32BIT_IO)
 		count =3D (count + 3) & 0xFFFC;
-	outb(E8390_NODMA+E8390_PAGE0+E8390_START, nic_base+ NE_CMD);
+	outb(E8390_NODMA + E8390_PAGE0 + E8390_START, nic_base + NE_CMD);
 	outb(count & 0xff, nic_base + EN0_RCNTLO);
 	outb(count >> 8, nic_base + EN0_RCNTHI);
 	outb(ring_offset & 0xff, nic_base + EN0_RSARLO);
 	outb(ring_offset >> 8, nic_base + EN0_RSARHI);
-	outb(E8390_RREAD+E8390_START, nic_base + NE_CMD);
+	outb(E8390_RREAD + E8390_START, nic_base + NE_CMD);

 	if (ei_status.ne2k_flags & ONLY_16BIT_IO) {
-		insw(NE_BASE + NE_DATAPORT,buf,count>>1);
-		if (count & 0x01) {
+		insw(NE_BASE + NE_DATAPORT, buf, count >> 1);
+		if (count & 0x01)
 			buf[count-1] =3D inb(NE_BASE + NE_DATAPORT);
-		}
 	} else {
-		insl(NE_BASE + NE_DATAPORT, buf, count>>2);
+		insl(NE_BASE + NE_DATAPORT, buf, count >> 2);
 		if (count & 3) {
 			buf +=3D count & ~3;
 			if (count & 2) {
@@ -556,30 +575,32 @@ static void ne2k_pci_block_input(struct net_device *=
dev, int count,
 				*buf =3D inb(NE_BASE + NE_DATAPORT);
 		}
 	}
-
-	outb(ENISR_RDC, nic_base + EN0_ISR);	/* Ack intr. */
+	/* Ack intr. */
+	outb(ENISR_RDC, nic_base + EN0_ISR);
 	ei_status.dmaing &=3D ~0x01;
 }

 static void ne2k_pci_block_output(struct net_device *dev, int count,
-				  const unsigned char *buf, const int start_page)
+		const unsigned char *buf, const int start_page)
 {
 	long nic_base =3D NE_BASE;
 	unsigned long dma_start;

 	/* On little-endian it's always safe to round the count up for
-	   word writes. */
+	 * word writes.
+	 */
 	if (ei_status.ne2k_flags & ONLY_32BIT_IO)
 		count =3D (count + 3) & 0xFFFC;
 	else
 		if (count & 0x01)
 			count++;

-	/* This *shouldn't* happen. If it does, it's the last thing you'll see *=
/
+	/* This *shouldn't* happen.
+	 * If it does, it's the last thing you'll see.
+	 */
 	if (ei_status.dmaing) {
-		netdev_err(dev, "DMAing conflict in ne2k_pci_block_output."
-			   "[DMAstat:%d][irqlock:%d]\n",
-			   ei_status.dmaing, ei_status.irqlock);
+		netdev_err(dev, "DMAing conflict in %s [DMAstat:%d][irqlock:%d]\n",
+			   __func__, ei_status.dmaing, ei_status.irqlock);
 		return;
 	}
 	ei_status.dmaing |=3D 0x01;
@@ -588,9 +609,10 @@ static void ne2k_pci_block_output(struct net_device *=
dev, int count,

 #ifdef NE8390_RW_BUGFIX
 	/* Handle the read-before-write bug the same way as the
-	   Crynwr packet driver -- the NatSemi method doesn't work.
-	   Actually this doesn't always work either, but if you have
-	   problems with your NEx000 this is better than nothing! */
+	 * Crynwr packet driver -- the NatSemi method doesn't work.
+	 * Actually this doesn't always work either, but if you have
+	 * problems with your NEx000 this is better than nothing!
+	 */
 	outb(0x42, nic_base + EN0_RCNTLO);
 	outb(0x00, nic_base + EN0_RCNTHI);
 	outb(0x42, nic_base + EN0_RSARLO);
@@ -599,16 +621,16 @@ static void ne2k_pci_block_output(struct net_device =
*dev, int count,
 #endif
 	outb(ENISR_RDC, nic_base + EN0_ISR);

-   /* Now the normal output. */
+	/* Now the normal output. */
 	outb(count & 0xff, nic_base + EN0_RCNTLO);
 	outb(count >> 8,   nic_base + EN0_RCNTHI);
 	outb(0x00, nic_base + EN0_RSARLO);
 	outb(start_page, nic_base + EN0_RSARHI);
 	outb(E8390_RWRITE+E8390_START, nic_base + NE_CMD);
 	if (ei_status.ne2k_flags & ONLY_16BIT_IO) {
-		outsw(NE_BASE + NE_DATAPORT, buf, count>>1);
+		outsw(NE_BASE + NE_DATAPORT, buf, count >> 1);
 	} else {
-		outsl(NE_BASE + NE_DATAPORT, buf, count>>2);
+		outsl(NE_BASE + NE_DATAPORT, buf, count >> 2);
 		if (count & 3) {
 			buf +=3D count & ~3;
 			if (count & 2) {
@@ -623,14 +645,15 @@ static void ne2k_pci_block_output(struct net_device =
*dev, int count,
 	dma_start =3D jiffies;

 	while ((inb(nic_base + EN0_ISR) & ENISR_RDC) =3D=3D 0)
-		if (jiffies - dma_start > 2) {			/* Avoid clock roll-over. */
+		/* Avoid clock roll-over. */
+		if (jiffies - dma_start > 2) {
 			netdev_warn(dev, "timeout waiting for Tx RDC.\n");
 			ne2k_pci_reset_8390(dev);
-			NS8390_init(dev,1);
+			NS8390_init(dev, 1);
 			break;
 		}
-
-	outb(ENISR_RDC, nic_base + EN0_ISR);	/* Ack intr. */
+	/* Ack intr. */
+	outb(ENISR_RDC, nic_base + EN0_ISR);
 	ei_status.dmaing &=3D ~0x01;
 }

@@ -640,9 +663,9 @@ static void ne2k_pci_get_drvinfo(struct net_device *de=
v,
 	struct ei_device *ei =3D netdev_priv(dev);
 	struct pci_dev *pci_dev =3D (struct pci_dev *) ei->priv;

-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, pci_name(pci_dev), sizeof(info->bus_info));
 }

 static u32 ne2k_pci_get_msglevel(struct net_device *dev)
@@ -677,9 +700,9 @@ static void ne2k_pci_remove_one(struct pci_dev *pdev)
 }

 #ifdef CONFIG_PM
-static int ne2k_pci_suspend (struct pci_dev *pdev, pm_message_t state)
+static int ne2k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct net_device *dev =3D pci_get_drvdata (pdev);
+	struct net_device *dev =3D pci_get_drvdata(pdev);

 	netif_device_detach(dev);
 	pci_save_state(pdev);
@@ -689,9 +712,9 @@ static int ne2k_pci_suspend (struct pci_dev *pdev, pm_=
message_t state)
 	return 0;
 }

-static int ne2k_pci_resume (struct pci_dev *pdev)
+static int ne2k_pci_resume(struct pci_dev *pdev)
 {
-	struct net_device *dev =3D pci_get_drvdata (pdev);
+	struct net_device *dev =3D pci_get_drvdata(pdev);
 	int rc;

 	pci_set_power_state(pdev, PCI_D0);
@@ -718,24 +741,20 @@ static struct pci_driver ne2k_driver =3D {
 #ifdef CONFIG_PM
 	.suspend	=3D ne2k_pci_suspend,
 	.resume		=3D ne2k_pci_resume,
-#endif /* CONFIG_PM */
+#endif

 };


 static int __init ne2k_pci_init(void)
 {
-/* when a module, this is printed whether or not devices are found in pro=
be */
-#ifdef MODULE
-	printk(version);
-#endif
 	return pci_register_driver(&ne2k_driver);
 }


 static void __exit ne2k_pci_cleanup(void)
 {
-	pci_unregister_driver (&ne2k_driver);
+	pci_unregister_driver(&ne2k_driver);
 }

 module_init(ne2k_pci_init);
=2D-
2.20.1

