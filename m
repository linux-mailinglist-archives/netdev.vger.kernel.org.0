Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2BE68BDE0
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjBFNTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjBFNTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:19:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B5383DE
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:55 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NQ-0000EH-Qx
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:44 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EFC8117148B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:27 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1B5D11712F4;
        Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 32f74f00;
        Mon, 6 Feb 2023 13:16:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Lukas Magel <lukas.magel@posteo.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 30/47] can: peak_usb: Reorder include directives alphabetically
Date:   Mon,  6 Feb 2023 14:16:03 +0100
Message-Id: <20230206131620.2758724-31-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
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

From: Lukas Magel <lukas.magel@posteo.net>

The include directives in all source files are reordered alphabetically
according to the names of the header files.

Signed-off-by: Lukas Magel <lukas.magel@posteo.net>
Link: https://lore.kernel.org/all/20230116200932.157769-9-lukas.magel@posteo.net
[mkl: move header changes from Patch 3 here]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb.c      |  5 +++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 10 +++++-----
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |  4 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c  |  4 ++--
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
index bead4f4ba472..b211b6e283a2 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
@@ -9,10 +9,11 @@
  * Many thanks to Klaus Hitschler <klaus.hitschler@gmx.de>
  */
 #include <asm/unaligned.h>
+
+#include <linux/ethtool.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
-#include <linux/module.h>
-#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 2bd62c8f2b25..d881e1d30183 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -8,15 +8,15 @@
  *
  * Many thanks to Klaus Hitschler <klaus.hitschler@gmx.de>
  */
+#include <linux/device.h>
+#include <linux/ethtool.h>
 #include <linux/init.h>
-#include <linux/signal.h>
-#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include <linux/usb.h>
-#include <linux/ethtool.h>
+#include <linux/signal.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
-#include <linux/device.h>
+#include <linux/usb.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index fd925ae96331..4d85b29a17b7 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -4,10 +4,10 @@
  *
  * Copyright (C) 2013-2014 Stephane Grosjean <s.grosjean@peak-system.com>
  */
+#include <linux/ethtool.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
-#include <linux/module.h>
-#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 0c805d9672bf..f736196383ac 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -6,10 +6,10 @@
  * Copyright (C) 2003-2011 PEAK System-Technik GmbH
  * Copyright (C) 2011-2012 Stephane Grosjean <s.grosjean@peak-system.com>
  */
+#include <linux/ethtool.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/usb.h>
-#include <linux/module.h>
-#include <linux/ethtool.h>
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
-- 
2.39.1


