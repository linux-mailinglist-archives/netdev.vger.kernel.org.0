Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C93488652
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiAHVoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiAHVn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:43:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D68C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:43:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVD-0004H0-K1
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:43:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BDF306D3A3A
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:49 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 64B786D3A0A;
        Sat,  8 Jan 2022 21:43:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1b7c73ef;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 04/22] can: mcp251xfd: add missing newline to printed strings
Date:   Sat,  8 Jan 2022 22:43:27 +0100
Message-Id: <20220108214345.1848470-5-mkl@pengutronix.de>
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

This patch adds the missing newline to printed strings.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/all/20220105154300.1258636-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9d1a8992d8ce..bf2ebd46ff83 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2624,7 +2624,7 @@ static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 	if (!mcp251xfd_is_251X(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {
 		netdev_info(ndev,
-			    "Detected %s, but firmware specifies a %s. Fixing up.",
+			    "Detected %s, but firmware specifies a %s. Fixing up.\n",
 			    __mcp251xfd_get_model_str(devtype_data->model),
 			    mcp251xfd_get_model_str(priv));
 	}
@@ -2661,7 +2661,7 @@ static int mcp251xfd_register_check_rx_int(struct mcp251xfd_priv *priv)
 		return 0;
 
 	netdev_info(priv->ndev,
-		    "RX_INT active after softreset, disabling RX_INT support.");
+		    "RX_INT active after softreset, disabling RX_INT support.\n");
 	devm_gpiod_put(&priv->spi->dev, priv->rx_int);
 	priv->rx_int = NULL;
 
-- 
2.34.1


