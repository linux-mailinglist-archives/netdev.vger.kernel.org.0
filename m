Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E20D3A93CA
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhFPH3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:23 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4804 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFPH3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4c7h5t1yzXgZt;
        Wed, 16 Jun 2021 15:21:52 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 06/15] net: cosa: fix the comments style issue
Date:   Wed, 16 Jun 2021 15:23:32 +0800
Message-ID: <1623828221-48349-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
References: <1623828221-48349-1-git-send-email-huangguangbin2@huawei.com>
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

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 89 +++++++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 9b57b3a..c09c079 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -1,13 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /* $Id: cosa.c,v 1.31 2000/03/08 17:47:16 kas Exp $ */
 
-/*
- *  Copyright (C) 1995-1997  Jan "Yenya" Kasprzak <kas@fi.muni.cz>
+/*  Copyright (C) 1995-1997  Jan "Yenya" Kasprzak <kas@fi.muni.cz>
  *  Generic HDLC port Copyright (C) 2008 Krzysztof Halasa <khc@pm.waw.pl>
  */
 
-/*
- * The driver for the SRP and COSA synchronous serial cards.
+/* The driver for the SRP and COSA synchronous serial cards.
  *
  * HARDWARE INFO
  *
@@ -152,28 +150,25 @@ struct cosa_data {
 	char *type;				/* card type */
 };
 
-/*
- * Define this if you want all the possible ports to be autoprobed.
+/* Define this if you want all the possible ports to be autoprobed.
  * It is here but it probably is not a good idea to use this.
  */
-/* #define COSA_ISA_AUTOPROBE	1 */
+/* #define COSA_ISA_AUTOPROBE	1*/
 
-/*
- * Character device major number. 117 was allocated for us.
+/* Character device major number. 117 was allocated for us.
  * The value of 0 means to allocate a first free one.
  */
 static DEFINE_MUTEX(cosa_chardev_mutex);
 static int cosa_major = 117;
 
-/*
- * Encoding of the minor numbers:
+/* Encoding of the minor numbers:
  * The lowest CARD_MINOR_BITS bits means the channel on the single card,
  * the highest bits means the card number.
  */
 #define CARD_MINOR_BITS	4	/* How many bits in minor number are reserved
-				 * for the single card */
-/*
- * The following depends on CARD_MINOR_BITS. Unfortunately, the "MODULE_STRING"
+				 * for the single card
+				 */
+/* The following depends on CARD_MINOR_BITS. Unfortunately, the "MODULE_STRING"
  * macro doesn't like anything other than the raw number as an argument :-(
  */
 #define MAX_CARDS	16
@@ -184,8 +179,7 @@ static int cosa_major = 117;
 #define DRIVER_TXMAP_SHIFT	2
 #define DRIVER_TXMAP_MASK	0x0c	/* FIXME: 0xfc for 8-channel version */
 
-/*
- * for cosa->rxtx - indicates whether either transmit or receive is
+/* for cosa->rxtx - indicates whether either transmit or receive is
  * in progress. These values are mean number of the bit.
  */
 #define TXBIT 0
@@ -439,7 +433,8 @@ static int cosa_probe(int base, int irq, int dma)
 		return -1;
 	}
 	/* I/O address should be between 0x100 and 0x3ff and should be
-	 * multiple of 8. */
+	 * multiple of 8.
+	 */
 	if (base < 0x100 || base > 0x3ff || base & 0x7) {
 		pr_info("invalid I/O address 0x%x\n", base);
 		return -1;
@@ -450,7 +445,8 @@ static int cosa_probe(int base, int irq, int dma)
 		return -1;
 	}
 	/* and finally, on 16-bit COSA DMA should be 4-7 and 
-	 * I/O base should not be multiple of 0x10 */
+	 * I/O base should not be multiple of 0x10
+	 */
 	if (((base & 0x8) && dma < 4) || (!(base & 0x8) && dma > 3)) {
 		pr_info("8/16 bit base and DMA mismatch (base=0x%x, dma=%d)\n",
 			base, dma);
@@ -496,8 +492,7 @@ static int cosa_probe(int base, int irq, int dma)
 		unsigned long irqs;
 /*		pr_info("IRQ autoprobe\n"); */
 		irqs = probe_irq_on();
-		/* 
-		 * Enable interrupt on tx buffer empty (it sure is) 
+		/* Enable interrupt on tx buffer empty (it sure is)
 		 * really sure ?
 		 * FIXME: When this code is not used as module, we should
 		 * probably call udelay() instead of the interruptible sleep.
@@ -715,8 +710,7 @@ static int cosa_net_close(struct net_device *dev)
 
 static char *cosa_net_setup_rx(struct channel_data *chan, int size)
 {
-	/*
-	 * We can safely fall back to non-dma-able memory, because we have
+	/* We can safely fall back to non-dma-able memory, because we have
 	 * the cosa->bouncebuf pre-allocated.
 	 */
 	kfree_skb(chan->rx_skb);
@@ -990,8 +984,7 @@ static int cosa_fasync(struct inode *inode, struct file *file, int on)
 
 /* ---------- Ioctls ---------- */
 
-/*
- * Ioctl subroutines can safely be made inline, because they are called
+/* Ioctl subroutines can safely be made inline, because they are called
  * only from cosa_ioctl().
  */
 static inline int cosa_reset(struct cosa_data *cosa)
@@ -1203,8 +1196,7 @@ static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
 
 /*---------- HW layer interface ---------- */
 
-/*
- * The higher layer can bind itself to the HW layer by setting the callbacks
+/* The higher layer can bind itself to the HW layer by setting the callbacks
  * in the channel_data structure and by using these routines.
  */
 static void cosa_enable_rx(struct channel_data *chan)
@@ -1223,8 +1215,7 @@ static void cosa_disable_rx(struct channel_data *chan)
 		put_driver_status(cosa);
 }
 
-/*
- * FIXME: This routine probably should check for cosa_start_tx() called when
+/* FIXME: This routine probably should check for cosa_start_tx() called when
  * the previous transmit is still unfinished. In this case the non-zero
  * return value should indicate to the caller that the queuing(sp?) up
  * the transmit has failed.
@@ -1319,8 +1310,7 @@ static void put_driver_status_nolock(struct cosa_data *cosa)
 #endif
 }
 
-/*
- * The "kickme" function: When the DMA times out, this is called to
+/* The "kickme" function: When the DMA times out, this is called to
  * clean up the driver status.
  * FIXME: Preliminary support, the interface is probably wrong.
  */
@@ -1355,8 +1345,7 @@ static void cosa_kick(struct cosa_data *cosa)
 	spin_unlock_irqrestore(&cosa->lock, flags);
 }
 
-/*
- * Check if the whole buffer is DMA-able. It means it is below the 16M of
+/* Check if the whole buffer is DMA-able. It means it is below the 16M of
  * physical memory and doesn't span the 64k boundary. For now it seems
  * SKB's never do this, but we'll check this anyway.
  */
@@ -1378,8 +1367,7 @@ static int cosa_dma_able(struct channel_data *chan, char *buf, int len)
 
 /* ---------- The SRP/COSA ROM monitor functions ---------- */
 
-/*
- * Downloading SRP microcode: say "w" to SRP monitor, it answers by "w=",
+/* Downloading SRP microcode: say "w" to SRP monitor, it answers by "w=",
  * drivers need to say 4-digit hex number meaning start address of the microcode
  * separated by a single space. Monitor replies by saying " =". Now driver
  * has to write 4-digit hex number meaning the last byte address ended
@@ -1425,8 +1413,7 @@ static int download(struct cosa_data *cosa, const char __user *microcode, int le
 	return 0;
 }
 
-/*
- * Starting microcode is done via the "g" command of the SRP monitor.
+/* Starting microcode is done via the "g" command of the SRP monitor.
  * The chat should be the following: "g" "g=" "<addr><CR>"
  * "<CR><CR><LF><CR><LF>".
  */
@@ -1450,8 +1437,7 @@ static int startmicrocode(struct cosa_data *cosa, int address)
 	return 0;
 }
 
-/*
- * Reading memory is done via the "r" command of the SRP monitor.
+/* Reading memory is done via the "r" command of the SRP monitor.
  * The chat is the following "r" "r=" "<addr> " " =" "<last_byte> " " "
  * Then driver can read the data and the conversation is finished
  * by SRP monitor sending "<CR><LF>." (dot at the end).
@@ -1502,8 +1488,7 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
 	return 0;
 }
 
-/*
- * This function resets the device and reads the initial prompt
+/* This function resets the device and reads the initial prompt
  * of the device's ROM monitor.
  */
 static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
@@ -1518,8 +1503,7 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 	/* Disable all IRQs from the card */
 	cosa_putstatus(cosa, 0);
 
-	/*
-	 * Try to read the ID string. The card then prints out the
+	/* Try to read the ID string. The card then prints out the
 	 * identification string ended by the "\n\x2e".
 	 *
 	 * The following loop is indexed through i (instead of id)
@@ -1544,8 +1528,7 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 
 /* ---------- Auxiliary routines for COSA/SRP monitor ---------- */
 
-/*
- * This routine gets the data byte from the card waiting for the SR_RX_RDY
+/* This routine gets the data byte from the card waiting for the SR_RX_RDY
  * bit to be set in a loop. It should be used in the exceptional cases
  * only (for example when resetting the card or downloading the firmware.
  */
@@ -1573,8 +1556,7 @@ static int get_wait_data(struct cosa_data *cosa)
 	return -1;
 }
 
-/*
- * This routine puts the data byte to the card waiting for the SR_TX_RDY
+/* This routine puts the data byte to the card waiting for the SR_TX_RDY
  * bit to be set in a loop. It should be used in the exceptional cases
  * only (for example when resetting the card or downloading the firmware).
  */
@@ -1601,8 +1583,7 @@ static int put_wait_data(struct cosa_data *cosa, int data)
 	return -1;
 }
 	
-/* 
- * The following routine puts the hexadecimal number into the SRP monitor
+/* The following routine puts the hexadecimal number into the SRP monitor
  * and verifies the proper echo of the sent bytes. Returns 0 on success,
  * negative number on failure (-1,-3,-5,-7) means that put_wait_data() failed,
  * (-2,-4,-6,-8) means that reading echo failed.
@@ -1631,8 +1612,7 @@ static int puthexnumber(struct cosa_data *cosa, int number)
 
 /* ---------- Interrupt routines ---------- */
 
-/*
- * There are three types of interrupt:
+/* There are three types of interrupt:
  * At the beginning of transmit - this handled is in tx_interrupt(),
  * at the beginning of receive - it is in rx_interrupt() and
  * at the end of transmit/receive - it is the eot_interrupt() function.
@@ -1646,8 +1626,7 @@ static int puthexnumber(struct cosa_data *cosa, int number)
  * It's time to use the bottom half :-(
  */
 
-/*
- * Transmit interrupt routine - called when COSA is willing to obtain
+/* Transmit interrupt routine - called when COSA is willing to obtain
  * data from the OS. The most tricky part of the routine is selection
  * of channel we (OS) want to send packet for. For SRP we should probably
  * use the round-robin approach. The newer COSA firmwares have a simple
@@ -1924,8 +1903,7 @@ static inline void eot_interrupt(struct cosa_data *cosa, int status)
 	} else {
 		pr_notice("cosa%d: unexpected EOT interrupt\n", cosa->num);
 	}
-	/*
-	 * Clear the RXBIT, TXBIT and IRQBIT (the latest should be
+	/* Clear the RXBIT, TXBIT and IRQBIT (the latest should be
 	 * cleared anyway). We should do it as soon as possible
 	 * so that we can tell the COSA we are done and to give it a time
 	 * for recovery.
@@ -1979,8 +1957,7 @@ static irqreturn_t cosa_interrupt(int irq, void *cosa_)
 }
 
 /* ---------- I/O debugging routines ---------- */
-/*
- * These routines can be used to monitor COSA/SRP I/O and to printk()
+/* These routines can be used to monitor COSA/SRP I/O and to printk()
  * the data being transferred on the data and status I/O port in a
  * readable way.
  */
-- 
2.8.1

