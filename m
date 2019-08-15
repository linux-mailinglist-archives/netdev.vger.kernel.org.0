Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D8E8EAFF
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbfHOMEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:04:30 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44178 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731340AbfHOME1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:04:27 -0400
Received: by mail-wr1-f43.google.com with SMTP id p17so1984466wrf.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cv9AHUXZSTIXwb3zYOsS0REKv7j9Ec1lDg+1ePlQxpg=;
        b=ZAw+gRewbIXMvSKpzDkDBQkRe5bSx8jpM3yr5bh1gf9cMqZ+R6+z3acFcNcdJYTRqv
         mMwMOK9cVTrFCLT3fJAQe4wKu1WoTNZSpDmKlp6HLoTnovFL8Ah0LwSBOfLrusGCPGpE
         /fYKXUf5oAMTC1ttqOSCJP9fg5lQUL35x+nPF/2OD1LMXsg5HSlfReJV5Y8wynhfS4ay
         rPJ+xRj8L9UkgsgqhNK36qijyhdymtFHybxIexAxqmGoGwtGBzNnhG/b9ytZwU674l8F
         3QG/SzauClWbJ407RMhpLbVUV46Xx1S47dZw2LNGZX+jMGaDkppUj6j+yVcqdZNkABtf
         WiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cv9AHUXZSTIXwb3zYOsS0REKv7j9Ec1lDg+1ePlQxpg=;
        b=FW79j8esr81Tpjh1QexXAWy/rP6LgQuLoAVmQ4LXI9cLp0A8JIzEkGjVp8tOgLpKRk
         kj7kTJX5w4uu/ZJ4LExNjoFUA4j2J7sPUUSlvH9wpgOPzeUsE0T+iGPGVOt7eP6lZL4G
         EoKntMGz8bg2R0aLYx6FsrR3eo9/J2TFqRfeb6Yk3rkWSXFS/URoNG1VqJbI5ZP1qbbB
         VTFOVQ8Igy9WUFoEaouQmzf1JDDODjHiMatXUyE7kKjYnW82HSVcUNyBpakCSAJeevUq
         xyPMmfswsVhiY8ZbyoJSB7aOSJsXmFiQhkttlg0VnZJBKLhrXwGpsCoPcwfbztrauV0k
         E9uQ==
X-Gm-Message-State: APjAAAV/AvTmb5noYrIMAlRyx4+wUHvwLMAuLbREWtl3Tt3gBPZoFpSS
        DJH26Ng5pmxZl4MQ8by9hC4Kyuto
X-Google-Smtp-Source: APXvYqxSYV3uua4v60rpIk/MRfYu8bHWpMRlYwl3v4EAYZ1YQ4A295aHbnQ5Pk946m/c3BaPRl+ewA==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr5151799wro.31.1565870666080;
        Thu, 15 Aug 2019 05:04:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id t63sm1137065wmt.6.2019.08.15.05.04.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:04:25 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: remove genphy_config_init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
Message-ID: <d184d744-a7ed-b236-8c20-e928ae805234@gmail.com>
Date:   Thu, 15 Aug 2019 14:04:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
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
index 7e7393f3c..d347ddcac 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1895,57 +1895,6 @@ int genphy_soft_reset(struct phy_device *phydev)
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


