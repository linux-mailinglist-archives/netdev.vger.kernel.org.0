Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2659097C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfHPUcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:32:41 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:34898 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbfHPUck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:32:40 -0400
Received: by mail-wr1-f47.google.com with SMTP id k2so2690185wrq.2
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 13:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mx9+lMjWlDBJoaKKItBGduSQiKJLy0OqvNV+u7gJVo=;
        b=t7+fzq1L9xHD7bUCZ2AX6xvXFGTs4mIrL0yG57pxQA4WQwa6AP7SF1s4nLVW00zseR
         kgDtLgAm3OjfYz7ibBZdA+qqiG4AVbRF2uQC0Pjr5Mzyb5gqvDaTkgBuvu7xx1VP7Xpk
         gifvoLx2mKPXdA92QhIRuBS/nb7BSUTvvxbRTMDditE7YvlYWN2hx5YDMbEGsv9vpPIw
         hoZxSnNvNIUwS6JldXljosGwu02P5mslm1oAMm5wrO9hBdUwBtlMYYh9Ld+M/FTd13ky
         Sgqw/6uri/dfkjMPon/AuItkL0/IUtiTM4+NdLTNtva7BtY4NIXEjbNVdNxKk8KMGVzl
         7G0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mx9+lMjWlDBJoaKKItBGduSQiKJLy0OqvNV+u7gJVo=;
        b=WOCkKr3fhuBV76WRVoTOwdFS0tY6U3AoJl/BmoiE1fUrVWMCv5HaW29kKckBjiBn5Q
         OKts/2WBhMDMawLtvoL6sABfLse0JUWfnskea5Dr0dSO+pxWavc4n3hVZZTQ/sipUti/
         7kG8LidPYuQYdCBbaRF1sUNmHPEjEXPdMCyPdEA8GuEJps8+zqL+r32M+unR/44sCpox
         1vP2BXqw/60mO4Vhh1wXHHWVjsCgjmz2WjY8Z2IoD+gH3pKE0LUIGktrfxQ0wsY6AgLX
         7XnqlM1IaqpxasfuGvEjVkiMTh3iDdomhSP/ijChgpIz7uQ/Wue9EvWqIEoZY48v3B12
         CGzw==
X-Gm-Message-State: APjAAAU/gyFprcfb9+unhqtxdxSCswk4WzIc46ChcRNQmOhpiGceavxi
        k10tLjRlhvW0T2kDPJU9d8c=
X-Google-Smtp-Source: APXvYqxG65IYpoM1P7kDNVmZsnLwm7l5pbnGfBY5HWJ7PvBsDfsQ0vI/ZG2Zy3jBrjaLR6DoWgEhMg==
X-Received: by 2002:adf:eccb:: with SMTP id s11mr12654945wro.351.1565987558024;
        Fri, 16 Aug 2019 13:32:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id t63sm5004055wmt.6.2019.08.16.13.32.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 13:32:37 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] net: phy: remove genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
Message-ID: <6c657d36-97e5-0feb-ddf2-a59e4c38c437@gmail.com>
Date:   Fri, 16 Aug 2019 22:32:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
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


