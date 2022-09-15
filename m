Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A215B9622
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiIOIVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiIOIUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:20:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF9A97B26
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6l-0004MN-Ox
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:27 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7E68FE399A
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CCA8BE3938;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 24e02e19;
        Thu, 15 Sep 2022 08:20:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/23] can: gs_usb: use common spelling of GS_USB in macros
Date:   Thu, 15 Sep 2022 10:19:59 +0200
Message-Id: <20220915082013.369072-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
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

There are a few macros in the driver which use GSUSB in the name of
the macro, while the majority uses GS_USB. Convert all macros to
GS_USB.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Fixes: b00ca070e022 ("can: gs_usb: activate quirks for CANtact Pro unconditionally")
Link: https://lore.kernel.org/all/20220827221548.3291393-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index baf749c8cda3..532510902f60 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -22,8 +22,8 @@
 #include <linux/can/error.h>
 
 /* Device specific constants */
-#define USB_GSUSB_1_VENDOR_ID 0x1d50
-#define USB_GSUSB_1_PRODUCT_ID 0x606f
+#define USB_GS_USB_1_VENDOR_ID 0x1d50
+#define USB_GS_USB_1_PRODUCT_ID 0x606f
 
 #define USB_CANDLELIGHT_VENDOR_ID 0x1209
 #define USB_CANDLELIGHT_PRODUCT_ID 0x2323
@@ -34,8 +34,8 @@
 #define USB_ABE_CANDEBUGGER_FD_VENDOR_ID 0x16d0
 #define USB_ABE_CANDEBUGGER_FD_PRODUCT_ID 0x10b8
 
-#define GSUSB_ENDPOINT_IN 1
-#define GSUSB_ENDPOINT_OUT 2
+#define GS_USB_ENDPOINT_IN 1
+#define GS_USB_ENDPOINT_OUT 2
 
 /* Device specific constants */
 enum gs_usb_breq {
@@ -491,7 +491,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 
  resubmit_urb:
 	usb_fill_bulk_urb(urb, usbcan->udev,
-			  usb_rcvbulkpipe(usbcan->udev, GSUSB_ENDPOINT_IN),
+			  usb_rcvbulkpipe(usbcan->udev, GS_USB_ENDPOINT_IN),
 			  hf, dev->parent->hf_size_rx,
 			  gs_usb_receive_bulk_callback, usbcan);
 
@@ -659,7 +659,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	}
 
 	usb_fill_bulk_urb(urb, dev->udev,
-			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
+			  usb_sndbulkpipe(dev->udev, GS_USB_ENDPOINT_OUT),
 			  hf, dev->hf_size_tx,
 			  gs_usb_xmit_callback, txc);
 
@@ -769,7 +769,7 @@ static int gs_can_open(struct net_device *netdev)
 			usb_fill_bulk_urb(urb,
 					  dev->udev,
 					  usb_rcvbulkpipe(dev->udev,
-							  GSUSB_ENDPOINT_IN),
+							  GS_USB_ENDPOINT_IN),
 					  buf,
 					  dev->parent->hf_size_rx,
 					  gs_usb_receive_bulk_callback, parent);
@@ -1063,8 +1063,8 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 	 * GS_CAN_FEATURE_QUIRK_BREQ_CANTACT_PRO to workaround this
 	 * issue.
 	 */
-	if (dev->udev->descriptor.idVendor == cpu_to_le16(USB_GSUSB_1_VENDOR_ID) &&
-	    dev->udev->descriptor.idProduct == cpu_to_le16(USB_GSUSB_1_PRODUCT_ID) &&
+	if (dev->udev->descriptor.idVendor == cpu_to_le16(USB_GS_USB_1_VENDOR_ID) &&
+	    dev->udev->descriptor.idProduct == cpu_to_le16(USB_GS_USB_1_PRODUCT_ID) &&
 	    dev->udev->manufacturer && dev->udev->product &&
 	    !strcmp(dev->udev->manufacturer, "LinkLayer Labs") &&
 	    !strcmp(dev->udev->product, "CANtact Pro") &&
@@ -1258,8 +1258,8 @@ static void gs_usb_disconnect(struct usb_interface *intf)
 }
 
 static const struct usb_device_id gs_usb_table[] = {
-	{ USB_DEVICE_INTERFACE_NUMBER(USB_GSUSB_1_VENDOR_ID,
-				      USB_GSUSB_1_PRODUCT_ID, 0) },
+	{ USB_DEVICE_INTERFACE_NUMBER(USB_GS_USB_1_VENDOR_ID,
+				      USB_GS_USB_1_PRODUCT_ID, 0) },
 	{ USB_DEVICE_INTERFACE_NUMBER(USB_CANDLELIGHT_VENDOR_ID,
 				      USB_CANDLELIGHT_PRODUCT_ID, 0) },
 	{ USB_DEVICE_INTERFACE_NUMBER(USB_CES_CANEXT_FD_VENDOR_ID,
-- 
2.35.1


