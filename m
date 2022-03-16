Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF24DB9B3
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358071AbiCPUuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347748AbiCPUus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:50:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5405A5B3
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaJ-0003qM-JF
        for netdev@vger.kernel.org; Wed, 16 Mar 2022 21:49:31 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 283CC4CBB4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:47:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D42864CB90;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e3f46762;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Julia Lawall <Julia.Lawall@inria.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 5/5] can: ucan: fix typos in comments
Date:   Wed, 16 Mar 2022 21:47:10 +0100
Message-Id: <20220316204710.716341-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316204710.716341-1-mkl@pengutronix.de>
References: <20220316204710.716341-1-mkl@pengutronix.de>
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

From: Julia Lawall <Julia.Lawall@inria.fr>

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Link: https://lore.kernel.org/all/20220314115354.144023-28-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/ucan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
index c7c41d1fd038..5ae0d7c017cc 100644
--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1392,7 +1392,7 @@ static int ucan_probe(struct usb_interface *intf,
 	 * Stage 3 for the final driver initialisation.
 	 */
 
-	/* Prepare Memory for control transferes */
+	/* Prepare Memory for control transfers */
 	ctl_msg_buffer = devm_kzalloc(&udev->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
@@ -1526,7 +1526,7 @@ static int ucan_probe(struct usb_interface *intf,
 	ret = ucan_device_request_in(up, UCAN_DEVICE_GET_FW_STRING, 0,
 				     sizeof(union ucan_ctl_payload));
 	if (ret > 0) {
-		/* copy string while ensuring zero terminiation */
+		/* copy string while ensuring zero termination */
 		strncpy(firmware_str, up->ctl_msg_buffer->raw,
 			sizeof(union ucan_ctl_payload));
 		firmware_str[sizeof(union ucan_ctl_payload)] = '\0';
-- 
2.35.1


