Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB0206293
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393295AbgFWVFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392189AbgFWVEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:04:54 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E865DC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 14:04:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so9705wrr.10
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 14:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=H0qgUSRa3szd6PniYbMBDVK99nWFlf+blCJsMzLRS+0=;
        b=vQZnNFPI363Jye5tiGGEG/r7NdL3YAYjtxGRFeHPw9w/g2Ft80ET2cDmfJe0hJKw89
         5cXRbjPajry7atnahesNeCXx+p0ZFRf6iSTa8LRRLU0E+V2lUXwZ1AxYo22FiixWMda3
         yV2P4junVQwsrEtm+z1VCYYdUUzk3PCI9ugLP7UQoQiAuzwowObSF+SHKbuUvmoDEl6H
         lcuwEIzCO+sHn1ukJjV9VjfO8hfu8z2tmn0Phhj2yFnkV2HgRUEVR6qkKJ13iLMUyHNK
         w2Pvov84mO06RB3bfvEFvewrKAAtRpkZWmwdqudMQJCsGXGuAb1ZhthQkv+MT/gYvk0R
         gUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=H0qgUSRa3szd6PniYbMBDVK99nWFlf+blCJsMzLRS+0=;
        b=lx99C1ADl/qhWARtCnuLK2CoxEiY8v7AVji0XFRfePsFvkwDuZnmY26nTBkaY/5GwO
         A8nqKAMrYAF8nOvw5Ll9Vv2OeRcumNb1Z5+OWIgjlr9LvA9Rf5ZLsEYSiKPfUttboTna
         G7SZMTTk6IBc2paH1lsn8OutFx19d57fy0zsKc9ZaiXBTS9izOIeP6MD3cpL5rKJiuqV
         nvi5KlSP9hwv48DWp9yaKp3GWQaAMLjcWbW+/AdskahkZVF5+Y0BGpEDNyAB+JADyyWu
         P5n4TVLNd+fHz0K2wbLkau6IFan1OVP7wTQFpmBdUPen5kKnXQl5tVaWdmK3vVXlAgyo
         nSzQ==
X-Gm-Message-State: AOAM530X85gw4xjEpJKmAX7JqmaZvD5jUy37OMPrydGehVkqIZCahhaX
        SyznCHCtzNjZA9faFp9ntZOBs+F/
X-Google-Smtp-Source: ABdhPJzy16ZijuLhY3DsmthPKkxt4hslwDqfb8GndNZ/zvDrh81VtRsA3F6YuociVPv1w2SbElTGww==
X-Received: by 2002:adf:f60b:: with SMTP id t11mr2842732wrp.249.1592946291331;
        Tue, 23 Jun 2020 14:04:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b187:5366:3877:fcde? (p200300ea8f235700b18753663877fcde.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b187:5366:3877:fcde])
        by smtp.googlemail.com with ESMTPSA id d132sm5231299wmd.35.2020.06.23.14.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 14:04:50 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: rename RTL8125 to RTL8125A
Message-ID: <639d7e95-baa6-6535-9ecf-008025dc446a@gmail.com>
Date:   Tue, 23 Jun 2020 23:04:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek added new members to the RTL8125 chip family, therefore rename
RTL8125 to RTL8125a. Then we use the same chip naming as in the r8125
vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c     | 24 +++++++++----------
 .../net/ethernet/realtek/r8169_phy_config.c   | 18 +++++++-------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 12329d2a2..d19535319 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -145,8 +145,8 @@ static const struct {
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
-	[RTL_GIGA_MAC_VER_60] = {"RTL8125"				},
-	[RTL_GIGA_MAC_VER_61] = {"RTL8125",		FIRMWARE_8125A_3},
+	[RTL_GIGA_MAC_VER_60] = {"RTL8125A"				},
+	[RTL_GIGA_MAC_VER_61] = {"RTL8125A",		FIRMWARE_8125A_3},
 };
 
 static const struct pci_device_id rtl8169_pci_tbl[] = {
@@ -2068,7 +2068,7 @@ static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
 	rtl_eri_set_bits(tp, 0x1b0, 0x0003);
 }
 
-static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
+static void rtl8125a_config_eee_mac(struct rtl8169_private *tp)
 {
 	r8168_mac_ocp_modify(tp, 0xe040, 0, BIT(1) | BIT(0));
 	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
@@ -3529,15 +3529,15 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 
 	rtl_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
 
-	rtl8125_config_eee_mac(tp);
+	rtl8125a_config_eee_mac(tp);
 
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
 	udelay(10);
 }
 
-static void rtl_hw_start_8125_1(struct rtl8169_private *tp)
+static void rtl_hw_start_8125a_1(struct rtl8169_private *tp)
 {
-	static const struct ephy_info e_info_8125_1[] = {
+	static const struct ephy_info e_info_8125a_1[] = {
 		{ 0x01, 0xffff, 0xa812 },
 		{ 0x09, 0xffff, 0x520c },
 		{ 0x04, 0xffff, 0xd000 },
@@ -3569,14 +3569,14 @@ static void rtl_hw_start_8125_1(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8125_1);
+	rtl_ephy_init(tp, e_info_8125a_1);
 
 	rtl_hw_start_8125_common(tp);
 }
 
-static void rtl_hw_start_8125_2(struct rtl8169_private *tp)
+static void rtl_hw_start_8125a_2(struct rtl8169_private *tp)
 {
-	static const struct ephy_info e_info_8125_2[] = {
+	static const struct ephy_info e_info_8125a_2[] = {
 		{ 0x04, 0xffff, 0xd000 },
 		{ 0x0a, 0xffff, 0x8653 },
 		{ 0x23, 0xffff, 0xab66 },
@@ -3596,7 +3596,7 @@ static void rtl_hw_start_8125_2(struct rtl8169_private *tp)
 
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
-	rtl_ephy_init(tp, e_info_8125_2);
+	rtl_ephy_init(tp, e_info_8125a_2);
 
 	rtl_hw_start_8125_common(tp);
 }
@@ -3650,8 +3650,8 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
-		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125_1,
-		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125_2,
+		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
+		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
 	};
 
 	if (hw_configs[tp->mac_version])
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index b73f7d023..0cf4893e5 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -89,7 +89,7 @@ static void rtl8168h_config_eee_phy(struct phy_device *phydev)
 	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
 }
 
-static void rtl8125_config_eee_phy(struct phy_device *phydev)
+static void rtl8125a_config_eee_phy(struct phy_device *phydev)
 {
 	rtl8168h_config_eee_phy(phydev);
 
@@ -1140,8 +1140,8 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
 
-static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
+static void rtl8125a_1_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	phy_modify_paged(phydev, 0xad4, 0x10, 0x03ff, 0x0084);
 	phy_modify_paged(phydev, 0xad4, 0x17, 0x0000, 0x0010);
@@ -1175,11 +1175,11 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
 	rtl8168g_enable_gphy_10m(phydev);
 
-	rtl8125_config_eee_phy(phydev);
+	rtl8125a_config_eee_phy(phydev);
 }
 
-static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
-				    struct phy_device *phydev)
+static void rtl8125a_2_hw_phy_config(struct rtl8169_private *tp,
+				     struct phy_device *phydev)
 {
 	int i;
 
@@ -1240,7 +1240,7 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	rtl8168g_enable_gphy_10m(phydev);
 
-	rtl8125_config_eee_phy(phydev);
+	rtl8125a_config_eee_phy(phydev);
 }
 
 void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
@@ -1300,8 +1300,8 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
-		[RTL_GIGA_MAC_VER_60] = rtl8125_1_hw_phy_config,
-		[RTL_GIGA_MAC_VER_61] = rtl8125_2_hw_phy_config,
+		[RTL_GIGA_MAC_VER_60] = rtl8125a_1_hw_phy_config,
+		[RTL_GIGA_MAC_VER_61] = rtl8125a_2_hw_phy_config,
 	};
 
 	if (phy_configs[ver])
-- 
2.27.0

