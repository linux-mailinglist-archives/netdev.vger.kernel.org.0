Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBCC3D3BC1
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhGWNph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 09:45:37 -0400
Received: from ns.kevlo.org ([220.134.220.36]:22421 "EHLO mail.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235094AbhGWNpg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 09:45:36 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2021 09:45:35 EDT
Received: from localhost (ns.kevlo.org [local])
        by ns.kevlo.org (OpenSMTPD) with ESMTPA id d2a0256b;
        Fri, 23 Jul 2021 21:59:27 +0800 (CST)
Date:   Fri, 23 Jul 2021 21:59:27 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phy: broadcom: re-add check for
 PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
Message-ID: <YPrLPwLXwk2zweMw@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore PHY_ID_BCM54811 accidently removed by commit 5d4358ede8eb.

Fixes: 5d4358ede8eb ("net: phy: broadcom: Allow BCM54210E to configure APD")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 7bf3011b8e77..83aea5c5cd03 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -288,7 +288,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	if (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) {
 		if (BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E ||
 		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54810 ||
-		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54210E)
+		    BRCM_PHY_MODEL(phydev) == PHY_ID_BCM54811)
 			val |= BCM54XX_SHD_SCR3_RXCTXC_DIS;
 		else
 			val |= BCM54XX_SHD_SCR3_TRDDAPD;
