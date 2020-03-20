Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0DC18D4F1
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCTQxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:53:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36004 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgCTQxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:53:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so2356568wrs.3
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+MklaXLqoXk/GebK1tKCuQnfkRb2dsVEmr27fUuHiow=;
        b=RlTx3bzJ6yIZ5aAOVDgLzlcmdgZhY0Pxrpq+yG7p/R9Aln1eKgoznbpFn1ILVlB/R0
         ITurSs/0+KsNBsJQR88CwKwupXt/0cHh6WVjq6QsqttxYbpYlCjVTa6GTduzoE3Xx7Hx
         Hxxj3978LZloQ4WjJ/TYxOIEeuhME2JWndQMyOhS4hT6mJgp9Vk4Vpr/yPsOuTV7TzoX
         RgCGNhzBYCUFtuIcp9N31KNURksgbZdIU5XC5QI23BZv2MP93gw/WeW+GGEkh967E3Xt
         afzLz+C/o/wxsRz5tTCSyQA3HyXaIVFe11jJQemJyuV52xjUw9Z/cMy2YgTIi8yAiQvK
         RDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+MklaXLqoXk/GebK1tKCuQnfkRb2dsVEmr27fUuHiow=;
        b=eha1XXxYv8Dg1KgUFS2T2LY4xgwfR8hus0u88HptriEOVwGpKBKyWu0l7+d6tAezLe
         BxY+75vKqND98eOQUKlPHJAygxNDbKDPUE3ZQnXB7AE1xRhpTTIaO+xNjbEVECkcKtiM
         5CcNTAT47t0ClyFMC+JybYa9GlklXa1N5MbXALZ6qie2w5LvQ9h6sKcNPEvHK2fQzb32
         /97hJ/uDdzPhmfH86K3Trigej558f2BhEAm4W+wQGDvpNvX/NEfri6WgMq580mfBIvJz
         eh361HRc+FDerhuRsW8TDbu33phMjhVRyIAI3hwuMLstedP1W1OQwTmQCa/wuDRwMn+Q
         rHQw==
X-Gm-Message-State: ANhLgQ3XeMqX4H/8MH7uRBsaJj4qhuxINuOvb5xeUCsijALiGGElMJNY
        KwK2UB7g7eq+lCJLvLLz+H6f+0vv
X-Google-Smtp-Source: ADFU+vvGnlBtFXVKqr/i6PmWVcNHH7K/Z2ukcUXShwJW0++b8tQd1eGmJ069ubbBlDBHgaoABgpblQ==
X-Received: by 2002:adf:b6a5:: with SMTP id j37mr11802331wre.412.1584723192643;
        Fri, 20 Mar 2020 09:53:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b52a:38f:362f:3e41? (p200300EA8F296000B52A038F362F3E41.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b52a:38f:362f:3e41])
        by smtp.googlemail.com with ESMTPSA id x3sm7457517wmx.44.2020.03.20.09.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 09:53:12 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] net: phy: aquantia: remove downshift warning
 now that phylib takes care
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Message-ID: <d30a90a0-17e4-b14f-ba71-6deff1475e5e@gmail.com>
Date:   Fri, 20 Mar 2020 17:52:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that phylib notifies the user of a downshift we can remove
this functionality from the driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/aquantia_main.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 31927b2c7..837d5eaf9 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -290,17 +290,6 @@ static int aqr_read_status(struct phy_device *phydev)
 	return genphy_c45_read_status(phydev);
 }
 
-static int aqr107_read_downshift_event(struct phy_device *phydev)
-{
-	int val;
-
-	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_TX_VEND_INT_STATUS1);
-	if (val < 0)
-		return val;
-
-	return !!(val & MDIO_AN_TX_VEND_INT_STATUS1_DOWNSHIFT);
-}
-
 static int aqr107_read_rate(struct phy_device *phydev)
 {
 	int val;
@@ -377,13 +366,7 @@ static int aqr107_read_status(struct phy_device *phydev)
 		break;
 	}
 
-	val = aqr107_read_downshift_event(phydev);
-	if (val <= 0)
-		return val;
-
-	phydev_warn(phydev, "Downshift occurred! Cabling may be defective.\n");
-
-	/* Read downshifted rate from vendor register */
+	/* Read possibly downshifted rate from vendor register */
 	return aqr107_read_rate(phydev);
 }
 
@@ -506,9 +489,6 @@ static int aqr107_config_init(struct phy_device *phydev)
 	if (!ret)
 		aqr107_chip_info(phydev);
 
-	/* ensure that a latched downshift event is cleared */
-	aqr107_read_downshift_event(phydev);
-
 	return aqr107_set_downshift(phydev, MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT);
 }
 
@@ -533,9 +513,6 @@ static int aqcs109_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	/* ensure that a latched downshift event is cleared */
-	aqr107_read_downshift_event(phydev);
-
 	return aqr107_set_downshift(phydev, MDIO_AN_VEND_PROV_DOWNSHIFT_DFLT);
 }
 
-- 
2.25.2


