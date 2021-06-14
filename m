Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368063A6540
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhFNLgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:36:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9113 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbhFNLeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:34:09 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3Tjy1CknzZdXS;
        Mon, 14 Jun 2021 19:29:10 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 14 Jun 2021 19:32:03 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 07/11] net: z85230: fix the code style issue about "if..else.."
Date:   Mon, 14 Jun 2021 19:28:47 +0800
Message-ID: <1623670131-49973-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
References: <1623670131-49973-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

According to the chackpatch.pl, else should follow close brace '}',
braces {} should be used on all arms of this statement.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/z85230.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index a3a2051..556de05 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -354,9 +354,7 @@ static void z8530_rx(struct z8530_channel *c)
 					/* printk("crc error\n"); */
 				}
 				/* Shove the frame upstream */
-			}
-			else
-			{
+			} else {
 				/*	Drop the lock for RX processing, or
 		 		 *	there are deadlocks
 		 		 */
@@ -489,9 +487,7 @@ static void z8530_dma_rx(struct z8530_channel *chan)
 		}		
 		write_zsctrl(chan, ERR_RES);
 		write_zsctrl(chan, RES_H_IUS);
-	}
-	else
-	{
+	} else {
 		/* DMA is off right now, drain the slow way */
 		z8530_rx(chan);
 	}	
@@ -1379,9 +1375,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			release_dma_lock(flags);
 		}
 		c->txcount=0;
-	}
-	else
-	{
+	} else {
 		c->txcount=c->tx_skb->len;
 
 		if(c->dma_tx)
@@ -1412,9 +1406,7 @@ static void z8530_tx_begin(struct z8530_channel *c)
 			release_dma_lock(flags);
 			write_zsctrl(c, RES_EOM_L);
 			write_zsreg(c, R5, c->regs[R5]|TxENAB);
-		}
-		else
-		{
+		} else {
 			/* ABUNDER off */
 			write_zsreg(c, R10, c->regs[10]);
 			write_zsctrl(c, RES_Tx_CRC);
@@ -1530,12 +1522,12 @@ static void z8530_rx_done(struct z8530_channel *c)
 			 * from passing
 			 */
 			write_zsreg(c, R0, RES_Rx_CRC);
-		}
-		else
+		} else {
 			/* Can't occur as we dont reenable the DMA irq until
 			 * after the flip is done
 			 */
 			netdev_warn(c->netdevice, "DMA flip overrun!\n");
+		}
 
 		release_dma_lock(flags);
 
@@ -1661,9 +1653,9 @@ netdev_tx_t z8530_queue_xmit(struct z8530_channel *c, struct sk_buff *skb)
 		c->tx_next_ptr=c->tx_dma_buf[c->tx_dma_used];
 		c->tx_dma_used^=1;	/* Flip temp buffer */
 		skb_copy_from_linear_data(skb, c->tx_next_ptr, skb->len);
+	} else {
+		c->tx_next_ptr = skb->data;
 	}
-	else
-		c->tx_next_ptr=skb->data;	
 	RT_LOCK;
 	c->tx_next_skb=skb;
 	RT_UNLOCK;
-- 
2.8.1

