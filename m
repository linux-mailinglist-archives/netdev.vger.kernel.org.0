Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D463A654D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhFNLhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:37:13 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4435 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbhFNLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:34:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3Tjg5wW2z6yZ7;
        Mon, 14 Jun 2021 19:28:55 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 06/11] net: z85230: fix the comments style issue
Date:   Mon, 14 Jun 2021 19:28:46 +0800
Message-ID: <1623670131-49973-7-git-send-email-huangguangbin2@huawei.com>
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

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 214 ++++++++++++++++++-----------------------------
 1 file changed, 83 insertions(+), 131 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index ced746d..a3a2051 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *
- *	(c) Copyright 1998 Alan Cox <alan@lxorguk.ukuu.org.uk>
+/*	(c) Copyright 1998 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *	(c) Copyright 2000, 2001 Red Hat Inc
  *
  *	Development of this driver was funded by Equiinet Ltd
@@ -183,8 +181,7 @@ static inline void write_zsdata(struct z8530_channel *c, u8 val)
 	z8530_write_port(c->dataio, val);
 }
 
-/*
- *	Register loading parameters for a dead port
+/*	Register loading parameters for a dead port
  */
  
 u8 z8530_dead_port[]=
@@ -193,12 +190,10 @@ u8 z8530_dead_port[]=
 };
 EXPORT_SYMBOL(z8530_dead_port);
 
-/*
- *	Register loading parameters for currently supported circuit types
+/*	Register loading parameters for currently supported circuit types
  */
 
-/*
- *	Data clocked by telco end. This is the correct data for the UK
+/*	Data clocked by telco end. This is the correct data for the UK
  *	"kilostream" service, and most other similar services.
  */
  
@@ -222,8 +217,7 @@ u8 z8530_hdlc_kilostream[]=
 };
 EXPORT_SYMBOL(z8530_hdlc_kilostream);
 
-/*
- *	As above but for enhanced chips.
+/*	As above but for enhanced chips.
  */
  
 u8 z8530_hdlc_kilostream_85230[]=
@@ -331,8 +325,7 @@ static void z8530_rx(struct z8530_channel *c)
 		ch=read_zsdata(c);
 		stat=read_zsreg(c, R1);
 	
-		/*
-		 *	Overrun ?
+		/*	Overrun ?
 		 */
 		if(c->count < c->max)
 		{
@@ -342,8 +335,7 @@ static void z8530_rx(struct z8530_channel *c)
 
 		if(stat&END_FR)
 		{
-			/*
-			 *	Error ?
+			/*	Error ?
 			 */
 			if(stat&(Rx_OVR|CRC_ERR))
 			{
@@ -365,8 +357,7 @@ static void z8530_rx(struct z8530_channel *c)
 			}
 			else
 			{
-				/*
-				 *	Drop the lock for RX processing, or
+				/*	Drop the lock for RX processing, or
 		 		 *	there are deadlocks
 		 		 */
 				z8530_rx_done(c);
@@ -374,8 +365,7 @@ static void z8530_rx(struct z8530_channel *c)
 			}
 		}
 	}
-	/*
-	 *	Clear irq
+	/*	Clear irq
 	 */
 	write_zsctrl(c, ERR_RES);
 	write_zsctrl(c, RES_H_IUS);
@@ -398,8 +388,7 @@ static void z8530_tx(struct z8530_channel *c)
 		if(!(read_zsreg(c, R0)&4))
 			return;
 		c->txcount--;
-		/*
-		 *	Shovel out the byte
+		/*	Shovel out the byte
 		 */
 		write_zsreg(c, R8, *c->tx_ptr++);
 		write_zsctrl(c, RES_H_IUS);
@@ -411,8 +400,7 @@ static void z8530_tx(struct z8530_channel *c)
 		}
 	}
 
-	/*
-	 *	End of frame TX - fire another one
+	/*	End of frame TX - fire another one
 	 */
 	 
 	write_zsctrl(c, RES_Tx_P);
@@ -607,8 +595,7 @@ static struct z8530_irqhandler z8530_txdma_sync = {
 
 static void z8530_rx_clear(struct z8530_channel *c)
 {
-	/*
-	 *	Data and status bytes
+	/*	Data and status bytes
 	 */
 	u8 stat;
 
@@ -617,8 +604,7 @@ static void z8530_rx_clear(struct z8530_channel *c)
 	
 	if(stat&END_FR)
 		write_zsctrl(c, RES_Rx_CRC);
-	/*
-	 *	Clear irq
+	/*	Clear irq
 	 */
 	write_zsctrl(c, ERR_RES);
 	write_zsctrl(c, RES_H_IUS);
@@ -704,11 +690,13 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 		if(!(intr & (CHARxIP|CHATxIP|CHAEXT|CHBRxIP|CHBTxIP|CHBEXT)))
 			break;
 	
-		/* This holds the IRQ status. On the 8530 you must read it from chan 
-		   A even though it applies to the whole chip */
+		/* This holds the IRQ status. On the 8530 you must read it
+		 * from chan A even though it applies to the whole chip
+		 */
 		
 		/* Now walk the chip and see what it is wanting - it may be
-		   an IRQ for someone else remember */
+		 * an IRQ for someone else remember
+		 */
 		   
 		irqs=dev->chanA.irqs;
 
@@ -835,14 +823,13 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->count = 0;
 	c->skb = NULL;
 	c->skb2 = NULL;
-	/*
-	 *	Load the DMA interfaces up
+
+	/*	Load the DMA interfaces up
 	 */
 	c->rxdma_on = 0;
 	c->txdma_on = 0;
-	
-	/*
-	 *	Allocate the DMA flip buffers. Limit by page size.
+
+	/*	Allocate the DMA flip buffers. Limit by page size.
 	 *	Everyone runs 1500 mtu or less on wan links so this
 	 *	should be fine.
 	 */
@@ -869,14 +856,12 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->dma_num=0;
 	c->dma_ready=1;
 	
-	/*
-	 *	Enable DMA control mode
+	/*	Enable DMA control mode
 	 */
 
 	spin_lock_irqsave(c->lock, cflags);
-	 
-	/*
-	 *	TX DMA via DIR/REQ
+
+	/*	TX DMA via DIR/REQ
 	 */
 	 
 	c->regs[R14]|= DTRREQ;
@@ -884,9 +869,8 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 
 	c->regs[R1]&= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	
-	/*
-	 *	RX DMA via W/Req
+
+	/*	RX DMA via W/Req
 	 */	 
 
 	c->regs[R1]|= WT_FN_RDYFN;
@@ -896,13 +880,11 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R1]|= WT_RDY_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);            
-	
-	/*
-	 *	DMA interrupts
+
+	/*	DMA interrupts
 	 */
-	 
-	/*
-	 *	Set up the DMA configuration
+
+	/*	Set up the DMA configuration
 	 */	
 	 
 	dflags=claim_dma_lock();
@@ -920,9 +902,8 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	disable_dma(c->txdma);
 	
 	release_dma_lock(dflags);
-	
-	/*
-	 *	Select the DMA interrupt handlers
+
+	/*	Select the DMA interrupt handlers
 	 */
 
 	c->rxdma_on = 1;
@@ -956,9 +937,8 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 	c->irqs = &z8530_nop;
 	c->max = 0;
 	c->sync = 0;
-	
-	/*
-	 *	Disable the PC DMA channels
+
+	/*	Disable the PC DMA channels
 	 */
 	
 	flags=claim_dma_lock(); 
@@ -976,8 +956,7 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 
 	spin_lock_irqsave(c->lock, flags);
 
-	/*
-	 *	Disable DMA control mode
+	/*	Disable DMA control mode
 	 */
 	 
 	c->regs[R1]&= ~WT_RDY_ENAB;
@@ -1028,9 +1007,8 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->count = 0;
 	c->skb = NULL;
 	c->skb2 = NULL;
-	
-	/*
-	 *	Allocate the DMA flip buffers. Limit by page size.
+
+	/*	Allocate the DMA flip buffers. Limit by page size.
 	 *	Everyone runs 1500 mtu or less on wan links so this
 	 *	should be fine.
 	 */
@@ -1046,15 +1024,13 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 
 	spin_lock_irqsave(c->lock, cflags);
 
-	/*
-	 *	Load the PIO receive ring
+	/*	Load the PIO receive ring
 	 */
 
 	z8530_rx_done(c);
 	z8530_rx_done(c);
 
-	/*
-	 *	Load the DMA interfaces up
+	/*	Load the DMA interfaces up
 	 */
 
 	c->rxdma_on = 0;
@@ -1065,21 +1041,18 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->dma_ready=1;
 	c->dma_tx = 1;
 
-	/*
-	 *	Enable DMA control mode
+	/*	Enable DMA control mode
 	 */
 
-	/*
-	 *	TX DMA via DIR/REQ
+	/*	TX DMA via DIR/REQ
 	 */
 	c->regs[R14]|= DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);     
 	
 	c->regs[R1]&= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	
-	/*
-	 *	Set up the DMA configuration
+
+	/*	Set up the DMA configuration
 	 */	
 	 
 	dflags = claim_dma_lock();
@@ -1090,9 +1063,8 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	disable_dma(c->txdma);
 
 	release_dma_lock(dflags);
-	
-	/*
-	 *	Select the DMA interrupt handlers
+
+	/*	Select the DMA interrupt handlers
 	 */
 
 	c->rxdma_on = 0;
@@ -1127,9 +1099,8 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	c->irqs = &z8530_nop;
 	c->max = 0;
 	c->sync = 0;
-	
-	/*
-	 *	Disable the PC DMA channels
+
+	/*	Disable the PC DMA channels
 	 */
 	 
 	dflags = claim_dma_lock();
@@ -1141,8 +1112,7 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 
 	release_dma_lock(dflags);
 
-	/*
-	 *	Disable DMA control mode
+	/*	Disable DMA control mode
 	 */
 	 
 	c->regs[R1]&= ~WT_RDY_ENAB;
@@ -1167,8 +1137,7 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 }
 EXPORT_SYMBOL(z8530_sync_txdma_close);
 
-/*
- *	Name strings for Z8530 chips. SGI claim to have a 130, Zilog deny
+/*	Name strings for Z8530 chips. SGI claim to have a 130, Zilog deny
  *	it exists...
  */
  
@@ -1200,14 +1169,14 @@ void z8530_describe(struct z8530_dev *dev, char *mapping, unsigned long io)
 }
 EXPORT_SYMBOL(z8530_describe);
 
-/*
- *	Locked operation part of the z8530 init code
+/*	Locked operation part of the z8530 init code
  */
  
 static inline int do_z8530_init(struct z8530_dev *dev)
 {
 	/* NOP the interrupt handlers first - we might get a
-	   floating IRQ transition when we reset the chip */
+	 * floating IRQ transition when we reset the chip
+	 */
 	dev->chanA.irqs=&z8530_nop;
 	dev->chanB.irqs=&z8530_nop;
 	dev->chanA.dcdcheck=DCD;
@@ -1225,15 +1194,13 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 		return -ENODEV;
 		
 	dev->type=Z8530;
-	
-	/*
-	 *	See the application note.
+
+	/*	See the application note.
 	 */
 	 
 	write_zsreg(&dev->chanA, R15, 0x01);
-	
-	/*
-	 *	If we can set the low bit of R15 then
+
+	/*	If we can set the low bit of R15 then
 	 *	the chip is enhanced.
 	 */
 	 
@@ -1247,17 +1214,15 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 		else
 			dev->type = Z85C30;	/* Z85C30, 1 byte FIFO */
 	}
-		
-	/*
-	 *	The code assumes R7' and friends are
+
+	/*	The code assumes R7' and friends are
 	 *	off. Use write_zsext() for these and keep
 	 *	this bit clear.
 	 */
 	 
 	write_zsreg(&dev->chanA, R15, 0);
-		
-	/*
-	 *	At this point it looks like the chip is behaving
+
+	/*	At this point it looks like the chip is behaving
 	 */
 	 
 	memcpy(dev->chanA.regs, reg_init, 16);
@@ -1404,8 +1369,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 		{
 			flags=claim_dma_lock();
 			disable_dma(c->txdma);
-			/*
-			 *	Check if we crapped out.
+			/*	Check if we crapped out.
 			 */
 			if (get_dma_residue(c->txdma))
 			{
@@ -1422,8 +1386,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 
 		if(c->dma_tx)
 		{
-			/*
-			 *	FIXME. DMA is broken for the original 8530,
+			/*	FIXME. DMA is broken for the original 8530,
 			 *	on the older parts we need to set a flag and
 			 *	wait for a further TX interrupt to fire this
 			 *	stage off	
@@ -1432,8 +1395,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			flags=claim_dma_lock();
 			disable_dma(c->txdma);
 
-			/*
-			 *	These two are needed by the 8530/85C30
+			/*	These two are needed by the 8530/85C30
 			 *	and must be issued when idling.
 			 */
 			 
@@ -1464,8 +1426,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			}
 		}
 	}
-	/*
-	 *	Since we emptied tx_skb we can ask for more
+	/*	Since we emptied tx_skb we can ask for more
 	 */
 	netif_wake_queue(c->netdevice);
 }
@@ -1529,22 +1490,19 @@ static void z8530_rx_done(struct z8530_channel *c)
 {
 	struct sk_buff *skb;
 	int ct;
-	
-	/*
-	 *	Is our receive engine in DMA mode
+
+	/*	Is our receive engine in DMA mode
 	 */
 	if(c->rxdma_on)
 	{
-		/*
-		 *	Save the ready state and the buffer currently
+		/*	Save the ready state and the buffer currently
 		 *	being used as the DMA target
 		 */
 		int ready=c->dma_ready;
 		unsigned char *rxb=c->rx_buf[c->dma_num];
 		unsigned long flags;
-		
-		/*
-		 *	Complete this DMA. Necessary to find the length
+
+		/*	Complete this DMA. Necessary to find the length
 		 */		
 		flags=claim_dma_lock();
 		
@@ -1555,9 +1513,8 @@ static void z8530_rx_done(struct z8530_channel *c)
 		if(ct<0)
 			ct=2;	/* Shit happens.. */
 		c->dma_ready=0;
-		
-		/*
-		 *	Normal case: the other slot is free, start the next DMA
+
+		/*	Normal case: the other slot is free, start the next DMA
 		 *	into it immediately.
 		 */
 		 
@@ -1569,19 +1526,20 @@ static void z8530_rx_done(struct z8530_channel *c)
 			set_dma_count(c->rxdma, c->mtu);
 			c->rxdma_on = 1;
 			enable_dma(c->rxdma);
-			/* Stop any frames that we missed the head of 
-			   from passing */
+			/* Stop any frames that we missed the head of
+			 * from passing
+			 */
 			write_zsreg(c, R0, RES_Rx_CRC);
 		}
 		else
 			/* Can't occur as we dont reenable the DMA irq until
-			   after the flip is done */
+			 * after the flip is done
+			 */
 			netdev_warn(c->netdevice, "DMA flip overrun!\n");
 
 		release_dma_lock(flags);
 
-		/*
-		 *	Shove the old buffer into an sk_buff. We can't DMA
+		/*	Shove the old buffer into an sk_buff. We can't DMA
 		 *	directly into one on a PC - it might be above the 16Mb
 		 *	boundary. Optimisation - we could check to see if we
 		 *	can avoid the copy. Optimisation 2 - make the memcpy
@@ -1603,8 +1561,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		RT_LOCK;
 		skb = c->skb;
 
-		/*
-		 *	The game we play for non DMA is similar. We want to
+		/*	The game we play for non DMA is similar. We want to
 		 *	get the controller set up for the next packet as fast
 		 *	as possible. We potentially only have one byte + the
 		 *	fifo length for this. Thus we want to flip to the new
@@ -1637,8 +1594,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		c->netdevice->stats.rx_packets++;
 		c->netdevice->stats.rx_bytes += ct;
 	}
-	/*
-	 *	If we received a frame we must now process it.
+	/*	If we received a frame we must now process it.
 	 */
 	if (skb) {
 		skb_trim(skb, ct);
@@ -1690,16 +1646,13 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 		return NETDEV_TX_BUSY;
 
 	/* PC SPECIFIC - DMA limits */
-	
-	/*
-	 *	If we will DMA the transmit and its gone over the ISA bus
+	/*	If we will DMA the transmit and its gone over the ISA bus
 	 *	limit, then copy to the flip buffer
 	 */
 	 
 	if(c->dma_tx && ((unsigned long)(virt_to_bus(skb->data+skb->len))>=16*1024*1024 || spans_boundary(skb)))
 	{
-		/* 
-		 *	Send the flip buffer, and flip the flippy bit.
+		/*	Send the flip buffer, and flip the flippy bit.
 		 *	We don't care which is used when just so long as
 		 *	we never use the same buffer twice in a row. Since
 		 *	only one buffer can be going out at a time the other
@@ -1723,8 +1676,7 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(z8530_queue_xmit);
 
-/*
- *	Module support
+/*	Module support
  */
 static const char banner[] __initconst =
 	KERN_INFO "Generic Z85C30/Z85230 interface driver v0.02\n";
-- 
2.8.1

