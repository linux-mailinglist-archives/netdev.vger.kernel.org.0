Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E523575E6
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356278AbhDGUZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236539AbhDGUXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6940561184;
        Wed,  7 Apr 2021 20:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827022;
        bh=5qefKy3s6QKoiPklCW8pRP7HOwFxnURhDrcL6eb7OVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRs6Vv7bragxUe0KI0tydmrL/Jiuc8Orh+m7hpejfyU4lnT+/qNVCnZzYFIZ+EFrK
         D/zCdvsnuejCSJKooXeR/MFycqX9lgq180231bJBbm7vy8DRA8s9jaOuCIUn3b4zk/
         LHFn0u+b7MYphLObfaE82ibjz1BI0bJZfhFj7Kv5OClgxYNZvl5Fq1nVbNhSN7z3XP
         jqa5Hcsbyx/XeP9FrdPsv07WEQdCdOP43qvDdZgsfH1YLyQh4yeHoZFyftD9Z8x2dC
         qw/Ixrj7hkCzWtxPFVspo/OCTF90ssYUXLdl5vwNibF0mhwcnyR4jtGWi2iWd0dy37
         KEV5tVqIjB2zA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 05/16] net: phy: marvell10g: add all MACTYPE definitions for 88X33x0
Date:   Wed,  7 Apr 2021 22:22:43 +0200
Message-Id: <20210407202254.29417-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

