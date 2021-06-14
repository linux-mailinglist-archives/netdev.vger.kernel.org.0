Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFBB3A5C31
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 06:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhFNEdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 00:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhFNEdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 00:33:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4F4C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 21:31:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lseFz-0001kR-Px; Mon, 14 Jun 2021 06:31:27 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lseFy-00034s-PP; Mon, 14 Jun 2021 06:31:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v5 3/8] net: phy: micrel: use consistent alignments
Date:   Mon, 14 Jun 2021 06:31:20 +0200
Message-Id: <20210614043125.11658-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210614043125.11658-1-o.rempel@pengutronix.de>
References: <20210614043125.11658-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the alignments to one space between "#define" and the
macro.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/micrel.c | 44 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a14a00328fa3..77640b990977 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -38,42 +38,42 @@
 
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
-#define	KSZPHY_INTCS_LINK_DOWN_STATUS		BIT(2)
-#define	KSZPHY_INTCS_LINK_UP_STATUS		BIT(0)
-#define	KSZPHY_INTCS_STATUS			(KSZPHY_INTCS_LINK_DOWN_STATUS |\
+#define KSZPHY_INTCS_LINK_DOWN_STATUS		BIT(2)
+#define KSZPHY_INTCS_LINK_UP_STATUS		BIT(0)
+#define KSZPHY_INTCS_STATUS			(KSZPHY_INTCS_LINK_DOWN_STATUS |\
 						 KSZPHY_INTCS_LINK_UP_STATUS)
 
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
 
 /* Write/read to/from extended registers */
-#define MII_KSZPHY_EXTREG                       0x0b
-#define KSZPHY_EXTREG_WRITE                     0x8000
+#define MII_KSZPHY_EXTREG			0x0b
+#define KSZPHY_EXTREG_WRITE			0x8000
 
-#define MII_KSZPHY_EXTREG_WRITE                 0x0c
-#define MII_KSZPHY_EXTREG_READ                  0x0d
+#define MII_KSZPHY_EXTREG_WRITE			0x0c
+#define MII_KSZPHY_EXTREG_READ			0x0d
 
 /* Extended registers */
-#define MII_KSZPHY_CLK_CONTROL_PAD_SKEW         0x104
-#define MII_KSZPHY_RX_DATA_PAD_SKEW             0x105
-#define MII_KSZPHY_TX_DATA_PAD_SKEW             0x106
+#define MII_KSZPHY_CLK_CONTROL_PAD_SKEW		0x104
+#define MII_KSZPHY_RX_DATA_PAD_SKEW		0x105
+#define MII_KSZPHY_TX_DATA_PAD_SKEW		0x106
 
 #define PS_TO_REG				200
 
-- 
2.29.2

