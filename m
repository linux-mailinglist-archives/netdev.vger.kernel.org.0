Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE91F4D4A55
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbiCJOc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbiCJObe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:31:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600DBC1CA2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:29:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nSJmy-0005v5-Ia
        for netdev@vger.kernel.org; Thu, 10 Mar 2022 15:29:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A080547DA9
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:29:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3132A47D9C;
        Thu, 10 Mar 2022 14:29:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 782a4bd8;
        Thu, 10 Mar 2022 14:29:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/29] can: gs_usb: use consistent one space indention
Date:   Thu, 10 Mar 2022 15:28:43 +0100
Message-Id: <20220310142903.341658-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310142903.341658-1-mkl@pengutronix.de>
References: <20220310142903.341658-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch a consistent one space indention throughout the whole
driver is used.

Link: https://lore.kernel.org/all/20220309124132.291861-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 38 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index d35749fad1ef..a63650b17931 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -21,14 +21,14 @@
 #include <linux/can/error.h>
 
 /* Device specific constants */
-#define USB_GSUSB_1_VENDOR_ID      0x1d50
-#define USB_GSUSB_1_PRODUCT_ID     0x606f
+#define USB_GSUSB_1_VENDOR_ID 0x1d50
+#define USB_GSUSB_1_PRODUCT_ID 0x606f
 
-#define USB_CANDLELIGHT_VENDOR_ID  0x1209
+#define USB_CANDLELIGHT_VENDOR_ID 0x1209
 #define USB_CANDLELIGHT_PRODUCT_ID 0x2323
 
-#define GSUSB_ENDPOINT_IN          1
-#define GSUSB_ENDPOINT_OUT         2
+#define GSUSB_ENDPOINT_IN 1
+#define GSUSB_ENDPOINT_OUT 2
 
 /* Device specific constants */
 enum gs_usb_breq {
@@ -87,11 +87,11 @@ struct gs_device_config {
 	__le32 hw_version;
 } __packed;
 
-#define GS_CAN_MODE_NORMAL               0
-#define GS_CAN_MODE_LISTEN_ONLY          BIT(0)
-#define GS_CAN_MODE_LOOP_BACK            BIT(1)
-#define GS_CAN_MODE_TRIPLE_SAMPLE        BIT(2)
-#define GS_CAN_MODE_ONE_SHOT             BIT(3)
+#define GS_CAN_MODE_NORMAL 0
+#define GS_CAN_MODE_LISTEN_ONLY BIT(0)
+#define GS_CAN_MODE_LOOP_BACK BIT(1)
+#define GS_CAN_MODE_TRIPLE_SAMPLE BIT(2)
+#define GS_CAN_MODE_ONE_SHOT BIT(3)
 
 struct gs_device_mode {
 	__le32 mode;
@@ -116,12 +116,12 @@ struct gs_identify_mode {
 	__le32 mode;
 } __packed;
 
-#define GS_CAN_FEATURE_LISTEN_ONLY      BIT(0)
-#define GS_CAN_FEATURE_LOOP_BACK        BIT(1)
-#define GS_CAN_FEATURE_TRIPLE_SAMPLE    BIT(2)
-#define GS_CAN_FEATURE_ONE_SHOT         BIT(3)
-#define GS_CAN_FEATURE_HW_TIMESTAMP     BIT(4)
-#define GS_CAN_FEATURE_IDENTIFY         BIT(5)
+#define GS_CAN_FEATURE_LISTEN_ONLY BIT(0)
+#define GS_CAN_FEATURE_LOOP_BACK BIT(1)
+#define GS_CAN_FEATURE_TRIPLE_SAMPLE BIT(2)
+#define GS_CAN_FEATURE_ONE_SHOT BIT(3)
+#define GS_CAN_FEATURE_HW_TIMESTAMP BIT(4)
+#define GS_CAN_FEATURE_IDENTIFY BIT(5)
 
 struct gs_device_bt_const {
 	__le32 feature;
@@ -1043,10 +1043,10 @@ static const struct usb_device_id gs_usb_table[] = {
 MODULE_DEVICE_TABLE(usb, gs_usb_table);
 
 static struct usb_driver gs_usb_driver = {
-	.name       = "gs_usb",
-	.probe      = gs_usb_probe,
+	.name = "gs_usb",
+	.probe = gs_usb_probe,
 	.disconnect = gs_usb_disconnect,
-	.id_table   = gs_usb_table,
+	.id_table = gs_usb_table,
 };
 
 module_usb_driver(gs_usb_driver);
-- 
2.35.1


