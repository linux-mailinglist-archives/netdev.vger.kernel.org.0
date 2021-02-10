Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F565317201
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhBJVJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:09:45 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42407 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbhBJVJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:09:02 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7990323E73;
        Wed, 10 Feb 2021 22:08:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612991298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UpL4V9o/g1ZEzgTRTKGihsAOBF2EZFW47qT5eRSu6k0=;
        b=OIt5bVB013h/dvuwee7JEXdalBm4FukqUeNgXtnq4MytnBEDjVlTclKHZNTB4jjHZnldRd
        +wKlcQpyQ9nApkhJOYA2pzGqz/77IhLxk0Sp7Rxu78VUrGlQ8IJdeaTzsCuIc2PKsuA8nH
        f/U65Xangx6vBBRJaaeuZR9ZoJZXQU4=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 3/9] net: phy: icplus: drop address operator for functions
Date:   Wed, 10 Feb 2021 22:08:03 +0100
Message-Id: <20210210210809.30125-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210210809.30125-1-michael@walle.cc>
References: <20210210210809.30125-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't sometimes use the address operator and sometimes not. Drop it and
make the code look uniform.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes since v2:
 - none

Changes since v1:
 - none

 drivers/net/phy/icplus.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index ae3cf61c5ac2..43b69addc0ce 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -336,16 +336,16 @@ static struct phy_driver icplus_driver[] = {
 	PHY_ID_MATCH_MODEL(IP175C_PHY_ID),
 	.name		= "ICPlus IP175C",
 	/* PHY_BASIC_FEATURES */
-	.config_init	= &ip175c_config_init,
-	.config_aneg	= &ip175c_config_aneg,
-	.read_status	= &ip175c_read_status,
+	.config_init	= ip175c_config_init,
+	.config_aneg	= ip175c_config_aneg,
+	.read_status	= ip175c_read_status,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
 	PHY_ID_MATCH_MODEL(IP1001_PHY_ID),
 	.name		= "ICPlus IP1001",
 	/* PHY_GBIT_FEATURES */
-	.config_init	= &ip1001_config_init,
+	.config_init	= ip1001_config_init,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -355,7 +355,7 @@ static struct phy_driver icplus_driver[] = {
 	.probe		= ip101a_g_probe,
 	.config_intr	= ip101a_g_config_intr,
 	.handle_interrupt = ip101a_g_handle_interrupt,
-	.config_init	= &ip101a_g_config_init,
+	.config_init	= ip101a_g_config_init,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 } };
-- 
2.20.1

