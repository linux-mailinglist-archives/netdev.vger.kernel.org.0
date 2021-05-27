Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3E43929EB
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhE0IuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbhE0Itw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7F2C061763
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgf-00020r-3c
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6DC2362D49C
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:44 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C121962D400;
        Thu, 27 May 2021 08:45:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d610c9d7;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 14/21] can: kvaser_usb: Rename define USB_HYBRID_{,PRO_}CANLIN_PRODUCT_ID
Date:   Thu, 27 May 2021 10:45:25 +0200
Message-Id: <20210527084532.1384031-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

Rename define USB_HYBRID_{,PRO_}CANLIN_PRODUCT_ID to
USB_HYBRID_{,PRO_}2CANLIN_PRODUCT_ID, to reflect the channel count.

Link: https://lore.kernel.org/r/20210429093730.499263-1-extja@kvaser.com
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 90ebcae13409..b2236bf63b41 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -79,10 +79,10 @@
 #define USB_USBCAN_PRO_2HS_V2_PRODUCT_ID	264
 #define USB_MEMO_2HS_PRODUCT_ID			265
 #define USB_MEMO_PRO_2HS_V2_PRODUCT_ID		266
-#define USB_HYBRID_CANLIN_PRODUCT_ID		267
+#define USB_HYBRID_2CANLIN_PRODUCT_ID		267
 #define USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID	268
 #define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID	269
-#define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	270
+#define USB_HYBRID_PRO_2CANLIN_PRODUCT_ID	270
 #define USB_U100_PRODUCT_ID			273
 #define USB_U100P_PRODUCT_ID			274
 #define USB_U100S_PRODUCT_ID			275
@@ -187,10 +187,10 @@ static const struct usb_device_id kvaser_usb_table[] = {
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_2HS_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_CANLIN_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_2CANLIN_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_CANLIN_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_HYBRID_PRO_2CANLIN_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100P_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_U100S_PRODUCT_ID) },
-- 
2.30.2


