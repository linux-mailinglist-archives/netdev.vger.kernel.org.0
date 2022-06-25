Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE55F55A9B8
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiFYMGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiFYMGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1E614092
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YS-0002ei-Qc
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BC4FA9F291
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E7C389F24B;
        Sat, 25 Jun 2022 12:05:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 40fe1258;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/22] can/esd_usb: Fixed some checkpatch.pl warnings
Date:   Sat, 25 Jun 2022 14:03:34 +0200
Message-Id: <20220625120335.324697-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Jungclaus <frank.jungclaus@esd.eu>

Link: https://lore.kernel.org/all/20220624190517.2299701-5-frank.jungclaus@esd.eu
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index befd570018d7..e23dce3db55a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -163,7 +163,7 @@ struct set_baudrate_msg {
 };
 
 /* Main message type used between library and application */
-struct __attribute__ ((packed)) esd_usb_msg {
+struct __packed esd_usb_msg {
 	union {
 		struct header_msg hdr;
 		struct version_msg version;
@@ -343,8 +343,6 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 
 		netif_rx(skb);
 	}
-
-	return;
 }
 
 static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
@@ -447,13 +445,9 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 		dev_err(dev->udev->dev.parent,
 			"failed resubmitting read bulk urb: %d\n", retval);
 	}
-
-	return;
 }
 
-/*
- * callback for bulk IN urb
- */
+/* callback for bulk IN urb */
 static void esd_usb_write_bulk_callback(struct urb *urb)
 {
 	struct esd_tx_urb_context *context = urb->context;
@@ -611,9 +605,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	return 0;
 }
 
-/*
- * Start interface
- */
+/* Start interface */
 static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
 	struct esd_usb *dev = priv->usb;
@@ -627,8 +619,7 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 		goto out;
 	}
 
-	/*
-	 * Enable all IDs
+	/* Enable all IDs
 	 * The IDADD message takes up to 64 32 bit bitmasks (2048 bits).
 	 * Each bit represents one 11 bit CAN identifier. A set bit
 	 * enables reception of the corresponding CAN identifier. A cleared
@@ -776,9 +767,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		}
 	}
 
-	/*
-	 * This may never happen.
-	 */
+	/* This may never happen */
 	if (!context) {
 		netdev_warn(netdev, "couldn't find free context\n");
 		ret = NETDEV_TX_BUSY;
@@ -826,8 +815,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 
 	netif_trans_update(netdev);
 
-	/*
-	 * Release our reference to this URB, the USB core will eventually free
+	/* Release our reference to this URB, the USB core will eventually free
 	 * it entirely.
 	 */
 	usb_free_urb(urb);
@@ -1043,8 +1031,7 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	return err;
 }
 
-/*
- * probe function for new USB devices
+/* probe function for new USB devices
  *
  * check version information and number of available
  * CAN interfaces
@@ -1120,9 +1107,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 	return err;
 }
 
-/*
- * called by the usb core when the device is removed from the system
- */
+/* called by the usb core when the device is removed from the system */
 static void esd_usb_disconnect(struct usb_interface *intf)
 {
 	struct esd_usb *dev = usb_get_intfdata(intf);
-- 
2.35.1


