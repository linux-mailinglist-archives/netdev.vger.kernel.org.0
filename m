Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F1857B26F
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbiGTILg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239588AbiGTILZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9C868DCC
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4ni-0008Sv-7T
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 65891B5897
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A6A5DB5880;
        Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e9d2c480;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 02/29] can: slcan: convert comments to network style comments
Date:   Wed, 20 Jul 2022 10:10:07 +0200
Message-Id: <20220720081034.3277385-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert all comments to network subsystem style comments.

Link: https://lore.kernel.org/all/20220704125954.1587880-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 55 +++++++++++++-----------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 92bdd49996d1..2d3bf15061a7 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -67,8 +67,9 @@ MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 #define SLCAN_MAGIC 0x53CA
 
 static int maxdev = 10;		/* MAX number of SLCAN channels;
-				   This can be overridden with
-				   insmod slcan.ko maxdev=nnn	*/
+				 * This can be overridden with
+				 * insmod slcan.ko maxdev=nnn
+				 */
 module_param(maxdev, int, 0);
 MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 
@@ -139,12 +140,11 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
 	return 0;
 }
 
- /************************************************************************
-  *			SLCAN ENCAPSULATION FORMAT			 *
-  ************************************************************************/
+/*************************************************************************
+ *			SLCAN ENCAPSULATION FORMAT			 *
+ *************************************************************************/
 
-/*
- * A CAN frame has a can_id (11 bit standard frame format OR 29 bit extended
+/* A CAN frame has a can_id (11 bit standard frame format OR 29 bit extended
  * frame format) a data length code (len) which can be from 0 to 8
  * and up to <len> data bytes as payload.
  * Additionally a CAN frame may become a remote transmission frame if the
@@ -174,9 +174,9 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
  *
  */
 
- /************************************************************************
-  *			STANDARD SLCAN DECAPSULATION			 *
-  ************************************************************************/
+/*************************************************************************
+ *			STANDARD SLCAN DECAPSULATION			 *
+ *************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
 static void slc_bump_frame(struct slcan *sl)
@@ -486,9 +486,9 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
 	}
 }
 
- /************************************************************************
-  *			STANDARD SLCAN ENCAPSULATION			 *
-  ************************************************************************/
+/*************************************************************************
+ *			STANDARD SLCAN ENCAPSULATION			 *
+ *************************************************************************/
 
 /* Encapsulate one can_frame and stuff into a TTY queue. */
 static void slc_encaps(struct slcan *sl, struct can_frame *cf)
@@ -575,7 +575,8 @@ static void slcan_transmit(struct work_struct *work)
 		}
 
 		/* Now serial buffer is almost free & we can start
-		 * transmission of another packet */
+		 * transmission of another packet
+		 */
 		sl->dev->stats.tx_packets++;
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 		spin_unlock_bh(&sl->lock);
@@ -589,8 +590,7 @@ static void slcan_transmit(struct work_struct *work)
 	spin_unlock_bh(&sl->lock);
 }
 
-/*
- * Called by the driver when there's room for more data.
+/* Called by the driver when there's room for more data.
  * Schedule the transmit.
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
@@ -632,7 +632,6 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-
 /******************************************
  *   Routines looking at netdevice side.
  ******************************************/
@@ -736,7 +735,6 @@ static int slc_open(struct net_device *dev)
 		/* The CAN framework has already validate the bitrate value,
 		 * so we can avoid to check if `s' has been properly set.
 		 */
-
 		snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
 		err = slcan_transmit_cmd(sl, cmd);
 		if (err) {
@@ -792,18 +790,16 @@ static const struct net_device_ops slc_netdev_ops = {
 };
 
 /******************************************
-  Routines looking at TTY side.
+ *  Routines looking at TTY side.
  ******************************************/
 
-/*
- * Handle the 'receiver data ready' interrupt.
+/* Handle the 'receiver data ready' interrupt.
  * This function is called by the 'tty_io' module in the kernel when
  * a block of SLCAN data has been received, which can now be decapsulated
  * and sent on to some IP layer for further processing. This will not
  * be re-entered while running but other ldisc functions may be called
  * in parallel
  */
-
 static void slcan_receive_buf(struct tty_struct *tty,
 			      const unsigned char *cp, const char *fp,
 			      int count)
@@ -890,8 +886,7 @@ static struct slcan *slc_alloc(void)
 	return sl;
 }
 
-/*
- * Open the high-level part of the SLCAN channel.
+/* Open the high-level part of the SLCAN channel.
  * This function is called by the TTY module when the
  * SLCAN line discipline is called for.  Because we are
  * sure the tty line exists, we only have to link it to
@@ -899,7 +894,6 @@ static struct slcan *slc_alloc(void)
  *
  * Called in process context serialized from other ldisc calls.
  */
-
 static int slcan_open(struct tty_struct *tty)
 {
 	struct slcan *sl;
@@ -912,8 +906,8 @@ static int slcan_open(struct tty_struct *tty)
 		return -EOPNOTSUPP;
 
 	/* RTnetlink lock is misused here to serialize concurrent
-	   opens of slcan channels. There are better ways, but it is
-	   the simplest one.
+	 * opens of slcan channels. There are better ways, but it is
+	 * the simplest one.
 	 */
 	rtnl_lock();
 
@@ -974,14 +968,12 @@ static int slcan_open(struct tty_struct *tty)
 	return err;
 }
 
-/*
- * Close down a SLCAN channel.
+/* Close down a SLCAN channel.
  * This means flushing out any pending queues, and then returning. This
  * call is serialized against other ldisc functions.
  *
  * We also use this method for a hangup event.
  */
-
 static void slcan_close(struct tty_struct *tty)
 {
 	struct slcan *sl = (struct slcan *) tty->disc_data;
@@ -1104,7 +1096,8 @@ static void __exit slcan_exit(void)
 	} while (busy && time_before(jiffies, timeout));
 
 	/* FIXME: hangup is async so we should wait when doing this second
-	   phase */
+	 * phase
+	 */
 
 	for (i = 0; i < maxdev; i++) {
 		dev = slcan_devs[i];
-- 
2.35.1


