Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DD15860D7
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiGaTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238057AbiGaTUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621B1DFB6
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUW-0007M2-Em
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:44 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A9E51BEC93
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CA5CEBEC71;
        Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f3c9c569;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/36] can: slcan: change every `slc' occurrence in `slcan'
Date:   Sun, 31 Jul 2022 21:20:10 +0200
Message-Id: <20220731192029.746751-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

In the driver there are parts of code where the prefix `slc' is used and
others where the prefix `slcan' is used instead. The patch replaces
every occurrence of `slc' with `slcan', except for the netdev functions
where, to avoid compilation conflicts, it was necessary to replace `slc'
with `slcan_netdev'.

The patch does not make any functional changes.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Link: https://lore.kernel.org/all/20220728070254.267974-5-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 109 +++++++++++++++--------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 133a9e045760..3a4701d8e081 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -65,16 +65,17 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 
 /* maximum rx buffer len: extended CAN frame with timestamp */
-#define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
-
-#define SLC_CMD_LEN 1
-#define SLC_SFF_ID_LEN 3
-#define SLC_EFF_ID_LEN 8
-#define SLC_STATE_LEN 1
-#define SLC_STATE_BE_RXCNT_LEN 3
-#define SLC_STATE_BE_TXCNT_LEN 3
-#define SLC_STATE_FRAME_LEN       (1 + SLC_CMD_LEN + SLC_STATE_BE_RXCNT_LEN + \
-				   SLC_STATE_BE_TXCNT_LEN)
+#define SLCAN_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
+
+#define SLCAN_CMD_LEN 1
+#define SLCAN_SFF_ID_LEN 3
+#define SLCAN_EFF_ID_LEN 8
+#define SLCAN_STATE_LEN 1
+#define SLCAN_STATE_BE_RXCNT_LEN 3
+#define SLCAN_STATE_BE_TXCNT_LEN 3
+#define SLCAN_STATE_FRAME_LEN       (1 + SLCAN_CMD_LEN + \
+				     SLCAN_STATE_BE_RXCNT_LEN + \
+				     SLCAN_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
 
@@ -85,9 +86,9 @@ struct slcan {
 	struct work_struct	tx_work;	/* Flushes transmit buffer   */
 
 	/* These are pointers to the malloc()ed frame buffers. */
-	unsigned char		rbuff[SLC_MTU];	/* receiver buffer	     */
+	unsigned char		rbuff[SLCAN_MTU];	/* receiver buffer   */
 	int			rcount;         /* received chars counter    */
-	unsigned char		xbuff[SLC_MTU];	/* transmitter buffer	     */
+	unsigned char		xbuff[SLCAN_MTU];	/* transmitter buffer*/
 	unsigned char		*xhead;         /* pointer to next XMIT byte */
 	int			xleft;          /* bytes left in XMIT queue  */
 
@@ -166,7 +167,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
  *************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump_frame(struct slcan *sl)
+static void slcan_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -186,10 +187,10 @@ static void slc_bump_frame(struct slcan *sl)
 		fallthrough;
 	case 't':
 		/* store dlc ASCII value and terminate SFF CAN ID string */
-		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN];
-		sl->rbuff[SLC_CMD_LEN + SLC_SFF_ID_LEN] = 0;
+		cf->len = sl->rbuff[SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN];
+		sl->rbuff[SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
-		cmd += SLC_CMD_LEN + SLC_SFF_ID_LEN + 1;
+		cmd += SLCAN_CMD_LEN + SLCAN_SFF_ID_LEN + 1;
 		break;
 	case 'R':
 		cf->can_id = CAN_RTR_FLAG;
@@ -197,16 +198,16 @@ static void slc_bump_frame(struct slcan *sl)
 	case 'T':
 		cf->can_id |= CAN_EFF_FLAG;
 		/* store dlc ASCII value and terminate EFF CAN ID string */
-		cf->len = sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN];
-		sl->rbuff[SLC_CMD_LEN + SLC_EFF_ID_LEN] = 0;
+		cf->len = sl->rbuff[SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN];
+		sl->rbuff[SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN] = 0;
 		/* point to payload data behind the dlc */
-		cmd += SLC_CMD_LEN + SLC_EFF_ID_LEN + 1;
+		cmd += SLCAN_CMD_LEN + SLCAN_EFF_ID_LEN + 1;
 		break;
 	default:
 		goto decode_failed;
 	}
 
-	if (kstrtou32(sl->rbuff + SLC_CMD_LEN, 16, &tmpid))
+	if (kstrtou32(sl->rbuff + SLCAN_CMD_LEN, 16, &tmpid))
 		goto decode_failed;
 
 	cf->can_id |= tmpid;
@@ -253,7 +254,7 @@ static void slc_bump_frame(struct slcan *sl)
  * sb256256 : state bus-off: rx counter 256, tx counter 256
  * sa057033 : state active, rx counter 57, tx counter 33
  */
-static void slc_bump_state(struct slcan *sl)
+static void slcan_bump_state(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
 	struct sk_buff *skb;
@@ -279,16 +280,16 @@ static void slc_bump_state(struct slcan *sl)
 		return;
 	}
 
-	if (state == sl->can.state || sl->rcount < SLC_STATE_FRAME_LEN)
+	if (state == sl->can.state || sl->rcount < SLCAN_STATE_FRAME_LEN)
 		return;
 
-	cmd += SLC_STATE_BE_RXCNT_LEN + SLC_CMD_LEN + 1;
-	cmd[SLC_STATE_BE_TXCNT_LEN] = 0;
+	cmd += SLCAN_STATE_BE_RXCNT_LEN + SLCAN_CMD_LEN + 1;
+	cmd[SLCAN_STATE_BE_TXCNT_LEN] = 0;
 	if (kstrtou32(cmd, 10, &txerr))
 		return;
 
 	*cmd = 0;
-	cmd -= SLC_STATE_BE_RXCNT_LEN;
+	cmd -= SLCAN_STATE_BE_RXCNT_LEN;
 	if (kstrtou32(cmd, 10, &rxerr))
 		return;
 
@@ -317,7 +318,7 @@ static void slc_bump_state(struct slcan *sl)
  * e1a : len 1, errors: ACK error
  * e3bcO: len 3, errors: Bit0 error, CRC error, Tx overrun error
  */
-static void slc_bump_err(struct slcan *sl)
+static void slcan_bump_err(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
 	struct sk_buff *skb;
@@ -333,7 +334,7 @@ static void slc_bump_err(struct slcan *sl)
 	else
 		return;
 
-	if ((len + SLC_CMD_LEN + 1) > sl->rcount)
+	if ((len + SLCAN_CMD_LEN + 1) > sl->rcount)
 		return;
 
 	skb = alloc_can_err_skb(dev, &cf);
@@ -341,7 +342,7 @@ static void slc_bump_err(struct slcan *sl)
 	if (skb)
 		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-	cmd += SLC_CMD_LEN + 1;
+	cmd += SLCAN_CMD_LEN + 1;
 	for (i = 0; i < len; i++, cmd++) {
 		switch (*cmd) {
 		case 'a':
@@ -430,7 +431,7 @@ static void slc_bump_err(struct slcan *sl)
 		netif_rx(skb);
 }
 
-static void slc_bump(struct slcan *sl)
+static void slcan_bump(struct slcan *sl)
 {
 	switch (sl->rbuff[0]) {
 	case 'r':
@@ -440,11 +441,11 @@ static void slc_bump(struct slcan *sl)
 	case 'R':
 		fallthrough;
 	case 'T':
-		return slc_bump_frame(sl);
+		return slcan_bump_frame(sl);
 	case 'e':
-		return slc_bump_err(sl);
+		return slcan_bump_err(sl);
 	case 's':
-		return slc_bump_state(sl);
+		return slcan_bump_state(sl);
 	default:
 		return;
 	}
@@ -456,12 +457,12 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
 	if ((s == '\r') || (s == '\a')) { /* CR or BEL ends the pdu */
 		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
 		    sl->rcount > 4)
-			slc_bump(sl);
+			slcan_bump(sl);
 
 		sl->rcount = 0;
 	} else {
 		if (!test_bit(SLF_ERROR, &sl->flags))  {
-			if (sl->rcount < SLC_MTU)  {
+			if (sl->rcount < SLCAN_MTU)  {
 				sl->rbuff[sl->rcount++] = s;
 				return;
 			}
@@ -477,7 +478,7 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
  *************************************************************************/
 
 /* Encapsulate one can_frame and stuff into a TTY queue. */
-static void slc_encaps(struct slcan *sl, struct can_frame *cf)
+static void slcan_encaps(struct slcan *sl, struct can_frame *cf)
 {
 	int actual, i;
 	unsigned char *pos;
@@ -494,11 +495,11 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 	/* determine number of chars for the CAN-identifier */
 	if (cf->can_id & CAN_EFF_FLAG) {
 		id &= CAN_EFF_MASK;
-		endpos = pos + SLC_EFF_ID_LEN;
+		endpos = pos + SLCAN_EFF_ID_LEN;
 	} else {
 		*pos |= 0x20; /* convert R/T to lower case for SFF */
 		id &= CAN_SFF_MASK;
-		endpos = pos + SLC_SFF_ID_LEN;
+		endpos = pos + SLCAN_SFF_ID_LEN;
 	}
 
 	/* build 3 (SFF) or 8 (EFF) digit CAN identifier */
@@ -508,7 +509,8 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 		id >>= 4;
 	}
 
-	pos += (cf->can_id & CAN_EFF_FLAG) ? SLC_EFF_ID_LEN : SLC_SFF_ID_LEN;
+	pos += (cf->can_id & CAN_EFF_FLAG) ?
+		SLCAN_EFF_ID_LEN : SLCAN_SFF_ID_LEN;
 
 	*pos++ = cf->len + '0';
 
@@ -586,7 +588,8 @@ static void slcan_write_wakeup(struct tty_struct *tty)
 }
 
 /* Send a can_frame to a TTY queue. */
-static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t slcan_netdev_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 
@@ -605,7 +608,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netif_stop_queue(sl->dev);
-	slc_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
+	slcan_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
 	spin_unlock(&sl->lock);
 
 out:
@@ -648,7 +651,7 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 }
 
 /* Netdevice UP -> DOWN routine */
-static int slc_close(struct net_device *dev)
+static int slcan_netdev_close(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 	int err;
@@ -677,10 +680,10 @@ static int slc_close(struct net_device *dev)
 }
 
 /* Netdevice DOWN -> UP routine */
-static int slc_open(struct net_device *dev)
+static int slcan_netdev_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	unsigned char cmd[SLC_MTU];
+	unsigned char cmd[SLCAN_MTU];
 	int err, s;
 
 	/* The baud rate is not set with the command
@@ -740,16 +743,16 @@ static int slc_open(struct net_device *dev)
 	return err;
 }
 
-static int slcan_change_mtu(struct net_device *dev, int new_mtu)
+static int slcan_netdev_change_mtu(struct net_device *dev, int new_mtu)
 {
 	return -EINVAL;
 }
 
-static const struct net_device_ops slc_netdev_ops = {
-	.ndo_open               = slc_open,
-	.ndo_stop               = slc_close,
-	.ndo_start_xmit         = slc_xmit,
-	.ndo_change_mtu         = slcan_change_mtu,
+static const struct net_device_ops slcan_netdev_ops = {
+	.ndo_open               = slcan_netdev_open,
+	.ndo_stop               = slcan_netdev_close,
+	.ndo_start_xmit         = slcan_netdev_xmit,
+	.ndo_change_mtu         = slcan_netdev_change_mtu,
 };
 
 /******************************************
@@ -822,7 +825,7 @@ static int slcan_open(struct tty_struct *tty)
 
 	/* Configure netdev interface */
 	sl->dev	= dev;
-	dev->netdev_ops = &slc_netdev_ops;
+	dev->netdev_ops = &slcan_netdev_ops;
 	dev->ethtool_ops = &slcan_ethtool_ops;
 
 	/* Mark ldisc channel as alive */
@@ -890,7 +893,7 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static struct tty_ldisc_ops slc_ldisc = {
+static struct tty_ldisc_ops slcan_ldisc = {
 	.owner		= THIS_MODULE,
 	.num		= N_SLCAN,
 	.name		= KBUILD_MODNAME,
@@ -908,7 +911,7 @@ static int __init slcan_init(void)
 	pr_info("serial line CAN interface driver\n");
 
 	/* Fill in our line protocol discipline, and register it */
-	status = tty_register_ldisc(&slc_ldisc);
+	status = tty_register_ldisc(&slcan_ldisc);
 	if (status)
 		pr_err("can't register line discipline\n");
 
@@ -920,7 +923,7 @@ static void __exit slcan_exit(void)
 	/* This will only be called when all channels have been closed by
 	 * userspace - tty_ldisc.c takes care of the module's refcount.
 	 */
-	tty_unregister_ldisc(&slc_ldisc);
+	tty_unregister_ldisc(&slcan_ldisc);
 }
 
 module_init(slcan_init);
-- 
2.35.1


