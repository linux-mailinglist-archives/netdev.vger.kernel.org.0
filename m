Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8147F3D1F0F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhGVGv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 02:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhGVGv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 02:51:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B359EC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 00:32:32 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6TBy-0004FA-Gp; Thu, 22 Jul 2021 09:32:26 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m6TBy-0005uD-4P; Thu, 22 Jul 2021 09:32:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: usb: asix: ax88772: add missing stop
Date:   Thu, 22 Jul 2021 09:32:24 +0200
Message-Id: <20210722073224.22652-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing stop and let phylib framework suspend attached PHY.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/usb/asix_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 049c20342a0b..9b914765c2de 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -1210,6 +1210,7 @@ static const struct driver_info ax88772b_info = {
 	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.reset = ax88772_reset,
+	.stop = ax88772_stop,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
 	         FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
-- 
2.30.2

