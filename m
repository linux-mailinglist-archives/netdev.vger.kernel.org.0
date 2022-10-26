Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10360DD51
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiJZIl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbiJZIkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F2C3FEE8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxV-0006nF-Df
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0241E10A0F6
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5DC6310A0C4;
        Wed, 26 Oct 2022 08:40:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 07d68ac5;
        Wed, 26 Oct 2022 08:40:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/29] can: gs_usb: document GS_CAN_FEATURE_GET_STATE
Date:   Wed, 26 Oct 2022 10:39:53 +0200
Message-Id: <20221026084007.1583333-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026084007.1583333-1-mkl@pengutronix.de>
References: <20221026084007.1583333-1-mkl@pengutronix.de>
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

From: Jeroen Hofstee <jhofstee@victronenergy.com>

Document the new feature ("GS_CAN_FEATURE_GET_STATE") that indicates
that the state of the CAN controller can be queried with the new
GS_USB_BREQ_GET_STATE control message.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Link: https://lore.kernel.org/all/20221019221016.1659260-7-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index e2e23467caf2..3f00e8d79b75 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -66,6 +66,7 @@ enum gs_usb_breq {
 	GS_USB_BREQ_BT_CONST_EXT,
 	GS_USB_BREQ_SET_TERMINATION,
 	GS_USB_BREQ_GET_TERMINATION,
+	GS_USB_BREQ_GET_STATE,
 };
 
 enum gs_can_mode {
@@ -135,6 +136,7 @@ struct gs_device_config {
 /* GS_CAN_FEATURE_BT_CONST_EXT BIT(10) */
 /* GS_CAN_FEATURE_TERMINATION BIT(11) */
 #define GS_CAN_MODE_BERR_REPORTING BIT(12)
+/* GS_CAN_FEATURE_GET_STATE BIT(13) */
 
 struct gs_device_mode {
 	__le32 mode;
@@ -176,7 +178,8 @@ struct gs_device_termination_state {
 #define GS_CAN_FEATURE_BT_CONST_EXT BIT(10)
 #define GS_CAN_FEATURE_TERMINATION BIT(11)
 #define GS_CAN_FEATURE_BERR_REPORTING BIT(12)
-#define GS_CAN_FEATURE_MASK GENMASK(12, 0)
+#define GS_CAN_FEATURE_GET_STATE BIT(13)
+#define GS_CAN_FEATURE_MASK GENMASK(13, 0)
 
 /* internal quirks - keep in GS_CAN_FEATURE space for now */
 
-- 
2.35.1


