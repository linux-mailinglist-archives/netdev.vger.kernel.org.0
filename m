Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302533A654A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhFNLhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:37:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9112 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbhFNLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:34:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3Tjx36p2zZdQ6;
        Mon, 14 Jun 2021 19:29:09 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 01/11] net: z85230: remove redundant blank lines
Date:   Mon, 14 Jun 2021 19:28:41 +0800
Message-ID: <1623670131-49973-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
References: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 34 +---------------------------------
 1 file changed, 1 insertion(+), 33 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 002b8c99..f074cb1 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -55,7 +55,6 @@
 
 #include "z85230.h"
 
-
 /**
  *	z8530_read_port - Architecture specific interface function
  *	@p: port to read
@@ -95,7 +94,6 @@ static inline int z8530_read_port(unsigned long p)
  *	dread 5uS sanity delay.
  */
 
-
 static inline void z8530_write_port(unsigned long p, u8 d)
 {
 	outb(d,Z8530_PORT_OF(p));
@@ -103,12 +101,9 @@ static inline void z8530_write_port(unsigned long p, u8 d)
 		udelay(5);
 }
 
-
-
 static void z8530_rx_done(struct z8530_channel *c);
 static void z8530_tx_done(struct z8530_channel *c);
 
-
 /**
  *	read_zsreg - Read a register from a Z85230 
  *	@c: Z8530 channel to read from (2 per chip)
@@ -159,7 +154,6 @@ static inline void write_zsreg(struct z8530_channel *c, u8 reg, u8 val)
 	if(reg)
 		z8530_write_port(c->ctrlio, reg);
 	z8530_write_port(c->ctrlio, val);
-
 }
 
 /**
@@ -182,8 +176,6 @@ static inline void write_zsctrl(struct z8530_channel *c, u8 val)
  *
  *	Write directly to the data register on the Z8530
  */
-
-
 static inline void write_zsdata(struct z8530_channel *c, u8 val)
 {
 	z8530_write_port(c->dataio, val);
@@ -204,7 +196,6 @@ EXPORT_SYMBOL(z8530_dead_port);
  *	Register loading parameters for currently supported circuit types
  */
 
-
 /*
  *	Data clocked by telco end. This is the correct data for the UK
  *	"kilostream" service, and most other similar services.
@@ -352,7 +343,6 @@ static void z8530_rx(struct z8530_channel *c)
 
 		if(stat&END_FR)
 		{
-		
 			/*
 			 *	Error ?
 			 */
@@ -392,7 +382,6 @@ static void z8530_rx(struct z8530_channel *c)
 	write_zsctrl(c, RES_H_IUS);
 }
 
-
 /**
  *	z8530_tx - Handle a PIO transmit event
  *	@c: Z8530 channel to process
@@ -423,7 +412,6 @@ static void z8530_tx(struct z8530_channel *c)
 		}
 	}
 
-	
 	/*
 	 *	End of frame TX - fire another one
 	 */
@@ -474,7 +462,6 @@ static void z8530_status(struct z8530_channel *chan)
 			if (chan->netdevice)
 				netif_carrier_off(chan->netdevice);
 		}
-
 	}
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
@@ -564,7 +551,6 @@ static void z8530_dma_status(struct z8530_channel *chan)
 	
 	chan->status=status;
 
-
 	if(chan->dma_tx)
 	{
 		if(status&TxEOM)
@@ -621,7 +607,6 @@ static struct z8530_irqhandler z8530_txdma_sync = {
  *	(eg the MacII) we must clear the interrupt cause or die.
  */
 
-
 static void z8530_rx_clear(struct z8530_channel *c)
 {
 	/*
@@ -680,7 +665,6 @@ struct z8530_irqhandler z8530_nop = {
 	.status = z8530_status_clear,
 };
 
-
 EXPORT_SYMBOL(z8530_nop);
 
 /**
@@ -718,7 +702,6 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 
 	while(++work<5000)
 	{
-
 		intr = read_zsreg(&dev->chanA, R3);
 		if(!(intr & (CHARxIP|CHATxIP|CHAEXT|CHBRxIP|CHBTxIP|CHBEXT)))
 			break;
@@ -772,7 +755,6 @@ static const u8 reg_init[16]=
 	0x55,0,0,0
 };
 
-
 /**
  *	z8530_sync_open - Open a Z8530 channel for PIO
  *	@dev:	The network interface we are using
@@ -808,7 +790,6 @@ int z8530_sync_open(struct net_device *dev, struct z8530_channel *c)
 	return 0;
 }
 
-
 EXPORT_SYMBOL(z8530_sync_open);
 
 /**
@@ -1070,7 +1051,6 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 
 	c->tx_dma_buf[1] = c->tx_dma_buf[0] + PAGE_SIZE/2;
 
-
 	spin_lock_irqsave(c->lock, cflags);
 
 	/*
@@ -1150,7 +1130,6 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	unsigned long dflags, cflags;
 	u8 chk;
 
-	
 	spin_lock_irqsave(c->lock, cflags);
 	
 	c->irqs = &z8530_nop;
@@ -1195,10 +1174,8 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	return 0;
 }
 
-
 EXPORT_SYMBOL(z8530_sync_txdma_close);
 
-
 /*
  *	Name strings for Z8530 chips. SGI claim to have a 130, Zilog deny
  *	it exists...
@@ -1333,7 +1310,6 @@ int z8530_init(struct z8530_dev *dev)
 	return ret;
 }
 
-
 EXPORT_SYMBOL(z8530_init);
 
 /**
@@ -1408,7 +1384,6 @@ int z8530_channel_load(struct z8530_channel *c, u8 *rtable)
 
 EXPORT_SYMBOL(z8530_channel_load);
 
-
 /**
  *	z8530_tx_begin - Begin packet transmission
  *	@c: The Z8530 channel to kick
@@ -1455,8 +1430,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 	else
 	{
 		c->txcount=c->tx_skb->len;
-		
-		
+
 		if(c->dma_tx)
 		{
 			/*
@@ -1490,7 +1464,6 @@ static void z8530_tx_begin(struct z8530_channel *c)
 		}
 		else
 		{
-
 			/* ABUNDER off */
 			write_zsreg(c, R10, c->regs[10]);
 			write_zsctrl(c, RES_Tx_CRC);
@@ -1500,7 +1473,6 @@ static void z8530_tx_begin(struct z8530_channel *c)
 				write_zsreg(c, R8, *c->tx_ptr++);
 				c->txcount--;
 			}
-
 		}
 	}
 	/*
@@ -1573,14 +1545,12 @@ static void z8530_rx_done(struct z8530_channel *c)
 	/*
 	 *	Is our receive engine in DMA mode
 	 */
-	 
 	if(c->rxdma_on)
 	{
 		/*
 		 *	Save the ready state and the buffer currently
 		 *	being used as the DMA target
 		 */
-		 
 		int ready=c->dma_ready;
 		unsigned char *rxb=c->rx_buf[c->dma_num];
 		unsigned long flags;
@@ -1588,7 +1558,6 @@ static void z8530_rx_done(struct z8530_channel *c)
 		/*
 		 *	Complete this DMA. Necessary to find the length
 		 */		
-		 
 		flags=claim_dma_lock();
 		
 		disable_dma(c->rxdma);
@@ -1731,7 +1700,6 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	if(c->tx_next_skb)
 		return NETDEV_TX_BUSY;
 
-	
 	/* PC SPECIFIC - DMA limits */
 	
 	/*
-- 
2.8.1

