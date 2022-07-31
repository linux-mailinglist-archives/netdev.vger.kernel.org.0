Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B0E5860E5
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiGaTU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbiGaTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E60E08A
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUQ-0007Cx-GD
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 17035BEC41
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7B423BEC33;
        Sun, 31 Jul 2022 19:20:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73ed314b;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/36] can: etas_es58x: replace ES58X_MODULE_NAME with KBUILD_MODNAME
Date:   Sun, 31 Jul 2022 21:20:02 +0200
Message-Id: <20220731192029.746751-10-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

ES58X_MODULE_NAME is set to "etas_es58x". KBUILD_MODNAME also
evaluates to "etas_es58x". Get rid of ES58X_MODULE_NAME and rely on
KBUILD_MODNAME instead.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220726082707.58758-10-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 7353745f92d7..ade0a650e0ed 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -25,7 +25,6 @@ MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL v2");
 
-#define ES58X_MODULE_NAME "etas_es58x"
 #define ES58X_VENDOR_ID 0x108C
 #define ES581_4_PRODUCT_ID 0x0159
 #define ES582_1_PRODUCT_ID 0x0168
@@ -59,11 +58,11 @@ MODULE_DEVICE_TABLE(usb, es58x_id_table);
 
 #define es58x_print_hex_dump(buf, len)					\
 	print_hex_dump(KERN_DEBUG,					\
-		       ES58X_MODULE_NAME " " __stringify(buf) ": ",	\
+		       KBUILD_MODNAME " " __stringify(buf) ": ",	\
 		       DUMP_PREFIX_NONE, 16, 1, buf, len, false)
 
 #define es58x_print_hex_dump_debug(buf, len)				 \
-	print_hex_dump_debug(ES58X_MODULE_NAME " " __stringify(buf) ": ",\
+	print_hex_dump_debug(KBUILD_MODNAME " " __stringify(buf) ": ",\
 			     DUMP_PREFIX_NONE, 16, 1, buf, len, false)
 
 /* The last two bytes of an ES58X command is a CRC16. The first two
@@ -2280,7 +2279,7 @@ static void es58x_disconnect(struct usb_interface *intf)
 }
 
 static struct usb_driver es58x_driver = {
-	.name = ES58X_MODULE_NAME,
+	.name = KBUILD_MODNAME,
 	.probe = es58x_probe,
 	.disconnect = es58x_disconnect,
 	.id_table = es58x_id_table
-- 
2.35.1


