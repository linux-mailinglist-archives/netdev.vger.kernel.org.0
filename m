Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3BB3F96FE
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244893AbhH0Jav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244794AbhH0Jag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB6361004;
        Fri, 27 Aug 2021 09:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630056588;
        bh=2gt+uFB3UMe9u6rWymx6Cl+iij8ULw+bccv3Rqok4u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgaOIhcnUufHL/pFtc9eTSDVEIeuXgbVBSxDrmhtmnVeeajBKbCHuvBlppjVLQker
         o9lZzA73Rg+WsM3i3X3hCPxmUTDy+xvDxasSGiEiQf8QsKi5m4ddNY/LtkxiCsuZ8u
         j25/WWyeXyPelNNAnbG9CunmJCKlTGhV8Ph1W2f1tWiH3Uw+k4dhkw/mWlHkTKlOD6
         iuzbO7edlb+DZphO/Dd59eBVaUqGGjjw1f/7S6CKSzQC2+zWJhZmeZdK0B8IKYQb8M
         1mbs2zoORTV2PPS4vUg2GNk15gzCk805Bzq3M2pOMa5E8RpMKRzEXjCS1pGbqFi+Pa
         hWrVR+qhUyfrQ==
Received: by pali.im (Postfix)
        id 4EA16F3C; Fri, 27 Aug 2021 11:29:46 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] phy: marvell: phy-mvebu-a3700-comphy: Rename HS-SGMMI to 2500Base-X
Date:   Fri, 27 Aug 2021 11:27:52 +0200
Message-Id: <20210827092753.2359-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210827092753.2359-1-pali@kernel.org>
References: <20210827092753.2359-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comphy phy mode 0x3 is incorrectly named. It is not SGMII but rather
2500Base-X mode which runs at 3.125 Gbps speed.

Rename macro names and comments to 2500Base-X.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 9695375a3f4a ("phy: add A3700 COMPHY support")
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index 810f25a47632..cc534a5c4b3b 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -29,7 +29,7 @@
 
 #define COMPHY_FW_MODE_SATA			0x1
 #define COMPHY_FW_MODE_SGMII			0x2
-#define COMPHY_FW_MODE_HS_SGMII			0x3
+#define COMPHY_FW_MODE_2500BASEX		0x3
 #define COMPHY_FW_MODE_USB3H			0x4
 #define COMPHY_FW_MODE_USB3D			0x5
 #define COMPHY_FW_MODE_PCIE			0x6
@@ -40,7 +40,7 @@
 
 #define COMPHY_FW_SPEED_1_25G			0 /* SGMII 1G */
 #define COMPHY_FW_SPEED_2_5G			1
-#define COMPHY_FW_SPEED_3_125G			2 /* SGMII 2.5G */
+#define COMPHY_FW_SPEED_3_125G			2 /* 2500BASE-X */
 #define COMPHY_FW_SPEED_5G			3
 #define COMPHY_FW_SPEED_5_15625G		4 /* XFI 5G */
 #define COMPHY_FW_SPEED_6G			5
@@ -84,14 +84,14 @@ static const struct mvebu_a3700_comphy_conf mvebu_a3700_comphy_modes[] = {
 	MVEBU_A3700_COMPHY_CONF_ETH(0, PHY_INTERFACE_MODE_SGMII, 1,
 				    COMPHY_FW_MODE_SGMII),
 	MVEBU_A3700_COMPHY_CONF_ETH(0, PHY_INTERFACE_MODE_2500BASEX, 1,
-				    COMPHY_FW_MODE_HS_SGMII),
+				    COMPHY_FW_MODE_2500BASEX),
 	/* lane 1 */
 	MVEBU_A3700_COMPHY_CONF_GEN(1, PHY_MODE_PCIE, 0,
 				    COMPHY_FW_MODE_PCIE),
 	MVEBU_A3700_COMPHY_CONF_ETH(1, PHY_INTERFACE_MODE_SGMII, 0,
 				    COMPHY_FW_MODE_SGMII),
 	MVEBU_A3700_COMPHY_CONF_ETH(1, PHY_INTERFACE_MODE_2500BASEX, 0,
-				    COMPHY_FW_MODE_HS_SGMII),
+				    COMPHY_FW_MODE_2500BASEX),
 	/* lane 2 */
 	MVEBU_A3700_COMPHY_CONF_GEN(2, PHY_MODE_SATA, 0,
 				    COMPHY_FW_MODE_SATA),
@@ -205,7 +205,7 @@ static int mvebu_a3700_comphy_power_on(struct phy *phy)
 						 COMPHY_FW_SPEED_1_25G);
 			break;
 		case PHY_INTERFACE_MODE_2500BASEX:
-			dev_dbg(lane->dev, "set lane %d to HS SGMII mode\n",
+			dev_dbg(lane->dev, "set lane %d to 2500BASEX mode\n",
 				lane->id);
 			fw_param = COMPHY_FW_NET(fw_mode, lane->port,
 						 COMPHY_FW_SPEED_3_125G);
-- 
2.20.1

