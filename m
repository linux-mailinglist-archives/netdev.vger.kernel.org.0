Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB5C296C66
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461812AbgJWJ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 05:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461630AbgJWJ5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 05:57:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5E0C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 02:57:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVtox-0002Kh-94; Fri, 23 Oct 2020 11:57:15 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVtor-0001ih-Ry; Fri, 23 Oct 2020 11:57:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
Subject: [PATCH v1] net: phy: remove spaces
Date:   Fri, 23 Oct 2020 11:57:09 +0200
Message-Id: <20201023095709.6544-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 8d333d3084ed..635be83962b6 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -120,10 +120,10 @@ static const struct phy_setting settings[] = {
 	PHY_SETTING( 100000, FULL, 100000baseDR_Full		),
 	PHY_SETTING( 100000, FULL, 100000baseSR_Full		),
 	/* 56G */
-	PHY_SETTING(  56000, FULL,  56000baseCR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseKR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseLR4_Full	  	),
-	PHY_SETTING(  56000, FULL,  56000baseSR4_Full	  	),
+	PHY_SETTING(  56000, FULL,  56000baseCR4_Full		),
+	PHY_SETTING(  56000, FULL,  56000baseKR4_Full		),
+	PHY_SETTING(  56000, FULL,  56000baseLR4_Full		),
+	PHY_SETTING(  56000, FULL,  56000baseSR4_Full		),
 	/* 50G */
 	PHY_SETTING(  50000, FULL,  50000baseCR2_Full		),
 	PHY_SETTING(  50000, FULL,  50000baseKR2_Full		),
-- 
2.28.0

