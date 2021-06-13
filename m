Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B23A56EE
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 09:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhFMHnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 03:43:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4058 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhFMHnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 03:43:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G2mc65V4nzWrJH;
        Sun, 13 Jun 2021 15:36:38 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:35 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 13 Jun 2021 15:41:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 09/11] net: z85230: add some required spaces
Date:   Sun, 13 Jun 2021 15:38:21 +0800
Message-ID: <1623569903-47930-10-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
References: <1623569903-47930-1-git-send-email-huangguangbin2@huawei.com>
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

Add space required before the open parenthesis '(' and '{'.
Add space required after that close brace '}' and ','
Add spaces required around that '=' , '&', '*', '|', '+', '/' and '-'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 418 ++++++++++++++++++++++++-----------------------
 1 file changed, 210 insertions(+), 208 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index ea4628c..35aa032 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -71,9 +71,9 @@
 
 static inline int z8530_read_port(unsigned long p)
 {
-	u8 r=inb(Z8530_PORT_OF(p));
+	u8 r = inb(Z8530_PORT_OF(p));
 
-	if(p&Z8530_PORT_SLEEP)	/* gcc should figure this out efficiently ! */
+	if (p & Z8530_PORT_SLEEP) /* gcc should figure this out efficiently ! */
 		udelay(5);
 	return r;
 }
@@ -95,8 +95,8 @@ static inline int z8530_read_port(unsigned long p)
 
 static inline void z8530_write_port(unsigned long p, u8 d)
 {
-	outb(d,Z8530_PORT_OF(p));
-	if(p&Z8530_PORT_SLEEP)
+	outb(d, Z8530_PORT_OF(p));
+	if (p & Z8530_PORT_SLEEP)
 		udelay(5);
 }
 
@@ -116,7 +116,7 @@ static void z8530_tx_done(struct z8530_channel *c);
 
 static inline u8 read_zsreg(struct z8530_channel *c, u8 reg)
 {
-	if(reg)
+	if (reg)
 		z8530_write_port(c->ctrlio, reg);
 	return z8530_read_port(c->ctrlio);
 }
@@ -133,7 +133,7 @@ static inline u8 read_zsdata(struct z8530_channel *c)
 {
 	u8 r;
 
-	r=z8530_read_port(c->dataio);
+	r = z8530_read_port(c->dataio);
 	return r;
 }
 
@@ -151,7 +151,7 @@ static inline u8 read_zsdata(struct z8530_channel *c)
  */
 static inline void write_zsreg(struct z8530_channel *c, u8 reg, u8 val)
 {
-	if(reg)
+	if (reg)
 		z8530_write_port(c->ctrlio, reg);
 	z8530_write_port(c->ctrlio, val);
 }
@@ -184,7 +184,7 @@ static inline void write_zsdata(struct z8530_channel *c, u8 val)
 /*	Register loading parameters for a dead port
  */
 
-u8 z8530_dead_port[]=
+u8 z8530_dead_port[] =
 {
 	255
 };
@@ -197,22 +197,22 @@ EXPORT_SYMBOL(z8530_dead_port);
  *	"kilostream" service, and most other similar services.
  */
 
-u8 z8530_hdlc_kilostream[]=
+u8 z8530_hdlc_kilostream[] =
 {
-	4,	SYNC_ENAB|SDLC|X1CLK,
+	4,	SYNC_ENAB | SDLC | X1CLK,
 	2,	0,	/* No vector */
 	1,	0,
-	3,	ENT_HM|RxCRC_ENAB|Rx8,
-	5,	TxCRC_ENAB|RTS|TxENAB|Tx8|DTR,
+	3,	ENT_HM | RxCRC_ENAB | Rx8,
+	5,	TxCRC_ENAB | RTS | TxENAB | Tx8 | DTR,
 	9,	0,		/* Disable interrupts */
 	6,	0xFF,
 	7,	FLAG,
-	10,	ABUNDER|NRZ|CRCPS,/*MARKIDLE ??*/
+	10,	ABUNDER | NRZ | CRCPS, /*MARKIDLE ??*/
 	11,	TCTRxCP,
 	14,	DISDPLL,
-	15,	DCDIE|SYNCIE|CTSIE|TxUIE|BRKIE,
-	1,	EXT_INT_ENAB|TxINT_ENAB|INT_ALL_Rx,
-	9,	NV|MIE|NORESET,
+	15,	DCDIE | SYNCIE | CTSIE | TxUIE | BRKIE,
+	1,	EXT_INT_ENAB | TxINT_ENAB | INT_ALL_Rx,
+	9,	NV | MIE | NORESET,
 	255
 };
 EXPORT_SYMBOL(z8530_hdlc_kilostream);
@@ -220,22 +220,22 @@ EXPORT_SYMBOL(z8530_hdlc_kilostream);
 /*	As above but for enhanced chips.
  */
 
-u8 z8530_hdlc_kilostream_85230[]=
+u8 z8530_hdlc_kilostream_85230[] =
 {
-	4,	SYNC_ENAB|SDLC|X1CLK,
+	4,	SYNC_ENAB | SDLC | X1CLK,
 	2,	0,	/* No vector */
 	1,	0,
-	3,	ENT_HM|RxCRC_ENAB|Rx8,
-	5,	TxCRC_ENAB|RTS|TxENAB|Tx8|DTR,
+	3,	ENT_HM | RxCRC_ENAB | Rx8,
+	5,	TxCRC_ENAB | RTS | TxENAB | Tx8 | DTR,
 	9,	0,		/* Disable interrupts */
 	6,	0xFF,
 	7,	FLAG,
-	10,	ABUNDER|NRZ|CRCPS,	/* MARKIDLE?? */
+	10,	ABUNDER | NRZ | CRCPS,	/* MARKIDLE?? */
 	11,	TCTRxCP,
 	14,	DISDPLL,
-	15,	DCDIE|SYNCIE|CTSIE|TxUIE|BRKIE,
-	1,	EXT_INT_ENAB|TxINT_ENAB|INT_ALL_Rx,
-	9,	NV|MIE|NORESET,
+	15,	DCDIE | SYNCIE | CTSIE | TxUIE | BRKIE,
+	1,	EXT_INT_ENAB | TxINT_ENAB | INT_ALL_Rx,
+	9,	NV | MIE | NORESET,
 	23,	3,		/* Extended mode AUTO TX and EOM*/
 
 	255
@@ -260,7 +260,7 @@ static void z8530_flush_fifo(struct z8530_channel *c)
 	read_zsreg(c, R1);
 	read_zsreg(c, R1);
 	read_zsreg(c, R1);
-	if(c->dev->type==Z85230)
+	if (c->dev->type == Z85230)
 	{
 		read_zsreg(c, R1);
 		read_zsreg(c, R1);
@@ -315,40 +315,40 @@ static void z8530_rtsdtr(struct z8530_channel *c, int set)
 
 static void z8530_rx(struct z8530_channel *c)
 {
-	u8 ch,stat;
+	u8 ch, stat;
 
-	while(1)
+	while (1)
 	{
 		/* FIFO empty ? */
-		if(!(read_zsreg(c, R0)&1))
+		if (!(read_zsreg(c, R0) & 1))
 			break;
-		ch=read_zsdata(c);
-		stat=read_zsreg(c, R1);
+		ch = read_zsdata(c);
+		stat = read_zsreg(c, R1);
 
 		/*	Overrun ?
 		 */
-		if(c->count < c->max)
+		if (c->count < c->max)
 		{
-			*c->dptr++=ch;
+			*c->dptr++ = ch;
 			c->count++;
 		}
 
-		if(stat&END_FR)
+		if (stat & END_FR)
 		{
 			/*	Error ?
 			 */
-			if(stat&(Rx_OVR|CRC_ERR))
+			if (stat & (Rx_OVR | CRC_ERR))
 			{
 				/* Rewind the buffer and return */
-				if(c->skb)
-					c->dptr=c->skb->data;
-				c->count=0;
-				if(stat&Rx_OVR)
+				if (c->skb)
+					c->dptr = c->skb->data;
+				c->count = 0;
+				if (stat & Rx_OVR)
 				{
 					pr_warn("%s: overrun\n", c->dev->name);
 					c->rx_overrun++;
 				}
-				if(stat&CRC_ERR)
+				if (stat & CRC_ERR)
 				{
 					c->rx_crc_err++;
 					/* printk("crc error\n"); */
@@ -356,8 +356,8 @@ static void z8530_rx(struct z8530_channel *c)
 				/* Shove the frame upstream */
 			} else {
 				/*	Drop the lock for RX processing, or
-		 		 *	there are deadlocks
-		 		 */
+				 *	there are deadlocks
+				 */
 				z8530_rx_done(c);
 				write_zsctrl(c, RES_Rx_CRC);
 			}
@@ -381,9 +381,9 @@ static void z8530_rx(struct z8530_channel *c)
 
 static void z8530_tx(struct z8530_channel *c)
 {
-	while(c->txcount) {
+	while (c->txcount) {
 		/* FIFO full ? */
-		if(!(read_zsreg(c, R0)&4))
+		if (!(read_zsreg(c, R0) & 4))
 			return;
 		c->txcount--;
 		/*	Shovel out the byte
@@ -391,10 +391,10 @@ static void z8530_tx(struct z8530_channel *c)
 		write_zsreg(c, R8, *c->tx_ptr++);
 		write_zsctrl(c, RES_H_IUS);
 		/* We are about to underflow */
-		if(c->txcount==0)
+		if (c->txcount == 0)
 		{
 			write_zsctrl(c, RES_EOM_L);
-			write_zsreg(c, R10, c->regs[10]&~ABUNDER);
+			write_zsreg(c, R10, c->regs[10] & ~ABUNDER);
 		}
 	}
 
@@ -471,7 +471,7 @@ EXPORT_SYMBOL(z8530_sync);
 
 static void z8530_dma_rx(struct z8530_channel *chan)
 {
-	if(chan->rxdma_on)
+	if (chan->rxdma_on)
 	{
 		/* Special condition check only */
 		u8 status;
@@ -479,12 +479,11 @@ static void z8530_dma_rx(struct z8530_channel *chan)
 		read_zsreg(chan, R7);
 		read_zsreg(chan, R6);
 
-		status=read_zsreg(chan, R1);
+		status = read_zsreg(chan, R1);
 
-		if(status&END_FR)
-		{
+		if (status & END_FR)
 			z8530_rx_done(chan);	/* Fire up the next one */
-		}
+
 		write_zsctrl(chan, ERR_RES);
 		write_zsctrl(chan, RES_H_IUS);
 	} else {
@@ -502,7 +501,7 @@ static void z8530_dma_rx(struct z8530_channel *chan)
  */
 static void z8530_dma_tx(struct z8530_channel *chan)
 {
-	if(!chan->dma_tx)
+	if (!chan->dma_tx)
 	{
 		pr_warn("Hey who turned the DMA off?\n");
 		z8530_tx(chan);
@@ -526,21 +525,21 @@ static void z8530_dma_status(struct z8530_channel *chan)
 {
 	u8 status, altered;
 
-	status=read_zsreg(chan, R0);
-	altered=chan->status^status;
+	status = read_zsreg(chan, R0);
+	altered = chan->status ^ status;
 
-	chan->status=status;
+	chan->status = status;
 
-	if(chan->dma_tx)
+	if (chan->dma_tx)
 	{
-		if(status&TxEOM)
+		if (status & TxEOM)
 		{
 			unsigned long flags;
 
-			flags=claim_dma_lock();
+			flags = claim_dma_lock();
 			disable_dma(chan->txdma);
 			clear_dma_ff(chan->txdma);
-			chan->txdma_on=0;
+			chan->txdma_on = 0;
 			release_dma_lock(flags);
 			z8530_tx_done(chan);
 		}
@@ -594,9 +593,9 @@ static void z8530_rx_clear(struct z8530_channel *c)
 	u8 stat;
 
 	read_zsdata(c);
-	stat=read_zsreg(c, R1);
+	stat = read_zsreg(c, R1);
 
-	if(stat&END_FR)
+	if (stat & END_FR)
 		write_zsctrl(c, RES_Rx_CRC);
 	/*	Clear irq
 	 */
@@ -630,9 +629,9 @@ static void z8530_tx_clear(struct z8530_channel *c)
 
 static void z8530_status_clear(struct z8530_channel *chan)
 {
-	u8 status=read_zsreg(chan, R0);
+	u8 status = read_zsreg(chan, R0);
 
-	if(status&TxEOM)
+	if (status & TxEOM)
 		write_zsctrl(chan, ERR_RES);
 	write_zsctrl(chan, RES_EXT_INT);
 	write_zsctrl(chan, RES_H_IUS);
@@ -647,7 +646,7 @@ EXPORT_SYMBOL(z8530_nop);
 
 /**
  *	z8530_interrupt - Handle an interrupt from a Z8530
- *	@irq: 	Interrupt number
+ *	@irq: Interrupt number
  *	@dev_id: The Z8530 device that is interrupting.
  *
  *	A Z85[2]30 device has stuck its hand in the air for attention.
@@ -663,25 +662,26 @@ EXPORT_SYMBOL(z8530_nop);
 
 irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
-	struct z8530_dev *dev=dev_id;
+	struct z8530_dev *dev = dev_id;
 	u8 intr;
 	static int locker;
-	int work=0;
+	int work = 0;
 	struct z8530_irqhandler *irqs;
 
-	if(locker)
+	if (locker)
 	{
 		pr_err("IRQ re-enter\n");
 		return IRQ_NONE;
 	}
-	locker=1;
+	locker = 1;
 
 	spin_lock(&dev->lock);
 
-	while(++work<5000)
+	while (++work < 5000)
 	{
 		intr = read_zsreg(&dev->chanA, R3);
-		if(!(intr & (CHARxIP|CHATxIP|CHAEXT|CHBRxIP|CHBTxIP|CHBEXT)))
+		if (!(intr &
+		    (CHARxIP | CHATxIP | CHAEXT | CHBRxIP | CHBTxIP | CHBEXT)))
 			break;
 
 		/* This holds the IRQ status. On the 8530 you must read it
@@ -692,46 +692,46 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 		 * an IRQ for someone else remember
 		 */
 
-		irqs=dev->chanA.irqs;
+		irqs = dev->chanA.irqs;
 
-		if(intr & (CHARxIP|CHATxIP|CHAEXT))
+		if (intr & (CHARxIP | CHATxIP | CHAEXT))
 		{
-			if(intr&CHARxIP)
+			if (intr & CHARxIP)
 				irqs->rx(&dev->chanA);
-			if(intr&CHATxIP)
+			if (intr & CHATxIP)
 				irqs->tx(&dev->chanA);
-			if(intr&CHAEXT)
+			if (intr & CHAEXT)
 				irqs->status(&dev->chanA);
 		}
 
-		irqs=dev->chanB.irqs;
+		irqs = dev->chanB.irqs;
 
-		if(intr & (CHBRxIP|CHBTxIP|CHBEXT))
+		if (intr & (CHBRxIP | CHBTxIP | CHBEXT))
 		{
-			if(intr&CHBRxIP)
+			if (intr & CHBRxIP)
 				irqs->rx(&dev->chanB);
-			if(intr&CHBTxIP)
+			if (intr & CHBTxIP)
 				irqs->tx(&dev->chanB);
-			if(intr&CHBEXT)
+			if (intr & CHBEXT)
 				irqs->status(&dev->chanB);
 		}
 	}
 	spin_unlock(&dev->lock);
-	if(work==5000)
+	if (work == 5000)
 		pr_err("%s: interrupt jammed - abort(0x%X)!\n",
 		       dev->name, intr);
 	/* Ok all done */
-	locker=0;
+	locker = 0;
 	return IRQ_HANDLED;
 }
 EXPORT_SYMBOL(z8530_interrupt);
 
-static const u8 reg_init[16]=
+static const u8 reg_init[16] =
 {
-	0,0,0,0,
-	0,0,0,0,
-	0,0,0,0,
-	0x55,0,0,0
+	0, 0, 0, 0,
+	0, 0, 0, 0,
+	0, 0, 0, 0,
+	0x55, 0, 0, 0
 };
 
 /**
@@ -749,7 +749,7 @@ int z8530_sync_open(struct net_device *dev, struct z8530_channel *c)
 	spin_lock_irqsave(c->lock, flags);
 
 	c->sync = 1;
-	c->mtu = dev->mtu+64;
+	c->mtu = dev->mtu + 64;
 	c->count = 0;
 	c->skb = NULL;
 	c->skb2 = NULL;
@@ -758,11 +758,11 @@ int z8530_sync_open(struct net_device *dev, struct z8530_channel *c)
 	/* This loads the double buffer up */
 	z8530_rx_done(c);	/* Load the frame ring */
 	z8530_rx_done(c);	/* Load the backup frame */
-	z8530_rtsdtr(c,1);
+	z8530_rtsdtr(c, 1);
 	c->dma_tx = 0;
-	c->regs[R1]|=TxINT_ENAB;
+	c->regs[R1] |= TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
+	write_zsreg(c, R3, c->regs[R3] | RxENABLE);
 
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
@@ -787,9 +787,9 @@ int z8530_sync_close(struct net_device *dev, struct z8530_channel *c)
 	c->max = 0;
 	c->sync = 0;
 
-	chk=read_zsreg(c,R0);
+	chk = read_zsreg(c, R0);
 	write_zsreg(c, R3, c->regs[R3]);
-	z8530_rtsdtr(c,0);
+	z8530_rtsdtr(c, 0);
 
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
@@ -810,7 +810,7 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	unsigned long cflags, dflags;
 
 	c->sync = 1;
-	c->mtu = dev->mtu+64;
+	c->mtu = dev->mtu + 64;
 	c->count = 0;
 	c->skb = NULL;
 	c->skb2 = NULL;
@@ -825,27 +825,27 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	 *	should be fine.
 	 */
 
-	if(c->mtu  > PAGE_SIZE/2)
+	if (c->mtu  > PAGE_SIZE / 2)
 		return -EMSGSIZE;
 
-	c->rx_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
+	c->rx_buf[0] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!c->rx_buf[0])
 		return -ENOBUFS;
-	c->rx_buf[1]=c->rx_buf[0]+PAGE_SIZE/2;
+	c->rx_buf[1] = c->rx_buf[0] + PAGE_SIZE / 2;
 
-	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
+	c->tx_dma_buf[0] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!c->tx_dma_buf[0])
 	{
 		free_page((unsigned long)c->rx_buf[0]);
-		c->rx_buf[0]=NULL;
+		c->rx_buf[0] = NULL;
 		return -ENOBUFS;
 	}
-	c->tx_dma_buf[1]=c->tx_dma_buf[0]+PAGE_SIZE/2;
+	c->tx_dma_buf[1] = c->tx_dma_buf[0] + PAGE_SIZE / 2;
 
-	c->tx_dma_used=0;
+	c->tx_dma_used = 0;
 	c->dma_tx = 1;
-	c->dma_num=0;
-	c->dma_ready=1;
+	c->dma_num = 0;
+	c->dma_ready = 1;
 
 	/*	Enable DMA control mode
 	 */
@@ -855,21 +855,21 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	/*	TX DMA via DIR/REQ
 	 */
 
-	c->regs[R14]|= DTRREQ;
+	c->regs[R14] |= DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	c->regs[R1]&= ~TxINT_ENAB;
+	c->regs[R1] &= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	RX DMA via W/Req
 	 */
 
-	c->regs[R1]|= WT_FN_RDYFN;
-	c->regs[R1]|= WT_RDY_RT;
-	c->regs[R1]|= INT_ERR_Rx;
-	c->regs[R1]&= ~TxINT_ENAB;
+	c->regs[R1] |= WT_FN_RDYFN;
+	c->regs[R1] |= WT_RDY_RT;
+	c->regs[R1] |= INT_ERR_Rx;
+	c->regs[R1] &= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	c->regs[R1]|= WT_RDY_ENAB;
+	c->regs[R1] |= WT_RDY_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	DMA interrupts
@@ -878,11 +878,11 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	/*	Set up the DMA configuration
 	 */
 
-	dflags=claim_dma_lock();
+	dflags = claim_dma_lock();
 
 	disable_dma(c->rxdma);
 	clear_dma_ff(c->rxdma);
-	set_dma_mode(c->rxdma, DMA_MODE_READ|0x10);
+	set_dma_mode(c->rxdma, DMA_MODE_READ | 0x10);
 	set_dma_addr(c->rxdma, virt_to_bus(c->rx_buf[0]));
 	set_dma_count(c->rxdma, c->mtu);
 	enable_dma(c->rxdma);
@@ -902,8 +902,8 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->tx_dma_used = 1;
 
 	c->irqs = &z8530_dma_sync;
-	z8530_rtsdtr(c,1);
-	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
+	z8530_rtsdtr(c, 1);
+	write_zsreg(c, R3, c->regs[R3] | RxENABLE);
 
 	spin_unlock_irqrestore(c->lock, cflags);
 
@@ -949,27 +949,27 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 	/*	Disable DMA control mode
 	 */
 
-	c->regs[R1]&= ~WT_RDY_ENAB;
+	c->regs[R1] &= ~WT_RDY_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	c->regs[R1]&= ~(WT_RDY_RT|WT_FN_RDYFN|INT_ERR_Rx);
-	c->regs[R1]|= INT_ALL_Rx;
+	c->regs[R1] &= ~(WT_RDY_RT | WT_FN_RDYFN | INT_ERR_Rx);
+	c->regs[R1] |= INT_ALL_Rx;
 	write_zsreg(c, R1, c->regs[R1]);
-	c->regs[R14]&= ~DTRREQ;
+	c->regs[R14] &= ~DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	if(c->rx_buf[0])
+	if (c->rx_buf[0])
 	{
 		free_page((unsigned long)c->rx_buf[0]);
-		c->rx_buf[0]=NULL;
+		c->rx_buf[0] = NULL;
 	}
-	if(c->tx_dma_buf[0])
+	if (c->tx_dma_buf[0])
 	{
 		free_page((unsigned  long)c->tx_dma_buf[0]);
-		c->tx_dma_buf[0]=NULL;
+		c->tx_dma_buf[0] = NULL;
 	}
-	chk=read_zsreg(c,R0);
+	chk = read_zsreg(c, R0);
 	write_zsreg(c, R3, c->regs[R3]);
-	z8530_rtsdtr(c,0);
+	z8530_rtsdtr(c, 0);
 
 	spin_unlock_irqrestore(c->lock, flags);
 
@@ -993,7 +993,7 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 
 	printk("Opening sync interface for TX-DMA\n");
 	c->sync = 1;
-	c->mtu = dev->mtu+64;
+	c->mtu = dev->mtu + 64;
 	c->count = 0;
 	c->skb = NULL;
 	c->skb2 = NULL;
@@ -1003,14 +1003,14 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	 *	should be fine.
 	 */
 
-	if(c->mtu  > PAGE_SIZE/2)
+	if (c->mtu > PAGE_SIZE / 2)
 		return -EMSGSIZE;
 
-	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
+	c->tx_dma_buf[0] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!c->tx_dma_buf[0])
 		return -ENOBUFS;
 
-	c->tx_dma_buf[1] = c->tx_dma_buf[0] + PAGE_SIZE/2;
+	c->tx_dma_buf[1] = c->tx_dma_buf[0] + PAGE_SIZE / 2;
 
 	spin_lock_irqsave(c->lock, cflags);
 
@@ -1026,9 +1026,9 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->rxdma_on = 0;
 	c->txdma_on = 0;
 
-	c->tx_dma_used=0;
-	c->dma_num=0;
-	c->dma_ready=1;
+	c->tx_dma_used = 0;
+	c->dma_num = 0;
+	c->dma_ready = 1;
 	c->dma_tx = 1;
 
 	/*	Enable DMA control mode
@@ -1036,10 +1036,10 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 
 	/*	TX DMA via DIR/REQ
 	 */
-	c->regs[R14]|= DTRREQ;
+	c->regs[R14] |= DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	c->regs[R1]&= ~TxINT_ENAB;
+	c->regs[R1] &= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	Set up the DMA configuration
@@ -1062,8 +1062,8 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->tx_dma_used = 1;
 
 	c->irqs = &z8530_txdma_sync;
-	z8530_rtsdtr(c,1);
-	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
+	z8530_rtsdtr(c, 1);
+	write_zsreg(c, R3, c->regs[R3] | RxENABLE);
 	spin_unlock_irqrestore(c->lock, cflags);
 
 	return 0;
@@ -1105,22 +1105,22 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	/*	Disable DMA control mode
 	 */
 
-	c->regs[R1]&= ~WT_RDY_ENAB;
+	c->regs[R1] &= ~WT_RDY_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
-	c->regs[R1]&= ~(WT_RDY_RT|WT_FN_RDYFN|INT_ERR_Rx);
-	c->regs[R1]|= INT_ALL_Rx;
+	c->regs[R1] &= ~(WT_RDY_RT | WT_FN_RDYFN | INT_ERR_Rx);
+	c->regs[R1] |= INT_ALL_Rx;
 	write_zsreg(c, R1, c->regs[R1]);
-	c->regs[R14]&= ~DTRREQ;
+	c->regs[R14] &= ~DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	if(c->tx_dma_buf[0])
+	if (c->tx_dma_buf[0])
 	{
 		free_page((unsigned long)c->tx_dma_buf[0]);
-		c->tx_dma_buf[0]=NULL;
+		c->tx_dma_buf[0] = NULL;
 	}
-	chk=read_zsreg(c,R0);
+	chk = read_zsreg(c, R0);
 	write_zsreg(c, R3, c->regs[R3]);
-	z8530_rtsdtr(c,0);
+	z8530_rtsdtr(c, 0);
 
 	spin_unlock_irqrestore(c->lock, cflags);
 	return 0;
@@ -1130,7 +1130,7 @@ EXPORT_SYMBOL(z8530_sync_txdma_close);
 /*	Name strings for Z8530 chips. SGI claim to have a 130, Zilog deny
  *	it exists...
  */
-static const char *z8530_type_name[]={
+static const char * const z8530_type_name[] = {
 	"Z8530",
 	"Z85C30",
 	"Z85230"
@@ -1165,23 +1165,23 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	/* NOP the interrupt handlers first - we might get a
 	 * floating IRQ transition when we reset the chip
 	 */
-	dev->chanA.irqs=&z8530_nop;
-	dev->chanB.irqs=&z8530_nop;
-	dev->chanA.dcdcheck=DCD;
-	dev->chanB.dcdcheck=DCD;
+	dev->chanA.irqs = &z8530_nop;
+	dev->chanB.irqs = &z8530_nop;
+	dev->chanA.dcdcheck = DCD;
+	dev->chanB.dcdcheck = DCD;
 
 	/* Reset the chip */
 	write_zsreg(&dev->chanA, R9, 0xC0);
 	udelay(200);
 	/* Now check its valid */
 	write_zsreg(&dev->chanA, R12, 0xAA);
-	if(read_zsreg(&dev->chanA, R12)!=0xAA)
+	if (read_zsreg(&dev->chanA, R12) != 0xAA)
 		return -ENODEV;
 	write_zsreg(&dev->chanA, R12, 0x55);
-	if(read_zsreg(&dev->chanA, R12)!=0x55)
+	if (read_zsreg(&dev->chanA, R12) != 0x55)
 		return -ENODEV;
 
-	dev->type=Z8530;
+	dev->type = Z8530;
 
 	/*	See the application note.
 	 */
@@ -1192,12 +1192,12 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	 *	the chip is enhanced.
 	 */
 
-	if(read_zsreg(&dev->chanA, R15)==0x01)
+	if (read_zsreg(&dev->chanA, R15) == 0x01)
 	{
 		/* This C30 versus 230 detect is from Klaus Kudielka's dmascc */
 		/* Put a char in the fifo */
 		write_zsreg(&dev->chanA, R8, 0);
-		if(read_zsreg(&dev->chanA, R0)&Tx_BUF_EMP)
+		if (read_zsreg(&dev->chanA, R0) & Tx_BUF_EMP)
 			dev->type = Z85230;	/* Has a FIFO */
 		else
 			dev->type = Z85C30;	/* Z85C30, 1 byte FIFO */
@@ -1214,7 +1214,7 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	 */
 
 	memcpy(dev->chanA.regs, reg_init, 16);
-	memcpy(dev->chanB.regs, reg_init ,16);
+	memcpy(dev->chanB.regs, reg_init, 16);
 
 	return 0;
 }
@@ -1270,8 +1270,8 @@ int z8530_shutdown(struct z8530_dev *dev)
 	/* Reset the chip */
 
 	spin_lock_irqsave(&dev->lock, flags);
-	dev->chanA.irqs=&z8530_nop;
-	dev->chanB.irqs=&z8530_nop;
+	dev->chanA.irqs = &z8530_nop;
+	dev->chanB.irqs = &z8530_nop;
 	write_zsreg(&dev->chanA, R9, 0xC0);
 	/* We must lock the udelay, the chip is offlimits here */
 	udelay(100);
@@ -1297,27 +1297,27 @@ int z8530_channel_load(struct z8530_channel *c, u8 *rtable)
 
 	spin_lock_irqsave(c->lock, flags);
 
-	while(*rtable!=255)
+	while (*rtable != 255)
 	{
-		int reg=*rtable++;
-
-		if(reg>0x0F)
-			write_zsreg(c, R15, c->regs[15]|1);
-		write_zsreg(c, reg&0x0F, *rtable);
-		if(reg>0x0F)
-			write_zsreg(c, R15, c->regs[15]&~1);
-		c->regs[reg]=*rtable++;
+		int reg = *rtable++;
+
+		if (reg > 0x0F)
+			write_zsreg(c, R15, c->regs[15] | 1);
+		write_zsreg(c, reg & 0x0F, *rtable);
+		if (reg > 0x0F)
+			write_zsreg(c, R15, c->regs[15] & ~1);
+		c->regs[reg] = *rtable++;
 	}
-	c->rx_function=z8530_null_rx;
-	c->skb=NULL;
-	c->tx_skb=NULL;
-	c->tx_next_skb=NULL;
-	c->mtu=1500;
-	c->max=0;
-	c->count=0;
-	c->status=read_zsreg(c, R0);
-	c->sync=1;
-	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
+	c->rx_function = z8530_null_rx;
+	c->skb = NULL;
+	c->tx_skb = NULL;
+	c->tx_next_skb = NULL;
+	c->mtu = 1500;
+	c->max = 0;
+	c->count = 0;
+	c->status = read_zsreg(c, R0);
+	c->sync = 1;
+	write_zsreg(c, R3, c->regs[R3] | RxENABLE);
 
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
@@ -1342,19 +1342,19 @@ static void z8530_tx_begin(struct z8530_channel *c)
 {
 	unsigned long flags;
 
-	if(c->tx_skb)
+	if (c->tx_skb)
 		return;
 
-	c->tx_skb=c->tx_next_skb;
-	c->tx_next_skb=NULL;
-	c->tx_ptr=c->tx_next_ptr;
+	c->tx_skb = c->tx_next_skb;
+	c->tx_next_skb = NULL;
+	c->tx_ptr = c->tx_next_ptr;
 
 	if (!c->tx_skb)
 	{
 		/* Idle on */
-		if(c->dma_tx)
+		if (c->dma_tx)
 		{
-			flags=claim_dma_lock();
+			flags = claim_dma_lock();
 			disable_dma(c->txdma);
 			/*	Check if we crapped out.
 			 */
@@ -1365,11 +1365,11 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			}
 			release_dma_lock(flags);
 		}
-		c->txcount=0;
+		c->txcount = 0;
 	} else {
-		c->txcount=c->tx_skb->len;
+		c->txcount = c->tx_skb->len;
 
-		if(c->dma_tx)
+		if (c->dma_tx)
 		{
 			/*	FIXME. DMA is broken for the original 8530,
 			 *	on the older parts we need to set a flag and
@@ -1377,25 +1377,25 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			 *	stage off
 			 */
 
-			flags=claim_dma_lock();
+			flags = claim_dma_lock();
 			disable_dma(c->txdma);
 
 			/*	These two are needed by the 8530/85C30
 			 *	and must be issued when idling.
 			 */
-			if(c->dev->type!=Z85230)
+			if (c->dev->type != Z85230)
 			{
 				write_zsctrl(c, RES_Tx_CRC);
 				write_zsctrl(c, RES_EOM_L);
 			}
-			write_zsreg(c, R10, c->regs[10]&~ABUNDER);
+			write_zsreg(c, R10, c->regs[10] & ~ABUNDER);
 			clear_dma_ff(c->txdma);
 			set_dma_addr(c->txdma, virt_to_bus(c->tx_ptr));
 			set_dma_count(c->txdma, c->txcount);
 			enable_dma(c->txdma);
 			release_dma_lock(flags);
 			write_zsctrl(c, RES_EOM_L);
-			write_zsreg(c, R5, c->regs[R5]|TxENAB);
+			write_zsreg(c, R5, c->regs[R5] | TxENAB);
 		} else {
 			/* ABUNDER off */
 			write_zsreg(c, R10, c->regs[10]);
@@ -1472,35 +1472,35 @@ static void z8530_rx_done(struct z8530_channel *c)
 
 	/*	Is our receive engine in DMA mode
 	 */
-	if(c->rxdma_on)
+	if (c->rxdma_on)
 	{
 		/*	Save the ready state and the buffer currently
 		 *	being used as the DMA target
 		 */
-		int ready=c->dma_ready;
-		unsigned char *rxb=c->rx_buf[c->dma_num];
+		int ready = c->dma_ready;
+		unsigned char *rxb = c->rx_buf[c->dma_num];
 		unsigned long flags;
 
 		/*	Complete this DMA. Necessary to find the length
 		 */
-		flags=claim_dma_lock();
+		flags = claim_dma_lock();
 
 		disable_dma(c->rxdma);
 		clear_dma_ff(c->rxdma);
-		c->rxdma_on=0;
-		ct=c->mtu-get_dma_residue(c->rxdma);
-		if(ct<0)
-			ct=2;	/* Shit happens.. */
-		c->dma_ready=0;
+		c->rxdma_on = 0;
+		ct = c->mtu - get_dma_residue(c->rxdma);
+		if (ct < 0)
+			ct = 2;	/* Shit happens.. */
+		c->dma_ready = 0;
 
 		/*	Normal case: the other slot is free, start the next DMA
 		 *	into it immediately.
 		 */
 
-		if(ready)
+		if (ready)
 		{
-			c->dma_num^=1;
-			set_dma_mode(c->rxdma, DMA_MODE_READ|0x10);
+			c->dma_num ^= 1;
+			set_dma_mode(c->rxdma, DMA_MODE_READ | 0x10);
 			set_dma_addr(c->rxdma, virt_to_bus(c->rx_buf[c->dma_num]));
 			set_dma_count(c->rxdma, c->mtu);
 			c->rxdma_on = 1;
@@ -1551,7 +1551,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		 *	sync IRQ for the RT_LOCK area.
 		 *
 		 */
-		ct=c->count;
+		ct = c->count;
 
 		c->skb = c->skb2;
 		c->count = 0;
@@ -1594,10 +1594,10 @@ static void z8530_rx_done(struct z8530_channel *c)
 
 static inline int spans_boundary(struct sk_buff *skb)
 {
-	unsigned long a=(unsigned long)skb->data;
+	unsigned long a = (unsigned long)skb->data;
 
-	a^=(a+skb->len);
-	if(a&0x00010000)	/* If the 64K bit is different.. */
+	a ^= (a + skb->len);
+	if (a & 0x00010000)	/* If the 64K bit is different.. */
 		return 1;
 	return 0;
 }
@@ -1620,7 +1620,7 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	unsigned long flags;
 
 	netif_stop_queue(c->netdevice);
-	if(c->tx_next_skb)
+	if (c->tx_next_skb)
 		return NETDEV_TX_BUSY;
 
 	/* PC SPECIFIC - DMA limits */
@@ -1628,7 +1628,9 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	 *	limit, then copy to the flip buffer
 	 */
 
-	if(c->dma_tx && ((unsigned long)(virt_to_bus(skb->data+skb->len))>=16*1024*1024 || spans_boundary(skb)))
+	if (c->dma_tx &&
+	    ((unsigned long)(virt_to_bus(skb->data + skb->len)) >=
+	    16 * 1024 * 1024 || spans_boundary(skb)))
 	{
 		/*	Send the flip buffer, and flip the flippy bit.
 		 *	We don't care which is used when just so long as
@@ -1636,14 +1638,14 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 		 *	only one buffer can be going out at a time the other
 		 *	has to be safe.
 		 */
-		c->tx_next_ptr=c->tx_dma_buf[c->tx_dma_used];
-		c->tx_dma_used^=1;	/* Flip temp buffer */
+		c->tx_next_ptr = c->tx_dma_buf[c->tx_dma_used];
+		c->tx_dma_used ^= 1;	/* Flip temp buffer */
 		skb_copy_from_linear_data(skb, c->tx_next_ptr, skb->len);
 	} else {
 		c->tx_next_ptr = skb->data;
 	}
 	RT_LOCK;
-	c->tx_next_skb=skb;
+	c->tx_next_skb = skb;
 	RT_UNLOCK;
 
 	spin_lock_irqsave(c->lock, flags);
-- 
2.8.1

