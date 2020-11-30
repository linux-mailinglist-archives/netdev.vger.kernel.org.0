Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E42C8674
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgK3OQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgK3OQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136FDC08E85E
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjx2-0007kc-Li
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5C57859FB2E
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D17F459FADA;
        Mon, 30 Nov 2020 14:14:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bbc27d47;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: [net-next 11/14] can: m_can: Kconfig: convert the into menu
Date:   Mon, 30 Nov 2020 15:14:29 +0100
Message-Id: <20201130141432.278219-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since there is more than one base driver for the m_can core, let's
convert this into a menu.

Link: https://lore.kernel.org/r/20201130133713.269256-4-mkl@pengutronix.de
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 5f9f8192dd0b..e3eb69b76cf5 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,21 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config CAN_M_CAN
+menuconfig CAN_M_CAN
 	tristate "Bosch M_CAN support"
 	help
 	  Say Y here if you want support for Bosch M_CAN controller framework.
 	  This is common support for devices that embed the Bosch M_CAN IP.
 
+if CAN_M_CAN
+
 config CAN_M_CAN_PLATFORM
 	tristate "Bosch M_CAN support for io-mapped devices"
 	depends on HAS_IOMEM
-	depends on CAN_M_CAN
 	help
 	  Say Y here if you want support for IO Mapped Bosch M_CAN controller.
 	  This support is for devices that have the Bosch M_CAN controller
 	  IP embedded into the device and the IP is IO Mapped to the processor.
 
 config CAN_M_CAN_TCAN4X5X
-	depends on CAN_M_CAN
 	depends on SPI
 	select REGMAP_SPI
 	tristate "TCAN4X5X M_CAN device"
@@ -23,3 +23,5 @@ config CAN_M_CAN_TCAN4X5X
 	  Say Y here if you want support for Texas Instruments TCAN4x5x
 	  M_CAN controller.  This device is a peripheral device that uses the
 	  SPI bus for communication.
+
+endif
-- 
2.29.2


