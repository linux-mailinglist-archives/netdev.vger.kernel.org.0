Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F4A3F96FC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244881AbhH0Jau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:30:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244657AbhH0Jag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 05:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7C360F6C;
        Fri, 27 Aug 2021 09:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630056587;
        bh=Qa+Xvz2tEkd6ZojFgLnzj3Z4HtfYDVECO06IQ4IQZ0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=hVzrnmwCr/1zatmWPlatKubAC95B3qTU0VHVJRMws0BZ5bbBC+8HZ/VbPVb7i8ZGS
         7yOZ6xiGQYnjXAkyW6SoJncbfvOFjp3gNoTLUfYHun6JkcRnM54S5XOCKS/+R/ukkp
         Q3h8FM1wvWF1Qm9moZ9ZVTeMivFPZKpRMGvsWKpStQm4vjmyEX+TF3hSgk6g3nS10l
         FzQ/dQxacUa8WSEXJ0GZ0k6eXI6/Pait4peCFOKZgfDDqZFZObB4cMSCk7b/BEIOu5
         zCucdbExI4/k74T41mRYbBgYb9rhgIHtLqLUOr/4Fj5VdqdR35ztYtNm5eMdG0U09Q
         695D9m8JGC9iw==
Received: by pali.im (Postfix)
        id 1F2E1617; Fri, 27 Aug 2021 11:29:45 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] phy: marvell: phy-mvebu-cp110-comphy: Rename HS-SGMMI to 2500Base-X
Date:   Fri, 27 Aug 2021 11:27:51 +0200
Message-Id: <20210827092753.2359-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
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
Fixes: eb6a1fcb53e2 ("phy: mvebu-cp110-comphy: Add SMC call support")
Fixes: c2afb2fef595 ("phy: mvebu-cp110-comphy: Rename the macro handling only Ethernet modes")
---
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
index 53ad127b100f..bbd6f2ad6f24 100644
--- a/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-cp110-comphy.c
@@ -167,7 +167,7 @@
 
 #define COMPHY_FW_MODE_SATA		0x1
 #define COMPHY_FW_MODE_SGMII		0x2 /* SGMII 1G */
-#define COMPHY_FW_MODE_HS_SGMII		0x3 /* SGMII 2.5G */
+#define COMPHY_FW_MODE_2500BASEX	0x3 /* 2500BASE-X */
 #define COMPHY_FW_MODE_USB3H		0x4
 #define COMPHY_FW_MODE_USB3D		0x5
 #define COMPHY_FW_MODE_PCIE		0x6
@@ -207,7 +207,7 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	/* lane 0 */
 	GEN_CONF(0, 0, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(0, 1, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(0, 1, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(0, 1, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_2500BASEX),
 	GEN_CONF(0, 1, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
 	/* lane 1 */
 	GEN_CONF(1, 0, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
@@ -215,10 +215,10 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	GEN_CONF(1, 0, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
 	GEN_CONF(1, 0, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(1, 2, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(1, 2, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(1, 2, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_2500BASEX),
 	/* lane 2 */
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(2, 0, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(2, 0, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_2500BASEX),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_RXAUI, 0x1, COMPHY_FW_MODE_RXAUI),
 	ETH_CONF(2, 0, PHY_INTERFACE_MODE_10GBASER, 0x1, COMPHY_FW_MODE_XFI),
 	GEN_CONF(2, 0, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
@@ -227,26 +227,26 @@ static const struct mvebu_comphy_conf mvebu_comphy_cp110_modes[] = {
 	/* lane 3 */
 	GEN_CONF(3, 0, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(3, 1, PHY_INTERFACE_MODE_SGMII, 0x2, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(3, 1, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(3, 1, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_2500BASEX),
 	ETH_CONF(3, 1, PHY_INTERFACE_MODE_RXAUI, 0x1, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(3, 1, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
 	GEN_CONF(3, 1, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
 	/* lane 4 */
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_SGMII, 0x2, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(4, 0, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(4, 0, PHY_INTERFACE_MODE_2500BASEX, 0x2, COMPHY_FW_MODE_2500BASEX),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_10GBASER, 0x2, COMPHY_FW_MODE_XFI),
 	ETH_CONF(4, 0, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(4, 0, PHY_MODE_USB_DEVICE_SS, COMPHY_FW_MODE_USB3D),
 	GEN_CONF(4, 1, PHY_MODE_USB_HOST_SS, COMPHY_FW_MODE_USB3H),
 	GEN_CONF(4, 1, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(4, 1, PHY_INTERFACE_MODE_2500BASEX, -1, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(4, 1, PHY_INTERFACE_MODE_2500BASEX, -1, COMPHY_FW_MODE_2500BASEX),
 	ETH_CONF(4, 1, PHY_INTERFACE_MODE_10GBASER, -1, COMPHY_FW_MODE_XFI),
 	/* lane 5 */
 	ETH_CONF(5, 1, PHY_INTERFACE_MODE_RXAUI, 0x2, COMPHY_FW_MODE_RXAUI),
 	GEN_CONF(5, 1, PHY_MODE_SATA, COMPHY_FW_MODE_SATA),
 	ETH_CONF(5, 2, PHY_INTERFACE_MODE_SGMII, 0x1, COMPHY_FW_MODE_SGMII),
-	ETH_CONF(5, 2, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_HS_SGMII),
+	ETH_CONF(5, 2, PHY_INTERFACE_MODE_2500BASEX, 0x1, COMPHY_FW_MODE_2500BASEX),
 	GEN_CONF(5, 2, PHY_MODE_PCIE, COMPHY_FW_MODE_PCIE),
 };
 
-- 
2.20.1

