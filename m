Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613BA2EAD2D
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbhAEONB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:13:01 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:32889 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbhAEONB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:13:01 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4D9Dvs46tgz1qs3H;
        Tue,  5 Jan 2021 15:12:09 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4D9Dvs3dP7z1sFWx;
        Tue,  5 Jan 2021 15:12:09 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id dz9eAR1bR1Kw; Tue,  5 Jan 2021 15:12:08 +0100 (CET)
X-Auth-Info: 8Tk4KBYDPvmZHasO7l2mPJnUDtJjRrQfCgIi9YeDRIQ=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  5 Jan 2021 15:12:08 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next V3 1/2] net: phy: micrel: Add KS8851 PHY support
Date:   Tue,  5 Jan 2021 15:11:50 +0100
Message-Id: <20210105141151.122922-2-marex@denx.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105141151.122922-1-marex@denx.de>
References: <20210105141151.122922-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The KS8851 has a reduced internal PHY, which is accessible through its
registers at offset 0xe4. The PHY is compatible with KS886x PHY present
in Micrel switches, including the PHY ID Low/High registers swap, which
is present both in the MAC and the switch.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
---
V2: Merge the KSZ8851 and KS886X entries, as those PHYs cannot be discerned
V3: Add RB from Andrew
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54e0d75203da..39c7c786a912 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1389,7 +1389,7 @@ static struct phy_driver ksphy_driver[] = {
 }, {
 	.phy_id		= PHY_ID_KSZ886X,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-	.name		= "Micrel KSZ886X Switch",
+	.name		= "Micrel KSZ8851 Ethernet MAC or KSZ886X Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.suspend	= genphy_suspend,
-- 
2.29.2

