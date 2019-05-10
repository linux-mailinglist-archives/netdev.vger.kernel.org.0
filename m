Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9181A3C1
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfEJULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:11:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38569 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbfEJULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:11:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id f2so8620429wmj.3
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 13:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GQeK0L7LKJ7kcYTytgkFCc8YBZ6fcDia0ruF/yGmgJ4=;
        b=D/P6rwe8/OKjwTAqKaHixR41zwXvtOjHgM4N5/uaOh06iHtJ+pZF0YF1VkBMCDTW9T
         umc3ftv3LrBkWGX3LvjCSrjsc4HYWvYo9H6zwK7FMzZLUbGSJTqeldpJysxICGKucV16
         O5m0TSDOFRSrP/z4QCqrI2rTtjDuyZlBt1NlXWXOiRrKiqeh7n/Bs+cyXj3mJ/b05TkP
         M3P0kKzu4SGYj/iOjPT0L0keC3dJCdKt9piGFnAj6PKklRZBzNcuzOw8z0aFy90xo8gc
         qRVmBzm7bnRF3gXigY/qZ1I9MKudHsBtar5VkxLdZdf346mVAbkSKrosQTTHMxLkqR5y
         6Slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GQeK0L7LKJ7kcYTytgkFCc8YBZ6fcDia0ruF/yGmgJ4=;
        b=o5cZUbFf448VulUIXwwBGSJX6XEJypqFK6nclhIeNJZll5TaX5FOGKdciNY+eeZtXo
         WxS2MeipYa+DE8yCbyOrI3PkCPsSSM/gbjXMYfa+gQqwqHg8dAc9khkZ6g05uxUWnfmI
         GtX/Yd5umL+Y0aEfyen0ThVn4Manhx1WEFBDSF1ffUQkSYY/TUjJZGym/6kJ6PUsqjYh
         pJsAKuX1Ofv2j/PMyQGbVd7wKSSVFoEdH6hOF0FCq4ruZ97eUc+Z4sWobGsT0XxApvQo
         sdoS95f8CuB0SNHw5B4V6KIjATyRUy9psTiRonQGPoE/xupoxyorI2ZtzN4/cDNtdFYz
         zLbw==
X-Gm-Message-State: APjAAAWMPIOpLO7g46Gxx/Kdl1PuQUggYcXlSKzTbkyrP9UXy/gEHV6z
        OrQ/Q1+Dlc8GwJQMDXMt+XOuV+izc2Q=
X-Google-Smtp-Source: APXvYqyRHll8YIlCJQspuMiUZId6t5ePTzid90bV6lVpuEldSI6BqfkKgkhBpDdEw6s1mNtg1MZkHw==
X-Received: by 2002:a1c:4083:: with SMTP id n125mr4608745wma.54.1557519096089;
        Fri, 10 May 2019 13:11:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:b86d:cacd:ffb5:67a5? (p200300EA8BD45700B86DCACDFFB567A5.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:b86d:cacd:ffb5:67a5])
        by smtp.googlemail.com with ESMTPSA id m6sm8970678wmc.32.2019.05.10.13.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 13:11:35 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: realtek: add missing page operations
Message-ID: <6dce0e4a-386e-af4e-4f9c-ee6dd2376957@gmail.com>
Date:   Fri, 10 May 2019 22:11:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing page operation callbacks to few Realtek drivers.
This also fixes a NPE after the referenced commit added code to the
RTL8211E driver that uses phy_select_page().

Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 761ce3b1e..29ce07312 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -275,6 +275,8 @@ static struct phy_driver realtek_drvs[] = {
 		.config_aneg	= rtl8211_config_aneg,
 		.read_mmd	= &genphy_read_mmd_unsupported,
 		.write_mmd	= &genphy_write_mmd_unsupported,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc912),
 		.name		= "RTL8211B Gigabit Ethernet",
@@ -284,12 +286,16 @@ static struct phy_driver realtek_drvs[] = {
 		.write_mmd	= &genphy_write_mmd_unsupported,
 		.suspend	= rtl8211b_suspend,
 		.resume		= rtl8211b_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc913),
 		.name		= "RTL8211C Gigabit Ethernet",
 		.config_init	= rtl8211c_config_init,
 		.read_mmd	= &genphy_read_mmd_unsupported,
 		.write_mmd	= &genphy_write_mmd_unsupported,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc914),
 		.name		= "RTL8211DN Gigabit Ethernet",
@@ -297,6 +303,8 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= rtl8211e_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc915),
 		.name		= "RTL8211E Gigabit Ethernet",
@@ -305,6 +313,8 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211e_config_intr,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc916),
 		.name		= "RTL8211F Gigabit Ethernet",
@@ -322,6 +332,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.21.0

