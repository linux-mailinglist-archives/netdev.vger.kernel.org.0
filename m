Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F831DD8E2
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 15:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfJSN6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 09:58:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50512 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfJSN6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 09:58:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so8866691wmg.0
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 06:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qtxt7B7KA2VfLWmb1pVzJwBoi1XxopBMH+6YQ2q2JfE=;
        b=CQg6QTilPSxT/j4jz+2zYPzXH3hE7wm1QUmYKUVqtyaLeZJqGHg0r6yD0VD3B0Vl/w
         KtMHOakjXNPmbvkIwtzuKV/fZnkeHw328lH2EZ1i6iHfiRuZXLG/LR4aDtfFA2bqmNnz
         E0NWpych/DgsNjONzzdt8CbY2UgyMbdV4F/FkUDcsEqfV5vicIuUrKnX7vNXeVV0OzVL
         9PJqYj9706pJesbczCLoOUO6P+dBtr6w8INJLsJddMxvG3Qsr4TrN11qKUhJKGjy6GvR
         hNWPwyS9p9pa85A/Ab04u9nQPAh7j50nbOCHofUMsNt32xvRbscAibQuvG0skWNmg8HI
         hK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qtxt7B7KA2VfLWmb1pVzJwBoi1XxopBMH+6YQ2q2JfE=;
        b=EnV9UbU9ZTgDEOinmpnirryWhnf0IEYsbR7AUt0AxArfxhMPayeN/CcaodkULVfKse
         cRMKxzV+V3ZlJHuabBYaS0j023YVFPfRd5VNxT2VKgsWH1eC7l1+F2Q7v/4q1uUcJdbU
         OghFlnZe5czyhvSrTtFGmKhlIhRvmxHZIAovepXkY/WzcsGSnnanhOFcYDwFJ6Q0w5Ds
         107x0B6KHILHKgDkBr8sg/TDG0M+EwgIv1OygcpeQtBGTYOQ2FhhAE6WFGTtEq2RA1hs
         q0BaFMcOisq5o3EsM4vV0jKMUi1AlOzxyZDvvKHNd5dj56mbypeuGtGoZrxyQomVPl4g
         9WWw==
X-Gm-Message-State: APjAAAU9Y7dy+DIBvA19+5aJYnVwr5hzi9zPhhmikPuGTIJlwKZzE9+z
        JRHAnrKdPlC0IKc6EXg60fl3IhPf
X-Google-Smtp-Source: APXvYqzXM+dc/rRDI7yeEbYzkQqB8++DONXgNLsbylKpmviK6NrSEC2TJCdXTzgS8BzQBzPOx6hhVQ==
X-Received: by 2002:a1c:1f4b:: with SMTP id f72mr2267817wmf.22.1571493512093;
        Sat, 19 Oct 2019 06:58:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:cd3d:5fcd:4de0:e061? (p200300EA8F266400CD3D5FCD4DE0E061.dip0.t-ipconnect.de. [2003:ea:8f26:6400:cd3d:5fcd:4de0:e061])
        by smtp.googlemail.com with ESMTPSA id b5sm8049117wmj.18.2019.10.19.06.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 06:58:31 -0700 (PDT)
Subject: [PATCH net-next 2/2] net: phy: marvell: remove superseded function
 marvell_set_downshift
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
Message-ID: <0834faf8-3b65-945c-ffc3-6237370cacc9@gmail.com>
Date:   Sat, 19 Oct 2019 15:58:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <85961f9a-999c-743d-3fd2-66c10e7a219e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of superseded function marvell_set_downshift() we can use new
function m88e1111_set_downshift() in m88e1116r_config_init().
For this m88e1116r_config_init() has to be moved in the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/marvell.c | 88 ++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 53 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bd9bc0b4c..1b574fcee 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -53,7 +53,6 @@
 
 #define MII_M1011_PHY_SCR			0x10
 #define MII_M1011_PHY_SCR_DOWNSHIFT_EN		BIT(11)
-#define MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT	12
 #define MII_M1011_PHY_SRC_DOWNSHIFT_MASK	GENMASK(14, 12)
 #define MII_M1011_PHY_SCR_DOWNSHIFT_MAX		8
 #define MII_M1011_PHY_SCR_MDI			(0x0 << 5)
@@ -277,23 +276,6 @@ static int marvell_set_polarity(struct phy_device *phydev, int polarity)
 	return val != reg;
 }
 
-static int marvell_set_downshift(struct phy_device *phydev, bool enable,
-				 u8 retries)
-{
-	int reg;
-
-	reg = phy_read(phydev, MII_M1011_PHY_SCR);
-	if (reg < 0)
-		return reg;
-
-	reg &= MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
-	reg |= ((retries - 1) << MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT);
-	if (enable)
-		reg |= MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-
-	return phy_write(phydev, MII_M1011_PHY_SCR, reg);
-}
-
 static int marvell_config_aneg(struct phy_device *phydev)
 {
 	int changed = 0;
@@ -662,41 +644,6 @@ static int marvell_config_init(struct phy_device *phydev)
 	return marvell_of_reg_init(phydev);
 }
 
-static int m88e1116r_config_init(struct phy_device *phydev)
-{
-	int err;
-
-	err = genphy_soft_reset(phydev);
-	if (err < 0)
-		return err;
-
-	msleep(500);
-
-	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
-	if (err < 0)
-		return err;
-
-	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
-	if (err < 0)
-		return err;
-
-	err = marvell_set_downshift(phydev, true, 8);
-	if (err < 0)
-		return err;
-
-	if (phy_interface_is_rgmii(phydev)) {
-		err = m88e1121_config_aneg_rgmii_delays(phydev);
-		if (err < 0)
-			return err;
-	}
-
-	err = genphy_soft_reset(phydev);
-	if (err < 0)
-		return err;
-
-	return marvell_config_init(phydev);
-}
-
 static int m88e3016_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -910,6 +857,41 @@ static void m88e1111_link_change_notify(struct phy_device *phydev)
 		phydev_warn(phydev, "Downshift occurred! Cabling may be defective.\n");
 }
 
+static int m88e1116r_config_init(struct phy_device *phydev)
+{
+	int err;
+
+	err = genphy_soft_reset(phydev);
+	if (err < 0)
+		return err;
+
+	msleep(500);
+
+	err = marvell_set_page(phydev, MII_MARVELL_COPPER_PAGE);
+	if (err < 0)
+		return err;
+
+	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
+	if (err < 0)
+		return err;
+
+	err = m88e1111_set_downshift(phydev, 8);
+	if (err < 0)
+		return err;
+
+	if (phy_interface_is_rgmii(phydev)) {
+		err = m88e1121_config_aneg_rgmii_delays(phydev);
+		if (err < 0)
+			return err;
+	}
+
+	err = genphy_soft_reset(phydev);
+	if (err < 0)
+		return err;
+
+	return marvell_config_init(phydev);
+}
+
 static int m88e1318_config_init(struct phy_device *phydev)
 {
 	if (phy_interrupt_is_valid(phydev)) {
-- 
2.23.0


