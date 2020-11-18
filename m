Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57F2B816C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgKRQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKRQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:04:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFAAC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:04:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kfPwQ-0001km-F8; Wed, 18 Nov 2020 17:04:18 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/4] can: kvaser_pciefd: Fix KCAN bittiming limits
Date:   Wed, 18 Nov 2020 17:04:11 +0100
Message-Id: <20201118160414.2731659-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118160414.2731659-1-mkl@pengutronix.de>
References: <20201118160414.2731659-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

Use correct bittiming limits for the KCAN CAN controller.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-1-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/kvaser_pciefd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 6f766918211a..72acd1ba162d 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -287,12 +287,12 @@ struct kvaser_pciefd_tx_packet {
 static const struct can_bittiming_const kvaser_pciefd_bittiming_const = {
 	.name = KVASER_PCIEFD_DRV_NAME,
 	.tseg1_min = 1,
-	.tseg1_max = 255,
+	.tseg1_max = 512,
 	.tseg2_min = 1,
 	.tseg2_max = 32,
 	.sjw_max = 16,
 	.brp_min = 1,
-	.brp_max = 4096,
+	.brp_max = 8192,
 	.brp_inc = 1,
 };
 

base-commit: c09c8a27b9baa417864b9adc3228b10ae5eeec93
-- 
2.29.2

