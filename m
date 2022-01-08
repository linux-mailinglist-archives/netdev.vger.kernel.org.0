Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2893A48866F
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiAHVo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiAHVoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF77CC06175E
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVQ-0004ew-VA
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F09E96D3AA6
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:54 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A8DE86D3A38;
        Sat,  8 Jan 2022 21:43:49 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1138b303;
        Sat, 8 Jan 2022 21:43:47 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 21/22] docs: networking: device drivers: add can sub-folder
Date:   Sat,  8 Jan 2022 22:43:44 +0100
Message-Id: <20220108214345.1848470-22-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Add the container for CAN drivers documentation.

Link: https://lore.kernel.org/all/20220107193105.1699523-7-mkl@pengutronix.de
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../networking/device_drivers/can/index.rst    | 18 ++++++++++++++++++
 .../networking/device_drivers/index.rst        |  1 +
 2 files changed, 19 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/can/index.rst

diff --git a/Documentation/networking/device_drivers/can/index.rst b/Documentation/networking/device_drivers/can/index.rst
new file mode 100644
index 000000000000..218276818968
--- /dev/null
+++ b/Documentation/networking/device_drivers/can/index.rst
@@ -0,0 +1,18 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Controller Area Network (CAN) Device Drivers
+============================================
+
+Device drivers for CAN devices.
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 3a5a1d46e77e..5f5cfdb2a300 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -11,6 +11,7 @@ Contents:
    appletalk/index
    atm/index
    cable/index
+   can/index
    cellular/index
    ethernet/index
    fddi/index
-- 
2.34.1


