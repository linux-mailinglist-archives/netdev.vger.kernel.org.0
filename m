Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F003492E1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhCYNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhCYNNd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC1661A1E;
        Thu, 25 Mar 2021 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678013;
        bh=eW67JIbT4Cz8LO2mBfJgUwc0Bo463M4DkT7UiRNnQMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqCbTtaztMNiLV1NLEKfleyUNxeZegNE5MfoRyIA75db2I+1utyZgUYudsOZ8v1Jy
         fMDVttouzQ4msjSURCtZw5P4OtueQ1+JCb9y9WuLuApViFwIN2+L6q6QXz0pWupClq
         UrUQJPpwP6W8yGscwRMTkCOh8+yi0O53OsdlX1OxkkStJY8jBNpD/k8fQl257AHbci
         SK36lFkr21buxHwGQvJKl8kZBgV6jo7M8dmf/Ig7XW0EHwhLwyxp8+PN9x94AVSRNi
         3+etf4nWldsJvr8RVv0j84cTYWvrsTzO/haf9JpKLQDxGj5cd0dbao0GFr3DQr7BUI
         sIwvOblutT6Kg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 05/12] net: phy: marvell10g: add MACTYPE definitions for 88X33X0/88X33X0P
Date:   Thu, 25 Mar 2021 14:12:43 +0100
Message-Id: <20210325131250.15901-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all MACTYPE definitions for 88X3310, 88X3310P, 88X3340 and 88X3340P.

In order to have consistent naming, rename
MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH to
MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7552a658a513..7d9a45437b69 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -78,10 +78,18 @@ enum {
 
 	/* Vendor2 MMD registers */
 	MV_V2_PORT_CTRL		= 0xf001,
-	MV_V2_PORT_CTRL_PWRDOWN			= BIT(11),
-	MV_V2_33X0_PORT_CTRL_SWRST		= BIT(15),
-	MV_V2_33X0_PORT_CTRL_MACTYPE_MASK	= 0x7,
-	MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH	= 0x6,
+	MV_V2_PORT_CTRL_PWRDOWN					= BIT(11),
+	MV_V2_33X0_PORT_CTRL_SWRST				= BIT(15),
+	MV_V2_33X0_PORT_CTRL_MACTYPE_MASK			= 0x7,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI			= 0x0,
+	MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH		= 0x1,
+	MV_V2_3340_PORT_CTRL_MACTYPE_RXAUI_NO_SGMII_AN		= 0x1,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH		= 0x2,
+	MV_V2_3310_PORT_CTRL_MACTYPE_XAUI			= 0x3,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER			= 0x4,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
+	MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
@@ -480,7 +488,7 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (val < 0)
 		return val;
 	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
-			MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH);
+			MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH);
 
 	/* Enable EDPD mode - saving 600mW */
 	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
-- 
2.26.2

