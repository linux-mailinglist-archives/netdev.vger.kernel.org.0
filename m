Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544093A744D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFOCtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:49:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10060 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhFOCtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:49:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3t1b2PlQzZf0n;
        Tue, 15 Jun 2021 10:44:03 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 10:46:57 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 03/10] net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
Date:   Tue, 15 Jun 2021 10:43:38 +0800
Message-ID: <1623725025-50976-4-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl,
EXPORT_SYMBOL(foo); should immediately follow its function/variable.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 3036d58..94ed9a2 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -191,7 +191,6 @@ u8 z8530_dead_port[]=
 {
 	255
 };
-
 EXPORT_SYMBOL(z8530_dead_port);
 
 /*
@@ -221,7 +220,6 @@ u8 z8530_hdlc_kilostream[]=
 	9,	NV|MIE|NORESET,
 	255
 };
-
 EXPORT_SYMBOL(z8530_hdlc_kilostream);
 
 /*
@@ -248,7 +246,6 @@ u8 z8530_hdlc_kilostream_85230[]=
 	
 	255
 };
-
 EXPORT_SYMBOL(z8530_hdlc_kilostream_85230);
 
 /**
@@ -474,7 +471,6 @@ struct z8530_irqhandler z8530_sync = {
 	.tx = z8530_tx,
 	.status = z8530_status,
 };
-
 EXPORT_SYMBOL(z8530_sync);
 
 /**
@@ -667,7 +663,6 @@ struct z8530_irqhandler z8530_nop = {
 	.tx = z8530_tx_clear,
 	.status = z8530_status_clear,
 };
-
 EXPORT_SYMBOL(z8530_nop);
 
 /**
@@ -747,7 +742,6 @@ irqreturn_t z8530_interrupt(int irq, void *dev_id)
 	locker=0;
 	return IRQ_HANDLED;
 }
-
 EXPORT_SYMBOL(z8530_interrupt);
 
 static const u8 reg_init[16]=
@@ -792,7 +786,6 @@ int z8530_sync_open(struct net_device *dev, struct z8530_channel *c)
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_open);
 
 /**
@@ -821,7 +814,6 @@ int z8530_sync_close(struct net_device *dev, struct z8530_channel *c)
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_close);
 
 /**
@@ -945,7 +937,6 @@ int z8530_sync_dma_open(struct net_device *dev, struct z8530_channel *c)
 	
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_dma_open);
 
 /**
@@ -1015,7 +1006,6 @@ int z8530_sync_dma_close(struct net_device *dev, struct z8530_channel *c)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_dma_close);
 
 /**
@@ -1116,7 +1106,6 @@ int z8530_sync_txdma_open(struct net_device *dev, struct z8530_channel *c)
 	
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_txdma_open);
 
 /**
@@ -1176,7 +1165,6 @@ int z8530_sync_txdma_close(struct net_device *dev, struct z8530_channel *c)
 	spin_unlock_irqrestore(c->lock, cflags);
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_sync_txdma_close);
 
 /*
@@ -1210,7 +1198,6 @@ void z8530_describe(struct z8530_dev *dev, char *mapping, unsigned long io)
 		Z8530_PORT_OF(io),
 		dev->irq);
 }
-
 EXPORT_SYMBOL(z8530_describe);
 
 /*
@@ -1312,7 +1299,6 @@ int z8530_init(struct z8530_dev *dev)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(z8530_init);
 
 /**
@@ -1340,7 +1326,6 @@ int z8530_shutdown(struct z8530_dev *dev)
 	spin_unlock_irqrestore(&dev->lock, flags);
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_shutdown);
 
 /**
@@ -1385,7 +1370,6 @@ int z8530_channel_load(struct z8530_channel *c, u8 *rtable)
 	spin_unlock_irqrestore(c->lock, flags);
 	return 0;
 }
-
 EXPORT_SYMBOL(z8530_channel_load);
 
 /**
@@ -1526,7 +1510,6 @@ void z8530_null_rx(struct z8530_channel *c, struct sk_buff *skb)
 {
 	dev_kfree_skb_any(skb);
 }
-
 EXPORT_SYMBOL(z8530_null_rx);
 
 /**
@@ -1738,7 +1721,6 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 	
 	return NETDEV_TX_OK;
 }
-
 EXPORT_SYMBOL(z8530_queue_xmit);
 
 /*
-- 
2.8.1

