Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A32955A9DF
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiFYMGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiFYMGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F44140CB
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YL-0002VH-4e
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 408D29F283
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:16 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B527F9F25A;
        Sat, 25 Jun 2022 12:05:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1c513997;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Frank Jungclaus <frank.jungclaus@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 22/22] can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION
Date:   Sat, 25 Jun 2022 14:03:35 +0200
Message-Id: <20220625120335.324697-23-mkl@pengutronix.de>
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

- Brought the copyright notice up to date
- Also regarding the changed company name from
esd electronic system design gmbh to esd electronics gmbh
- Using socketcan@esd.eu as a generic mail address for matthias who
left esd 6 years before
- Added a second MODULE_AUTHOR() for Frank Jungclaus

Link: https://lore.kernel.org/all/20220624190517.2299701-6-frank.jungclaus@esd.eu
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/esd_usb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index e23dce3db55a..8a4bf2961f3d 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * CAN driver for esd CAN-USB/2 and CAN-USB/Micro
+ * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
  *
- * Copyright (C) 2010-2012 Matthias Fuchs <matthias.fuchs@esd.eu>, esd gmbh
+ * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
+ * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
  */
 #include <linux/signal.h>
 #include <linux/slab.h>
@@ -14,8 +15,9 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 
-MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd.eu>");
-MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2 and CAN-USB/Micro interfaces");
+MODULE_AUTHOR("Matthias Fuchs <socketcan@esd.eu>");
+MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
+MODULE_DESCRIPTION("CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro interfaces");
 MODULE_LICENSE("GPL v2");
 
 /* USB vendor and product ID */
-- 
2.35.1


