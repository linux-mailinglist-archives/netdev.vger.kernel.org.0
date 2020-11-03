Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D602A595A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgKCWG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731388AbgKCWG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:56 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9953C061A4C
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:53 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4S3-0006Ui-E9; Tue, 03 Nov 2020 23:06:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tom Rix <trix@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 23/27] can: mcp251xfd: remove unneeded break
Date:   Tue,  3 Nov 2020 23:06:32 +0100
Message-Id: <20201103220636.972106-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A break is not needed if it is preceded by a return.

Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20201019172412.31143-1-trix@redhat.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index c3f49543ff26..9c215f7c5f81 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -75,11 +75,11 @@ static const char *__mcp251xfd_get_model_str(enum mcp251xfd_model model)
 {
 	switch (model) {
 	case MCP251XFD_MODEL_MCP2517FD:
-		return "MCP2517FD"; break;
+		return "MCP2517FD";
 	case MCP251XFD_MODEL_MCP2518FD:
-		return "MCP2518FD"; break;
+		return "MCP2518FD";
 	case MCP251XFD_MODEL_MCP251XFD:
-		return "MCP251xFD"; break;
+		return "MCP251xFD";
 	}
 
 	return "<unknown>";
@@ -95,21 +95,21 @@ static const char *mcp251xfd_get_mode_str(const u8 mode)
 {
 	switch (mode) {
 	case MCP251XFD_REG_CON_MODE_MIXED:
-		return "Mixed (CAN FD/CAN 2.0)"; break;
+		return "Mixed (CAN FD/CAN 2.0)";
 	case MCP251XFD_REG_CON_MODE_SLEEP:
-		return "Sleep"; break;
+		return "Sleep";
 	case MCP251XFD_REG_CON_MODE_INT_LOOPBACK:
-		return "Internal Loopback"; break;
+		return "Internal Loopback";
 	case MCP251XFD_REG_CON_MODE_LISTENONLY:
-		return "Listen Only"; break;
+		return "Listen Only";
 	case MCP251XFD_REG_CON_MODE_CONFIG:
-		return "Configuration"; break;
+		return "Configuration";
 	case MCP251XFD_REG_CON_MODE_EXT_LOOPBACK:
-		return "External Loopback"; break;
+		return "External Loopback";
 	case MCP251XFD_REG_CON_MODE_CAN2_0:
-		return "CAN 2.0"; break;
+		return "CAN 2.0";
 	case MCP251XFD_REG_CON_MODE_RESTRICTED:
-		return "Restricted Operation"; break;
+		return "Restricted Operation";
 	}
 
 	return "<unknown>";
-- 
2.28.0

