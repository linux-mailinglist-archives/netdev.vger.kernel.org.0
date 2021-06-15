Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BB73A7453
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhFOCtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:49:20 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:6367 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhFOCtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:49:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G3t0N6PQ2z61Y4;
        Tue, 15 Jun 2021 10:43:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
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
Subject: [PATCH V2 net-next 09/10] net: z85230: fix the code style issue about open brace {
Date:   Tue, 15 Jun 2021 10:43:44 +0800
Message-ID: <1623725025-50976-10-git-send-email-huangguangbin2@huawei.com>
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

This patch fixes the code style issue according to checkpatch.pl error:
"ERROR: that open brace { should be on the previous line".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 108 ++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index cab963f..621f730 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -184,8 +184,7 @@ static inline void write_zsdata(struct z8530_channel *c, u8 val)
 /*	Register loading parameters for a dead port
  */
 
-u8 z8530_dead_port[] =
-{
+u8 z8530_dead_port[] = {
 	255
 };
 EXPORT_SYMBOL(z8530_dead_port);
@@ -197,8 +196,7 @@ EXPORT_SYMBOL(z8530_dead_port);
  *	"kilostream" service, and most other similar services.
  */
 
-u8 z8530_hdlc_kilostream[] =
-{
+u8 z8530_hdlc_kilostream[] = {
 	4,	SYNC_ENAB | SDLC | X1CLK,
 	2,	0,	/* No vector */
 	1,	0,
@@ -220,8 +218,7 @@ EXPORT_SYMBOL(z8530_hdlc_kilostream);
 /*	As above but for enhanced chips.
  */
 
-u8 z8530_hdlc_kilostream_85230[] =
-{
+u8 z8530_hdlc_kilostream_85230[] = {
 	4,	SYNC_ENAB | SDLC | X1CLK,
 	2,	0,	/* No vector */
 	1,	0,
@@ -260,8 +257,7 @@ static void z8530_flush_fifo(struct z8530_channel *c)
 	read_zsreg(c, R1);
 	read_zsreg(c, R1);
 	read_zsreg(c, R1);
-	if (c->dev->type == Z85230)
-	{
+	if (c->dev->type == Z85230) {
 		read_zsreg(c, R1);
 		read_zsreg(c, R1);
 		read_zsreg(c, R1);
@@ -317,8 +313,7 @@ static void z8530_rx(struct z8530_channel *c)
 {
 	u8 ch, stat;
 
-	while (1)
-	{
+	while (1) {
 		/* FIFO empty ? */
 		if (!(read_zsreg(c, R0) & 1))
 			break;
@@ -327,29 +322,24 @@ static void z8530_rx(struct z8530_channel *c)
 
 		/*	Overrun ?
 		 */
-		if (c->count < c->max)
-		{
+		if (c->count < c->max) {
 			*c->dptr++ = ch;
 			c->count++;
 		}
 
-		if (stat & END_FR)
-		{
+		if (stat & END_FR) {
 			/*	Error ?
 			 */
-			if (stat & (Rx_OVR | CRC_ERR))
-			{
+			if (stat & (Rx_OVR | CRC_ERR)) {
 				/* Rewind the buffer and return */
 				if (c->skb)
 					c->dptr = c->skb->data;
 				c->count = 0;
-				if (stat & Rx_OVR)
-				{
+				if (stat & Rx_OVR) {
 					pr_warn("%s: overrun\n", c->dev->name);
 					c->rx_overrun++;
 				}
-				if (stat & CRC_ERR)
-				{
+				if (stat & CRC_ERR) {
 					c->rx_crc_err++;
 					/* printk("crc error\n"); */
 				}
@@ -391,8 +381,7 @@ static void z8530_tx(struct z8530_channel *c)
 		write_zsreg(c, R8, *c->tx_ptr++);
 		write_zsctrl(c, RES_H_IUS);
 		/* We are about to underflow */
-		if (c->txcount == 0)
-		{
+		if (c->txcount == 0) {
 			write_zsctrl(c, RES_EOM_L);
 			write_zsreg(c, R10, c->regs[10] & ~ABUNDER);
 		}
@@ -433,8 +422,7 @@ static void z8530_status(struct z8530_channel *chan)
 		z8530_tx_done(chan);
 	}
 
-	if (altered & chan->dcdcheck)
-	{
+	if (altered & chan->dcdcheck) {
 		if (status & chan->dcdcheck) {
 			pr_info("%s: DCD raised\n", chan->dev->name);
 			write_zsreg(chan, R3, chan->regs[3] | RxENABLE);
@@ -471,8 +459,7 @@ EXPORT_SYMBOL(z8530_sync);
 
 static void z8530_dma_rx(struct z8530_channel *chan)
 {
-	if (chan->rxdma_on)
-	{
+	if (chan->rxdma_on) {
 		/* Special condition check only */
 		u8 status;
 
@@ -501,8 +488,7 @@ static void z8530_dma_rx(struct z8530_channel *chan)
  */
 static void z8530_dma_tx(struct z8530_channel *chan)
 {
-	if (!chan->dma_tx)
-	{
+	if (!chan->dma_tx) {
 		pr_warn("Hey who turned the DMA off?\n");
 		z8530_tx(chan);
 		return;
@@ -530,10 +516,8 @@ static void z8530_dma_status(struct z8530_channel *chan)
 
 	chan->status = status;
 
-	if (chan->dma_tx)
-	{
-		if (status & TxEOM)
-		{
+	if (chan->dma_tx) {
+		if (status & TxEOM) {
 			unsigned long flags;
 
 			flags = claim_dma_lock();
@@ -545,8 +529,7 @@ static void z8530_dma_status(struct z8530_channel *chan)
 		}
 	}
 
-	if (altered & chan->dcdcheck)
-	{
+	if (altered & chan->dcdcheck) {
 		if (status & chan->dcdcheck) {
 			pr_info("%s: DCD raised\n", chan->dev->name);
 			write_zsreg(chan, R3, chan->regs[3] | RxENABLE);
@@ -668,8 +651,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 	int work = 0;
 	struct z8530_irqhandler *irqs;
 
-	if (locker)
-	{
+	if (locker) {
 		pr_err("IRQ re-enter\n");
 		return IRQ_NONE;
 	}
@@ -677,8 +659,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 
 	spin_lock(&dev->lock);
 
-	while (++work < 5000)
-	{
+	while (++work < 5000) {
 		intr = read_zsreg(&dev->chanA, R3);
 		if (!(intr &
 		   (CHARxIP | CHATxIP | CHAEXT | CHBRxIP | CHBTxIP | CHBEXT)))
@@ -694,8 +675,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 
 		irqs = dev->chanA.irqs;
 
-		if (intr & (CHARxIP | CHATxIP | CHAEXT))
-		{
+		if (intr & (CHARxIP | CHATxIP | CHAEXT)) {
 			if (intr & CHARxIP)
 				irqs->rx(&dev->chanA);
 			if (intr & CHATxIP)
@@ -706,8 +686,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 
 		irqs = dev->chanB.irqs;
 
-		if (intr & (CHBRxIP | CHBTxIP | CHBEXT))
-		{
+		if (intr & (CHBRxIP | CHBTxIP | CHBEXT)) {
 			if (intr & CHBRxIP)
 				irqs->rx(&dev->chanB);
 			if (intr & CHBTxIP)
@@ -726,8 +705,7 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 }
 EXPORT_SYMBOL(z8530_interrupt);
 
-static const u8 reg_init[16] =
-{
+static const u8 reg_init[16] = {
 	0, 0, 0, 0,
 	0, 0, 0, 0,
 	0, 0, 0, 0,
@@ -834,8 +812,7 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	c->rx_buf[1] = c->rx_buf[0] + PAGE_SIZE / 2;
 
 	c->tx_dma_buf[0] = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
-	if (!c->tx_dma_buf[0])
-	{
+	if (!c->tx_dma_buf[0]) {
 		free_page((unsigned long)c->rx_buf[0]);
 		c->rx_buf[0] = NULL;
 		return -ENOBUFS;
@@ -957,13 +934,11 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 	c->regs[R14] &= ~DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	if (c->rx_buf[0])
-	{
+	if (c->rx_buf[0]) {
 		free_page((unsigned long)c->rx_buf[0]);
 		c->rx_buf[0] = NULL;
 	}
-	if (c->tx_dma_buf[0])
-	{
+	if (c->tx_dma_buf[0]) {
 		free_page((unsigned  long)c->tx_dma_buf[0]);
 		c->tx_dma_buf[0] = NULL;
 	}
@@ -1113,8 +1088,7 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	c->regs[R14] &= ~DTRREQ;
 	write_zsreg(c, R14, c->regs[R14]);
 
-	if (c->tx_dma_buf[0])
-	{
+	if (c->tx_dma_buf[0]) {
 		free_page((unsigned long)c->tx_dma_buf[0]);
 		c->tx_dma_buf[0] = NULL;
 	}
@@ -1192,8 +1166,7 @@ static inline int do_z8530_init(struct z8530_dev *dev)
 	 *	the chip is enhanced.
 	 */
 
-	if (read_zsreg(&dev->chanA, R15) == 0x01)
-	{
+	if (read_zsreg(&dev->chanA, R15) == 0x01) {
 		/* This C30 versus 230 detect is from Klaus Kudielka's dmascc */
 		/* Put a char in the fifo */
 		write_zsreg(&dev->chanA, R8, 0);
@@ -1297,8 +1270,7 @@ int z8530_channel_load(struct z8530_channel *c, u8 *rtable)
 
 	spin_lock_irqsave(c->lock, flags);
 
-	while (*rtable != 255)
-	{
+	while (*rtable != 255) {
 		int reg = *rtable++;
 
 		if (reg > 0x0F)
@@ -1349,17 +1321,14 @@ static void z8530_tx_begin(struct z8530_channel *c)
 	c->tx_next_skb = NULL;
 	c->tx_ptr = c->tx_next_ptr;
 
-	if (!c->tx_skb)
-	{
+	if (!c->tx_skb) {
 		/* Idle on */
-		if (c->dma_tx)
-		{
+		if (c->dma_tx) {
 			flags = claim_dma_lock();
 			disable_dma(c->txdma);
 			/*	Check if we crapped out.
 			 */
-			if (get_dma_residue(c->txdma))
-			{
+			if (get_dma_residue(c->txdma)) {
 				c->netdevice->stats.tx_dropped++;
 				c->netdevice->stats.tx_fifo_errors++;
 			}
@@ -1369,8 +1338,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 	} else {
 		c->txcount = c->tx_skb->len;
 
-		if (c->dma_tx)
-		{
+		if (c->dma_tx) {
 			/*	FIXME. DMA is broken for the original 8530,
 			 *	on the older parts we need to set a flag and
 			 *	wait for a further TX interrupt to fire this
@@ -1383,8 +1351,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			/*	These two are needed by the 8530/85C30
 			 *	and must be issued when idling.
 			 */
-			if (c->dev->type != Z85230)
-			{
+			if (c->dev->type != Z85230) {
 				write_zsctrl(c, RES_Tx_CRC);
 				write_zsctrl(c, RES_EOM_L);
 			}
@@ -1472,8 +1439,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 
 	/*	Is our receive engine in DMA mode
 	 */
-	if (c->rxdma_on)
-	{
+	if (c->rxdma_on) {
 		/*	Save the ready state and the buffer currently
 		 *	being used as the DMA target
 		 */
@@ -1497,8 +1463,7 @@ static void z8530_rx_done(struct z8530_channel *c)
 		 *	into it immediately.
 		 */
 
-		if (ready)
-		{
+		if (ready) {
 			c->dma_num ^= 1;
 			set_dma_mode(c->rxdma, DMA_MODE_READ | 0x10);
 			set_dma_addr(c->rxdma, virt_to_bus(c->rx_buf[c->dma_num]));
@@ -1630,8 +1595,7 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 
 	if (c->dma_tx &&
 	    ((unsigned long)(virt_to_bus(skb->data + skb->len)) >=
-	    16 * 1024 * 1024 || spans_boundary(skb)))
-	{
+	    16 * 1024 * 1024 || spans_boundary(skb))) {
 		/*	Send the flip buffer, and flip the flippy bit.
 		 *	We don't care which is used when just so long as
 		 *	we never use the same buffer twice in a row. Since
-- 
2.8.1

