Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF638EA4B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhEXOx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3932 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhEXOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 10:51:54 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fpg6R0XgwzBvt8;
        Mon, 24 May 2021 22:47:27 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 24 May 2021 22:50:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 04/10] net: wan: code indent use tabs where possible
Date:   Mon, 24 May 2021 22:47:11 +0800
Message-ID: <1621867637-2680-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
References: <1621867637-2680-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Code indent should use tabs where possible.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/wanxl.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 566c519c6f65..0bcb21ddcc62 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -54,7 +54,7 @@ struct port {
 	struct net_device *dev;
 	struct card *card;
 	spinlock_t lock;	/* for wanxl_xmit */
-        int node;		/* physical port #0 - 3 */
+	int node;		/* physical port #0 - 3 */
 	unsigned int clock_type;
 	int tx_in, tx_out;
 	struct sk_buff *tx_skbs[TX_BUFFERS];
@@ -153,7 +153,7 @@ static inline void wanxl_tx_intr(struct port *port)
 	struct net_device *dev = port->dev;
 
 	while (1) {
-                desc_t *desc = &get_status(port)->tx_descs[port->tx_in];
+		desc_t *desc = &get_status(port)->tx_descs[port->tx_in];
 		struct sk_buff *skb = port->tx_skbs[port->tx_in];
 
 		switch (desc->stat) {
@@ -171,12 +171,12 @@ static inline void wanxl_tx_intr(struct port *port)
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += skb->len;
 		}
-                desc->stat = PACKET_EMPTY; /* Free descriptor */
+		desc->stat = PACKET_EMPTY; /* Free descriptor */
 		dma_unmap_single(&port->card->pdev->dev, desc->address,
 				 skb->len, DMA_TO_DEVICE);
 		dev_consume_skb_irq(skb);
-                port->tx_in = (port->tx_in + 1) % TX_BUFFERS;
-        }
+		port->tx_in = (port->tx_in + 1) % TX_BUFFERS;
+	}
 }
 
 /* Receive complete interrupt service */
@@ -233,15 +233,15 @@ static inline void wanxl_rx_intr(struct card *card)
 static irqreturn_t wanxl_intr(int irq, void *dev_id)
 {
 	struct card *card = dev_id;
-        int i;
-        u32 stat;
-        int handled = 0;
+	int i;
+	u32 stat;
+	int handled = 0;
 
-        while((stat = readl(card->plx + PLX_DOORBELL_FROM_CARD)) != 0) {
-                handled = 1;
+	while ((stat = readl(card->plx + PLX_DOORBELL_FROM_CARD)) != 0) {
+		handled = 1;
 		writel(stat, card->plx + PLX_DOORBELL_FROM_CARD);
 
-                for (i = 0; i < card->n_ports; i++) {
+		for (i = 0; i < card->n_ports; i++) {
 			if (stat & (1 << (DOORBELL_FROM_CARD_TX_0 + i)))
 				wanxl_tx_intr(&card->ports[i]);
 			if (stat & (1 << (DOORBELL_FROM_CARD_CABLE_0 + i)))
@@ -249,9 +249,9 @@ static irqreturn_t wanxl_intr(int irq, void *dev_id)
 		}
 		if (stat & (1 << DOORBELL_FROM_CARD_RX))
 			wanxl_rx_intr(card);
-        }
+	}
 
-        return IRQ_RETVAL(handled);
+	return IRQ_RETVAL(handled);
 }
 
 static netdev_tx_t wanxl_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -259,11 +259,11 @@ static netdev_tx_t wanxl_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct port *port = dev_to_port(dev);
 	desc_t *desc;
 
-        spin_lock(&port->lock);
+	spin_lock(&port->lock);
 
 	desc = &get_status(port)->tx_descs[port->tx_out];
-        if (desc->stat != PACKET_EMPTY) {
-                /* should never happen - previous xmit should stop queue */
+	if (desc->stat != PACKET_EMPTY) {
+		/* should never happen - previous xmit should stop queue */
 #ifdef DEBUG_PKT
                 printk(KERN_DEBUG "%s: transmitter buffer full\n", dev->name);
 #endif
@@ -366,7 +366,7 @@ static int wanxl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	default:
 		return hdlc_ioctl(dev, ifr, cmd);
-        }
+	}
 }
 
 static int wanxl_open(struct net_device *dev)
-- 
2.8.1

