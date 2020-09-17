Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAE26D0C5
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIQBqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 21:46:21 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47585 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgIQBqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 21:46:18 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 21:46:16 EDT
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 08H1dJ9Y1015685, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb05.realtek.com.tw[172.21.6.98])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 08H1dJ9Y1015685
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Sep 2020 09:39:19 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 17 Sep 2020 09:39:19 +0800
Received: from localhost.localdomain (172.21.179.130) by
 RTEXMB04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 17 Sep 2020 09:39:18 +0800
From:   Willy Liu <willy.liu@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <linux@armlinux.org.uk>,
        <kuba@kernel.org>, <ryankao@realtek.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>
Subject: [PATCH] net: phy: realtek: Replace 2.5Gbps name from RTL8125 to RTL8226
Date:   Thu, 17 Sep 2020 09:39:08 +0800
Message-ID: <1600306748-3176-1-git-send-email-willy.liu@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.179.130]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to PHY ID, 0x001cc800 should be named "RTL8226 2.5Gbps PHY"
and 0x001cc840 should be named "RTL8226B_RTL8221B 2.5Gbps PHY".
RTL8125 is not a single PHY solution, it integrates PHY/MAC/PCIE bus
controller and embedded memory.

Signed-off-by: Willy Liu <willy.liu@realtek.com>
---
 drivers/net/phy/realtek.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)
 mode change 100644 => 100755 drivers/net/phy/realtek.c

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
old mode 100644
new mode 100755
index 95dbe5e..a98b09d
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -400,7 +400,7 @@ static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
-static int rtl8125_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+static int rtl822x_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
 {
 	int ret = rtlgen_read_mmd(phydev, devnum, regnum);
 
@@ -424,7 +424,7 @@ static int rtl8125_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
 	return ret;
 }
 
-static int rtl8125_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+static int rtl822x_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 			     u16 val)
 {
 	int ret = rtlgen_write_mmd(phydev, devnum, regnum, val);
@@ -441,7 +441,7 @@ static int rtl8125_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
 	return ret;
 }
 
-static int rtl8125_get_features(struct phy_device *phydev)
+static int rtl822x_get_features(struct phy_device *phydev)
 {
 	int val;
 
@@ -459,7 +459,7 @@ static int rtl8125_get_features(struct phy_device *phydev)
 	return genphy_read_abilities(phydev);
 }
 
-static int rtl8125_config_aneg(struct phy_device *phydev)
+static int rtl822x_config_aneg(struct phy_device *phydev)
 {
 	int ret = 0;
 
@@ -479,7 +479,7 @@ static int rtl8125_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, ret);
 }
 
-static int rtl8125_read_status(struct phy_device *phydev)
+static int rtl822x_read_status(struct phy_device *phydev)
 {
 	int ret;
 
@@ -521,7 +521,7 @@ static int rtlgen_match_phy_device(struct phy_device *phydev)
 	       !rtlgen_supports_2_5gbps(phydev);
 }
 
-static int rtl8125_match_phy_device(struct phy_device *phydev)
+static int rtl8226_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->phy_id == RTL_GENERIC_PHYID &&
 	       rtlgen_supports_2_5gbps(phydev);
@@ -626,29 +626,29 @@ static int rtlgen_resume(struct phy_device *phydev)
 		.read_mmd	= rtlgen_read_mmd,
 		.write_mmd	= rtlgen_write_mmd,
 	}, {
-		.name		= "RTL8125 2.5Gbps internal",
-		.match_phy_device = rtl8125_match_phy_device,
-		.get_features	= rtl8125_get_features,
-		.config_aneg	= rtl8125_config_aneg,
-		.read_status	= rtl8125_read_status,
+		.name		= "RTL8226 2.5Gbps PHY",
+		.match_phy_device = rtl8226_match_phy_device,
+		.get_features	= rtl822x_get_features,
+		.config_aneg	= rtl822x_config_aneg,
+		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl8125_read_mmd,
-		.write_mmd	= rtl8125_write_mmd,
+		.read_mmd	= rtl822x_read_mmd,
+		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc840),
-		.name		= "RTL8125B 2.5Gbps internal",
-		.get_features	= rtl8125_get_features,
-		.config_aneg	= rtl8125_config_aneg,
-		.read_status	= rtl8125_read_status,
+		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
+		.get_features	= rtl822x_get_features,
+		.config_aneg	= rtl822x_config_aneg,
+		.read_status	= rtl822x_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= rtlgen_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
-		.read_mmd	= rtl8125_read_mmd,
-		.write_mmd	= rtl8125_write_mmd,
+		.read_mmd	= rtl822x_read_mmd,
+		.write_mmd	= rtl822x_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
1.9.1

