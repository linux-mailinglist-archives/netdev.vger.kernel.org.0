Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA43A93D0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhFPH3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4941 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbhFPH3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:02 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4c9s5jyPz70R8;
        Wed, 16 Jun 2021 15:23:45 +0800 (CST)
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
Subject: [PATCH net-next 14/15] net: cosa: remove trailing whitespaces
Date:   Wed, 16 Jun 2021 15:23:40 +0800
Message-ID: <1623828221-48349-15-git-send-email-huangguangbin2@huawei.com>
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

This patch removes trailing whitespaces.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 26cdfda..79941b3 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -444,7 +444,7 @@ static int cosa_probe(int base, int irq, int dma)
 		pr_info("invalid DMA %d\n", dma);
 		return -1;
 	}
-	/* and finally, on 16-bit COSA DMA should be 4-7 and 
+	/* and finally, on 16-bit COSA DMA should be 4-7 and
 	 * I/O base should not be multiple of 0x10
 	 */
 	if (((base & 0x8) && dma < 4) || (!(base & 0x8) && dma > 3)) {
@@ -460,7 +460,7 @@ static int cosa_probe(int base, int irq, int dma)
 
 	if (!request_region(base, is_8bit(cosa) ? 2 : 4, "cosa"))
 		return -1;
-	
+
 	if (cosa_reset_and_read_id(cosa, cosa->id_string) < 0) {
 		printk(KERN_DEBUG "probe at 0x%x failed.\n", base);
 		err = -1;
@@ -480,7 +480,7 @@ static int cosa_probe(int base, int irq, int dma)
 		err = -1;
 		goto err_out;
 	}
-	/* Update the name of the region now we know the type of card */ 
+	/* Update the name of the region now we know the type of card */
 	release_region(base, is_8bit(cosa) ? 2 : 4);
 	if (!request_region(base, is_8bit(cosa) ? 2 : 4, cosa->type)) {
 		printk(KERN_DEBUG "changing name at 0x%x failed.\n", base);
@@ -532,7 +532,7 @@ static int cosa_probe(int base, int irq, int dma)
 		err = -1;
 		goto err_out1;
 	}
-	
+
 	cosa->bouncebuf = kmalloc(COSA_MTU, GFP_KERNEL | GFP_DMA);
 	if (!cosa->bouncebuf) {
 		err = -ENOMEM;
@@ -777,7 +777,7 @@ static ssize_t cosa_read(struct file *file,
 	}
 	if (mutex_lock_interruptible(&chan->rlock))
 		return -ERESTARTSYS;
-	
+
 	chan->rxdata = kmalloc(COSA_MTU, GFP_DMA | GFP_KERNEL);
 	if (!chan->rxdata) {
 		mutex_unlock(&chan->rlock);
@@ -854,7 +854,7 @@ static ssize_t cosa_write(struct file *file,
 
 	if (count > COSA_MTU)
 		count = COSA_MTU;
-	
+
 	/* Allocate the buffer */
 	kbuf = kmalloc(count, GFP_KERNEL | GFP_DMA);
 	if (!kbuf) {
@@ -934,7 +934,7 @@ static int cosa_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 	chan = cosa->chan + n;
-	
+
 	file->private_data = chan;
 
 	spin_lock_irqsave(&cosa->lock, flags);
@@ -1018,7 +1018,7 @@ static inline int cosa_download(struct cosa_data *cosa, void __user *arg)
 			  cosa->name, cosa->firmware_status);
 		return -EPERM;
 	}
-	
+
 	if (copy_from_user(&d, arg, sizeof(d)))
 		return -EFAULT;
 
@@ -1101,7 +1101,7 @@ static inline int cosa_start(struct cosa_data *cosa, int address)
 	cosa->firmware_status |= COSA_FW_START;
 	return 0;
 }
-		
+
 /* Buffer of size at least COSA_MAX_ID_STRING is expected */
 static inline int cosa_getidstr(struct cosa_data *cosa, char __user *string)
 {
@@ -1140,7 +1140,7 @@ static int cosa_ioctl_common(struct cosa_data *cosa,
 	case COSAIODOWNLD:	/* Download the firmware */
 		if (!capable(CAP_SYS_RAWIO))
 			return -EACCES;
-		
+
 		return cosa_download(cosa, argp);
 	case COSAIORMEM:
 		if (!capable(CAP_SYS_RAWIO))
@@ -1443,7 +1443,7 @@ static int startmicrocode(struct cosa_data *cosa, int address)
 		return -4;
 	if (put_wait_data(cosa, '\r') == -1)
 		return -5;
-	
+
 	if (get_wait_data(cosa) != '\r')
 		return -6;
 	if (get_wait_data(cosa) != '\r')
@@ -1618,7 +1618,7 @@ static int put_wait_data(struct cosa_data *cosa, int data)
 		cosa->num, cosa_getstatus(cosa));
 	return -1;
 }
-	
+
 /* The following routine puts the hexadecimal number into the SRP monitor
  * and verifies the proper echo of the sent bytes. Returns 0 on success,
  * negative number on failure (-1,-3,-5,-7) means that put_wait_data() failed,
@@ -1656,7 +1656,7 @@ static int puthexnumber(struct cosa_data *cosa, int number)
  * COSA status byte. I have moved the rx/tx/eot interrupt handling into
  * separate functions to make it more readable. These functions are inline,
  * so there should be no overhead of function call.
- * 
+ *
  * In the COSA bus-master mode, we need to tell the card the address of a
  * buffer. Unfortunately, COSA may be too slow for us, so we must busy-wait.
  * It's time to use the bottom half :-(
-- 
2.8.1

