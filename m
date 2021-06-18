Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F43AC0DB
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbhFRCh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 22:37:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8268 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbhFRChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 22:37:48 -0400
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5jZf5fYDz1BNm7;
        Fri, 18 Jun 2021 10:30:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 10:35:37 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 6/7] net: hostess_sv11: fix the comments style issue
Date:   Fri, 18 Jun 2021 10:32:23 +0800
Message-ID: <1623983544-39879-7-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
References: <1623983544-39879-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/hostess_sv11.c | 48 ++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wan/hostess_sv11.c b/drivers/net/wan/hostess_sv11.c
index 4e11c86..992181a 100644
--- a/drivers/net/wan/hostess_sv11.c
+++ b/drivers/net/wan/hostess_sv11.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- *	Comtrol SV11 card driver
+/*	Comtrol SV11 card driver
  *
  *	This is a slightly odd Z85230 synchronous driver. All you need to
  *	know basically is
@@ -44,8 +43,7 @@
 
 static int dma;
 
-/*
- *	Network driver support routines
+/*	Network driver support routines
  */
 
 static inline struct z8530_dev *dev_to_sv(struct net_device *dev)
@@ -53,8 +51,7 @@ static inline struct z8530_dev *dev_to_sv(struct net_device *dev)
 	return (struct z8530_dev *)dev_to_hdlc(dev)->priv;
 }
 
-/*
- *	Frame receive. Simple for our card as we do HDLC and there
+/*	Frame receive. Simple for our card as we do HDLC and there
  *	is no funny garbage involved
  */
 
@@ -65,15 +62,13 @@ static void hostess_input(struct z8530_channel *c, struct sk_buff *skb)
 	skb->protocol = hdlc_type_trans(skb, c->netdevice);
 	skb_reset_mac_header(skb);
 	skb->dev = c->netdevice;
-	/*
-	 *	Send it to the PPP layer. We don't have time to process
+	/*	Send it to the PPP layer. We don't have time to process
 	 *	it right now.
 	 */
 	netif_rx(skb);
 }
 
-/*
- *	We've been placed in the UP state
+/*	We've been placed in the UP state
  */
 
 static int hostess_open(struct net_device *d)
@@ -81,8 +76,7 @@ static int hostess_open(struct net_device *d)
 	struct z8530_dev *sv11 = dev_to_sv(d);
 	int err = -1;
 
-	/*
-	 *	Link layer up
+	/*	Link layer up
 	 */
 	switch (dma) {
 	case 0:
@@ -127,8 +121,7 @@ static int hostess_open(struct net_device *d)
 static int hostess_close(struct net_device *d)
 {
 	struct z8530_dev *sv11 = dev_to_sv(d);
-	/*
-	 *	Discard new frames
+	/*	Discard new frames
 	 */
 	sv11->chanA.rx_function = z8530_null_rx;
 
@@ -154,8 +147,7 @@ static int hostess_ioctl(struct net_device *d, struct ifreq *ifr, int cmd)
 	return hdlc_ioctl(d, ifr, cmd);
 }
 
-/*
- *	Passed network frames, fire them downwind.
+/*	Passed network frames, fire them downwind.
  */
 
 static netdev_tx_t hostess_queue_xmit(struct sk_buff *skb,
@@ -172,8 +164,7 @@ static int hostess_attach(struct net_device *dev, unsigned short encoding,
 	return -EINVAL;
 }
 
-/*
- *	Description block for a Comtrol Hostess SV11 card
+/*	Description block for a Comtrol Hostess SV11 card
  */
 
 static const struct net_device_ops hostess_ops = {
@@ -187,8 +178,7 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 {
 	struct z8530_dev *sv;
 	struct net_device *netdev;
-	/*
-	 *	Get the needed I/O space
+	/*	Get the needed I/O space
 	 */
 
 	if (!request_region(iobase, 8, "Comtrol SV11")) {
@@ -200,8 +190,7 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 	if (!sv)
 		goto err_kzalloc;
 
-	/*
-	 *	Stuff in the I/O addressing
+	/*	Stuff in the I/O addressing
 	 */
 
 	sv->active = 0;
@@ -216,7 +205,8 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 	outb(0, iobase + 4);		/* DMA off */
 
 	/* We want a fast IRQ for this device. Actually we'd like an even faster
-	   IRQ ;) - This is one driver RtLinux is made for */
+	 * IRQ ;) - This is one driver RtLinux is made for
+	 */
 
 	if (request_irq(irq, z8530_interrupt, 0,
 			"Hostess SV11", sv) < 0) {
@@ -230,8 +220,7 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 	sv->chanB.dev = sv;
 
 	if (dma) {
-		/*
-		 *	You can have DMA off or 1 and 3 thats the lot
+		/*	You can have DMA off or 1 and 3 thats the lot
 		 *	on the Comtrol.
 		 */
 		sv->chanA.txdma = 3;
@@ -246,11 +235,11 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 	}
 
 	/* Kill our private IRQ line the hostess can end up chattering
-	   until the configuration is set */
+	 * until the configuration is set
+	 */
 	disable_irq(irq);
 
-	/*
-	 *	Begin normal initialise
+	/*	Begin normal initialise
 	 */
 
 	if (z8530_init(sv)) {
@@ -266,8 +255,7 @@ static struct z8530_dev *sv11_init(int iobase, int irq)
 
 	enable_irq(irq);
 
-	/*
-	 *	Now we can take the IRQ
+	/*	Now we can take the IRQ
 	 */
 
 	sv->chanA.netdevice = netdev = alloc_hdlcdev(sv);
-- 
2.8.1

