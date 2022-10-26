Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9560DD41
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiJZIkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiJZIkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E05357E0
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxQ-0006hy-6s
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D7B0F10A0B8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3588310A092;
        Wed, 26 Oct 2022 08:40:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c7e4a8ba;
        Wed, 26 Oct 2022 08:40:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/29] can: gs_usb: mention candleLight as supported device
Date:   Wed, 26 Oct 2022 10:39:46 +0200
Message-Id: <20221026084007.1583333-9-mkl@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make it easier for new users to find the correct driver for
candleLight compatible CAN-USB devices mention candleLight in the
driver's Kconfig input prompt.

Link: https://lore.kernel.org/all/20221019205037.1600936-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index 1218f9642f33..8c6fea661530 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -38,10 +38,13 @@ config CAN_ETAS_ES58X
 	  will be called etas_es58x.
 
 config CAN_GS_USB
-	tristate "Geschwister Schneider UG interfaces"
+	tristate "Geschwister Schneider UG and candleLight compatible interfaces"
 	help
-	  This driver supports the Geschwister Schneider and bytewerk.org
-	  candleLight USB CAN interfaces USB/CAN devices
+	  This driver supports the Geschwister Schneider and
+	  bytewerk.org candleLight compatible
+	  (https://github.com/candle-usb/candleLight_fw) USB/CAN
+	  interfaces.
+
 	  If unsure choose N,
 	  choose Y for built in support,
 	  M to compile as module (module will be named: gs_usb).
-- 
2.35.1


