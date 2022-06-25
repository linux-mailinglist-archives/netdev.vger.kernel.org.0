Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D9D55A9C8
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbiFYMGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiFYMGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFC2140E9
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YT-0002f0-4H
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C57929F1BB
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A051C9F18B;
        Sat, 25 Jun 2022 12:04:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9228c7d7;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/22] net: Kconfig: move the CAN device menu to the "Device Drivers" section
Date:   Sat, 25 Jun 2022 14:03:22 +0200
Message-Id: <20220625120335.324697-10-mkl@pengutronix.de>
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The devices are meant to be under the "Device Drivers" category of the
menuconfig. The CAN subsystem is currently one of the rare exception
with all of its devices under the "Networking support" category.

The CAN_DEV menuentry gets moved to fix this discrepancy. The CAN menu
is added just before MCTP in order to be consistent with the current
order under the "Networking support" menu.

A dependency on CAN is added to CAN_DEV so that the CAN devices only
show up if the CAN subsystem is enabled.

Link: https://lore.kernel.org/all/20220610143009.323579-6-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Max Staudt <max@enpas.org>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/Kconfig     | 2 ++
 drivers/net/can/Kconfig | 1 +
 net/can/Kconfig         | 5 ++---
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b2a4f998c180..5de243899de8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -499,6 +499,8 @@ config NET_SB1000
 
 source "drivers/net/phy/Kconfig"
 
+source "drivers/net/can/Kconfig"
+
 source "drivers/net/mctp/Kconfig"
 
 source "drivers/net/mdio/Kconfig"
diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 5335f3afc0a5..806f15146f69 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -3,6 +3,7 @@
 menuconfig CAN_DEV
 	tristate "CAN Device Drivers"
 	default y
+	depends on CAN
 	help
 	  Controller Area Network (CAN) is serial communications protocol up to
 	  1Mbit/s for its original release (now known as Classical CAN) and up
diff --git a/net/can/Kconfig b/net/can/Kconfig
index a9ac5ffab286..cb56be8e3862 100644
--- a/net/can/Kconfig
+++ b/net/can/Kconfig
@@ -15,7 +15,8 @@ menuconfig CAN
 	  PF_CAN is contained in <Documentation/networking/can.rst>.
 
 	  If you want CAN support you should say Y here and also to the
-	  specific driver for your controller(s) below.
+	  specific driver for your controller(s) under the Network device
+	  support section.
 
 if CAN
 
@@ -69,6 +70,4 @@ config CAN_ISOTP
 	  If you want to perform automotive vehicle diagnostic services (UDS),
 	  say 'y'.
 
-source "drivers/net/can/Kconfig"
-
 endif
-- 
2.35.1


