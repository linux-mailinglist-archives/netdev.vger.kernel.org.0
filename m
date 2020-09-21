Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97615272640
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgIUNro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgIUNqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE40C061787
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:13 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8x-0003ED-1p; Mon, 21 Sep 2020 15:46:11 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 23/38] can: spi: Kconfig: remove unneeded dependencies form Kconfig symbols
Date:   Mon, 21 Sep 2020 15:45:42 +0200
Message-Id: <20200921134557.2251383-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commits

    653ee35ce6d5 ("can: hi311x: remove custom DMA mapped buffer")
    Fixes: df58525df395 ("can: mcp251x: remove custom DMA mapped buffer")

both the hi3111x and the mcp251x driver don't make use of the DMA API
any more. So we can safely remove the HAS_DMA dependency.

While we're here, remove the unneeded CAN_DEV and SPI dependencies from
the CAN_HI311X symbol, as the parent menus already have these
dependencies.

Link: https://lore.kernel.org/r/20200915223527.1417033-24-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index f780c79aac6f..a332008d8495 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -4,13 +4,11 @@ menu "CAN SPI interfaces"
 
 config CAN_HI311X
 	tristate "Holt HI311x SPI CAN controllers"
-	depends on CAN_DEV && SPI && HAS_DMA
 	help
 	  Driver for the Holt HI311x SPI CAN controllers.
 
 config CAN_MCP251X
 	tristate "Microchip MCP251x and MCP25625 SPI CAN controllers"
-	depends on HAS_DMA
 	help
 	  Driver for the Microchip MCP251x and MCP25625 SPI CAN
 	  controllers.
-- 
2.28.0

