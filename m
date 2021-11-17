Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C995F4550D6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241518AbhKQWyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241485AbhKQWyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 17:54:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC3EC61B93;
        Wed, 17 Nov 2021 22:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637189468;
        bh=whK1wt/Uk1I5jN9W5WcTntaGF28yC0dQ4k4Bl9OH6Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFp5m/6XDpAtwkB0LJGKP1K6DenAvmzOsA2suEq1VhwaKd9g9Bj3hERW8tWCBTC57
         by8kdLhLPbGsZrJOxQ4gXSooZdZkRhm3KcoHfZVoeN7iCbekZHNZmUON8njCpzf2lS
         Yr0lD2UWxxKSgpkfP442R9bCrHk1CaePUEf4geRRWyOQsX0br1Yh8w6FEY7OVe9MmO
         InmMAIN3sDQnOqBvM301gqgF3Gn/bP5XI3RTUNn6RNJpgXhyX65Mb8gPWKxM0g8lR2
         i/AeSR+hQUcbBs93P03hq+Hb/udcYwmc80vtvEaasAl7yDrcw4Aidefk+F6QwdLYz1
         0bXO6GJc1L/zg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 7/8] net: phy: marvell10g: Use tabs instead of spaces for indentation
Date:   Wed, 17 Nov 2021 23:50:49 +0100
Message-Id: <20211117225050.18395-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117225050.18395-1-kabel@kernel.org>
References: <20211117225050.18395-1-kabel@kernel.org>
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

