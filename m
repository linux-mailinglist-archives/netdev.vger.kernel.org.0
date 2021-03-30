Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45F534E9AA
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhC3Nyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhC3NyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:54:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B21C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:54:21 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREos-0006Q2-3h; Tue, 30 Mar 2021 15:54:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lREoq-0004RS-Nl; Tue, 30 Mar 2021 15:54:08 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 1/3] net: phy: micrel: KSZ8081: add loopback support
Date:   Tue, 30 Mar 2021 15:54:05 +0200
Message-Id: <20210330135407.17010-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210330135407.17010-1-o.rempel@pengutronix.de>
References: <20210330135407.17010-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY loopback is needed for the ethernet controller self test support.
This PHY was tested with the FEC sefltest.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a14a00328fa3..f05345f1c602 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1311,6 +1311,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_stats	= kszphy_get_stats,
 	.suspend	= kszphy_suspend,
 	.resume		= kszphy_resume,
+	.set_loopback	= genphy_loopback,
 }, {
 	.phy_id		= PHY_ID_KSZ8061,
 	.name		= "Micrel KSZ8061",
-- 
2.29.2

