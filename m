Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9744C88C
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhKJTKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhKJTKN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 14:10:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BB4061052;
        Wed, 10 Nov 2021 19:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636571245;
        bh=whK1wt/Uk1I5jN9W5WcTntaGF28yC0dQ4k4Bl9OH6Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP2VgTPXC/Qp33cu/PWssv9io+hHdRyO8Mr0O12KOwiWwpz2zN/70127YK+d/ACJQ
         hj97/jWLnuXW92GJjJQ+28n1i/mx1inJeMB+PCT5MvH+Awz+lDvcl67I/tfd89FT15
         g3IsQ94mvFwgrn0KLe6ISsWvwgKHqw5C9lIIDYpChlFM8FohAzTkjXwoTtTbGmmgX3
         Inza6RWl4LD+0byTwPCsxwp0keTnHLPi1d3yfDCGd0FaklOKF72LVZcN1PPDXVP1f6
         6d75M5jXUWBywBqANNEqwJz/bK8MZ5bwDzm1OVBQOfF8aq67H1q6WBpMze1MX6uMoM
         ZogGbYbipm7eg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 7/8] net: phy: marvell10g: Use tabs instead of spaces for indentation
Date:   Wed, 10 Nov 2021 20:07:08 +0100
Message-Id: <20211110190709.16505-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110190709.16505-1-kabel@kernel.org>
References: <20211110190709.16505-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some register definitions were defined with spaces used for indentation.
Change them to tabs.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index d289641190db..0cb9b4ef09c7 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -117,16 +117,16 @@ enum {
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN	= 0x5,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH	= 0x6,
 	MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII			= 0x7,
-	MV_V2_PORT_INTR_STS     = 0xf040,
-	MV_V2_PORT_INTR_MASK    = 0xf043,
-	MV_V2_PORT_INTR_STS_WOL_EN      = BIT(8),
-	MV_V2_MAGIC_PKT_WORD0   = 0xf06b,
-	MV_V2_MAGIC_PKT_WORD1   = 0xf06c,
-	MV_V2_MAGIC_PKT_WORD2   = 0xf06d,
+	MV_V2_PORT_INTR_STS		= 0xf040,
+	MV_V2_PORT_INTR_MASK		= 0xf043,
+	MV_V2_PORT_INTR_STS_WOL_EN	= BIT(8),
+	MV_V2_MAGIC_PKT_WORD0		= 0xf06b,
+	MV_V2_MAGIC_PKT_WORD1		= 0xf06c,
+	MV_V2_MAGIC_PKT_WORD2		= 0xf06d,
 	/* Wake on LAN registers */
-	MV_V2_WOL_CTRL          = 0xf06e,
-	MV_V2_WOL_CTRL_CLEAR_STS        = BIT(15),
-	MV_V2_WOL_CTRL_MAGIC_PKT_EN     = BIT(0),
+	MV_V2_WOL_CTRL			= 0xf06e,
+	MV_V2_WOL_CTRL_CLEAR_STS	= BIT(15),
+	MV_V2_WOL_CTRL_MAGIC_PKT_EN	= BIT(0),
 	/* Temperature control/read registers (88X3310 only) */
 	MV_V2_TEMP_CTRL		= 0xf08a,
 	MV_V2_TEMP_CTRL_MASK	= 0xc000,
-- 
2.32.0

