Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6F418D4F2
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgCTQxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:53:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45368 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbgCTQxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:53:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id t7so3663673wrw.12
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 09:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=buaZhoVDOuQOoO70UnpiVP0JWaiXNW88GGXb36tLmCQ=;
        b=NXBC9fluppLSAO0yivDffuLa8bTaG6Wt8cLKtKg5qNfd4FkMSo2l0ssYJfVmccGofZ
         f1F5x+g0tOhl6arY3d4Ot5QLGYsipq8uTaTCswe7g60Kvd034a7jE5LrCfbUtjS3dKSW
         WlSyEvh0jNHU0P6/ECyZlm9kG/CtbScv9vKJVx8dS+SZPWIakDh0nvclLryzdLWN2nLa
         DlznHsrf8P+jJxcGMdKOAet3u024btxglfAY1ZEwlZR9o2k+uazwqvV7XKoSHBevTLNn
         DhAEiVRT0XSh4QxWeEKZHm3vHtj4eESdoC63i8Z0DTj456NncyvTi/3wRDT58oTFnqIr
         SHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=buaZhoVDOuQOoO70UnpiVP0JWaiXNW88GGXb36tLmCQ=;
        b=JJ9a62hqdDxKaSW/gPl1ws3r/4m5tfA/3ZsEdideQvAf2nRN+6iIu6ssxPLEbxAFlE
         XIk4isbYAvsyyZ+7tE9FM2gxgR4ivUkZLa2T/I7t3XZNExOBTqniQ8EgX+bWo1xDXgrL
         x2AsDltmqF3XjK0tprzbu9Oii2NWIdQUZNRGhPmkaJKy/oj87uLKFPOFGaXYPj9L+hoi
         0798iBwmTk2mTgQrldE9pU0BIW0F6wYx8HKrU7tHBwA0p8CQwoRZlKVUFwcaa+MqUzUd
         AubwP7xuR1oX6NwHRjbcevwz3wQQ3pt1aTx2LphLsGiU692yD/Vz2aRExPglis2inDXo
         zpcg==
X-Gm-Message-State: ANhLgQ1k0IebejFApOE+/9F+nZVODVtBXLckcWL93nELbE7ynLCD0ayO
        ODj6fQoJYlAV0dNZmiTqLvVv7Z/M
X-Google-Smtp-Source: ADFU+vvCXvbA3SDNW/tWPze8bYt2O5a+WPyozwfDG18q8PV/jL+MRzxZ2+nJSKyVQe/1n1tfe2qqwg==
X-Received: by 2002:adf:cd0c:: with SMTP id w12mr11671391wrm.234.1584723191537;
        Fri, 20 Mar 2020 09:53:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b52a:38f:362f:3e41? (p200300EA8F296000B52A038F362F3E41.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b52a:38f:362f:3e41])
        by smtp.googlemail.com with ESMTPSA id i21sm8781625wmb.23.2020.03.20.09.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 09:53:11 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] net: phy: marvell: remove downshift warning
 now that phylib takes care
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
Message-ID: <cefb0257-7b97-71dd-5dad-83fb02caf1bd@gmail.com>
Date:   Fri, 20 Mar 2020 17:52:10 +0100
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
2.25.2


