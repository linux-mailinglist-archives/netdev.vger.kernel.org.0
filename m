Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0803A93CC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhFPH30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:26 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7295 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhFPH3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4c7k1Sxqz1BN7C;
        Wed, 16 Jun 2021 15:21:54 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 13/15] net: cosa: add some required spaces
Date:   Wed, 16 Jun 2021 15:23:39 +0800
Message-ID: <1623828221-48349-14-git-send-email-huangguangbin2@huawei.com>
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

Add space required before the open parenthesis '(' and '{'.
Add space required after that close brace '}' and ','
Add spaces required around that '=' , '&', '*', '|', '+', '/' and '-'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 137 +++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 4fb602b..26cdfda 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -88,7 +88,7 @@
 #define COSA_MAX_ID_STRING	128
 
 /* Maximum length of the channel name */
-#define COSA_MAX_NAME		(sizeof("cosaXXXcXXX")+1)
+#define COSA_MAX_NAME		(sizeof("cosaXXXcXXX") + 1)
 
 /* Per-channel data structure */
 
@@ -192,22 +192,22 @@ static int cosa_major = 117;
 #undef DEBUG_IRQS //1	/* Print the message when the IRQ is received */
 #undef DEBUG_IO   //1	/* Dump the I/O traffic */
 
-#define TX_TIMEOUT	(5*HZ)
+#define TX_TIMEOUT	(5 * HZ)
 
 /* Maybe the following should be allocated dynamically */
 static struct cosa_data cosa_cards[MAX_CARDS];
 static int nr_cards;
 
 #ifdef COSA_ISA_AUTOPROBE
-static int io[MAX_CARDS+1]  = { 0x220, 0x228, 0x210, 0x218, 0, };
+static int io[MAX_CARDS + 1]  = {0x220, 0x228, 0x210, 0x218, 0,};
 /* NOTE: DMA is not autoprobed!!! */
-static int dma[MAX_CARDS+1] = { 1, 7, 1, 7, 1, 7, 1, 7, 0, };
+static int dma[MAX_CARDS + 1] = {1, 7, 1, 7, 1, 7, 1, 7, 0,};
 #else
-static int io[MAX_CARDS+1];
-static int dma[MAX_CARDS+1];
+static int io[MAX_CARDS + 1];
+static int dma[MAX_CARDS + 1];
 #endif
 /* IRQ can be safely autoprobed */
-static int irq[MAX_CARDS+1] = { -1, -1, -1, -1, -1, -1, 0, };
+static int irq[MAX_CARDS + 1] = {-1, -1, -1, -1, -1, -1, 0,};
 
 /* for class stuff*/
 static struct class *cosa_class;
@@ -356,9 +356,9 @@ static int __init cosa_init(void)
 			goto out;
 		}
 	}
-	for (i=0; i<MAX_CARDS; i++)
+	for (i = 0; i < MAX_CARDS; i++)
 		cosa_cards[i].num = -1;
-	for (i=0; io[i] != 0 && i < MAX_CARDS; i++)
+	for (i = 0; io[i] != 0 && i < MAX_CARDS; i++)
 		cosa_probe(io[i], irq[i], dma[i]);
 	if (!nr_cards) {
 		pr_warn("no devices found\n");
@@ -421,7 +421,7 @@ static const struct net_device_ops cosa_ops = {
 
 static int cosa_probe(int base, int irq, int dma)
 {
-	struct cosa_data *cosa = cosa_cards+nr_cards;
+	struct cosa_data *cosa = cosa_cards + nr_cards;
 	int i, err = 0;
 
 	memset(cosa, 0, sizeof(struct cosa_data));
@@ -455,10 +455,10 @@ static int cosa_probe(int base, int irq, int dma)
 
 	cosa->dma = dma;
 	cosa->datareg = base;
-	cosa->statusreg = is_8bit(cosa)?base+1:base+2;
+	cosa->statusreg = is_8bit(cosa) ? base + 1 : base + 2;
 	spin_lock_init(&cosa->lock);
 
-	if (!request_region(base, is_8bit(cosa)?2:4,"cosa"))
+	if (!request_region(base, is_8bit(cosa) ? 2 : 4, "cosa"))
 		return -1;
 	
 	if (cosa_reset_and_read_id(cosa, cosa->id_string) < 0) {
@@ -471,7 +471,7 @@ static int cosa_probe(int base, int irq, int dma)
 	if (!strncmp(cosa->id_string, "SRP", 3)) {
 		cosa->type = "srp";
 	} else if (!strncmp(cosa->id_string, "COSA", 4)) {
-		cosa->type = is_8bit(cosa)? "cosa8": "cosa16";
+		cosa->type = is_8bit(cosa) ? "cosa8" : "cosa16";
 	} else {
 /* Print a warning only if we are not autoprobing */
 #ifndef COSA_ISA_AUTOPROBE
@@ -481,8 +481,8 @@ static int cosa_probe(int base, int irq, int dma)
 		goto err_out;
 	}
 	/* Update the name of the region now we know the type of card */ 
-	release_region(base, is_8bit(cosa)?2:4);
-	if (!request_region(base, is_8bit(cosa)?2:4, cosa->type)) {
+	release_region(base, is_8bit(cosa) ? 2 : 4);
+	if (!request_region(base, is_8bit(cosa) ? 2 : 4, cosa->type)) {
 		printk(KERN_DEBUG "changing name at 0x%x failed.\n", base);
 		return -1;
 	}
@@ -533,7 +533,7 @@ static int cosa_probe(int base, int irq, int dma)
 		goto err_out1;
 	}
 	
-	cosa->bouncebuf = kmalloc(COSA_MTU, GFP_KERNEL|GFP_DMA);
+	cosa->bouncebuf = kmalloc(COSA_MTU, GFP_KERNEL | GFP_DMA);
 	if (!cosa->bouncebuf) {
 		err = -ENOMEM;
 		goto err_out2;
@@ -600,7 +600,7 @@ static int cosa_probe(int base, int irq, int dma)
 err_out1:
 	free_irq(cosa->irq, cosa);
 err_out:
-	release_region(cosa->datareg,is_8bit(cosa)?2:4);
+	release_region(cosa->datareg, is_8bit(cosa) ? 2 : 4);
 	pr_notice("cosa%d: allocating resources failed\n", cosa->num);
 	return err;
 }
@@ -778,7 +778,7 @@ static ssize_t cosa_read(struct file *file,
 	if (mutex_lock_interruptible(&chan->rlock))
 		return -ERESTARTSYS;
 	
-	chan->rxdata = kmalloc(COSA_MTU, GFP_DMA|GFP_KERNEL);
+	chan->rxdata = kmalloc(COSA_MTU, GFP_DMA | GFP_KERNEL);
 	if (!chan->rxdata) {
 		mutex_unlock(&chan->rlock);
 		return -ENOMEM;
@@ -856,7 +856,7 @@ static ssize_t cosa_write(struct file *file,
 		count = COSA_MTU;
 	
 	/* Allocate the buffer */
-	kbuf = kmalloc(count, GFP_KERNEL|GFP_DMA);
+	kbuf = kmalloc(count, GFP_KERNEL | GFP_DMA);
 	if (!kbuf) {
 		up(&chan->wsem);
 		return -ENOMEM;
@@ -866,7 +866,7 @@ static ssize_t cosa_write(struct file *file,
 		kfree(kbuf);
 		return -EFAULT;
 	}
-	chan->tx_status=0;
+	chan->tx_status = 0;
 	cosa_start_tx(chan, kbuf, count);
 
 	spin_lock_irqsave(&cosa->lock, flags);
@@ -926,7 +926,7 @@ static int cosa_open(struct inode *inode, struct file *file)
 		ret = -ENODEV;
 		goto out;
 	}
-	cosa = cosa_cards+n;
+	cosa = cosa_cards + n;
 
 	n = iminor(file_inode(file)) & ((1 << CARD_MINOR_BITS) - 1);
 	if (n >= cosa->nchannels) {
@@ -994,7 +994,7 @@ static inline int cosa_reset(struct cosa_data *cosa)
 	if (cosa->usage > 1)
 		pr_info("cosa%d: WARNING: reset requested with cosa->usage > 1 (%d). Odd things may happen.\n",
 			cosa->num, cosa->usage);
-	cosa->firmware_status &= ~(COSA_FW_RESET|COSA_FW_START);
+	cosa->firmware_status &= ~(COSA_FW_RESET | COSA_FW_START);
 	if (cosa_reset_and_read_id(cosa, idstring) < 0) {
 		pr_notice("cosa%d: reset failed\n", cosa->num);
 		return -EIO;
@@ -1028,7 +1028,7 @@ static inline int cosa_download(struct cosa_data *cosa, void __user *arg)
 		return -EINVAL;
 
 	/* If something fails, force the user to reset the card */
-	cosa->firmware_status &= ~(COSA_FW_RESET|COSA_FW_DOWNLOAD);
+	cosa->firmware_status &= ~(COSA_FW_RESET | COSA_FW_DOWNLOAD);
 
 	i = download(cosa, d.code, d.len, d.addr);
 	if (i < 0) {
@@ -1038,7 +1038,7 @@ static inline int cosa_download(struct cosa_data *cosa, void __user *arg)
 	}
 	pr_info("cosa%d: downloading microcode - 0x%04x bytes at 0x%04x\n",
 		cosa->num, d.len, d.addr);
-	cosa->firmware_status |= COSA_FW_RESET|COSA_FW_DOWNLOAD;
+	cosa->firmware_status |= COSA_FW_RESET | COSA_FW_DOWNLOAD;
 	return 0;
 }
 
@@ -1083,8 +1083,8 @@ static inline int cosa_start(struct cosa_data *cosa, int address)
 		pr_info("cosa%d: WARNING: start microcode requested with cosa->usage > 1 (%d). Odd things may happen.\n",
 			cosa->num, cosa->usage);
 
-	if ((cosa->firmware_status & (COSA_FW_RESET|COSA_FW_DOWNLOAD))
-		!= (COSA_FW_RESET|COSA_FW_DOWNLOAD)) {
+	if ((cosa->firmware_status & (COSA_FW_RESET | COSA_FW_DOWNLOAD))
+		!= (COSA_FW_RESET | COSA_FW_DOWNLOAD)) {
 		pr_notice("%s: download the microcode and/or reset the card first (status %d)\n",
 			  cosa->name, cosa->firmware_status);
 		return -EPERM;
@@ -1105,7 +1105,7 @@ static inline int cosa_start(struct cosa_data *cosa, int address)
 /* Buffer of size at least COSA_MAX_ID_STRING is expected */
 static inline int cosa_getidstr(struct cosa_data *cosa, char __user *string)
 {
-	int l = strlen(cosa->id_string)+1;
+	int l = strlen(cosa->id_string) + 1;
 
 	if (copy_to_user(string, cosa->id_string, l))
 		return -EFAULT;
@@ -1115,7 +1115,7 @@ static inline int cosa_getidstr(struct cosa_data *cosa, char __user *string)
 /* Buffer of size at least COSA_MAX_ID_STRING is expected */
 static inline int cosa_gettype(struct cosa_data *cosa, char __user *string)
 {
-	int l = strlen(cosa->type)+1;
+	int l = strlen(cosa->type) + 1;
 
 	if (copy_to_user(string, cosa->type, l))
 		return -EFAULT;
@@ -1230,7 +1230,7 @@ static int cosa_start_tx(struct channel_data *chan, char *buf, int len)
 
 	pr_info("cosa%dc%d: starting tx(0x%x)",
 		chan->cosa->num, chan->num, len);
-	for (i=0; i<len; i++)
+	for (i = 0; i < len; i++)
 		pr_cont(" %02x", buf[i]&0xff);
 	pr_cont("\n");
 #endif
@@ -1257,10 +1257,10 @@ static void put_driver_status(struct cosa_data *cosa)
 
 	status = (cosa->rxbitmap ? DRIVER_RX_READY : 0)
 		| (cosa->txbitmap ? DRIVER_TX_READY : 0)
-		| (cosa->txbitmap? ~(cosa->txbitmap<<DRIVER_TXMAP_SHIFT)
-			&DRIVER_TXMAP_MASK : 0);
+		| (cosa->txbitmap ? ~(cosa->txbitmap << DRIVER_TXMAP_SHIFT)
+			& DRIVER_TXMAP_MASK : 0);
 	if (!cosa->rxtx) {
-		if (cosa->rxbitmap|cosa->txbitmap) {
+		if (cosa->rxbitmap | cosa->txbitmap) {
 			if (!cosa->enabled) {
 				cosa_putstatus(cosa, SR_RX_INT_ENA);
 #ifdef DEBUG_IO
@@ -1289,10 +1289,10 @@ static void put_driver_status_nolock(struct cosa_data *cosa)
 
 	status = (cosa->rxbitmap ? DRIVER_RX_READY : 0)
 		| (cosa->txbitmap ? DRIVER_TX_READY : 0)
-		| (cosa->txbitmap? ~(cosa->txbitmap<<DRIVER_TXMAP_SHIFT)
-			&DRIVER_TXMAP_MASK : 0);
+		| (cosa->txbitmap ? ~(cosa->txbitmap << DRIVER_TXMAP_SHIFT)
+			& DRIVER_TXMAP_MASK : 0);
 
-	if (cosa->rxbitmap|cosa->txbitmap) {
+	if (cosa->rxbitmap | cosa->txbitmap) {
 		cosa_putstatus(cosa, SR_RX_INT_ENA);
 #ifdef DEBUG_IO
 		debug_status_out(cosa, SR_RX_INT_ENA);
@@ -1355,9 +1355,9 @@ static int cosa_dma_able(struct channel_data *chan, char *buf, int len)
 	static int count;
 	unsigned long b = (unsigned long)buf;
 
-	if (b+len >= MAX_DMA_ADDRESS)
+	if (b + len >= MAX_DMA_ADDRESS)
 		return 0;
-	if ((b^ (b+len)) & 0x10000) {
+	if ((b ^ (b + len)) & 0x10000) {
 		if (count++ < 5)
 			pr_info("%s: packet spanning a 64k boundary\n",
 				chan->name);
@@ -1502,7 +1502,7 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
 			pr_info("0x%04x bytes remaining\n", length);
 			return -11;
 		}
-		c=i;
+		c = i;
 #if 1
 		if (put_user(c, microcode))
 			return -23; /* ??? */
@@ -1529,7 +1529,7 @@ static int readmem(struct cosa_data *cosa, char __user *microcode, int length, i
  */
 static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 {
-	int i=0, id=0, prev=0, curr=0;
+	int i = 0, id = 0, prev = 0, curr = 0;
 
 	/* Reset the card ... */
 	cosa_putstatus(cosa, 0);
@@ -1546,7 +1546,7 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 	 * to avoid looping forever when for any reason
 	 * the port returns '\r', '\n' or '\x2e' permanently.
 	 */
-	for (i=0; i<COSA_MAX_ID_STRING-1; i++, prev=curr) {
+	for (i = 0; i < COSA_MAX_ID_STRING - 1; i++, prev = curr) {
 		curr = get_wait_data(cosa);
 		if (curr == -1)
 			return -1;
@@ -1580,7 +1580,7 @@ static int get_wait_data(struct cosa_data *cosa)
 			r = cosa_getdata8(cosa);
 #if 0
 			pr_info("get_wait_data returning after %d retries\n",
-				999-retries);
+				999 - retries);
 #endif
 			return r;
 		}
@@ -1605,7 +1605,7 @@ static int put_wait_data(struct cosa_data *cosa, int data)
 		if (cosa_getstatus(cosa) & SR_TX_RDY) {
 			cosa_putdata8(cosa, data);
 #if 0
-			pr_info("Putdata: %d retries\n", 999-retries);
+			pr_info("Putdata: %d retries\n", 999 - retries);
 #endif
 			return 0;
 		}
@@ -1631,16 +1631,16 @@ static int puthexnumber(struct cosa_data *cosa, int number)
 
 	/* Well, I should probably replace this by something faster. */
 	sprintf(temp, "%04X", number);
-	for (i=0; i<4; i++) {
+	for (i = 0; i < 4; i++) {
 		if (put_wait_data(cosa, temp[i]) == -1) {
 			pr_notice("cosa%d: puthexnumber failed to write byte %d\n",
 				  cosa->num, i);
-			return -1-2*i;
+			return -1 - 2 * i;
 		}
 		if (get_wait_data(cosa) != temp[i]) {
 			pr_notice("cosa%d: puthexhumber failed to read echo of byte %d\n",
 				  cosa->num, i);
-			return -2-2*i;
+			return -2 - 2 * i;
 		}
 	}
 	return 0;
@@ -1687,7 +1687,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 	set_bit(TXBIT, &cosa->rxtx);
 	if (!test_bit(IRQBIT, &cosa->rxtx)) {
 		/* flow control, see the comment above */
-		int i=0;
+		int i = 0;
 
 		if (!cosa->txbitmap) {
 			pr_warn("%s: No channel wants data in TX IRQ. Expect DMA timeout.\n",
@@ -1702,9 +1702,10 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 			i++;
 			if (cosa->txchan >= cosa->nchannels)
 				cosa->txchan = 0;
-			if (!(cosa->txbitmap & (1<<cosa->txchan)))
+			if (!(cosa->txbitmap & (1 << cosa->txchan)))
 				continue;
-			if (~status & (1 << (cosa->txchan+DRIVER_TXMAP_SHIFT)))
+			if (~status &
+			    (1 << (cosa->txchan + DRIVER_TXMAP_SHIFT)))
 				break;
 			/* in second pass, accept first ready-to-TX channel */
 			if (i > cosa->nchannels) {
@@ -1719,7 +1720,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		}
 
 		cosa->txsize = cosa->chan[cosa->txchan].txsize;
-		if (cosa_dma_able(cosa->chan+cosa->txchan,
+		if (cosa_dma_able(cosa->chan + cosa->txchan,
 				  cosa->chan[cosa->txchan].txbuf,
 				  cosa->txsize)) {
 			cosa->txbuf = cosa->chan[cosa->txchan].txbuf;
@@ -1733,11 +1734,11 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 	if (is_8bit(cosa)) {
 		if (!test_bit(IRQBIT, &cosa->rxtx)) {
 			cosa_putstatus(cosa, SR_TX_INT_ENA);
-			cosa_putdata8(cosa, ((cosa->txchan << 5) & 0xe0)|
+			cosa_putdata8(cosa, ((cosa->txchan << 5) & 0xe0) |
 				((cosa->txsize >> 8) & 0x1f));
 #ifdef DEBUG_IO
 			debug_status_out(cosa, SR_TX_INT_ENA);
-			debug_data_out(cosa, ((cosa->txchan << 5) & 0xe0)|
+			debug_data_out(cosa, ((cosa->txchan << 5) & 0xe0) |
                                 ((cosa->txsize >> 8) & 0x1f));
 			debug_data_in(cosa, cosa_getdata8(cosa));
 #else
@@ -1749,19 +1750,19 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		} else {
 			clear_bit(IRQBIT, &cosa->rxtx);
 			cosa_putstatus(cosa, 0);
-			cosa_putdata8(cosa, cosa->txsize&0xff);
+			cosa_putdata8(cosa, cosa->txsize & 0xff);
 #ifdef DEBUG_IO
 			debug_status_out(cosa, 0);
-			debug_data_out(cosa, cosa->txsize&0xff);
+			debug_data_out(cosa, cosa->txsize & 0xff);
 #endif
 		}
 	} else {
 		cosa_putstatus(cosa, SR_TX_INT_ENA);
-		cosa_putdata16(cosa, ((cosa->txchan<<13) & 0xe000)
+		cosa_putdata16(cosa, ((cosa->txchan << 13) & 0xe000)
 			| (cosa->txsize & 0x1fff));
 #ifdef DEBUG_IO
 		debug_status_out(cosa, SR_TX_INT_ENA);
-		debug_data_out(cosa, ((cosa->txchan<<13) & 0xe000)
+		debug_data_out(cosa, ((cosa->txchan << 13) & 0xe000)
                         | (cosa->txsize & 0x1fff));
 		debug_data_in(cosa, cosa_getdata8(cosa));
 		debug_status_out(cosa, 0);
@@ -1773,10 +1774,10 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 
 	if (cosa->busmaster) {
 		unsigned long addr = virt_to_bus(cosa->txbuf);
-		int count=0;
+		int count = 0;
 
 		pr_info("busmaster IRQ\n");
-		while (!(cosa_getstatus(cosa)&SR_TX_RDY)) {
+		while (!(cosa_getstatus(cosa) & SR_TX_RDY)) {
 			count++;
 			udelay(10);
 			if (count > 1000)
@@ -1784,17 +1785,17 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		}
 		pr_info("status %x\n", cosa_getstatus(cosa));
 		pr_info("ready after %d loops\n", count);
-		cosa_putdata16(cosa, (addr >> 16)&0xffff);
+		cosa_putdata16(cosa, (addr >> 16) & 0xffff);
 
 		count = 0;
-		while (!(cosa_getstatus(cosa)&SR_TX_RDY)) {
+		while (!(cosa_getstatus(cosa) & SR_TX_RDY)) {
 			count++;
 			if (count > 1000)
 				break;
 			udelay(10);
 		}
 		pr_info("ready after %d loops\n", count);
-		cosa_putdata16(cosa, addr &0xffff);
+		cosa_putdata16(cosa, addr & 0xffff);
 		flags1 = claim_dma_lock();
 		set_dma_mode(cosa->dma, DMA_MODE_CASCADE);
 		enable_dma(cosa->dma);
@@ -1810,9 +1811,9 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 		enable_dma(cosa->dma);
 		release_dma_lock(flags1);
 	}
-	cosa_putstatus(cosa, SR_TX_DMA_ENA|SR_USR_INT_ENA);
+	cosa_putstatus(cosa, SR_TX_DMA_ENA | SR_USR_INT_ENA);
 #ifdef DEBUG_IO
-	debug_status_out(cosa, SR_TX_DMA_ENA|SR_USR_INT_ENA);
+	debug_status_out(cosa, SR_TX_DMA_ENA | SR_USR_INT_ENA);
 #endif
 	spin_unlock_irqrestore(&cosa->lock, flags);
 }
@@ -1831,7 +1832,7 @@ static inline void rx_interrupt(struct cosa_data *cosa, int status)
 		if (!test_bit(IRQBIT, &cosa->rxtx)) {
 			set_bit(IRQBIT, &cosa->rxtx);
 			put_driver_status_nolock(cosa);
-			cosa->rxsize = cosa_getdata8(cosa) <<8;
+			cosa->rxsize = cosa_getdata8(cosa) << 8;
 #ifdef DEBUG_IO
 			debug_data_in(cosa, cosa->rxsize >> 8);
 #endif
@@ -1889,15 +1890,15 @@ static inline void rx_interrupt(struct cosa_data *cosa, int status)
 	else
 		set_dma_addr(cosa->dma, virt_to_bus(cosa->bouncebuf));
 
-	set_dma_count(cosa->dma, (cosa->rxsize&0x1fff));
+	set_dma_count(cosa->dma, (cosa->rxsize & 0x1fff));
 	enable_dma(cosa->dma);
 	release_dma_lock(flags);
 	spin_lock_irqsave(&cosa->lock, flags);
-	cosa_putstatus(cosa, SR_RX_DMA_ENA|SR_USR_INT_ENA);
+	cosa_putstatus(cosa, SR_RX_DMA_ENA | SR_USR_INT_ENA);
 	if (!is_8bit(cosa) && (status & SR_TX_RDY))
 		cosa_putdata8(cosa, DRIVER_RX_READY);
 #ifdef DEBUG_IO
-	debug_status_out(cosa, SR_RX_DMA_ENA|SR_USR_INT_ENA);
+	debug_status_out(cosa, SR_RX_DMA_ENA | SR_USR_INT_ENA);
 	if (!is_8bit(cosa) && (status & SR_TX_RDY))
 		debug_data_cmd(cosa, DRIVER_RX_READY);
 #endif
@@ -1914,7 +1915,7 @@ static inline void eot_interrupt(struct cosa_data *cosa, int status)
 	clear_dma_ff(cosa->dma);
 	release_dma_lock(flags1);
 	if (test_bit(TXBIT, &cosa->rxtx)) {
-		struct channel_data *chan = cosa->chan+cosa->txchan;
+		struct channel_data *chan = cosa->chan + cosa->txchan;
 
 		if (chan->tx_done)
 			if (chan->tx_done(chan, cosa->txsize))
@@ -1926,7 +1927,7 @@ static inline void eot_interrupt(struct cosa_data *cosa, int status)
 
 		pr_info("cosa%dc%d: done rx(0x%x)",
 			cosa->num, cosa->rxchan->num, cosa->rxsize);
-		for (i=0; i<cosa->rxsize; i++)
+		for (i = 0; i < cosa->rxsize; i++)
 			pr_cont(" %02x", cosa->rxbuf[i]&0xff);
 		pr_cont("\n");
 	}
-- 
2.8.1

