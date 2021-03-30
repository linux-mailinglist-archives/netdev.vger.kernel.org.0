Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE634E6BF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhC3LrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbhC3Lqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC37AC061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpZ-0006YL-Dh
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:45 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 54F77603ED8
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7A376603E3A;
        Tue, 30 Mar 2021 11:46:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a0cc611c;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 28/39] can: c_can: convert block comments to network style comments
Date:   Tue, 30 Mar 2021 13:45:48 +0200
Message-Id: <20210330114559.1114855-29-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts all block comments to network subsystem style
block comments.

Link: https://lore.kernel.org/r/20210304154240.2747987-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c     | 52 ++++++++++---------------------
 drivers/net/can/c_can/c_can_pci.c |  3 +-
 2 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 6958830cb983..6629951e4935 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -161,9 +161,7 @@
 
 #define IF_MCONT_TX		(IF_MCONT_TXIE | IF_MCONT_EOB)
 
-/*
- * Use IF1 for RX and IF2 for TX
- */
+/* Use IF1 for RX and IF2 for TX */
 #define IF_RX			0
 #define IF_TX			1
 
@@ -189,8 +187,7 @@ enum c_can_lec_type {
 	LEC_MASK = LEC_UNUSED,
 };
 
-/*
- * c_can error types:
+/* c_can error types:
  * Bus errors (BUS_OFF, ERROR_WARNING, ERROR_PASSIVE) are supported
  */
 enum c_can_bus_error_types {
@@ -268,8 +265,7 @@ static inline void c_can_object_put(struct net_device *dev, int iface,
 	c_can_obj_update(dev, iface, cmd | IF_COMM_WR, obj);
 }
 
-/*
- * Note: According to documentation clearing TXIE while MSGVAL is set
+/* Note: According to documentation clearing TXIE while MSGVAL is set
  * is not allowed, but works nicely on C/DCAN. And that lowers the I/O
  * load significantly.
  */
@@ -309,8 +305,7 @@ static void c_can_setup_tx_object(struct net_device *dev, int iface,
 	if (!rtr)
 		arb |= IF_ARB_TRANSMIT;
 
-	/*
-	 * If we change the DIR bit, we need to invalidate the buffer
+	/* If we change the DIR bit, we need to invalidate the buffer
 	 * first, i.e. clear the MSGVAL flag in the arbiter.
 	 */
 	if (rtr != (bool)test_bit(idx, &priv->tx_dir)) {
@@ -447,8 +442,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 
 	if (can_dropped_invalid_skb(dev, skb))
 		return NETDEV_TX_OK;
-	/*
-	 * This is not a FIFO. C/D_CAN sends out the buffers
+	/* This is not a FIFO. C/D_CAN sends out the buffers
 	 * prioritized. The lowest buffer number wins.
 	 */
 	idx = fls(atomic_read(&priv->tx_active));
@@ -457,8 +451,7 @@ static netdev_tx_t c_can_start_xmit(struct sk_buff *skb,
 	/* If this is the last buffer, stop the xmit queue */
 	if (idx == C_CAN_MSG_OBJ_TX_NUM - 1)
 		netif_stop_queue(dev);
-	/*
-	 * Store the message in the interface so we can call
+	/* Store the message in the interface so we can call
 	 * can_put_echo_skb(). We must do this before we enable
 	 * transmit as we might race against do_tx().
 	 */
@@ -527,8 +520,7 @@ static int c_can_set_bittiming(struct net_device *dev)
 	return c_can_wait_for_ctrl_init(dev, priv, 0);
 }
 
-/*
- * Configure C_CAN message objects for Tx and Rx purposes:
+/* Configure C_CAN message objects for Tx and Rx purposes:
  * C_CAN provides a total of 32 message objects that can be configured
  * either for Tx or Rx purposes. Here the first 16 message objects are used as
  * a reception FIFO. The end of reception FIFO is signified by the EoB bit
@@ -572,8 +564,7 @@ static int c_can_software_reset(struct net_device *dev)
 	return 0;
 }
 
-/*
- * Configure C_CAN chip:
+/* Configure C_CAN chip:
  * - enable/disable auto-retransmission
  * - set operating mode
  * - configure message objects
@@ -739,8 +730,7 @@ static void c_can_do_tx(struct net_device *dev)
 	}
 }
 
-/*
- * If we have a gap in the pending bits, that means we either
+/* If we have a gap in the pending bits, that means we either
  * raced with the hardware or failed to readout all upper
  * objects in the last run due to quota limit.
  */
@@ -751,8 +741,7 @@ static u32 c_can_adjust_pending(u32 pend)
 	if (pend == RECEIVE_OBJECT_BITS)
 		return pend;
 
-	/*
-	 * If the last set bit is larger than the number of pending
+	/* If the last set bit is larger than the number of pending
 	 * bits we have a gap.
 	 */
 	weight = hweight32(pend);
@@ -762,8 +751,7 @@ static u32 c_can_adjust_pending(u32 pend)
 	if (lasts == weight)
 		return pend;
 
-	/*
-	 * Find the first set bit after the gap. We walk backwards
+	/* Find the first set bit after the gap. We walk backwards
 	 * from the last set bit.
 	 */
 	for (lasts--; pend & (1 << (lasts - 1)); lasts--);
@@ -803,8 +791,7 @@ static int c_can_read_objects(struct net_device *dev, struct c_can_priv *priv,
 			continue;
 		}
 
-		/*
-		 * This really should not happen, but this covers some
+		/* This really should not happen, but this covers some
 		 * odd HW behaviour. Do not remove that unless you
 		 * want to brick your machine.
 		 */
@@ -830,8 +817,7 @@ static inline u32 c_can_get_pending(struct c_can_priv *priv)
 	return pend;
 }
 
-/*
- * theory of operation:
+/* theory of operation:
  *
  * c_can core saves a received CAN message into the first free message
  * object it finds free (starting with the lowest). Bits NEWDAT and
@@ -848,8 +834,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 	struct c_can_priv *priv = netdev_priv(dev);
 	u32 pkts = 0, pend = 0, toread, n;
 
-	/*
-	 * It is faster to read only one 16bit register. This is only possible
+	/* It is faster to read only one 16bit register. This is only possible
 	 * for a maximum number of 16 objects.
 	 */
 	BUILD_BUG_ON_MSG(C_CAN_MSG_OBJ_RX_LAST > 16,
@@ -860,8 +845,7 @@ static int c_can_do_rx_poll(struct net_device *dev, int quota)
 			pend = c_can_get_pending(priv);
 			if (!pend)
 				break;
-			/*
-			 * If the pending field has a gap, handle the
+			/* If the pending field has a gap, handle the
 			 * bits above the gap first.
 			 */
 			toread = c_can_adjust_pending(pend);
@@ -979,8 +963,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
-	/*
-	 * early exit if no lec update or no error.
+	/* early exit if no lec update or no error.
 	 * no lec update means that no CAN bus event has been detected
 	 * since CPU wrote 0x7 value to status reg.
 	 */
@@ -999,8 +982,7 @@ static int c_can_handle_bus_err(struct net_device *dev,
 	if (unlikely(!skb))
 		return 0;
 
-	/*
-	 * check for 'last error code' which tells us the
+	/* check for 'last error code' which tells us the
 	 * type of the last error to occur on the CAN bus
 	 */
 	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 7efb60b50876..9d7a4a335249 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -41,8 +41,7 @@ struct c_can_pci_data {
 	void (*init)(const struct c_can_priv *priv, bool enable);
 };
 
-/*
- * 16-bit c_can registers can be arranged differently in the memory
+/* 16-bit c_can registers can be arranged differently in the memory
  * architecture of different implementations. For example: 16-bit
  * registers can be aligned to a 16-bit boundary or 32-bit boundary etc.
  * Handle the same by providing a common read/write interface.
-- 
2.30.2


