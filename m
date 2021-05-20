Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8F389C12
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 05:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhETDwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 23:52:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3437 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhETDwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 23:52:20 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Flwgb1C3nzCv5j;
        Thu, 20 May 2021 11:48:11 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 20 May 2021 11:50:58 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH net-next 5/9] net: hamradio: remove leading spaces before tabs
Date:   Thu, 20 May 2021 11:47:50 +0800
Message-ID: <1621482474-26903-6-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
References: <1621482474-26903-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/hamradio/baycom_epp.c |  4 ++--
 drivers/net/hamradio/hdlcdrv.c    |  2 +-
 drivers/net/hamradio/mkiss.c      |  6 +++---
 drivers/net/hamradio/scc.c        | 20 ++++++++++----------
 drivers/net/hamradio/yam.c        |  2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index e4e4981..4435a11 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -231,7 +231,7 @@ struct baycom_state {
 #if 0
 static inline void append_crc_ccitt(unsigned char *buffer, int len)
 {
- 	unsigned int crc = 0xffff;
+	unsigned int crc = 0xffff;
 
 	for (;len>0;len--)
 		crc = (crc >> 8) ^ crc_ccitt_table[(crc ^ *buffer++) & 0xff];
@@ -390,7 +390,7 @@ static void encode_hdlc(struct baycom_state *bc)
 		for (j = 0; j < 8; j++)
 			if (unlikely(!(notbitstream & (0x1f0 << j)))) {
 				bitstream &= ~(0x100 << j);
- 				bitbuf = (bitbuf & (((2 << j) << numbit) - 1)) |
+				bitbuf = (bitbuf & (((2 << j) << numbit) - 1)) |
 					((bitbuf & ~(((2 << j) << numbit) - 1)) << 1);
 				numbit++;
 				notbitstream = ~bitstream;
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 9e00581..cbaf1cd 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -74,7 +74,7 @@
 
 static inline void append_crc_ccitt(unsigned char *buffer, int len)
 {
- 	unsigned int crc = crc_ccitt(0xffff, buffer, len) ^ 0xffff;
+	unsigned int crc = crc_ccitt(0xffff, buffer, len) ^ 0xffff;
 	buffer += len;
 	*buffer++ = crc;
 	*buffer++ = crc >> 8;
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 6515422..9933c87 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -276,7 +276,7 @@ static void ax_bump(struct mkiss *ax)
 			 */
 			*ax->rbuff &= ~0x20;
 		}
- 	}
+	}
 
 	count = ax->rcount;
 
@@ -501,7 +501,7 @@ static void ax_encaps(struct net_device *dev, unsigned char *icp, int len)
 		default:
 			count = kiss_esc(p, ax->xbuff, len);
 		}
-  	}
+	}
 	spin_unlock_bh(&ax->buflock);
 
 	set_bit(TTY_DO_WRITE_WAKEUP, &ax->tty->flags);
@@ -815,7 +815,7 @@ static int mkiss_ioctl(struct tty_struct *tty, struct file *file,
 	dev = ax->dev;
 
 	switch (cmd) {
- 	case SIOCGIFNAME:
+	case SIOCGIFNAME:
 		err = copy_to_user((void __user *) arg, ax->dev->name,
 		                   strlen(ax->dev->name) + 1) ? -EFAULT : 0;
 		break;
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 4690c6a..3f1edd0 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1192,18 +1192,18 @@ static void t_tail(struct timer_list *t)
 	unsigned long flags;
 	
 	spin_lock_irqsave(&scc->lock, flags); 
- 	del_timer(&scc->tx_wdog);	
- 	scc_key_trx(scc, TX_OFF);
+	del_timer(&scc->tx_wdog);
+	scc_key_trx(scc, TX_OFF);
 	spin_unlock_irqrestore(&scc->lock, flags);
 
- 	if (scc->stat.tx_state == TXS_TIMEOUT)		/* we had a timeout? */
- 	{
- 		scc->stat.tx_state = TXS_WAIT;
+	if (scc->stat.tx_state == TXS_TIMEOUT)		/* we had a timeout? */
+	{
+		scc->stat.tx_state = TXS_WAIT;
 		scc_start_tx_timer(scc, t_dwait, scc->kiss.mintime*100);
- 		return;
- 	}
- 	
- 	scc->stat.tx_state = TXS_IDLE;
+		return;
+	}
+
+	scc->stat.tx_state = TXS_IDLE;
 	netif_wake_queue(scc->dev);
 }
 
@@ -1580,7 +1580,7 @@ static int scc_net_open(struct net_device *dev)
 {
 	struct scc_channel *scc = (struct scc_channel *) dev->ml_priv;
 
- 	if (!scc->init)
+	if (!scc->init)
 		return -EINVAL;
 
 	scc->tx_buff = NULL;
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5ab53e9..d491104 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -668,7 +668,7 @@ static void yam_tx_byte(struct net_device *dev, struct yam_port *yp)
 			}
 			yp->tx_len = skb->len - 1;	/* strip KISS byte */
 			if (yp->tx_len >= YAM_MAX_FRAME || yp->tx_len < 2) {
-        			dev_kfree_skb_any(skb);
+				dev_kfree_skb_any(skb);
 				break;
 			}
 			skb_copy_from_linear_data_offset(skb, 1,
-- 
2.8.1

