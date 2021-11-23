Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C17845A893
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKWQoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234047AbhKWQnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:43:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A84160FD7;
        Tue, 23 Nov 2021 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685647;
        bh=pm89O6T7XMf9GJsbHn268oS26nRGu8hdc24kbn90W60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXvHnhYpvwplB5lJVRuvsgaxhHNY4sMyyQds1zIulvjOyGcjjdtCofVLCEaLjonZO
         yv9YqYYLZ+peecPR0YqksABX16JYAc11QG9wuUGMJ2qI8h1flL9RCyNakjSlC813SX
         dHQNlK0S7/KE66GKkog6vFm6rhg7DHQxPgmrckStZjwp3MtRWI6VOjnxicUG7Mr9aS
         6DQTh4Ga3u+soadoNliq6e6i4jMWvxy1jkx8P4Beu7vf9hdngr1E2KMTm+AZm5oEM/
         Zxx6FCl9jaTmsbS7xe+LDbfMOqIcJ4W2dtxEdHJVbb3rtlSp1GvSqpzG9jn22PPnX5
         xI20xkF76RTrw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>, davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 7/8] net: phy: marvell10g: Use tabs instead of spaces for indentation
Date:   Tue, 23 Nov 2021 17:40:26 +0100
Message-Id: <20211123164027.15618-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123164027.15618-1-kabel@kernel.org>
References: <20211123164027.15618-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some register definitions were defined with spaces used for indentation.
Change them to tabs.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
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

