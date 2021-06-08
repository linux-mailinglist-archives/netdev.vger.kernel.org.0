Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFCB39F09F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhFHIST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8082 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFHIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzjfR1xlVzYrwd;
        Tue,  8 Jun 2021 16:13:03 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 06/16] net: farsync: fix the comments style issue
Date:   Tue, 8 Jun 2021 16:12:32 +0800
Message-ID: <1623139962-34847-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
 drivers/net/wan/farsync.c | 235 ++++++++++++++++------------------------------
 1 file changed, 83 insertions(+), 152 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 7e408d5..f8c7558 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- *      FarSync WAN driver for Linux (2.6.x kernel version)
+/*      FarSync WAN driver for Linux (2.6.x kernel version)
  *
  *      Actually sync driver for X.21, V.35 and V.24 on FarSync T-series cards
  *
@@ -30,8 +29,7 @@
 
 #include "farsync.h"
 
-/*
- *      Module info
+/*      Module info
  */
 MODULE_AUTHOR("R.J.Dunlop <bob.dunlop@farsite.co.uk>");
 MODULE_DESCRIPTION("FarSync T-Series WAN driver. FarSite Communications Ltd.");
@@ -49,16 +47,19 @@ MODULE_LICENSE("GPL");
 /*      Default parameters for the link
  */
 #define FST_TX_QUEUE_LEN        100	/* At 8Mbps a longer queue length is
-					 * useful */
+					 * useful
+					 */
 #define FST_TXQ_DEPTH           16	/* This one is for the buffering
 					 * of frames on the way down to the card
 					 * so that we can keep the card busy
 					 * and maximise throughput
 					 */
 #define FST_HIGH_WATER_MARK     12	/* Point at which we flow control
-					 * network layer */
+					 * network layer
+					 */
 #define FST_LOW_WATER_MARK      8	/* Point at which we remove flow
-					 * control from network layer */
+					 * control from network layer
+					 */
 #define FST_MAX_MTU             8000	/* Huge but possible */
 #define FST_DEF_MTU             1500	/* Common sane value */
 
@@ -70,8 +71,7 @@ MODULE_LICENSE("GPL");
 #define ARPHRD_MYTYPE   ARPHRD_HDLC	/* Cisco-HDLC (keepalives etc) */
 #endif
 
-/*
- * Modules parameters and associated variables
+/* Modules parameters and associated variables
  */
 static int fst_txq_low = FST_LOW_WATER_MARK;
 static int fst_txq_high = FST_HIGH_WATER_MARK;
@@ -105,9 +105,11 @@ module_param_array(fst_excluded_list, int, NULL, 0);
 #define FST_MEMSIZE 0x100000	/* Size of card memory (1Mb) */
 
 #define SMC_BASE 0x00002000L	/* Base offset of the shared memory window main
-				 * configuration structure */
+				 * configuration structure
+				 */
 #define BFM_BASE 0x00010000L	/* Base offset of the shared memory window DMA
-				 * buffers */
+				 * buffers
+				 */
 
 #define LEN_TX_BUFFER 8192	/* Size of packet buffers */
 #define LEN_RX_BUFFER 8192
@@ -377,8 +379,7 @@ struct fst_shared {
 #define INTCSR_9054     0x68	/* Interrupt control/status register */
 
 /* 9054 DMA Registers */
-/*
- * Note that we will be using DMA Channel 0 for copying rx data
+/* Note that we will be using DMA Channel 0 for copying rx data
  * and Channel 1 for copying tx data
  */
 #define DMAMODE0        0x80
@@ -431,8 +432,7 @@ struct fst_port_info {
 	int txpos;		/* Next Tx buffer to use */
 	int txipos;		/* Next Tx buffer to check for free */
 	int start;		/* Indication of start/stop to network */
-	/*
-	 * A sixteen entry transmit queue
+	/* A sixteen entry transmit queue
 	 */
 	int txqs;		/* index to get next buffer to tx */
 	int txqe;		/* index to queue next packet */
@@ -479,8 +479,7 @@ struct fst_card_info {
 #define dev_to_port(D)  (dev_to_hdlc(D)->priv)
 #define port_to_dev(P)  ((P)->dev)
 
-/*
- *      Shared memory window access macros
+/*      Shared memory window access macros
  *
  *      We have a nice memory based structure above, which could be directly
  *      mapped on i386 but might not work on other architectures unless we use
@@ -498,8 +497,7 @@ struct fst_card_info {
 #define FST_WRW(C,E,W)  writew ((W), (C)->mem + WIN_OFFSET(E))
 #define FST_WRL(C,E,L)  writel ((L), (C)->mem + WIN_OFFSET(E))
 
-/*
- *      Debug support
+/*      Debug support
  */
 #if FST_DEBUG
 
@@ -523,8 +521,7 @@ do {								\
 } while (0)
 #endif
 
-/*
- *      PCI ID lookup table
+/*      PCI ID lookup table
  */
 static const struct pci_device_id fst_pci_dev_id[] = {
 	{PCI_VENDOR_ID_FARSITE, PCI_DEVICE_ID_FARSITE_T2P, PCI_ANY_ID, 
@@ -552,8 +549,7 @@ static const struct pci_device_id fst_pci_dev_id[] = {
 
 MODULE_DEVICE_TABLE(pci, fst_pci_dev_id);
 
-/*
- *      Device Driver Work Queues
+/*      Device Driver Work Queues
  *
  *      So that we don't spend too much time processing events in the 
  *      Interrupt Service routine, we will declare a work queue per Card 
@@ -582,13 +578,11 @@ fst_q_work_item(u64 *queue, int card_index)
 	unsigned long flags;
 	u64 mask;
 
-	/*
-	 * Grab the queue exclusively
+	/* Grab the queue exclusively
 	 */
 	spin_lock_irqsave(&fst_work_q_lock, flags);
 
-	/*
-	 * Making an entry in the queue is simply a matter of setting
+	/* Making an entry in the queue is simply a matter of setting
 	 * a bit for the card indicating that there is work to do in the
 	 * bottom half for the card.  Note the limitation of 64 cards.
 	 * That ought to be enough
@@ -605,8 +599,7 @@ fst_process_tx_work_q(struct tasklet_struct *unused)
 	u64 work_txq;
 	int i;
 
-	/*
-	 * Grab the queue exclusively
+	/* Grab the queue exclusively
 	 */
 	dbg(DBG_TX, "fst_process_tx_work_q\n");
 	spin_lock_irqsave(&fst_work_q_lock, flags);
@@ -614,8 +607,7 @@ fst_process_tx_work_q(struct tasklet_struct *unused)
 	fst_work_txq = 0;
 	spin_unlock_irqrestore(&fst_work_q_lock, flags);
 
-	/*
-	 * Call the bottom half for each card with work waiting
+	/* Call the bottom half for each card with work waiting
 	 */
 	for (i = 0; i < FST_MAX_CARDS; i++) {
 		if (work_txq & 0x01) {
@@ -635,8 +627,7 @@ fst_process_int_work_q(struct tasklet_struct *unused)
 	u64 work_intq;
 	int i;
 
-	/*
-	 * Grab the queue exclusively
+	/* Grab the queue exclusively
 	 */
 	dbg(DBG_INTR, "fst_process_int_work_q\n");
 	spin_lock_irqsave(&fst_work_q_lock, flags);
@@ -644,8 +635,7 @@ fst_process_int_work_q(struct tasklet_struct *unused)
 	fst_work_intq = 0;
 	spin_unlock_irqrestore(&fst_work_q_lock, flags);
 
-	/*
-	 * Call the bottom half for each card with work waiting
+	/* Call the bottom half for each card with work waiting
 	 */
 	for (i = 0; i < FST_MAX_CARDS; i++) {
 		if (work_intq & 0x01) {
@@ -682,19 +672,16 @@ fst_cpureset(struct fst_card_info *card)
 			dbg(DBG_ASS,
 			    "Error in reading interrupt line register\n");
 		}
-		/*
-		 * Assert PLX software reset and Am186 hardware reset
+		/* Assert PLX software reset and Am186 hardware reset
 		 * and then deassert the PLX software reset but 186 still in reset
 		 */
 		outw(0x440f, card->pci_conf + CNTRL_9054 + 2);
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
-		/*
-		 * We are delaying here to allow the 9054 to reset itself
+		/* We are delaying here to allow the 9054 to reset itself
 		 */
 		usleep_range(10, 20);
 		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
-		/*
-		 * We are delaying here to allow the 9054 to reload its eeprom
+		/* We are delaying here to allow the 9054 to reload its eeprom
 		 */
 		usleep_range(10, 20);
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
@@ -719,13 +706,11 @@ static inline void
 fst_cpurelease(struct fst_card_info *card)
 {
 	if (card->family == FST_FAMILY_TXU) {
-		/*
-		 * Force posted writes to complete
+		/* Force posted writes to complete
 		 */
 		(void) readb(card->mem);
 
-		/*
-		 * Release LRESET DO = 1
+		/* Release LRESET DO = 1
 		 * Then release Local Hold, DO = 1
 		 */
 		outw(0x040e, card->pci_conf + CNTRL_9054 + 2);
@@ -781,8 +766,7 @@ fst_process_rx_status(int rx_status, char *name)
 	switch (rx_status) {
 	case NET_RX_SUCCESS:
 		{
-			/*
-			 * Nothing to do here
+			/* Nothing to do here
 			 */
 			break;
 		}
@@ -799,8 +783,7 @@ fst_process_rx_status(int rx_status, char *name)
 static inline void
 fst_init_dma(struct fst_card_info *card)
 {
-	/*
-	 * This is only required for the PLX 9054
+	/* This is only required for the PLX 9054
 	 */
 	if (card->family == FST_FAMILY_TXU) {
 	        pci_set_master(card->device);
@@ -818,8 +801,7 @@ fst_tx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 {
 	struct net_device *dev = port_to_dev(port);
 
-	/*
-	 * Everything is now set, just tell the card to go
+	/* Everything is now set, just tell the card to go
 	 */
 	dbg(DBG_TX, "fst_tx_dma_complete\n");
 	FST_WRB(card, txDescrRing[port->index][txpos].bits,
@@ -829,8 +811,7 @@ fst_tx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 	netif_trans_update(dev);
 }
 
-/*
- * Mark it for our own raw sockets interface
+/* Mark it for our own raw sockets interface
  */
 static __be16 farsync_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
@@ -873,14 +854,12 @@ fst_rx_dma_complete(struct fst_card_info *card, struct fst_port_info *port,
 		dev->stats.rx_dropped++;
 }
 
-/*
- *      Receive a frame through the DMA
+/*      Receive a frame through the DMA
  */
 static inline void
 fst_rx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 {
-	/*
-	 * This routine will setup the DMA and start it
+	/* This routine will setup the DMA and start it
 	 */
 
 	dbg(DBG_RX, "In fst_rx_dma %x %x %d\n", (u32)dma, mem, len);
@@ -893,21 +872,18 @@ fst_rx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 	outl(len, card->pci_conf + DMASIZ0);	/* for this length */
 	outl(0x00000000c, card->pci_conf + DMADPR0);	/* In this direction */
 
-	/*
-	 * We use the dmarx_in_progress flag to flag the channel as busy
+	/* We use the dmarx_in_progress flag to flag the channel as busy
 	 */
 	card->dmarx_in_progress = 1;
 	outb(0x03, card->pci_conf + DMACSR0);	/* Start the transfer */
 }
 
-/*
- *      Send a frame through the DMA
+/*      Send a frame through the DMA
  */
 static inline void
 fst_tx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 {
-	/*
-	 * This routine will setup the DMA and start it.
+	/* This routine will setup the DMA and start it.
 	 */
 
 	dbg(DBG_TX, "In fst_tx_dma %x %x %d\n", (u32)dma, mem, len);
@@ -920,8 +896,7 @@ fst_tx_dma(struct fst_card_info *card, dma_addr_t dma, u32 mem, int len)
 	outl(len, card->pci_conf + DMASIZ1);	/* for this length */
 	outl(0x000000004, card->pci_conf + DMADPR1);	/* In this direction */
 
-	/*
-	 * We use the dmatx_in_progress to flag the channel as busy
+	/* We use the dmatx_in_progress to flag the channel as busy
 	 */
 	card->dmatx_in_progress = 1;
 	outb(0x03, card->pci_conf + DMACSR1);	/* Start the transfer */
@@ -997,8 +972,7 @@ fst_op_lower(struct fst_port_info *port, unsigned int outputs)
 		fst_issue_cmd(port, SETV24O);
 }
 
-/*
- *      Setup port Rx buffers
+/*      Setup port Rx buffers
  */
 static void
 fst_rx_config(struct fst_port_info *port)
@@ -1025,8 +999,7 @@ fst_rx_config(struct fst_port_info *port)
 	spin_unlock_irqrestore(&card->card_lock, flags);
 }
 
-/*
- *      Setup port Tx buffers
+/*      Setup port Tx buffers
  */
 static void
 fst_tx_config(struct fst_port_info *port)
@@ -1068,16 +1041,14 @@ fst_intr_te1_alarm(struct fst_card_info *card, struct fst_port_info *port)
 	ais = FST_RDB(card, suStatus.alarmIndicationSignal);
 
 	if (los) {
-		/*
-		 * Lost the link
+		/* Lost the link
 		 */
 		if (netif_carrier_ok(port_to_dev(port))) {
 			dbg(DBG_INTR, "Net carrier off\n");
 			netif_carrier_off(port_to_dev(port));
 		}
 	} else {
-		/*
-		 * Link available
+		/* Link available
 		 */
 		if (!netif_carrier_ok(port_to_dev(port))) {
 			dbg(DBG_INTR, "Net carrier on\n");
@@ -1131,8 +1102,7 @@ fst_log_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 {
 	struct net_device *dev = port_to_dev(port);
 
-	/*
-	 * Increment the appropriate error counter
+	/* Increment the appropriate error counter
 	 */
 	dev->stats.rx_errors++;
 	if (dmabits & RX_OFLO) {
@@ -1167,8 +1137,7 @@ fst_recover_rx_error(struct fst_card_info *card, struct fst_port_info *port,
 	int pi;
 
 	pi = port->index;
-	/* 
-	 * Discard buffer descriptors until we see the start of the
+	/* Discard buffer descriptors until we see the start of the
 	 * next frame.  Note that for long frames this could be in
 	 * a subsequent interrupt. 
 	 */
@@ -1226,8 +1195,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	/* Discard the CRC */
 	len -= 2;
 	if (len == 0) {
-		/*
-		 * This seems to happen on the TE1 interface sometimes
+		/* This seems to happen on the TE1 interface sometimes
 		 * so throw the frame away and log the event.
 		 */
 		pr_err("Frame received with 0 length. Card %d Port %d\n",
@@ -1266,8 +1234,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 		return;
 	}
 
-	/*
-	 * We know the length we need to receive, len.
+	/* We know the length we need to receive, len.
 	 * It's not worth using the DMA for reads of less than
 	 * FST_MIN_DMA_LEN
 	 */
@@ -1310,8 +1277,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	port->rxpos = rxp;
 }
 
-/*
- *      The bottom halfs to the ISR
+/*      The bottom half to the ISR
  *
  */
 
@@ -1325,8 +1291,7 @@ do_bottom_half_tx(struct fst_card_info *card)
 	unsigned long flags;
 	struct net_device *dev;
 
-	/*
-	 *  Find a free buffer for the transmit
+	/*  Find a free buffer for the transmit
 	 *  Step through each port on this card
 	 */
 
@@ -1339,24 +1304,21 @@ do_bottom_half_tx(struct fst_card_info *card)
 		while (!(FST_RDB(card, txDescrRing[pi][port->txpos].bits) &
 			 DMA_OWN) &&
 		       !(card->dmatx_in_progress)) {
-			/*
-			 * There doesn't seem to be a txdone event per-se
+			/* There doesn't seem to be a txdone event per-se
 			 * We seem to have to deduce it, by checking the DMA_OWN
 			 * bit on the next buffer we think we can use
 			 */
 			spin_lock_irqsave(&card->card_lock, flags);
 			txq_length = port->txqe - port->txqs;
 			if (txq_length < 0) {
-				/*
-				 * This is the case where one has wrapped and the
+				/* This is the case where one has wrapped and the
 				 * maths gives us a negative number
 				 */
 				txq_length = txq_length + FST_TXQ_DEPTH;
 			}
 			spin_unlock_irqrestore(&card->card_lock, flags);
 			if (txq_length > 0) {
-				/*
-				 * There is something to send
+				/* There is something to send
 				 */
 				spin_lock_irqsave(&card->card_lock, flags);
 				skb = port->txq[port->txqs];
@@ -1365,8 +1327,7 @@ do_bottom_half_tx(struct fst_card_info *card)
 					port->txqs = 0;
 				}
 				spin_unlock_irqrestore(&card->card_lock, flags);
-				/*
-				 * copy the data and set the required indicators on the
+				/* copy the data and set the required indicators on the
 				 * card.
 				 */
 				FST_WRW(card, txDescrRing[pi][port->txpos].bcnt,
@@ -1401,8 +1362,7 @@ do_bottom_half_tx(struct fst_card_info *card)
 				}
 				if (++port->txpos >= NUM_TX_BUFFER)
 					port->txpos = 0;
-				/*
-				 * If we have flow control on, can we now release it?
+				/* If we have flow control on, can we now release it?
 				 */
 				if (port->start) {
 					if (txq_length < fst_txq_low) {
@@ -1413,8 +1373,7 @@ do_bottom_half_tx(struct fst_card_info *card)
 				}
 				dev_kfree_skb(skb);
 			} else {
-				/*
-				 * Nothing to send so break out of the while loop
+				/* Nothing to send so break out of the while loop
 				 */
 				break;
 			}
@@ -1438,8 +1397,7 @@ do_bottom_half_rx(struct fst_card_info *card)
 		while (!(FST_RDB(card, rxDescrRing[pi][port->rxpos].bits)
 			 & DMA_OWN) && !(card->dmarx_in_progress)) {
 			if (rx_count > fst_max_reads) {
-				/*
-				 * Don't spend forever in receive processing
+				/* Don't spend forever in receive processing
 				 * Schedule another event
 				 */
 				fst_q_work_item(&fst_work_intq, card->card_no);
@@ -1452,8 +1410,7 @@ do_bottom_half_rx(struct fst_card_info *card)
 	}
 }
 
-/*
- *      The interrupt service routine
+/*      The interrupt service routine
  *      Dev_id is our fst_card_info pointer
  */
 static irqreturn_t
@@ -1468,8 +1425,7 @@ fst_intr(int dummy, void *dev_id)
 	unsigned int do_card_interrupt;
 	unsigned int int_retry_count;
 
-	/*
-	 * Check to see if the interrupt was for this card
+	/* Check to see if the interrupt was for this card
 	 * return if not
 	 * Note that the call to clear the interrupt is important
 	 */
@@ -1478,8 +1434,7 @@ fst_intr(int dummy, void *dev_id)
 		pr_err("Interrupt received for card %d in a non running state (%d)\n",
 		       card->card_no, card->state);
 
-		/* 
-		 * It is possible to really be running, i.e. we have re-loaded
+		/* It is possible to really be running, i.e. we have re-loaded
 		 * a running card
 		 * Clear and reprime the interrupt source 
 		 */
@@ -1490,8 +1445,7 @@ fst_intr(int dummy, void *dev_id)
 	/* Clear and reprime the interrupt source */
 	fst_clear_intr(card);
 
-	/*
-	 * Is the interrupt for this card (handshake == 1)
+	/* Is the interrupt for this card (handshake == 1)
 	 */
 	do_card_interrupt = 0;
 	if (FST_RDB(card, interruptHandshake) == 1) {
@@ -1500,13 +1454,11 @@ fst_intr(int dummy, void *dev_id)
 		FST_WRB(card, interruptHandshake, 0xEE);
 	}
 	if (card->family == FST_FAMILY_TXU) {
-		/*
-		 * Is it a DMA Interrupt
+		/* Is it a DMA Interrupt
 		 */
 		dma_intcsr = inl(card->pci_conf + INTCSR_9054);
 		if (dma_intcsr & 0x00200000) {
-			/*
-			 * DMA Channel 0 (Rx transfer complete)
+			/* DMA Channel 0 (Rx transfer complete)
 			 */
 			dbg(DBG_RX, "DMA Rx xfer complete\n");
 			outb(0x8, card->pci_conf + DMACSR0);
@@ -1517,8 +1469,7 @@ fst_intr(int dummy, void *dev_id)
 			do_card_interrupt += FST_RX_DMA_INT;
 		}
 		if (dma_intcsr & 0x00400000) {
-			/*
-			 * DMA Channel 1 (Tx transfer complete)
+			/* DMA Channel 1 (Tx transfer complete)
 			 */
 			dbg(DBG_TX, "DMA Tx xfer complete\n");
 			outb(0x8, card->pci_conf + DMACSR1);
@@ -1529,8 +1480,7 @@ fst_intr(int dummy, void *dev_id)
 		}
 	}
 
-	/*
-	 * Have we been missing Interrupts
+	/* Have we been missing Interrupts
 	 */
 	int_retry_count = FST_RDL(card, interruptRetryCount);
 	if (int_retry_count) {
@@ -1788,27 +1738,23 @@ gather_conf_info(struct fst_card_info *card, struct fst_port_info *port,
 	info->cardMode = FST_RDW(card, cardMode);
 	info->smcFirmwareVersion = FST_RDL(card, smcFirmwareVersion);
 
-	/*
-	 * The T2U can report cable presence for both A or B
+	/* The T2U can report cable presence for both A or B
 	 * in bits 0 and 1 of cableStatus.  See which port we are and 
 	 * do the mapping.
 	 */
 	if (card->family == FST_FAMILY_TXU) {
 		if (port->index == 0) {
-			/*
-			 * Port A
+			/* Port A
 			 */
 			info->cableStatus = info->cableStatus & 1;
 		} else {
-			/*
-			 * Port B
+			/* Port B
 			 */
 			info->cableStatus = info->cableStatus >> 1;
 			info->cableStatus = info->cableStatus & 1;
 		}
 	}
-	/*
-	 * Some additional bits if we are TE1
+	/* Some additional bits if we are TE1
 	 */
 	if (card->type == FST_TYPE_TE1) {
 		info->lineSpeed = FST_RDL(card, suConfig.dataRate);
@@ -2072,9 +2018,7 @@ fst_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	case FSTSETCONF:
-
-		/*
-		 * Most of the settings have been moved to the generic ioctls
+		/* Most of the settings have been moved to the generic ioctls
 		 * this just covers debug and board ident now
 		 */
 
@@ -2230,8 +2174,7 @@ fst_close(struct net_device *dev)
 static int
 fst_attach(struct net_device *dev, unsigned short encoding, unsigned short parity)
 {
-	/*
-	 * Setting currently fixed in FarSync card so we check and forget
+	/* Setting currently fixed in FarSync card so we check and forget
 	 */
 	if (encoding != ENCODING_NRZ || parity != PARITY_CRC16_PR1_CCITT)
 		return -EINVAL;
@@ -2289,24 +2232,21 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	/*
-	 * We are always going to queue the packet
+	/* We are always going to queue the packet
 	 * so that the bottom half is the only place we tx from
 	 * Check there is room in the port txq
 	 */
 	spin_lock_irqsave(&card->card_lock, flags);
 	txq_length = port->txqe - port->txqs;
 	if (txq_length < 0) {
-		/*
-		 * This is the case where the next free has wrapped but the
+		/* This is the case where the next free has wrapped but the
 		 * last used hasn't
 		 */
 		txq_length = txq_length + FST_TXQ_DEPTH;
 	}
 	spin_unlock_irqrestore(&card->card_lock, flags);
 	if (txq_length > fst_txq_high) {
-		/*
-		 * We have got enough buffers in the pipeline.  Ask the network
+		/* We have got enough buffers in the pipeline.  Ask the network
 		 * layer to stop sending frames down
 		 */
 		netif_stop_queue(dev);
@@ -2314,8 +2254,7 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (txq_length == FST_TXQ_DEPTH - 1) {
-		/*
-		 * This shouldn't have happened but such is life
+		/* This shouldn't have happened but such is life
 		 */
 		dev_kfree_skb(skb);
 		dev->stats.tx_errors++;
@@ -2324,8 +2263,7 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
-	/*
-	 * queue the buffer
+	/* queue the buffer
 	 */
 	spin_lock_irqsave(&card->card_lock, flags);
 	port->txq[port->txqe] = skb;
@@ -2341,8 +2279,7 @@ fst_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-/*
- *      Card setup having checked hardware resources.
+/*      Card setup having checked hardware resources.
  *      Should be pretty bizarre if we get an error here (kernel memory
  *      exhaustion is one possibility). If we do see a problem we report it
  *      via a printk and leave the corresponding interface and all that follow
@@ -2394,8 +2331,7 @@ static const struct net_device_ops fst_ops = {
 	.ndo_tx_timeout = fst_tx_timeout,
 };
 
-/*
- *      Initialise card when detected.
+/*      Initialise card when detected.
  *      Returns 0 to indicate success, or errno otherwise.
  */
 static int
@@ -2412,13 +2348,11 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #if FST_DEBUG
 	dbg(DBG_ASS, "The value of debug mask is %x\n", fst_debug_mask);
 #endif
-	/*
-	 * We are going to be clever and allow certain cards not to be
+	/* We are going to be clever and allow certain cards not to be
 	 * configured.  An exclude list can be provided in /etc/modules.conf
 	 */
 	if (fst_excluded_cards != 0) {
-		/*
-		 * There are cards to exclude
+		/* There are cards to exclude
 		 *
 		 */
 		for (i = 0; i < fst_excluded_cards; i++) {
@@ -2555,8 +2489,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto init_card_fail;
 	if (card->family == FST_FAMILY_TXU) {
-		/*
-		 * Allocate a dma buffer for transmit and receives
+		/* Allocate a dma buffer for transmit and receives
 		 */
 		card->rx_dma_handle_host =
 		    dma_alloc_coherent(&card->device->dev, FST_MAX_MTU,
@@ -2604,8 +2537,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-/*
- *      Cleanup and close down a card
+/*      Cleanup and close down a card
  */
 static void
 fst_remove_one(struct pci_dev *pdev)
@@ -2628,8 +2560,7 @@ fst_remove_one(struct pci_dev *pdev)
 	iounmap(card->mem);
 	pci_release_regions(pdev);
 	if (card->family == FST_FAMILY_TXU) {
-		/*
-		 * Free dma buffers
+		/* Free dma buffers
 		 */
 		dma_free_coherent(&card->device->dev, FST_MAX_MTU,
 				  card->rx_dma_handle_host,
-- 
2.8.1

