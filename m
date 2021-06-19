Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870C93AD93D
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 11:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhFSKCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 06:02:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5051 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhFSKB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 06:01:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6WNb6bYlzXh8G;
        Sat, 19 Jun 2021 17:54:39 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:45 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 19 Jun 2021 17:59:44 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 8/8] net: at91_can: fix the comments style issue
Date:   Sat, 19 Jun 2021 17:56:29 +0800
Message-ID: <1624096589-13452-9-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
References: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
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

Networking block comments don't use an empty /* line,
use /* Comment...

Block comments use * on subsequent lines.
Block comments use a trailing */ on a separate line.

This patch fixes the comments style issues.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/can/at91_can.c | 42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 0e6ed59a763d..566891312eda 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -317,8 +317,7 @@ static void at91_setup_mailboxes(struct net_device *dev)
 	unsigned int i;
 	u32 reg_mid;
 
-	/*
-	 * Due to a chip bug (errata 50.2.6.3 & 50.3.5.3) the first
+	/* Due to a chip bug (errata 50.2.6.3 & 50.3.5.3) the first
 	 * mailbox is disabled. The next 11 mailboxes are used as a
 	 * reception FIFO. The last mailbox is configured with
 	 * overwrite option. The overwrite flag indicates a FIFO
@@ -424,8 +423,7 @@ static void at91_chip_stop(struct net_device *dev, enum can_state state)
 	priv->can.state = state;
 }
 
-/*
- * theory of operation:
+/* theory of operation:
  *
  * According to the datasheet priority 0 is the highest priority, 15
  * is the lowest. If two mailboxes have the same priority level the
@@ -487,8 +485,7 @@ static netdev_tx_t at91_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* _NOTE_: subtract AT91_MB_TX_FIRST offset from mb! */
 	can_put_echo_skb(skb, dev, mb - get_mb_tx_first(priv), 0);
 
-	/*
-	 * we have to stop the queue and deliver all messages in case
+	/* we have to stop the queue and deliver all messages in case
 	 * of a prio+mb counter wrap around. This is the case if
 	 * tx_next buffer prio and mailbox equals 0.
 	 *
@@ -799,8 +796,7 @@ static int at91_poll(struct napi_struct *napi, int quota)
 	if (reg_sr & get_irq_mb_rx(priv))
 		work_done += at91_poll_rx(dev, quota - work_done);
 
-	/*
-	 * The error bits are clear on read,
+	/* The error bits are clear on read,
 	 * so use saved value from irq handler.
 	 */
 	reg_sr |= priv->reg_sr;
@@ -820,8 +816,7 @@ static int at91_poll(struct napi_struct *napi, int quota)
 	return work_done;
 }
 
-/*
- * theory of operation:
+/* theory of operation:
  *
  * priv->tx_echo holds the number of the oldest can_frame put for
  * transmission into the hardware, but not yet ACKed by the CAN tx
@@ -850,8 +845,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 		/* Disable irq for this TX mailbox */
 		at91_write(priv, AT91_IDR, 1 << mb);
 
-		/*
-		 * only echo if mailbox signals us a transfer
+		/* only echo if mailbox signals us a transfer
 		 * complete (MSR_MRDY). Otherwise it's a tansfer
 		 * abort. "can_bus_off()" takes care about the skbs
 		 * parked in the echo queue.
@@ -866,8 +860,7 @@ static void at91_irq_tx(struct net_device *dev, u32 reg_sr)
 		}
 	}
 
-	/*
-	 * restart queue if we don't have a wrap around but restart if
+	/* restart queue if we don't have a wrap around but restart if
 	 * we get a TX int for the last can frame directly before a
 	 * wrap around.
 	 */
@@ -887,8 +880,7 @@ static void at91_irq_err_state(struct net_device *dev,
 
 	switch (priv->can.state) {
 	case CAN_STATE_ERROR_ACTIVE:
-		/*
-		 * from: ERROR_ACTIVE
+		/* from: ERROR_ACTIVE
 		 * to  : ERROR_WARNING, ERROR_PASSIVE, BUS_OFF
 		 * =>  : there was a warning int
 		 */
@@ -904,8 +896,7 @@ static void at91_irq_err_state(struct net_device *dev,
 		}
 		fallthrough;
 	case CAN_STATE_ERROR_WARNING:
-		/*
-		 * from: ERROR_ACTIVE, ERROR_WARNING
+		/* from: ERROR_ACTIVE, ERROR_WARNING
 		 * to  : ERROR_PASSIVE, BUS_OFF
 		 * =>  : error passive int
 		 */
@@ -921,8 +912,7 @@ static void at91_irq_err_state(struct net_device *dev,
 		}
 		break;
 	case CAN_STATE_BUS_OFF:
-		/*
-		 * from: BUS_OFF
+		/* from: BUS_OFF
 		 * to  : ERROR_ACTIVE, ERROR_WARNING, ERROR_PASSIVE
 		 */
 		if (new_state <= CAN_STATE_ERROR_PASSIVE) {
@@ -942,8 +932,7 @@ static void at91_irq_err_state(struct net_device *dev,
 	/* process state changes depending on the new state */
 	switch (new_state) {
 	case CAN_STATE_ERROR_ACTIVE:
-		/*
-		 * actually we want to enable AT91_IRQ_WARN here, but
+		/* actually we want to enable AT91_IRQ_WARN here, but
 		 * it screws up the system under certain
 		 * circumstances. so just enable AT91_IRQ_ERRP, thus
 		 * the "fallthrough"
@@ -1055,8 +1044,7 @@ static void at91_irq_err(struct net_device *dev)
 	priv->can.state = new_state;
 }
 
-/*
- * interrupt handler
+/* interrupt handler
  */
 static irqreturn_t at91_irq(int irq, void *dev_id)
 {
@@ -1077,8 +1065,7 @@ static irqreturn_t at91_irq(int irq, void *dev_id)
 
 	/* Receive or error interrupt? -> napi */
 	if (reg_sr & (get_irq_mb_rx(priv) | AT91_IRQ_ERR_FRAME)) {
-		/*
-		 * The error bits are clear on read,
+		/* The error bits are clear on read,
 		 * save for later use.
 		 */
 		priv->reg_sr = reg_sr;
@@ -1135,8 +1122,7 @@ static int at91_open(struct net_device *dev)
 	return err;
 }
 
-/*
- * stop CAN bus activity
+/* stop CAN bus activity
  */
 static int at91_close(struct net_device *dev)
 {
-- 
2.8.1

