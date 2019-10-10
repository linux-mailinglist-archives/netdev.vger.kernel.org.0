Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8B7D3130
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfJJTNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:13:01 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58297 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfJJTNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:13:01 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46q1236rk0z1rGS3;
        Thu, 10 Oct 2019 21:12:59 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46q12367Vbz1qqkH;
        Thu, 10 Oct 2019 21:12:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id GdVv9lYdxDc2; Thu, 10 Oct 2019 21:12:58 +0200 (CEST)
X-Auth-Info: 5CrYEUNWxV1fk1lJEY/dH2Bhl5HGHkYsvABeSVoO+uI=
Received: from chi.lan (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 10 Oct 2019 21:12:58 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 2/2] net: phy: micrel: Update KSZ87xx PHY name
Date:   Thu, 10 Oct 2019 21:12:49 +0200
Message-Id: <20191010191249.2112-2-marex@denx.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010191249.2112-1-marex@denx.de>
References: <20191010191249.2112-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KSZ8795 PHY ID is in fact used by KSZ8794/KSZ8795/KSZ8765 switches.
Update the PHY ID and name to reflect that, as this family of switches
is commonly refered to as KSZ87xx

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/phy/micrel.c   | 4 ++--
 include/linux/micrel_phy.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54d483de024f..e6be7b2516f3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1170,9 +1170,9 @@ static struct phy_driver ksphy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8795,
+	.phy_id		= PHY_ID_KSZ87XX,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-	.name		= "Micrel KSZ8795",
+	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
diff --git a/include/linux/micrel_phy.h b/include/linux/micrel_phy.h
index ad24554f11f9..75f880c25bb8 100644
--- a/include/linux/micrel_phy.h
+++ b/include/linux/micrel_phy.h
@@ -31,7 +31,7 @@
 #define PHY_ID_KSZ886X		0x00221430
 #define PHY_ID_KSZ8863		0x00221435
 
-#define PHY_ID_KSZ8795		0x00221550
+#define PHY_ID_KSZ87XX		0x00221550
 
 #define	PHY_ID_KSZ9477		0x00221631
 
-- 
2.23.0

