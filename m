Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76DC3A93D1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhFPH3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:29:33 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7298 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhFPH3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 03:29:07 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4c7p5T33z1BN7V;
        Wed, 16 Jun 2021 15:21:58 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 15:26:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 11/15] net: cosa: fix the alignment issue
Date:   Wed, 16 Jun 2021 15:23:37 +0800
Message-ID: <1623828221-48349-12-git-send-email-huangguangbin2@huawei.com>
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

Alignment should match open parenthesis.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/cosa.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index ade6da7..fbfc3e5 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -274,14 +274,14 @@ static char *chrdev_setup_rx(struct channel_data *channel, int size);
 static int chrdev_rx_done(struct channel_data *channel);
 static int chrdev_tx_done(struct channel_data *channel, int size);
 static ssize_t cosa_read(struct file *file,
-	char __user *buf, size_t count, loff_t *ppos);
+			 char __user *buf, size_t count, loff_t *ppos);
 static ssize_t cosa_write(struct file *file,
-	const char __user *buf, size_t count, loff_t *ppos);
+			  const char __user *buf, size_t count, loff_t *ppos);
 static unsigned int cosa_poll(struct file *file, poll_table *poll);
 static int cosa_open(struct inode *inode, struct file *file);
 static int cosa_release(struct inode *inode, struct file *file);
 static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
-				unsigned long arg);
+			       unsigned long arg);
 #ifdef COSA_FASYNC_WORKING
 static int cosa_fasync(struct inode *inode, struct file *file, int on);
 #endif
@@ -655,7 +655,7 @@ static int cosa_net_open(struct net_device *dev)
 }
 
 static netdev_tx_t cosa_net_tx(struct sk_buff *skb,
-				     struct net_device *dev)
+			       struct net_device *dev)
 {
 	struct channel_data *chan = dev_to_chan(dev);
 
@@ -762,7 +762,7 @@ static int cosa_net_tx_done(struct channel_data *chan, int size)
 /*---------- Character device ---------- */
 
 static ssize_t cosa_read(struct file *file,
-	char __user *buf, size_t count, loff_t *ppos)
+			 char __user *buf, size_t count, loff_t *ppos)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	unsigned long flags;
@@ -836,7 +836,7 @@ static int chrdev_rx_done(struct channel_data *chan)
 }
 
 static ssize_t cosa_write(struct file *file,
-	const char __user *buf, size_t count, loff_t *ppos)
+			  const char __user *buf, size_t count, loff_t *ppos)
 {
 	DECLARE_WAITQUEUE(wait, current);
 	struct channel_data *chan = file->private_data;
@@ -1123,7 +1123,8 @@ static inline int cosa_gettype(struct cosa_data *cosa, char __user *string)
 }
 
 static int cosa_ioctl_common(struct cosa_data *cosa,
-	struct channel_data *channel, unsigned int cmd, unsigned long arg)
+			     struct channel_data *channel, unsigned int cmd,
+			     unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 
@@ -1181,7 +1182,7 @@ static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+			       unsigned long arg)
 {
 	struct channel_data *channel = file->private_data;
 	struct cosa_data *cosa;
@@ -1684,11 +1685,12 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 
 		cosa->txsize = cosa->chan[cosa->txchan].txsize;
 		if (cosa_dma_able(cosa->chan+cosa->txchan,
-			cosa->chan[cosa->txchan].txbuf, cosa->txsize)) {
+				  cosa->chan[cosa->txchan].txbuf,
+				  cosa->txsize)) {
 			cosa->txbuf = cosa->chan[cosa->txchan].txbuf;
 		} else {
 			memcpy(cosa->bouncebuf, cosa->chan[cosa->txchan].txbuf,
-				cosa->txsize);
+			       cosa->txsize);
 			cosa->txbuf = cosa->bouncebuf;
 		}
 	}
-- 
2.8.1

