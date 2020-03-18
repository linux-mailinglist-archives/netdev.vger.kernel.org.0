Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABBC18A71A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCRVca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:32:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37616 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRVca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:32:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id w10so301476wrm.4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 14:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3eodPXLXtt5t8s46JrHKm7viP/pzc2GFuxyi3+xmNFs=;
        b=cIrQAaCSM4Da+AP0qH4Nr/xQUbvErL1UBJL1s6GIjF4YhnV6nsFD93kPD0FE1o0rmc
         8AubywY5lCVVbVNcvYYw3RKvHV9UqfyNRdHdMZg9NFzQeok5gGj8HFd9PEyJrijOFomy
         p27BwtyJC4UHn7vJeA7W4Ic1gUmnmM3oMkFlv9RXWA+nqJves6A/mehqYHE7npAf2cT/
         YcchWEHWl/jFXmvE/lnbyPu1jC1Q3gfWP2vLkNuWAEn3mF5oR490IdzRZ/rzN0B/xC57
         9cABrcgEryMd3dxq01IuXZo3xqE8Yw7iFApUisb9CpsbPOmLDqVffjq/FW44uG8P51vA
         NgfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3eodPXLXtt5t8s46JrHKm7viP/pzc2GFuxyi3+xmNFs=;
        b=otDQaxoaYJdch4T6/CZ8gkuZtcWgntANq+UmtPZGedvmjl6qGwp+oQejurkfU8m8ya
         2SWkzS/rvaXgV15HiKijwJ+04r66yrAHG5mRlLjlMNMC6vau1FXNlMOhXw0RnBQ+shKP
         A1vjLd3RZLVticAk4W0eITY6/e3wM0R67Koz3Iv3/Jbd986DJ3Gs+1X1XEqQAjPDZRd2
         ZWjFZIVHxFGBEQtC88MAAgglkJv0vOW/omlsnEidk8+fdgfJxhnC0Nel+m7akhQk3+0R
         BLwfjt7cr1H/US9Z0y1n0aoM4VQz6Gj3Qu1U93k9srF/JsO3+FJZknL7nb4nSLaYPxAK
         YdVg==
X-Gm-Message-State: ANhLgQ1GfNbMMTJqEIAJK3nDj+xl1BCz6JBeGC+jihGsJyNXgme/kwGs
        hTExAjFCH2quohfH6F2UuuwEOcCE
X-Google-Smtp-Source: ADFU+vvZIVhBk8lfmsm+Eui4HH43iOukwpqJ1HqzRG4MVohzV97S7PdlqQbwNPw9e/zAIU6XRS/dNQ==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr8236405wrn.29.1584567147021;
        Wed, 18 Mar 2020 14:32:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c8fb:eee:cf86:ecdf? (p200300EA8F296000C8FB0EEECF86ECDF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c8fb:eee:cf86:ecdf])
        by smtp.googlemail.com with ESMTPSA id p10sm146103wrx.81.2020.03.18.14.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 14:32:26 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: aquantia: remove downshift warning now
 that phylib takes care
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
Message-ID: <f721148c-ac1b-68a8-863b-4e197f28cdc2@gmail.com>
Date:   Wed, 18 Mar 2020 22:31:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
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
2.25.1


