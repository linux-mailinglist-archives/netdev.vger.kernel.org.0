Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A627F332
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgI3USq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbgI3US2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407ACC0613D5
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:28 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYU-0002Qt-Gn; Wed, 30 Sep 2020 22:18:26 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 09/13] can: mcp251xfd: rename all user facing strings to mcp251xfd
Date:   Wed, 30 Sep 2020 22:18:12 +0200
Message-Id: <20200930201816.1032054-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1] Geert noted that the autodetect compatible for the mcp25xxfd driver,
which is "microchip,mcp25xxfd" might be too generic and overlap with upcoming,
but incompatible chips.

In the previous patch the autodetect DT compatbile has been renamed to
"microchip,mcp251xfd", this patch changes all user facing strings from
"mcp25xxfd" to "mcp251xfd" and "MCP25XXFD" to "MCP251XFD", including:
- kconfig symbols
- name of kernel module
- DT and SPI compatible

[1] http://lore.kernel.org/r/CAMuHMdVkwGjr6dJuMyhQNqFoJqbh6Ec5V2b5LenCshwpM2SDsQ@mail.gmail.com

Link: https://lore.kernel.org/r/20200930091424.792165-9-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/Kconfig          | 10 +++++-----
 drivers/net/can/spi/mcp251xfd/Makefile         | 10 +++++-----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/Kconfig b/drivers/net/can/spi/mcp251xfd/Kconfig
index 9eb596019a58..f5a147a92cb2 100644
--- a/drivers/net/can/spi/mcp251xfd/Kconfig
+++ b/drivers/net/can/spi/mcp251xfd/Kconfig
@@ -1,14 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-config CAN_MCP25XXFD
-	tristate "Microchip MCP25xxFD SPI CAN controllers"
+config CAN_MCP251XFD
+	tristate "Microchip MCP251xFD SPI CAN controllers"
 	select REGMAP
 	help
-	  Driver for the Microchip MCP25XXFD SPI FD-CAN controller
+	  Driver for the Microchip MCP251XFD SPI FD-CAN controller
 	  family.
 
-config CAN_MCP25XXFD_SANITY
-	depends on CAN_MCP25XXFD
+config CAN_MCP251XFD_SANITY
+	depends on CAN_MCP251XFD
 	bool "Additional Sanity Checks"
 	help
 	  This option enables additional sanity checks in the driver,
diff --git a/drivers/net/can/spi/mcp251xfd/Makefile b/drivers/net/can/spi/mcp251xfd/Makefile
index e943e6a2db0c..cb71244cbe89 100644
--- a/drivers/net/can/spi/mcp251xfd/Makefile
+++ b/drivers/net/can/spi/mcp251xfd/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_CAN_MCP25XXFD) += mcp25xxfd.o
+obj-$(CONFIG_CAN_MCP251XFD) += mcp251xfd.o
 
-mcp25xxfd-objs :=
-mcp25xxfd-objs += mcp251xfd-core.o
-mcp25xxfd-objs += mcp251xfd-crc16.o
-mcp25xxfd-objs += mcp251xfd-regmap.o
+mcp251xfd-objs :=
+mcp251xfd-objs += mcp251xfd-core.o
+mcp251xfd-objs += mcp251xfd-crc16.o
+mcp251xfd-objs += mcp251xfd-regmap.o
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 7cd14531ab1e..37d3f07c9bf6 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -25,7 +25,7 @@
 
 #include "mcp251xfd.h"
 
-#define DEVICE_NAME "mcp25xxfd"
+#define DEVICE_NAME "mcp251xfd"
 
 static const struct mcp25xxfd_devtype_data mcp25xxfd_devtype_data_mcp2517fd = {
 	.quirks = MCP25XXFD_QUIRK_MAB_NO_WARN | MCP25XXFD_QUIRK_CRC_REG |
@@ -2923,5 +2923,5 @@ static struct spi_driver mcp25xxfd_driver = {
 module_spi_driver(mcp25xxfd_driver);
 
 MODULE_AUTHOR("Marc Kleine-Budde <mkl@pengutronix.de>");
-MODULE_DESCRIPTION("Microchip MCP25xxFD Family CAN controller driver");
+MODULE_DESCRIPTION("Microchip MCP251xFD Family CAN controller driver");
 MODULE_LICENSE("GPL v2");
-- 
2.28.0

