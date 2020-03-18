Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A9718A719
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgCRVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:32:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33975 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCRVca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:32:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id x3so3289046wmj.1
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 14:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5B/qNdY0WNZGNcZ4e+FIr5yzavXE++f/Ppts/oFfCQU=;
        b=fEy88gORjVRZZpuEnSPl3PpLpjcWmsx3bLV32ZwL4/n1PbI5RljCuIFMpbxqVhtdwI
         0ypsoqgxbT9sEfJiUCEf1AuWFz6nU5dTSwEwccYQ7Z09VP7PuNdYDw2YUZ8SL9s7AmR/
         I+wQstjHArY0lnl7bQdF3HH/38O6W7YGBDzPqgU6a62H66v/nEClzLwoZx803ZCEZp0h
         24TNvNh95CJtmhwB6FIB7mHib3qaQjSlAc347b2Kor2v2UbxUVlxSHMBLA3HnHy4z5Dw
         wiS6dSePqnkVt4jFOXummduLNx6gXZNTezmlXXu1PiVksAOtfseUSDYWxXl6Jm7wOS5Z
         BPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5B/qNdY0WNZGNcZ4e+FIr5yzavXE++f/Ppts/oFfCQU=;
        b=kyLcEHKk9wHLaK/FPXOiO+0m8EPpmZEm3Wd/wympZZPOH3cbgeFNeaVFkUKvf4wHYx
         cx1WO8scIrINxNi6iwuhwK/39lrT4RoekEaiBHwY0PENru45Aw4nm7cz6vfYtPjlaMlS
         r84BbqUpzCogiOH2YSM4JDK5mjV6cTz1RWjUEfJrKQkWQwpuTNw7xn2YubmwpXr5kqQK
         didYmDxBTmXGzmiAcQkDn+68f9M6JnvmC0swUeVo/xyHmse93jN7T1mwCBJEVjDeprml
         0xOCYtiYJgh/Akg9jP+jNAQNBpthNnO9Rf6Abre4dI/GitDCqejGn3C8lbEIrmNhxKwm
         qWgg==
X-Gm-Message-State: ANhLgQ0dx1Z7VSgR7/65E/AyD2Btms+ttMRoWg/WZ35a9zOUyufxUqF6
        VT4ydAPI/8asateaIijCLK17AsiV
X-Google-Smtp-Source: ADFU+vvFEP/Ht0kMJDjBjaIZztVefMa4vkmFmd+E6rfiJ8P21Dc62HbPnAWmUoyqsHbaIl5uoOkxNg==
X-Received: by 2002:a1c:4d7:: with SMTP id 206mr7130077wme.5.1584567145948;
        Wed, 18 Mar 2020 14:32:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c8fb:eee:cf86:ecdf? (p200300EA8F296000C8FB0EEECF86ECDF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c8fb:eee:cf86:ecdf])
        by smtp.googlemail.com with ESMTPSA id o16sm190829wrs.44.2020.03.18.14.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 14:32:25 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: phy: marvell: remove downshift warning now
 that phylib takes care
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
Message-ID: <ac35c144-d8b8-2a3f-9b85-ace1e230d9ec@gmail.com>
Date:   Wed, 18 Mar 2020 22:29:57 +0100
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
 drivers/net/phy/marvell.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 9a8badafe..4714ca0e0 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -867,21 +867,6 @@ static int m88e1011_set_tunable(struct phy_device *phydev,
 	}
 }
 
-static void m88e1011_link_change_notify(struct phy_device *phydev)
-{
-	int status;
-
-	if (phydev->state != PHY_RUNNING)
-		return;
-
-	/* we may be on fiber page currently */
-	status = phy_read_paged(phydev, MII_MARVELL_COPPER_PAGE,
-				MII_M1011_PHY_SSR);
-
-	if (status > 0 && status & MII_M1011_PHY_SSR_DOWNSHIFT)
-		phydev_warn(phydev, "Downshift occurred! Cabling may be defective.\n");
-}
-
 static int m88e1116r_config_init(struct phy_device *phydev)
 {
 	int err;
@@ -2201,7 +2186,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1111,
@@ -2223,7 +2207,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1111_get_tunable,
 		.set_tunable = m88e1111_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1118,
@@ -2264,7 +2247,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1318S,
@@ -2308,7 +2290,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1111_get_tunable,
 		.set_tunable = m88e1111_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1149R,
@@ -2364,7 +2345,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1510,
@@ -2390,7 +2370,6 @@ static struct phy_driver marvell_drivers[] = {
 		.set_loopback = genphy_loopback,
 		.get_tunable = m88e1011_get_tunable,
 		.set_tunable = m88e1011_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -2413,7 +2392,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -2436,7 +2414,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -2479,7 +2456,6 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.get_tunable = m88e1540_get_tunable,
 		.set_tunable = m88e1540_set_tunable,
-		.link_change_notify = m88e1011_link_change_notify,
 	},
 };
 
-- 
2.25.1


