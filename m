Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033BE3A7457
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFOCt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:49:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7260 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFOCtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:49:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G3szF2xT1z1BMb9;
        Tue, 15 Jun 2021 10:42:01 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 07/10] net: z85230: remove trailing whitespaces
Date:   Tue, 15 Jun 2021 10:43:42 +0800
Message-ID: <1623725025-50976-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623725025-50976-1-git-send-email-huangguangbin2@huawei.com>
References: <1623725025-50976-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes trailing whitespaces.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 224 ++++++++++++++++++++++-------------------------
 1 file changed, 105 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 34004e4..5db452d 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -10,7 +10,7 @@
  *	Asynchronous mode dropped for 2.2. For 2.5 we will attempt the
  *	unification of all the Z85x30 asynchronous drivers for real.
  *
- *	DMA now uses get_free_page as kmalloc buffers may span a 64K 
+ *	DMA now uses get_free_page as kmalloc buffers may span a 64K
  *	boundary.
  *
  *	Modified for SMP safety and SMP locking by Alan Cox
@@ -59,7 +59,7 @@
  *
  *	Provided port access methods. The Comtrol SV11 requires no delays
  *	between accesses and uses PC I/O. Some drivers may need a 5uS delay
- *	
+ *
  *	In the longer term this should become an architecture specific
  *	section so that this can become a generic driver interface for all
  *	platforms. For now we only handle PC I/O ports with or without the
@@ -104,16 +104,16 @@ static void z8530_rx_done(struct z8530_channel *c);
 static void z8530_tx_done(struct z8530_channel *c);
 
 /**
- *	read_zsreg - Read a register from a Z85230 
+ *	read_zsreg - Read a register from a Z85230
  *	@c: Z8530 channel to read from (2 per chip)
  *	@reg: Register to read
  *	FIXME: Use a spinlock.
- *	
+ *
  *	Most of the Z8530 registers are indexed off the control registers.
  *	A read is done by writing to the control register and reading the
  *	register back.  The caller must hold the lock
  */
- 
+
 static inline u8 read_zsreg(struct z8530_channel *c, u8 reg)
 {
 	if(reg)
@@ -183,7 +183,7 @@ static inline void write_zsdata(struct z8530_channel *c, u8 val)
 
 /*	Register loading parameters for a dead port
  */
- 
+
 u8 z8530_dead_port[]=
 {
 	255
@@ -196,7 +196,7 @@ EXPORT_SYMBOL(z8530_dead_port);
 /*	Data clocked by telco end. This is the correct data for the UK
  *	"kilostream" service, and most other similar services.
  */
- 
+
 u8 z8530_hdlc_kilostream[]=
 {
 	4,	SYNC_ENAB|SDLC|X1CLK,
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(z8530_hdlc_kilostream);
 
 /*	As above but for enhanced chips.
  */
- 
+
 u8 z8530_hdlc_kilostream_85230[]=
 {
 	4,	SYNC_ENAB|SDLC|X1CLK,
@@ -237,7 +237,7 @@ u8 z8530_hdlc_kilostream_85230[]=
 	1,	EXT_INT_ENAB|TxINT_ENAB|INT_ALL_Rx,
 	9,	NV|MIE|NORESET,
 	23,	3,		/* Extended mode AUTO TX and EOM*/
-	
+
 	255
 };
 EXPORT_SYMBOL(z8530_hdlc_kilostream_85230);
@@ -246,14 +246,14 @@ EXPORT_SYMBOL(z8530_hdlc_kilostream_85230);
  *	z8530_flush_fifo - Flush on chip RX FIFO
  *	@c: Channel to flush
  *
- *	Flush the receive FIFO. There is no specific option for this, we 
+ *	Flush the receive FIFO. There is no specific option for this, we
  *	blindly read bytes and discard them. Reading when there is no data
  *	is harmless. The 8530 has a 4 byte FIFO, the 85230 has 8 bytes.
- *	
+ *
  *	All locking is handled for the caller. On return data may still be
  *	present if it arrived during the flush.
  */
- 
+
 static void z8530_flush_fifo(struct z8530_channel *c)
 {
 	read_zsreg(c, R1);
@@ -267,7 +267,7 @@ static void z8530_flush_fifo(struct z8530_channel *c)
 		read_zsreg(c, R1);
 		read_zsreg(c, R1);
 	}
-}	
+}
 
 /**
  *	z8530_rtsdtr - Control the outgoing DTS/RTS line
@@ -293,7 +293,7 @@ static void z8530_rtsdtr(struct z8530_channel *c, int set)
  *	z8530_rx - Handle a PIO receive event
  *	@c: Z8530 channel to process
  *
- *	Receive handler for receiving in PIO mode. This is much like the 
+ *	Receive handler for receiving in PIO mode. This is much like the
  *	async one but not quite the same or as complex
  *
  *	Note: Its intended that this handler can easily be separated from
@@ -306,13 +306,13 @@ static void z8530_rtsdtr(struct z8530_channel *c, int set)
  *	other code - this is true in the RT case too.
  *
  *	We only cover the sync cases for this. If you want 2Mbit async
- *	do it yourself but consider medical assistance first. This non DMA 
- *	synchronous mode is portable code. The DMA mode assumes PCI like 
+ *	do it yourself but consider medical assistance first. This non DMA
+ *	synchronous mode is portable code. The DMA mode assumes PCI like
  *	ISA DMA
  *
  *	Called with the device lock held
  */
- 
+
 static void z8530_rx(struct z8530_channel *c)
 {
 	u8 ch,stat;
@@ -324,7 +324,7 @@ static void z8530_rx(struct z8530_channel *c)
 			break;
 		ch=read_zsdata(c);
 		stat=read_zsreg(c, R1);
-	
+
 		/*	Overrun ?
 		 */
 		if(c->count < c->max)
@@ -378,7 +378,7 @@ static void z8530_rx(struct z8530_channel *c)
  *	in as possible, its quite possible that we won't keep up with the
  *	data rate otherwise.
  */
- 
+
 static void z8530_tx(struct z8530_channel *c)
 {
 	while(c->txcount) {
@@ -400,10 +400,10 @@ static void z8530_tx(struct z8530_channel *c)
 
 	/*	End of frame TX - fire another one
 	 */
-	 
+
 	write_zsctrl(c, RES_Tx_P);
 
-	z8530_tx_done(c);	 
+	z8530_tx_done(c);
 	write_zsctrl(c, RES_H_IUS);
 }
 
@@ -468,29 +468,29 @@ EXPORT_SYMBOL(z8530_sync);
  *	events are handled by the DMA hardware. We get a kick here only if
  *	a frame ended.
  */
- 
+
 static void z8530_dma_rx(struct z8530_channel *chan)
 {
 	if(chan->rxdma_on)
 	{
 		/* Special condition check only */
 		u8 status;
-	
+
 		read_zsreg(chan, R7);
 		read_zsreg(chan, R6);
-		
+
 		status=read_zsreg(chan, R1);
-	
+
 		if(status&END_FR)
 		{
 			z8530_rx_done(chan);	/* Fire up the next one */
-		}		
+		}
 		write_zsctrl(chan, ERR_RES);
 		write_zsctrl(chan, RES_H_IUS);
 	} else {
 		/* DMA is off right now, drain the slow way */
 		z8530_rx(chan);
-	}	
+	}
 }
 
 /**
@@ -500,7 +500,6 @@ static void z8530_dma_rx(struct z8530_channel *chan)
  *	We have received an interrupt while doing DMA transmissions. It
  *	shouldn't happen. Scream loudly if it does.
  */
- 
 static void z8530_dma_tx(struct z8530_channel *chan)
 {
 	if(!chan->dma_tx)
@@ -517,20 +516,19 @@ static void z8530_dma_tx(struct z8530_channel *chan)
 /**
  *	z8530_dma_status - Handle a DMA status exception
  *	@chan: Z8530 channel to process
- *	
+ *
  *	A status event occurred on the Z8530. We receive these for two reasons
  *	when in DMA mode. Firstly if we finished a packet transfer we get one
  *	and kick the next packet out. Secondly we may see a DCD change.
  *
  */
- 
 static void z8530_dma_status(struct z8530_channel *chan)
 {
 	u8 status, altered;
 
 	status=read_zsreg(chan, R0);
 	altered=chan->status^status;
-	
+
 	chan->status=status;
 
 	if(chan->dma_tx)
@@ -538,10 +536,10 @@ static void z8530_dma_status(struct z8530_channel *chan)
 		if(status&TxEOM)
 		{
 			unsigned long flags;
-	
+
 			flags=claim_dma_lock();
 			disable_dma(chan->txdma);
-			clear_dma_ff(chan->txdma);	
+			clear_dma_ff(chan->txdma);
 			chan->txdma_on=0;
 			release_dma_lock(flags);
 			z8530_tx_done(chan);
@@ -597,7 +595,7 @@ static void z8530_rx_clear(struct z8530_channel *c)
 
 	read_zsdata(c);
 	stat=read_zsreg(c, R1);
-	
+
 	if(stat&END_FR)
 		write_zsctrl(c, RES_Rx_CRC);
 	/*	Clear irq
@@ -670,7 +668,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 	static volatile int locker=0;
 	int work=0;
 	struct z8530_irqhandler *irqs;
-	
+
 	if(locker)
 	{
 		pr_err("IRQ re-enter\n");
@@ -685,15 +683,15 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 		intr = read_zsreg(&dev->chanA, R3);
 		if(!(intr & (CHARxIP|CHATxIP|CHAEXT|CHBRxIP|CHBTxIP|CHBEXT)))
 			break;
-	
+
 		/* This holds the IRQ status. On the 8530 you must read it
 		 * from chan A even though it applies to the whole chip
 		 */
-		
+
 		/* Now walk the chip and see what it is wanting - it may be
 		 * an IRQ for someone else remember
 		 */
-		   
+
 		irqs=dev->chanA.irqs;
 
 		if(intr & (CHARxIP|CHATxIP|CHAEXT))
@@ -744,7 +742,6 @@ static const u8 reg_init[16]=
  *	Switch a Z8530 into synchronous mode without DMA assist. We
  *	raise the RTS/DTR and commence network operation.
  */
- 
 int z8530_sync_open(struct net_device *dev, struct z8530_channel *c)
 {
 	unsigned long flags;
@@ -780,17 +777,16 @@ EXPORT_SYMBOL(z8530_sync_open);
  *	Close down a Z8530 interface and switch its interrupt handlers
  *	to discard future events.
  */
- 
 int z8530_sync_close(struct net_device *dev, struct z8530_channel *c)
 {
 	u8 chk;
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(c->lock, flags);
 	c->irqs = &z8530_nop;
 	c->max = 0;
 	c->sync = 0;
-	
+
 	chk=read_zsreg(c,R0);
 	write_zsreg(c, R3, c->regs[R3]);
 	z8530_rtsdtr(c,0);
@@ -809,11 +805,10 @@ EXPORT_SYMBOL(z8530_sync_close);
  *	ISA DMA channels must be available for this to work. We assume ISA
  *	DMA driven I/O and PC limits on access.
  */
- 
 int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 {
 	unsigned long cflags, dflags;
-	
+
 	c->sync = 1;
 	c->mtu = dev->mtu+64;
 	c->count = 0;
@@ -829,15 +824,15 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	 *	Everyone runs 1500 mtu or less on wan links so this
 	 *	should be fine.
 	 */
-	 
+
 	if(c->mtu  > PAGE_SIZE/2)
 		return -EMSGSIZE;
-	 
+
 	c->rx_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
 	if (!c->rx_buf[0])
 		return -ENOBUFS;
 	c->rx_buf[1]=c->rx_buf[0]+PAGE_SIZE/2;
-	
+
 	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
 	if (!c->tx_dma_buf[0])
 	{
@@ -851,7 +846,7 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->dma_tx = 1;
 	c->dma_num=0;
 	c->dma_ready=1;
-	
+
 	/*	Enable DMA control mode
 	 */
 
@@ -859,15 +854,15 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 
 	/*	TX DMA via DIR/REQ
 	 */
-	 
+
 	c->regs[R14]|= DTRREQ;
-	write_zsreg(c, R14, c->regs[R14]);     
+	write_zsreg(c, R14, c->regs[R14]);
 
 	c->regs[R1]&= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	RX DMA via W/Req
-	 */	 
+	 */
 
 	c->regs[R1]|= WT_FN_RDYFN;
 	c->regs[R1]|= WT_RDY_RT;
@@ -875,16 +870,16 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->regs[R1]&= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R1]|= WT_RDY_ENAB;
-	write_zsreg(c, R1, c->regs[R1]);            
+	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	DMA interrupts
 	 */
 
 	/*	Set up the DMA configuration
-	 */	
-	 
+	 */
+
 	dflags=claim_dma_lock();
-	 
+
 	disable_dma(c->rxdma);
 	clear_dma_ff(c->rxdma);
 	set_dma_mode(c->rxdma, DMA_MODE_READ|0x10);
@@ -896,7 +891,7 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	clear_dma_ff(c->txdma);
 	set_dma_mode(c->txdma, DMA_MODE_WRITE);
 	disable_dma(c->txdma);
-	
+
 	release_dma_lock(dflags);
 
 	/*	Select the DMA interrupt handlers
@@ -905,13 +900,13 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->rxdma_on = 1;
 	c->txdma_on = 1;
 	c->tx_dma_used = 1;
-	 
+
 	c->irqs = &z8530_dma_sync;
 	z8530_rtsdtr(c,1);
 	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
 
 	spin_unlock_irqrestore(c->lock, cflags);
-	
+
 	return 0;
 }
 EXPORT_SYMBOL(z8530_sync_dma_open);
@@ -924,29 +919,28 @@ EXPORT_SYMBOL(z8530_sync_dma_open);
  *	Shut down a DMA mode synchronous interface. Halt the DMA, and
  *	free the buffers.
  */
- 
 int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 {
 	u8 chk;
 	unsigned long flags;
-	
+
 	c->irqs = &z8530_nop;
 	c->max = 0;
 	c->sync = 0;
 
 	/*	Disable the PC DMA channels
 	 */
-	
-	flags=claim_dma_lock(); 
+
+	flags = claim_dma_lock();
 	disable_dma(c->rxdma);
 	clear_dma_ff(c->rxdma);
-	
+
 	c->rxdma_on = 0;
-	
+
 	disable_dma(c->txdma);
 	clear_dma_ff(c->txdma);
 	release_dma_lock(flags);
-	
+
 	c->txdma_on = 0;
 	c->tx_dma_used = 0;
 
@@ -954,15 +948,15 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 
 	/*	Disable DMA control mode
 	 */
-	 
+
 	c->regs[R1]&= ~WT_RDY_ENAB;
-	write_zsreg(c, R1, c->regs[R1]);            
+	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R1]&= ~(WT_RDY_RT|WT_FN_RDYFN|INT_ERR_Rx);
 	c->regs[R1]|= INT_ALL_Rx;
 	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R14]&= ~DTRREQ;
-	write_zsreg(c, R14, c->regs[R14]);   
-	
+	write_zsreg(c, R14, c->regs[R14]);
+
 	if(c->rx_buf[0])
 	{
 		free_page((unsigned long)c->rx_buf[0]);
@@ -1008,10 +1002,10 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	 *	Everyone runs 1500 mtu or less on wan links so this
 	 *	should be fine.
 	 */
-	 
+
 	if(c->mtu  > PAGE_SIZE/2)
 		return -EMSGSIZE;
-	 
+
 	c->tx_dma_buf[0]=(void *)get_zeroed_page(GFP_KERNEL|GFP_DMA);
 	if (!c->tx_dma_buf[0])
 		return -ENOBUFS;
@@ -1031,7 +1025,7 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 
 	c->rxdma_on = 0;
 	c->txdma_on = 0;
-	
+
 	c->tx_dma_used=0;
 	c->dma_num=0;
 	c->dma_ready=1;
@@ -1043,14 +1037,14 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	/*	TX DMA via DIR/REQ
 	 */
 	c->regs[R14]|= DTRREQ;
-	write_zsreg(c, R14, c->regs[R14]);     
-	
+	write_zsreg(c, R14, c->regs[R14]);
+
 	c->regs[R1]&= ~TxINT_ENAB;
 	write_zsreg(c, R1, c->regs[R1]);
 
 	/*	Set up the DMA configuration
-	 */	
-	 
+	 */
+
 	dflags = claim_dma_lock();
 
 	disable_dma(c->txdma);
@@ -1066,12 +1060,12 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	c->rxdma_on = 0;
 	c->txdma_on = 1;
 	c->tx_dma_used = 1;
-	 
+
 	c->irqs = &z8530_txdma_sync;
 	z8530_rtsdtr(c,1);
 	write_zsreg(c, R3, c->regs[R3]|RxENABLE);
 	spin_unlock_irqrestore(c->lock, cflags);
-	
+
 	return 0;
 }
 EXPORT_SYMBOL(z8530_sync_txdma_open);
@@ -1081,7 +1075,7 @@ EXPORT_SYMBOL(z8530_sync_txdma_open);
  *	@dev: Network device to detach
  *	@c: Z8530 channel to move into discard mode
  *
- *	Shut down a DMA/PIO split mode synchronous interface. Halt the DMA, 
+ *	Shut down a DMA/PIO split mode synchronous interface. Halt the DMA,
  *	and  free the buffers.
  */
 
@@ -1091,14 +1085,14 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	u8 chk;
 
 	spin_lock_irqsave(c->lock, cflags);
-	
+
 	c->irqs = &z8530_nop;
 	c->max = 0;
 	c->sync = 0;
 
 	/*	Disable the PC DMA channels
 	 */
-	 
+
 	dflags = claim_dma_lock();
 
 	disable_dma(c->txdma);
@@ -1110,15 +1104,15 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 
 	/*	Disable DMA control mode
 	 */
-	 
+
 	c->regs[R1]&= ~WT_RDY_ENAB;
-	write_zsreg(c, R1, c->regs[R1]);            
+	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R1]&= ~(WT_RDY_RT|WT_FN_RDYFN|INT_ERR_Rx);
 	c->regs[R1]|= INT_ALL_Rx;
 	write_zsreg(c, R1, c->regs[R1]);
 	c->regs[R14]&= ~DTRREQ;
-	write_zsreg(c, R14, c->regs[R14]);   
-	
+	write_zsreg(c, R14, c->regs[R14]);
+
 	if(c->tx_dma_buf[0])
 	{
 		free_page((unsigned long)c->tx_dma_buf[0]);
@@ -1136,7 +1130,6 @@ EXPORT_SYMBOL(z8530_sync_txdma_close);
 /*	Name strings for Z8530 chips. SGI claim to have a 130, Zilog deny
  *	it exists...
  */
- 
 static const char *z8530_type_name[]={
 	"Z8530",
 	"Z85C30",
@@ -1157,7 +1150,7 @@ static const char *z8530_type_name[]={
 void z8530_describe(struct z8530_dev *dev, char *mapping, unsigned long io)
 {
 	pr_info("%s: %s found at %s 0x%lX, IRQ %d\n",
-		dev->name, 
+		dev->name,
 		z8530_type_name[dev->type],
 		mapping,
 		Z8530_PORT_OF(io),
@@ -1167,7 +1160,6 @@ EXPORT_SYMBOL(z8530_describe);
 
 /*	Locked operation part of the z8530 init code
  */
- 
 static inline int do_z8530_init(struct z8530_dev *dev)
 {
 	/* NOP the interrupt handlers first - we might get a
@@ -1188,18 +1180,18 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	write_zsreg(&dev->chanA, R12, 0x55);
 	if(read_zsreg(&dev->chanA, R12)!=0x55)
 		return -ENODEV;
-		
+
 	dev->type=Z8530;
 
 	/*	See the application note.
 	 */
-	 
+
 	write_zsreg(&dev->chanA, R15, 0x01);
 
 	/*	If we can set the low bit of R15 then
 	 *	the chip is enhanced.
 	 */
-	 
+
 	if(read_zsreg(&dev->chanA, R15)==0x01)
 	{
 		/* This C30 versus 230 detect is from Klaus Kudielka's dmascc */
@@ -1215,15 +1207,15 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	 *	off. Use write_zsext() for these and keep
 	 *	this bit clear.
 	 */
-	 
+
 	write_zsreg(&dev->chanA, R15, 0);
 
 	/*	At this point it looks like the chip is behaving
 	 */
-	 
+
 	memcpy(dev->chanA.regs, reg_init, 16);
 	memcpy(dev->chanB.regs, reg_init ,16);
-	
+
 	return 0;
 }
 
@@ -1266,13 +1258,12 @@ EXPORT_SYMBOL(z8530_init);
  *	z8530_shutdown - Shutdown a Z8530 device
  *	@dev: The Z8530 chip to shutdown
  *
- *	We set the interrupt handlers to silence any interrupts. We then 
+ *	We set the interrupt handlers to silence any interrupts. We then
  *	reset the chip and wait 100uS to be sure the reset completed. Just
  *	in case the caller then tries to do stuff.
  *
  *	This is called without the lock held
  */
- 
 int z8530_shutdown(struct z8530_dev *dev)
 {
 	unsigned long flags;
@@ -1295,7 +1286,7 @@ EXPORT_SYMBOL(z8530_shutdown);
  *	@rtable: table of register, value pairs
  *	FIXME: ioctl to allow user uploaded tables
  *
- *	Load a Z8530 channel up from the system data. We use +16 to 
+ *	Load a Z8530 channel up from the system data. We use +16 to
  *	indicate the "prime" registers. The value 255 terminates the
  *	table.
  */
@@ -1339,7 +1330,7 @@ EXPORT_SYMBOL(z8530_channel_load);
  *
  *	This is the speed sensitive side of transmission. If we are called
  *	and no buffer is being transmitted we commence the next buffer. If
- *	nothing is queued we idle the sync. 
+ *	nothing is queued we idle the sync.
  *
  *	Note: We are handling this code path in the interrupt path, keep it
  *	fast or bad things will happen.
@@ -1353,11 +1344,11 @@ static void z8530_tx_begin(struct z8530_channel *c)
 
 	if(c->tx_skb)
 		return;
-		
+
 	c->tx_skb=c->tx_next_skb;
 	c->tx_next_skb=NULL;
 	c->tx_ptr=c->tx_next_ptr;
-	
+
 	if (!c->tx_skb)
 	{
 		/* Idle on */
@@ -1383,21 +1374,20 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			/*	FIXME. DMA is broken for the original 8530,
 			 *	on the older parts we need to set a flag and
 			 *	wait for a further TX interrupt to fire this
-			 *	stage off	
+			 *	stage off
 			 */
-			 
+
 			flags=claim_dma_lock();
 			disable_dma(c->txdma);
 
 			/*	These two are needed by the 8530/85C30
 			 *	and must be issued when idling.
 			 */
-			 
 			if(c->dev->type!=Z85230)
 			{
 				write_zsctrl(c, RES_Tx_CRC);
 				write_zsctrl(c, RES_EOM_L);
-			}	
+			}
 			write_zsreg(c, R10, c->regs[10]&~ABUNDER);
 			clear_dma_ff(c->txdma);
 			set_dma_addr(c->txdma, virt_to_bus(c->tx_ptr));
@@ -1410,9 +1400,8 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			/* ABUNDER off */
 			write_zsreg(c, R10, c->regs[10]);
 			write_zsctrl(c, RES_Tx_CRC);
-	
-			while(c->txcount && (read_zsreg(c,R0)&Tx_BUF_EMP))
-			{		
+
+			while (c->txcount && (read_zsreg(c, R0) & Tx_BUF_EMP)) {
 				write_zsreg(c, R8, *c->tx_ptr++);
 				c->txcount--;
 			}
@@ -1458,7 +1447,6 @@ static void z8530_tx_done(struct z8530_channel *c)
  *	We point the receive handler at this function when idle. Instead
  *	of processing the frames we get to throw them away.
  */
- 
 void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb)
 {
 	dev_kfree_skb_any(skb);
@@ -1477,7 +1465,6 @@ EXPORT_SYMBOL(z8530_null_rx);
  *
  *	Called with the lock held
  */
- 
 static void z8530_rx_done(struct z8530_channel *c)
 {
 	struct sk_buff *skb;
@@ -1495,9 +1482,9 @@ static void z8530_rx_done(struct z8530_channel *c)
 		unsigned long flags;
 
 		/*	Complete this DMA. Necessary to find the length
-		 */		
+		 */
 		flags=claim_dma_lock();
-		
+
 		disable_dma(c->rxdma);
 		clear_dma_ff(c->rxdma);
 		c->rxdma_on=0;
@@ -1509,7 +1496,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		/*	Normal case: the other slot is free, start the next DMA
 		 *	into it immediately.
 		 */
-		 
+
 		if(ready)
 		{
 			c->dma_num^=1;
@@ -1621,18 +1608,17 @@ static inline int spans_boundary(struct sk_buff *skb)
  *	@skb: The packet to kick down the channel
  *
  *	Queue a packet for transmission. Because we have rather
- *	hard to hit interrupt latencies for the Z85230 per packet 
+ *	hard to hit interrupt latencies for the Z85230 per packet
  *	even in DMA mode we do the flip to DMA buffer if needed here
  *	not in the IRQ.
  *
- *	Called from the network code. The lock is not held at this 
+ *	Called from the network code. The lock is not held at this
  *	point.
  */
-
 netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 {
 	unsigned long flags;
-	
+
 	netif_stop_queue(c->netdevice);
 	if(c->tx_next_skb)
 		return NETDEV_TX_BUSY;
@@ -1641,7 +1627,7 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	/*	If we will DMA the transmit and its gone over the ISA bus
 	 *	limit, then copy to the flip buffer
 	 */
-	 
+
 	if(c->dma_tx && ((unsigned long)(virt_to_bus(skb->data+skb->len))>=16*1024*1024 || spans_boundary(skb)))
 	{
 		/*	Send the flip buffer, and flip the flippy bit.
@@ -1659,11 +1645,11 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	RT_LOCK;
 	c->tx_next_skb=skb;
 	RT_UNLOCK;
-	
+
 	spin_lock_irqsave(c->lock, flags);
 	z8530_tx_begin(c);
 	spin_unlock_irqrestore(c->lock, flags);
-	
+
 	return NETDEV_TX_OK;
 }
 EXPORT_SYMBOL(z8530_queue_xmit);
-- 
2.8.1

