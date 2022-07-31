Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CD55860D3
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbiGaTU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbiGaTUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725ABE08C
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUQ-0007E5-Ju
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 86443BEC49
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0230ABEC3E;
        Sun, 31 Jul 2022 19:20:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bc354921;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/36] can: etas_es58x: remove DRV_VERSION
Date:   Sun, 31 Jul 2022 21:20:03 +0200
Message-Id: <20220731192029.746751-11-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

DRV_VERSION is a leftover from when the driver was an out of tree
module. The driver version was never incremented despite of the
numerous changes made since it was mainstreamed. Keeping an
unmaintained driver version number makes no sense. Remove it and rely
on the kernel version instead.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220726082707.58758-11-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index ade0a650e0ed..c22e989d42ff 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -18,11 +18,9 @@
 
 #include "es58x_core.h"
 
-#define DRV_VERSION "1.00"
 MODULE_AUTHOR("Vincent Mailhol <mailhol.vincent@wanadoo.fr>");
 MODULE_AUTHOR("Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>");
 MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
-MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL v2");
 
 #define ES58X_VENDOR_ID 0x108C
@@ -2180,9 +2178,8 @@ static struct es58x_device *es58x_init_es58x_dev(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep_in, *ep_out;
 	int ret;
 
-	dev_info(dev,
-		 "Starting %s %s (Serial Number %s) driver version %s\n",
-		 udev->manufacturer, udev->product, udev->serial, DRV_VERSION);
+	dev_info(dev, "Starting %s %s (Serial Number %s)\n",
+		 udev->manufacturer, udev->product, udev->serial);
 
 	ret = usb_find_common_endpoints(intf->cur_altsetting, &ep_in, &ep_out,
 					NULL, NULL);
-- 
2.35.1


