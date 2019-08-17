Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D630591000
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfHQKa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:30:57 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43731 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfHQKa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:30:56 -0400
Received: by mail-wr1-f51.google.com with SMTP id y8so3878779wrn.10
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 03:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mx9+lMjWlDBJoaKKItBGduSQiKJLy0OqvNV+u7gJVo=;
        b=MMpoJ1s3hl+YCY/O/+iO5aFEjJIhx0Zx+nnq9j+5cg/Z6ItNbYtyqKwb2JnYJArPw4
         RmJXKmk0TBTsgnTVyDuM0bza7GR7ikwVXNFRwkVCwQUva0CTFedOUUyZAxvobOJKsiys
         lwVwvens0SeuCnNF2e9M4cEsg/sGbKRJWFQTzeZ8L2nYxGZa3mcNK+NMz99SYQt2L3S2
         3421csqjHs3xkWEC+8i2EzZi5ozDs9yRuxcozKxgXkh2kAzHYoqQBSV7qFlMCvysWhO6
         jro/wxp7bOaZCBFCFrnPNwWMeK4UzO6a7OY458ktK1SKIGstTa1eyKON8TeaWdUM0LKE
         /aqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mx9+lMjWlDBJoaKKItBGduSQiKJLy0OqvNV+u7gJVo=;
        b=aV+8oeaJJY0z6FFcogpPweM5q0V+Np9CsGQtoBfVPiJmSBNlvICldxSpCAu9yO9EiZ
         nBhpo9nD7H8bsO8WqWgtvyrKQYhFJ09h/3Ku/O4KHrb/uS7f6QFHUqKclWdRiiA6A1Hl
         61+F0LGSPPzeLsnnxSQHPh1LLxn/iYcCSNa1OQOw4TdAvBcc/As9sRqEWhMjIPDHZZ6J
         KNqO4yI6IvS07GirmASv87dqxS4gvgOcKkpuoCnY5OgMiUxpcF1uzUkkWne4xAdzE78g
         x/M/LGzbwgpFOCwr5D6MLVFsN6Do2lMb6rwRMavOA4qrBowKJoJEhr5gfKblohRvatso
         7uNA==
X-Gm-Message-State: APjAAAV8lhDMNcbGlJg9+sCQwB5yExLKfIt0EdPeC/jtxUSmTQgjZQ94
        vUmPcfzdPPE7YLs2yDrvoGVh/v8H
X-Google-Smtp-Source: APXvYqwlp+wp6qr873QNLi0m4K/JX4aMGCSQALpg/v34GTsAWnRmrdSr1OXJbsMLzW6Jef8Opwmpeg==
X-Received: by 2002:adf:e3ce:: with SMTP id k14mr14595013wrm.303.1566037854510;
        Sat, 17 Aug 2019 03:30:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:ec01:10b1:c9a3:2488? (p200300EA8F47DB00EC0110B1C9A32488.dip0.t-ipconnect.de. [2003:ea:8f47:db00:ec01:10b1:c9a3:2488])
        by smtp.googlemail.com with ESMTPSA id o14sm13545547wrg.64.2019.08.17.03.30.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 03:30:54 -0700 (PDT)
Subject: [PATCH net-next v3 3/3] net: phy: remove genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Message-ID: <a65b09d1-b0f8-b4fe-84e9-902d32ce26bc@gmail.com>
Date:   Sat, 17 Aug 2019 12:30:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all users have been removed we can remove genphy_config_init.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 51 ------------------------------------
 include/linux/phy.h          |  1 -
 2 files changed, 52 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9c546bae9..d5db7604d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1885,57 +1885,6 @@ int genphy_soft_reset(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_soft_reset);
 
-int genphy_config_init(struct phy_device *phydev)
-{
-	int val;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(features) = { 0, };
-
-	linkmode_set_bit_array(phy_basic_ports_array,
-			       ARRAY_SIZE(phy_basic_ports_array),
-			       features);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, features);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, features);
-
-	/* Do we support autonegotiation? */
-	val = phy_read(phydev, MII_BMSR);
-	if (val < 0)
-		return val;
-
-	if (val & BMSR_ANEGCAPABLE)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, features);
-
-	if (val & BMSR_100FULL)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, features);
-	if (val & BMSR_100HALF)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, features);
-	if (val & BMSR_10FULL)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, features);
-	if (val & BMSR_10HALF)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, features);
-
-	if (val & BMSR_ESTATEN) {
-		val = phy_read(phydev, MII_ESTATUS);
-		if (val < 0)
-			return val;
-
-		if (val & ESTATUS_1000_TFULL)
-			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
-					 features);
-		if (val & ESTATUS_1000_THALF)
-			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
-					 features);
-		if (val & ESTATUS_1000_XFULL)
-			linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
-					 features);
-	}
-
-	linkmode_and(phydev->supported, phydev->supported, features);
-	linkmode_and(phydev->advertising, phydev->advertising, features);
-
-	return 0;
-}
-EXPORT_SYMBOL(genphy_config_init);
-
 /**
  * genphy_read_abilities - read PHY abilities from Clause 22 registers
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5ac7d2137..d26779f1f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1069,7 +1069,6 @@ void phy_attached_print(struct phy_device *phydev, const char *fmt, ...)
 void phy_attached_info(struct phy_device *phydev);
 
 /* Clause 22 PHY */
-int genphy_config_init(struct phy_device *phydev);
 int genphy_read_abilities(struct phy_device *phydev);
 int genphy_setup_forced(struct phy_device *phydev);
 int genphy_restart_aneg(struct phy_device *phydev);
-- 
2.22.1


