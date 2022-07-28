Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1816158392C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiG1HDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiG1HDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:03:11 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C295F118
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:09 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j22so1597699ejs.2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zm8CDawEO00pmFYhToSSc819K70UuVm9tw0evLiuI+U=;
        b=OvopPApEGax0Ef1R0/igJZCwgnNkfgC310m6Bi3Cpk7X0gcvEYMoQFSt1jvVzF9rXk
         ojVLnhxbWI0To4nS23MrA22ul18HF3q7Z+YMTrA0RMCVz5ZexlozRU6VwNvxJBJy7rsg
         i/7sYyOgZ6FgG/GmeOr8HEtTw88WIoXmYN1Jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zm8CDawEO00pmFYhToSSc819K70UuVm9tw0evLiuI+U=;
        b=UIMONaxEE6cMTowVNwbc7DmQn6aBb9nfj1QYl+98vtUEhI95V73hPHyO+48yV+QMQr
         18n/UQdHjLXVQRX4Dn25rrEv2CISO2ktfbOoYmSk8d8VpbBSYf3wuxI++d3q/H3yFgvR
         kfUtytKKY0oJC3C3YrhukMupFY9sDlXs1WeKy0h0cn1W0UpWnKsTezRx9u9H+0s0oP6K
         LYLqg/2bIgXFmjJp+yjiFmU8SY07+8/LOCpeFjyb+vNL2t/YhPvftwtt9RLjPM8IzXdW
         LlRwTHOQRa0Y3taXSZFFdfQtfJvbvl3KoEwnWlNEwvw6wgCRfJ936HP9siZZmJjH2yxm
         vfVw==
X-Gm-Message-State: AJIora+VSCCilB0RrV6bst+HNG0D37/Vl4/a4xchaeDh1NNoJ+PnjWQK
        s/Msrdmon2uFjmc7RQd4Qwpyug==
X-Google-Smtp-Source: AGRyM1v1WQGVFA3qd7PQBZNzrwxIcxe/vLNn3315IMZ7qGr4FqaAgVZSbXZGHKHlV3DVrRau/m0CNQ==
X-Received: by 2002:a17:906:98c8:b0:72b:3a31:6cc3 with SMTP id zd8-20020a17090698c800b0072b3a316cc3mr20327677ejb.597.1658991788676;
        Thu, 28 Jul 2022 00:03:08 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id r18-20020aa7d152000000b0042de3d661d2sm154742edo.1.2022.07.28.00.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 00:03:08 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>, netdev@vger.kernel.org
Subject: [PATCH v4 4/7] can: slcan: change every `slc' occurrence in `slcan'
Date:   Thu, 28 Jul 2022 09:02:51 +0200
Message-Id: <20220728070254.267974-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
References: <20220728070254.267974-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the driver there are parts of code where the prefix `slc' is used and
others where the prefix `slcan' is used instead. The patch replaces
every occurrence of `slc' with `slcan', except for the netdev functions
where, to avoid compilation conflicts, it was necessary to replace `slc'
with `slcan_netdev'.

The patch does not make any functional changes.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---

(no changes since v1)

 drivers/net/can/slcan/slcan-core.c | 109 +++++++++++++++--------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 0d309d0636df..bd8e84ded051 100644
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
 
@@ -316,7 +317,7 @@ static void slc_bump_state(struct slcan *sl)
  * e1a : len 1, errors: ACK error
  * e3bcO: len 3, errors: Bit0 error, CRC error, Tx overrun error
  */
-static void slc_bump_err(struct slcan *sl)
+static void slcan_bump_err(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
 	struct sk_buff *skb;
@@ -332,7 +333,7 @@ static void slc_bump_err(struct slcan *sl)
 	else
 		return;
 
-	if ((len + SLC_CMD_LEN + 1) > sl->rcount)
+	if ((len + SLCAN_CMD_LEN + 1) > sl->rcount)
 		return;
 
 	skb = alloc_can_err_skb(dev, &cf);
@@ -340,7 +341,7 @@ static void slc_bump_err(struct slcan *sl)
 	if (skb)
 		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
-	cmd += SLC_CMD_LEN + 1;
+	cmd += SLCAN_CMD_LEN + 1;
 	for (i = 0; i < len; i++, cmd++) {
 		switch (*cmd) {
 		case 'a':
@@ -429,7 +430,7 @@ static void slc_bump_err(struct slcan *sl)
 		netif_rx(skb);
 }
 
-static void slc_bump(struct slcan *sl)
+static void slcan_bump(struct slcan *sl)
 {
 	switch (sl->rbuff[0]) {
 	case 'r':
@@ -439,11 +440,11 @@ static void slc_bump(struct slcan *sl)
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
@@ -455,12 +456,12 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
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
@@ -476,7 +477,7 @@ static void slcan_unesc(struct slcan *sl, unsigned char s)
  *************************************************************************/
 
 /* Encapsulate one can_frame and stuff into a TTY queue. */
-static void slc_encaps(struct slcan *sl, struct can_frame *cf)
+static void slcan_encaps(struct slcan *sl, struct can_frame *cf)
 {
 	int actual, i;
 	unsigned char *pos;
@@ -493,11 +494,11 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
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
@@ -507,7 +508,8 @@ static void slc_encaps(struct slcan *sl, struct can_frame *cf)
 		id >>= 4;
 	}
 
-	pos += (cf->can_id & CAN_EFF_FLAG) ? SLC_EFF_ID_LEN : SLC_SFF_ID_LEN;
+	pos += (cf->can_id & CAN_EFF_FLAG) ?
+		SLCAN_EFF_ID_LEN : SLCAN_SFF_ID_LEN;
 
 	*pos++ = cf->len + '0';
 
@@ -585,7 +587,8 @@ static void slcan_write_wakeup(struct tty_struct *tty)
 }
 
 /* Send a can_frame to a TTY queue. */
-static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t slcan_netdev_xmit(struct sk_buff *skb,
+				     struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 
@@ -604,7 +607,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netif_stop_queue(sl->dev);
-	slc_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
+	slcan_encaps(sl, (struct can_frame *)skb->data); /* encaps & send */
 	spin_unlock(&sl->lock);
 
 out:
@@ -647,7 +650,7 @@ static int slcan_transmit_cmd(struct slcan *sl, const unsigned char *cmd)
 }
 
 /* Netdevice UP -> DOWN routine */
-static int slc_close(struct net_device *dev)
+static int slcan_netdev_close(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
 	int err;
@@ -676,10 +679,10 @@ static int slc_close(struct net_device *dev)
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
@@ -739,16 +742,16 @@ static int slc_open(struct net_device *dev)
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
@@ -821,7 +824,7 @@ static int slcan_open(struct tty_struct *tty)
 
 	/* Configure netdev interface */
 	sl->dev	= dev;
-	dev->netdev_ops = &slc_netdev_ops;
+	dev->netdev_ops = &slcan_netdev_ops;
 	slcan_set_ethtool_ops(dev);
 
 	/* Mark ldisc channel as alive */
@@ -889,7 +892,7 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static struct tty_ldisc_ops slc_ldisc = {
+static struct tty_ldisc_ops slcan_ldisc = {
 	.owner		= THIS_MODULE,
 	.num		= N_SLCAN,
 	.name		= KBUILD_MODNAME,
@@ -907,7 +910,7 @@ static int __init slcan_init(void)
 	pr_info("serial line CAN interface driver\n");
 
 	/* Fill in our line protocol discipline, and register it */
-	status = tty_register_ldisc(&slc_ldisc);
+	status = tty_register_ldisc(&slcan_ldisc);
 	if (status)
 		pr_err("can't register line discipline\n");
 
@@ -919,7 +922,7 @@ static void __exit slcan_exit(void)
 	/* This will only be called when all channels have been closed by
 	 * userspace - tty_ldisc.c takes care of the module's refcount.
 	 */
-	tty_unregister_ldisc(&slc_ldisc);
+	tty_unregister_ldisc(&slcan_ldisc);
 }
 
 module_init(slcan_init);
-- 
2.32.0

