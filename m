Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFF4394FD4
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 08:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhE3G3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 02:29:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5147 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhE3G3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 02:29:20 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ft7gv2kL2zYpTY;
        Sun, 30 May 2021 14:24:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:41 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 30 May 2021 14:27:40 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 09/10] net: sealevel: fix the comments style issue
Date:   Sun, 30 May 2021 14:24:33 +0800
Message-ID: <1622355874-18933-10-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
References: <1622355874-18933-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/sealevel.c | 60 ++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wan/sealevel.c b/drivers/net/wan/sealevel.c
index 6665732f96ce..60028cfaaab5 100644
--- a/drivers/net/wan/sealevel.c
+++ b/drivers/net/wan/sealevel.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *	Sealevel Systems 4021 driver.
+/*	Sealevel Systems 4021 driver.
  *
  *	(c) Copyright 1999, 2001 Alan Cox
  *	(c) Copyright 2001 Red Hat Inc.
@@ -40,17 +39,14 @@ struct slvl_board {
 	int iobase;
 };
 
-/*
- *	Network driver support routines
- */
+ /*	Network driver support routines */
 
 static inline struct slvl_device *dev_to_chan(struct net_device *dev)
 {
 	return (struct slvl_device *)dev_to_hdlc(dev)->priv;
 }
 
-/*
- *	Frame receive. Simple for our card as we do HDLC and there
+/*	Frame receive. Simple for our card as we do HDLC and there
  *	is no funny garbage involved
  */
 
@@ -64,9 +60,7 @@ static void sealevel_input(struct z8530_channel *c, struct sk_buff *skb)
 	netif_rx(skb);
 }
 
-/*
- *	We've been placed in the UP state
- */
+ /*	We've been placed in the UP state */
 
 static int sealevel_open(struct net_device *d)
 {
@@ -74,9 +68,7 @@ static int sealevel_open(struct net_device *d)
 	int err = -1;
 	int unit = slvl->channel;
 
-	/*
-	 *	Link layer up.
-	 */
+	 /*	Link layer up. */
 
 	switch (unit) {
 	case 0:
@@ -114,9 +106,7 @@ static int sealevel_close(struct net_device *d)
 	struct slvl_device *slvl = dev_to_chan(d);
 	int unit = slvl->channel;
 
-	/*
-	 *	Discard new frames
-	 */
+	/*	Discard new frames */
 
 	slvl->chan->rx_function = z8530_null_rx;
 
@@ -137,13 +127,12 @@ static int sealevel_close(struct net_device *d)
 static int sealevel_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 {
 	/* struct slvl_device *slvl=dev_to_chan(d);
-	   z8530_ioctl(d,&slvl->sync.chanA,ifr,cmd) */
+	 * z8530_ioctl(d,&slvl->sync.chanA,ifr,cmd)
+	 */
 	return hdlc_ioctl(d, ifr, cmd);
 }
 
-/*
- *	Passed network frames, fire them downwind.
- */
+/*	Passed network frames, fire them downwind. */
 
 static netdev_tx_t sealevel_queue_xmit(struct sk_buff *skb,
 					     struct net_device *d)
@@ -189,9 +178,7 @@ static int slvl_setup(struct slvl_device *sv, int iobase, int irq)
 	return 0;
 }
 
-/*
- *	Allocate and setup Sealevel board.
- */
+/*	Allocate and setup Sealevel board. */
 
 static __init struct slvl_board *slvl_init(int iobase, int irq,
 					   int txdma, int rxdma, int slow)
@@ -199,9 +186,7 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 	struct z8530_dev *dev;
 	struct slvl_board *b;
 
-	/*
-	 *	Get the needed I/O space
-	 */
+	/*	Get the needed I/O space */
 
 	if (!request_region(iobase, 8, "Sealevel 4021")) {
 		pr_warn("I/O 0x%X already in use\n", iobase);
@@ -220,17 +205,13 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 
 	dev = &b->board;
 
-	/*
-	 *	Stuff in the I/O addressing
-	 */
+	/*	Stuff in the I/O addressing */
 
 	dev->active = 0;
 
 	b->iobase = iobase;
 
-	/*
-	 *	Select 8530 delays for the old board
-	 */
+	/*	Select 8530 delays for the old board */
 
 	if (slow)
 		iobase |= Z8530_PORT_SLEEP;
@@ -243,14 +224,13 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 	dev->chanA.irqs = &z8530_nop;
 	dev->chanB.irqs = &z8530_nop;
 
-	/*
-	 *	Assert DTR enable DMA
-	 */
+	/*	Assert DTR enable DMA */
 
 	outb(3 | (1 << 7), b->iobase + 4);
 
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
-	   IRQ ;) - This is one driver RtLinux is made for */
+	 * IRQ ;) - This is one driver RtLinux is made for
+	 */
 
 	if (request_irq(irq, z8530_interrupt, 0,
 			"SeaLevel", dev) < 0) {
@@ -274,9 +254,7 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 
 	disable_irq(irq);
 
-	/*
-	 *	Begin normal initialise
-	 */
+	/*	Begin normal initialise */
 
 	if (z8530_init(dev) != 0) {
 		pr_err("Z8530 series device not found\n");
@@ -291,9 +269,7 @@ static __init struct slvl_board *slvl_init(int iobase, int irq,
 		z8530_channel_load(&dev->chanB, z8530_hdlc_kilostream_85230);
 	}
 
-	/*
-	 *	Now we can take the IRQ
-	 */
+	/*	Now we can take the IRQ */
 
 	enable_irq(irq);
 
-- 
2.8.1

