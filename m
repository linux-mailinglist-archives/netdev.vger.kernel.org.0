Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071BD136130
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgAITfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43809 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730920AbgAITfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id d16so8627188wre.10
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nXI7U+xiB1oQKrZIXyZNtLdOU5Dr2ro/tb9p4kfRB3o=;
        b=J5m8Q7lEZ7jaCbnbUBGeQLkiciSndFpKDBi6ZUqEC+3XkFDV185/WyAWpHcNnNSRmq
         9Bebr06E4DXcRF50ozazYOFjPpGslT8QxOEPK2I6opNXYFw44QYI4nYnzItat9gbmDF7
         2LiqN2Ixe3yGJhW4l9VBALRSmIaOxUc5A0MxsE7ZNnIe5CpeEPLxLeD0YSRdMMdCjKsB
         WFVLLWHW1pdSPYwAhiV0ajgFCYwpcHPQ6di4E7AaGeocdHoz3OSBiSstQDVG9Yo8n78Z
         X8izMYkb5y3hcQ4JpPHU1dMBW+2SuPN54lqkJYWPZCcIIlAs6chQTJ46wT6BNLG40AoZ
         KirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nXI7U+xiB1oQKrZIXyZNtLdOU5Dr2ro/tb9p4kfRB3o=;
        b=aYzjQYiqgZ+VFS7pMBekt/+lxSRhMUSpwaUQNBM+6AOWEs6+Cz7XFZCRUXoL4mOLy7
         YC7ClNFGVg+Ro3uwOIiM04D1dBOhWwkDdJk5UTBDGw/B1uFuaTQ/Xc+wDn5TdcutXZPU
         XyftnOOE+0SwSPNTtBNT68lW5d3WIAwAWPYrry3XwHOm7CeHSo3czSoqkrXnl1c/W/YY
         moR//2tyzLF97pwE28KEZuOKwEHolJXV8erq9mMiH4XKBBF3MErchzvObROKMUgmvIeI
         AbpbWEO2ykvsF+fYzvkmIoebZh87/x6lyc6yCmxLSBQgJTdRBslZBFoF7BmgNvcWFxWq
         N0tg==
X-Gm-Message-State: APjAAAVWxtNbPPxHTS/xIWDBMAxclqOs3czTI8Xxcg/n67WNEXTTR+ys
        x1Itfeg+5sZgAbbU9uGIeMVvBoF/
X-Google-Smtp-Source: APXvYqwwojJmWlV/5eTaE4BiGF3wNcvTzTbw5X+xE9Ynt3lJCi0WkboHLWTRa+v2K56AWG4ObKkNLw==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr11805207wrx.253.1578598548685;
        Thu, 09 Jan 2020 11:35:48 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id 124sm4176621wmc.29.2020.01.09.11.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:48 -0800 (PST)
Subject: [PATCH net-next 14/15] r8169: add r8169.h
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <c8a703d1-bf93-61ad-a8c4-57f44bc448fa@gmail.com>
Date:   Thu, 9 Jan 2020 20:34:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out PHY configuration to a separate source
file move commonly used definitions to new header file r8169.h.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h      | 78 +++++++++++++++++++++++
 drivers/net/ethernet/realtek/r8169_main.c | 70 ++------------------
 2 files changed, 84 insertions(+), 64 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169.h

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
new file mode 100644
index 000000000..22a6a057b
--- /dev/null
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* r8169.h: RealTek 8169/8168/8101 ethernet driver.
+ *
+ * Copyright (c) 2002 ShuChen <shuchen@realtek.com.tw>
+ * Copyright (c) 2003 - 2007 Francois Romieu <romieu@fr.zoreil.com>
+ * Copyright (c) a lot of people too. Please respect their work.
+ *
+ * See MAINTAINERS file for support contact information.
+ */
+
+#include <linux/types.h>
+#include <linux/phy.h>
+
+enum mac_version {
+	/* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
+	RTL_GIGA_MAC_VER_02,
+	RTL_GIGA_MAC_VER_03,
+	RTL_GIGA_MAC_VER_04,
+	RTL_GIGA_MAC_VER_05,
+	RTL_GIGA_MAC_VER_06,
+	RTL_GIGA_MAC_VER_07,
+	RTL_GIGA_MAC_VER_08,
+	RTL_GIGA_MAC_VER_09,
+	RTL_GIGA_MAC_VER_10,
+	RTL_GIGA_MAC_VER_11,
+	RTL_GIGA_MAC_VER_12,
+	RTL_GIGA_MAC_VER_13,
+	RTL_GIGA_MAC_VER_14,
+	RTL_GIGA_MAC_VER_15,
+	RTL_GIGA_MAC_VER_16,
+	RTL_GIGA_MAC_VER_17,
+	RTL_GIGA_MAC_VER_18,
+	RTL_GIGA_MAC_VER_19,
+	RTL_GIGA_MAC_VER_20,
+	RTL_GIGA_MAC_VER_21,
+	RTL_GIGA_MAC_VER_22,
+	RTL_GIGA_MAC_VER_23,
+	RTL_GIGA_MAC_VER_24,
+	RTL_GIGA_MAC_VER_25,
+	RTL_GIGA_MAC_VER_26,
+	RTL_GIGA_MAC_VER_27,
+	RTL_GIGA_MAC_VER_28,
+	RTL_GIGA_MAC_VER_29,
+	RTL_GIGA_MAC_VER_30,
+	RTL_GIGA_MAC_VER_31,
+	RTL_GIGA_MAC_VER_32,
+	RTL_GIGA_MAC_VER_33,
+	RTL_GIGA_MAC_VER_34,
+	RTL_GIGA_MAC_VER_35,
+	RTL_GIGA_MAC_VER_36,
+	RTL_GIGA_MAC_VER_37,
+	RTL_GIGA_MAC_VER_38,
+	RTL_GIGA_MAC_VER_39,
+	RTL_GIGA_MAC_VER_40,
+	RTL_GIGA_MAC_VER_41,
+	RTL_GIGA_MAC_VER_42,
+	RTL_GIGA_MAC_VER_43,
+	RTL_GIGA_MAC_VER_44,
+	RTL_GIGA_MAC_VER_45,
+	RTL_GIGA_MAC_VER_46,
+	RTL_GIGA_MAC_VER_47,
+	RTL_GIGA_MAC_VER_48,
+	RTL_GIGA_MAC_VER_49,
+	RTL_GIGA_MAC_VER_50,
+	RTL_GIGA_MAC_VER_51,
+	RTL_GIGA_MAC_VER_52,
+	RTL_GIGA_MAC_VER_60,
+	RTL_GIGA_MAC_VER_61,
+	RTL_GIGA_MAC_NONE
+};
+
+struct rtl8169_private;
+
+void r8169_apply_firmware(struct rtl8169_private *tp);
+u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp);
+u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr);
+void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
+			 enum mac_version ver);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f243f3695..7bbc9794d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -31,6 +31,7 @@
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
 
+#include "r8169.h"
 #include "r8169_firmware.h"
 
 #define MODULENAME "r8169"
@@ -84,64 +85,6 @@
 #define RTL_R16(tp, reg)		readw(tp->mmio_addr + (reg))
 #define RTL_R32(tp, reg)		readl(tp->mmio_addr + (reg))
 
-enum mac_version {
-	/* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
-	RTL_GIGA_MAC_VER_02,
-	RTL_GIGA_MAC_VER_03,
-	RTL_GIGA_MAC_VER_04,
-	RTL_GIGA_MAC_VER_05,
-	RTL_GIGA_MAC_VER_06,
-	RTL_GIGA_MAC_VER_07,
-	RTL_GIGA_MAC_VER_08,
-	RTL_GIGA_MAC_VER_09,
-	RTL_GIGA_MAC_VER_10,
-	RTL_GIGA_MAC_VER_11,
-	RTL_GIGA_MAC_VER_12,
-	RTL_GIGA_MAC_VER_13,
-	RTL_GIGA_MAC_VER_14,
-	RTL_GIGA_MAC_VER_15,
-	RTL_GIGA_MAC_VER_16,
-	RTL_GIGA_MAC_VER_17,
-	RTL_GIGA_MAC_VER_18,
-	RTL_GIGA_MAC_VER_19,
-	RTL_GIGA_MAC_VER_20,
-	RTL_GIGA_MAC_VER_21,
-	RTL_GIGA_MAC_VER_22,
-	RTL_GIGA_MAC_VER_23,
-	RTL_GIGA_MAC_VER_24,
-	RTL_GIGA_MAC_VER_25,
-	RTL_GIGA_MAC_VER_26,
-	RTL_GIGA_MAC_VER_27,
-	RTL_GIGA_MAC_VER_28,
-	RTL_GIGA_MAC_VER_29,
-	RTL_GIGA_MAC_VER_30,
-	RTL_GIGA_MAC_VER_31,
-	RTL_GIGA_MAC_VER_32,
-	RTL_GIGA_MAC_VER_33,
-	RTL_GIGA_MAC_VER_34,
-	RTL_GIGA_MAC_VER_35,
-	RTL_GIGA_MAC_VER_36,
-	RTL_GIGA_MAC_VER_37,
-	RTL_GIGA_MAC_VER_38,
-	RTL_GIGA_MAC_VER_39,
-	RTL_GIGA_MAC_VER_40,
-	RTL_GIGA_MAC_VER_41,
-	RTL_GIGA_MAC_VER_42,
-	RTL_GIGA_MAC_VER_43,
-	RTL_GIGA_MAC_VER_44,
-	RTL_GIGA_MAC_VER_45,
-	RTL_GIGA_MAC_VER_46,
-	RTL_GIGA_MAC_VER_47,
-	RTL_GIGA_MAC_VER_48,
-	RTL_GIGA_MAC_VER_49,
-	RTL_GIGA_MAC_VER_50,
-	RTL_GIGA_MAC_VER_51,
-	RTL_GIGA_MAC_VER_52,
-	RTL_GIGA_MAC_VER_60,
-	RTL_GIGA_MAC_VER_61,
-	RTL_GIGA_MAC_NONE
-};
-
 #define JUMBO_1K	ETH_DATA_LEN
 #define JUMBO_4K	(4*1024 - ETH_HLEN - 2)
 #define JUMBO_6K	(6*1024 - ETH_HLEN - 2)
@@ -1362,7 +1305,7 @@ DECLARE_RTL_COND(rtl_efusear_cond)
 	return RTL_R32(tp, EFUSEAR) & EFUSEAR_FLAG;
 }
 
-static u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
+u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
 {
 	RTL_W32(tp, EFUSEAR, (reg_addr & EFUSEAR_REG_MASK) << EFUSEAR_REG_SHIFT);
 
@@ -2287,7 +2230,7 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 	}
 }
 
-static void r8169_apply_firmware(struct rtl8169_private *tp)
+void r8169_apply_firmware(struct rtl8169_private *tp)
 {
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
 	if (tp->rtl_fw)
@@ -3178,7 +3121,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
 	rtl8168h_config_eee_phy(phydev);
 }
 
-static u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
+u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
 {
 	u16 data1, data2, ioffset;
 
@@ -3510,9 +3453,8 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl8125_config_eee_phy(phydev);
 }
 
-static void r8169_hw_phy_config(struct rtl8169_private *tp,
-				struct phy_device *phydev,
-				enum mac_version ver)
+void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
+			 enum mac_version ver)
 {
 	static const rtl_phy_cfg_fct phy_configs[] = {
 		/* PCI devices. */
-- 
2.24.1


