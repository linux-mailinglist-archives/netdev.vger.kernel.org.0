Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777AC21B4BE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGJMJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGJMJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:09:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F2CC08E886
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:09:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpu-00080a-8F; Fri, 10 Jul 2020 14:09:02 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpq-0007Yf-MF; Fri, 10 Jul 2020 14:08:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 1/5] net: phy: micrel: use consistent indention after define
Date:   Fri, 10 Jul 2020 14:08:47 +0200
Message-Id: <20200710120851.28984-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710120851.28984-1-o.rempel@pengutronix.de>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the indention to one space between "#define" and the
macro.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3fe552675dd2..caf56b9b51db 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -38,23 +38,23 @@
 
 /* general Interrupt control/status reg in vendor specific block. */
 #define MII_KSZPHY_INTCS			0x1B
-#define	KSZPHY_INTCS_JABBER			BIT(15)
-#define	KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
-#define	KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
-#define	KSZPHY_INTCS_PARELLEL			BIT(12)
-#define	KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
-#define	KSZPHY_INTCS_LINK_DOWN			BIT(10)
-#define	KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
-#define	KSZPHY_INTCS_LINK_UP			BIT(8)
-#define	KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
+#define KSZPHY_INTCS_JABBER			BIT(15)
+#define KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
+#define KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
+#define KSZPHY_INTCS_PARELLEL			BIT(12)
+#define KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
+#define KSZPHY_INTCS_LINK_DOWN			BIT(10)
+#define KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
+#define KSZPHY_INTCS_LINK_UP			BIT(8)
+#define KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
 						KSZPHY_INTCS_LINK_DOWN)
 
 /* PHY Control 1 */
-#define	MII_KSZPHY_CTRL_1			0x1e
+#define MII_KSZPHY_CTRL_1			0x1e
 
 /* PHY Control 2 / PHY Control (if no PHY Control 1) */
-#define	MII_KSZPHY_CTRL_2			0x1f
-#define	MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
+#define MII_KSZPHY_CTRL_2			0x1f
+#define MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
 /* bitmap of PHY register to set interrupt mode */
 #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
 #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
-- 
2.27.0

