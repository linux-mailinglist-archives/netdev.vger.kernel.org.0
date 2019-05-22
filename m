Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8224226A16
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfEVStl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:49:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43583 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729611AbfEVStk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 14:49:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZEZKUQFTamLteogtN3PFA6d4TsK9pp6yKGKqBHc0dOA=; b=k4zvZ4saSaiiJSAkv+RGtXrduL
        qKPdXOrhmoJjb/hAUOjJJJbN8WuSXrF3Bj+Wy7zVbZLT/vJbv2U+VwRWv32rwA4vKYYVeMP+Vm5jH
        pHObuoVDXD/3glnFli9Qwap5muI2LBmd2/3DB9fipW0IHpLNpdfo/8Q9GX0zDMvMAA1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWGr-0001t8-8P; Wed, 22 May 2019 20:47:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: phy: Make phy_basic_t1_features use base100t1.
Date:   Wed, 22 May 2019 20:47:04 +0200
Message-Id: <20190522184704.7195-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522184704.7195-1-andrew@lunn.ch>
References: <20190522184704.7195-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that there is a link mode for 100BaseT1, use it in
phy_basic_t1_features so T1 PHY drivers will indicate this mode via
the Ethtool API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dcc93a873174..5d288da9a3b0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(phy_10_100_features_array);
 
 const int phy_basic_t1_features_array[2] = {
 	ETHTOOL_LINK_MODE_TP_BIT,
-	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+	ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
 };
 EXPORT_SYMBOL_GPL(phy_basic_t1_features_array);
 
-- 
2.20.1

