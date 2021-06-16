Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E463A93C1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhFPH3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10091 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhFPH3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:00 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4cB56TQJzZfQX;
        Wed, 16 Jun 2021 15:23:57 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 01/15] net: cosa: remove redundant blank lines
Date:   Wed, 16 Jun 2021 15:23:27 +0800
Message-ID: <1623828221-48349-2-git-send-email-huangguangbin2@huawei.com>
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

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 2369ca2..297ea34 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -608,7 +608,6 @@ static int cosa_probe(int base, int irq, int dma)
 	return err;
 }
 
-
 /*---------- network device ---------- */
 
 static int cosa_net_attach(struct net_device *dev, unsigned short encoding,
@@ -840,7 +839,6 @@ static int chrdev_rx_done(struct channel_data *chan)
 	return 1;
 }
 
-
 static ssize_t cosa_write(struct file *file,
 	const char __user *buf, size_t count, loff_t *ppos)
 {
@@ -988,7 +986,6 @@ static int cosa_fasync(struct inode *inode, struct file *file, int on)
 }
 #endif
 
-
 /* ---------- Ioctls ---------- */
 
 /*
@@ -1034,7 +1031,6 @@ static inline int cosa_download(struct cosa_data *cosa, void __user *arg)
 	if (d.len < 0 || d.len > COSA_MAX_FIRMWARE_SIZE)
 		return -EINVAL;
 
-
 	/* If something fails, force the user to reset the card */
 	cosa->firmware_status &= ~(COSA_FW_RESET|COSA_FW_DOWNLOAD);
 
@@ -1197,7 +1193,6 @@ static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-
 /*---------- HW layer interface ---------- */
 
 /*
@@ -1372,7 +1367,6 @@ static int cosa_dma_able(struct channel_data *chan, char *buf, int len)
 	return 1;
 }
 
-
 /* ---------- The SRP/COSA ROM monitor functions ---------- */
 
 /*
@@ -1422,7 +1416,6 @@ static int download(struct cosa_data *cosa, const char __user *microcode, int le
 	return 0;
 }
 
-
 /*
  * Starting microcode is done via the "g" command of the SRP monitor.
  * The chat should be the following: "g" "g=" "<addr><CR>"
@@ -1537,7 +1530,6 @@ static int cosa_reset_and_read_id(struct cosa_data *cosa, char *idstring)
 	return id;
 }
 
-
 /* ---------- Auxiliary routines for COSA/SRP monitor ---------- */
 
 /*
@@ -1623,7 +1615,6 @@ static int puthexnumber(struct cosa_data *cosa, int number)
 	return 0;
 }
 
-
 /* ---------- Interrupt routines ---------- */
 
 /*
@@ -1968,7 +1959,6 @@ static irqreturn_t cosa_interrupt(int irq, void *cosa_)
 	return IRQ_HANDLED;
 }
 
-
 /* ---------- I/O debugging routines ---------- */
 /*
  * These routines can be used to monitor COSA/SRP I/O and to printk()
-- 
2.8.1

