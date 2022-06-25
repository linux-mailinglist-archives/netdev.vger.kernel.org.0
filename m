Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9CD55A9C5
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiFYMG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiFYMGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AB4140E9
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YL-0002Uy-5H
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4352F9F258
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9F5DC9F22B;
        Sat, 25 Jun 2022 12:04:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ce4a6173;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 18/22] can/esd_usb2: Rename esd_usb2.c to esd_usb.c
Date:   Sat, 25 Jun 2022 14:03:31 +0200
Message-Id: <20220625120335.324697-19-mkl@pengutronix.de>
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

As suggested by Vincent, renaming of esd_usb2.c to esd_usb.c
and according to that, adaption of Kconfig and Makfile, too.

Link: https://lore.kernel.org/all/20220624190517.2299701-2-frank.jungclaus@esd.eu
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/Kconfig                   | 15 +++++++++++----
 drivers/net/can/usb/Makefile                  |  2 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c} |  0
 3 files changed, 12 insertions(+), 5 deletions(-)
 rename drivers/net/can/usb/{esd_usb2.c => esd_usb.c} (100%)

diff --git a/drivers/net/can/usb/Kconfig b/drivers/net/can/usb/Kconfig
index f959215c9d53..1218f9642f33 100644
--- a/drivers/net/can/usb/Kconfig
+++ b/drivers/net/can/usb/Kconfig
@@ -14,11 +14,18 @@ config CAN_EMS_USB
 	  This driver is for the one channel CPC-USB/ARM7 CAN/USB interface
 	  from EMS Dr. Thomas Wuensche (http://www.ems-wuensche.de).
 
-config CAN_ESD_USB2
-	tristate "ESD USB/2 CAN/USB interface"
+config CAN_ESD_USB
+	tristate "esd electronics gmbh CAN/USB interfaces"
 	help
-	  This driver supports the CAN-USB/2 interface
-	  from esd electronic system design gmbh (http://www.esd.eu).
+	  This driver adds supports for several CAN/USB interfaces
+	  from esd electronics gmbh (https://www.esd.eu).
+
+	  The drivers supports the following devices:
+	    - esd CAN-USB/2
+	    - esd CAN-USB/Micro
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called esd_usb.
 
 config CAN_ETAS_ES58X
 	tristate "ETAS ES58X CAN/USB interfaces"
diff --git a/drivers/net/can/usb/Makefile b/drivers/net/can/usb/Makefile
index 748cf31a0d53..1ea16be5743b 100644
--- a/drivers/net/can/usb/Makefile
+++ b/drivers/net/can/usb/Makefile
@@ -5,7 +5,7 @@
 
 obj-$(CONFIG_CAN_8DEV_USB) += usb_8dev.o
 obj-$(CONFIG_CAN_EMS_USB) += ems_usb.o
-obj-$(CONFIG_CAN_ESD_USB2) += esd_usb2.o
+obj-$(CONFIG_CAN_ESD_USB) += esd_usb.o
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x/
 obj-$(CONFIG_CAN_GS_USB) += gs_usb.o
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb/
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb.c
similarity index 100%
rename from drivers/net/can/usb/esd_usb2.c
rename to drivers/net/can/usb/esd_usb.c
-- 
2.35.1


