Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07914613A7D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJaPoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiJaPoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:44:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A653C11A3A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:44:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWxP-0002no-L0
        for netdev@vger.kernel.org; Mon, 31 Oct 2022 16:44:11 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1956A10F443
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 15:44:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3662310F40C;
        Mon, 31 Oct 2022 15:44:08 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b9e960c2;
        Mon, 31 Oct 2022 15:44:07 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/14] can: peak_usb: rename device_id to a more explicit name
Date:   Mon, 31 Oct 2022 16:43:53 +0100
Message-Id: <20221031154406.259857-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031154406.259857-1-mkl@pengutronix.de>
References: <20221031154406.259857-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

The so-called "device id" is in fact a value defined by the user.
Therefore, in order not to confuse it with the device id used by the USB,
the functions and variables for reading this user-defined value are
renamed.

Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20221030105939.87658-2-lukas.magel@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      | 8 ++++----
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 6 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_core.h | 4 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   | 2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  | 8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index 687dd542f7f6..11fd033b57f3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -381,9 +381,9 @@ static int pcan_usb_get_serial(struct peak_usb_device *dev, u32 *serial_number)
 }
 
 /*
- * read device id from device
+ * read user device id from device
  */
-static int pcan_usb_get_device_id(struct peak_usb_device *dev, u32 *device_id)
+static int pcan_usb_get_user_devid(struct peak_usb_device *dev, u32 *user_devid)
 {
 	u8 args[PCAN_USB_CMD_ARGS_LEN];
 	int err;
@@ -393,7 +393,7 @@ static int pcan_usb_get_device_id(struct peak_usb_device *dev, u32 *device_id)
 		netdev_err(dev->netdev, "getting device id failure: %d\n", err);
 
 	else
-		*device_id = args[0];
+		*user_devid = args[0];
 
 	return err;
 }
@@ -1017,7 +1017,7 @@ const struct peak_usb_adapter pcan_usb = {
 	.dev_init = pcan_usb_init,
 	.dev_set_bus = pcan_usb_write_mode,
 	.dev_set_bittiming = pcan_usb_set_bittiming,
-	.dev_get_device_id = pcan_usb_get_device_id,
+	.dev_get_user_devid = pcan_usb_get_user_devid,
 	.dev_decode_buf = pcan_usb_decode_buf,
 	.dev_encode_msg = pcan_usb_encode_msg,
 	.dev_start = pcan_usb_start,
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 225697d70a9a..8e1b3c19f92f 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -922,11 +922,11 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 	}
 
 	/* get device number early */
-	if (dev->adapter->dev_get_device_id)
-		dev->adapter->dev_get_device_id(dev, &dev->device_number);
+	if (dev->adapter->dev_get_user_devid)
+		dev->adapter->dev_get_user_devid(dev, &dev->user_devid);
 
 	netdev_info(netdev, "attached to %s channel %u (device %u)\n",
-			peak_usb_adapter->name, ctrl_idx, dev->device_number);
+			peak_usb_adapter->name, ctrl_idx, dev->user_devid);
 
 	return 0;
 
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.h b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
index f6bdd8b3f290..6ff32673a256 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.h
@@ -60,7 +60,7 @@ struct peak_usb_adapter {
 	int (*dev_set_data_bittiming)(struct peak_usb_device *dev,
 				      struct can_bittiming *bt);
 	int (*dev_set_bus)(struct peak_usb_device *dev, u8 onoff);
-	int (*dev_get_device_id)(struct peak_usb_device *dev, u32 *device_id);
+	int (*dev_get_user_devid)(struct peak_usb_device *dev, u32 *user_devid);
 	int (*dev_decode_buf)(struct peak_usb_device *dev, struct urb *urb);
 	int (*dev_encode_msg)(struct peak_usb_device *dev, struct sk_buff *skb,
 					u8 *obuf, size_t *size);
@@ -122,7 +122,7 @@ struct peak_usb_device {
 	u8 *cmd_buf;
 	struct usb_anchor rx_submitted;
 
-	u32 device_number;
+	u32 user_devid;
 	u8 device_rev;
 
 	u8 ep_msg_in;
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 2ea1500df393..b8053e697261 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -972,7 +972,7 @@ static int pcan_usb_fd_init(struct peak_usb_device *dev)
 	}
 
 	pdev->usb_if->dev[dev->ctrl_idx] = dev;
-	dev->device_number =
+	dev->user_devid =
 		le32_to_cpu(pdev->usb_if->fw_info.dev_id[dev->ctrl_idx]);
 
 	/* if vendor rsp is of type 2, then it contains EP numbers to
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 5d8f6a40bb2c..15410d60cdf7 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -419,8 +419,8 @@ static int pcan_usb_pro_set_led(struct peak_usb_device *dev, u8 mode,
 	return pcan_usb_pro_send_cmd(dev, &um);
 }
 
-static int pcan_usb_pro_get_device_id(struct peak_usb_device *dev,
-				      u32 *device_id)
+static int pcan_usb_pro_get_user_devid(struct peak_usb_device *dev,
+				       u32 *user_devid)
 {
 	struct pcan_usb_pro_devid *pdn;
 	struct pcan_usb_pro_msg um;
@@ -439,7 +439,7 @@ static int pcan_usb_pro_get_device_id(struct peak_usb_device *dev,
 		return err;
 
 	pdn = (struct pcan_usb_pro_devid *)pc;
-	*device_id = le32_to_cpu(pdn->dev_num);
+	*user_devid = le32_to_cpu(pdn->dev_num);
 
 	return err;
 }
@@ -1076,7 +1076,7 @@ const struct peak_usb_adapter pcan_usb_pro = {
 	.dev_free = pcan_usb_pro_free,
 	.dev_set_bus = pcan_usb_pro_set_bus,
 	.dev_set_bittiming = pcan_usb_pro_set_bittiming,
-	.dev_get_device_id = pcan_usb_pro_get_device_id,
+	.dev_get_user_devid = pcan_usb_pro_get_user_devid,
 	.dev_decode_buf = pcan_usb_pro_decode_buf,
 	.dev_encode_msg = pcan_usb_pro_encode_msg,
 	.dev_start = pcan_usb_pro_start,

base-commit: 02a97e02c64fb3245b84835cbbed1c3a3222e2f1
-- 
2.35.1


