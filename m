Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC89655A9D7
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiFYMGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiFYMGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA914021
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YK-0002UV-OJ
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 42AF09F184
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:04:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 407039F161;
        Sat, 25 Jun 2022 12:03:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3677835c;
        Sat, 25 Jun 2022 12:03:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 05/22] can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
Date:   Sat, 25 Jun 2022 14:03:18 +0200
Message-Id: <20220625120335.324697-6-mkl@pengutronix.de>
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

In the next patches, the scope of the can-dev module will grow to
engloble the software/virtual drivers (slcan, v(x)can). To this
extent, release CAN_DEV by renaming it into CAN_NETLINK. The config
symbol CAN_DEV will be reused to cover this extended scope.

The rationale for the name CAN_NETLINK is that netlink is the
predominant feature added here.

The current description only mentions platform drivers despite the
fact that this symbol is also required by "normal" devices (e.g. USB
or PCI) which do not fall under the platform devices category. The
description is updated accordingly to fix this gap.

Link: https://lore.kernel.org/all/20220610143009.323579-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Acked-by: Max Staudt <max@enpas.org>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig      | 18 +++++++++++-------
 drivers/net/can/dev/Makefile |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index b2dcc1e5a388..99f189ad35ad 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -48,15 +48,19 @@ config CAN_SLCAN
 	  can be changed by the 'maxdev=xx' module option. This driver can
 	  also be built as a module. If so, the module will be called slcan.
 
-config CAN_DEV
-	tristate "Platform CAN drivers with Netlink support"
+config CAN_NETLINK
+	tristate "CAN device drivers with Netlink support"
 	default y
 	help
-	  Enables the common framework for platform CAN drivers with Netlink
-	  support. This is the standard library for CAN drivers.
-	  If unsure, say Y.
+	  Enables the common framework for CAN device drivers. This is the
+	  standard library and provides features for the Netlink interface such
+	  as bittiming validation, support of CAN error states, device restart
+	  and others.
+
+	  This is required by all platform and hardware CAN drivers. If you
+	  plan to use such devices or if unsure, say Y.
 
-if CAN_DEV
+if CAN_NETLINK
 
 config CAN_CALC_BITTIMING
 	bool "CAN bit-timing calculation"
@@ -164,7 +168,7 @@ source "drivers/net/can/softing/Kconfig"
 source "drivers/net/can/spi/Kconfig"
 source "drivers/net/can/usb/Kconfig"
 
-endif
+endif #CAN_NETLINK
 
 config CAN_DEBUG_DEVICES
 	bool "CAN devices debugging messages"
diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makefile
index af2901db473c..5b4c813c6222 100644
--- a/drivers/net/can/dev/Makefile
+++ b/drivers/net/can/dev/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_CAN_DEV)		+= can-dev.o
+obj-$(CONFIG_CAN_NETLINK) += can-dev.o
 can-dev-y			+= bittiming.o
 can-dev-y			+= dev.o
 can-dev-y			+= length.o
-- 
2.35.1


