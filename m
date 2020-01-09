Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD68136127
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgAITfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35935 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730594AbgAITfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so8692411wru.3
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=53dosYT2YrwQYq7T1AaSPoG13rdtFcG8aXyYuXlEwKY=;
        b=ORtH5r44oahRZ0R2VhAmnOCl69uMryt7iO0iMemqqz2lI7w+iJP58VuBTL6TNlm3OK
         KDQLhrdhXeeWJzhAxXl+YaNKmuI8CR3N1DGqt+Ky54FQEDnjV5G0/sDpaWY7wFNPI6rh
         3fJOOTV0AsrQNUC7QVwsEZ6BCfDRU4Z+LVSQUkuwTe0t9XwHTEsU4kOCtMMl1HgyKz8V
         uH1eAamlFHFQFFl2ePhKEwLu4+95jviNxw2qvQOtpcNZQ2YTKqk69qoDfpS/Wy4vJLQC
         QRDJkq35BQy8LBHVNxEKdiwr2XC5QP+r7P5Mn30TpUfZNs0IIB0BkhsW664QCZ9/z8de
         9kGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=53dosYT2YrwQYq7T1AaSPoG13rdtFcG8aXyYuXlEwKY=;
        b=dudhN8FyTRHzUB0p4LvZqwsZjZFwHl9jeIVro0UbhPZSwrS1poyDrhMVIo0OUTI8lN
         b83qnY1RrvMPj341/FlbXsEyKBCenITClFUI74c1nyO4L04rL9tqBbGLwu+WteSpfV8w
         nEan/8t+waQq9TNpwbbdqz8UfiAHnzCnK9yWJcIhhJoJ/DauQ+N6PqGVks34ZUGC2ILb
         69qU/dTtuM6bVawi6TlsJqRwxotTZ9i0VmRorTnkleLFxuUtMJMbg2sGnXLqWTUFi+wR
         YAoWZnkQqqz6Fyhj05/Utux8sBwmDWFOWJxPzCCNFr6LlK1ZLE5rZhixokDgt+EeavjW
         WouQ==
X-Gm-Message-State: APjAAAXBD9diJEvdqvGzIN5LXmXaEXyn/XKpv4OtfAM3U6COyuPsEok/
        HJgk40ogj6nOjnAk2bdTGVe4QDTq
X-Google-Smtp-Source: APXvYqzanope2th+/7Yg6gKBbdqu/EsEj9W44e1qqq3tagaIiRMb7S6ptWFRfb7W7Jw5+PaU/qOgfQ==
X-Received: by 2002:a5d:5091:: with SMTP id a17mr12508458wrt.362.1578598538552;
        Thu, 09 Jan 2020 11:35:38 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id f207sm4430268wme.9.2020.01.09.11.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:38 -0800 (PST)
Subject: [PATCH net-next 04/15] r8169: change argument type of EEE PHY
 functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <b7dfc684-2437-9b0f-e467-9ce173be142d@gmail.com>
Date:   Thu, 9 Jan 2020 20:27:33 +0100
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

These functions use only the phy_device member of rtl8169_private,
so we can pass the phy_device as parameter directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 42 ++++++++++-------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3514de25d..dcb6fedf8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2318,34 +2318,28 @@ static void rtl8125_config_eee_mac(struct rtl8169_private *tp)
 	r8168_mac_ocp_modify(tp, 0xeb62, 0, BIT(2) | BIT(1));
 }
 
-static void rtl8168f_config_eee_phy(struct rtl8169_private *tp)
+static void rtl8168f_config_eee_phy(struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	r8168d_modify_extpage(phydev, 0x0020, 0x15, 0, BIT(8));
 	r8168d_phy_param(phydev, 0x8b85, 0, BIT(13));
 }
 
-static void rtl8168g_config_eee_phy(struct rtl8169_private *tp)
+static void rtl8168g_config_eee_phy(struct phy_device *phydev)
 {
-	phy_modify_paged(tp->phydev, 0x0a43, 0x11, 0, BIT(4));
+	phy_modify_paged(phydev, 0x0a43, 0x11, 0, BIT(4));
 }
 
-static void rtl8168h_config_eee_phy(struct rtl8169_private *tp)
+static void rtl8168h_config_eee_phy(struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 
 	phy_modify_paged(phydev, 0xa4a, 0x11, 0x0000, 0x0200);
 	phy_modify_paged(phydev, 0xa42, 0x14, 0x0000, 0x0080);
 }
 
-static void rtl8125_config_eee_phy(struct rtl8169_private *tp)
+static void rtl8125_config_eee_phy(struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
-	rtl8168h_config_eee_phy(tp);
+	rtl8168h_config_eee_phy(phydev);
 
 	phy_modify_paged(phydev, 0xa6d, 0x12, 0x0001, 0x0000);
 	phy_modify_paged(phydev, 0xa6d, 0x14, 0x0010, 0x0000);
@@ -2954,7 +2948,7 @@ static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 	/* Improve 2-pair detection performance */
 	r8168d_phy_param(phydev, 0x8b85, 0x0000, 0x4000);
 
-	rtl8168f_config_eee_phy(tp);
+	rtl8168f_config_eee_phy(phydev);
 
 	/* Green feature */
 	rtl_writephy(tp, 0x1f, 0x0003);
@@ -2979,7 +2973,7 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
 	/* Improve 10M EEE waveform */
 	r8168d_phy_param(phydev, 0x8b86, 0x0000, 0x0001);
 
-	rtl8168f_config_eee_phy(tp);
+	rtl8168f_config_eee_phy(phydev);
 }
 
 static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
@@ -3124,14 +3118,14 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
 	rtl_apply_firmware(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
@@ -3197,7 +3191,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168h_config_eee_phy(tp);
+	rtl8168h_config_eee_phy(phydev);
 }
 
 static u16 rtl8168h_2_get_adc_bias_ioffset(struct rtl8169_private *tp)
@@ -3251,7 +3245,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
@@ -3272,7 +3266,7 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
@@ -3322,7 +3316,7 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x1f, 0x0000);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168g_config_eee_phy(tp);
+	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
@@ -3360,7 +3354,7 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
 	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
 
 	rtl8168g_disable_aldps(tp);
-	rtl8168h_config_eee_phy(tp);
+	rtl8168h_config_eee_phy(phydev);
 }
 
 static void rtl8102e_hw_phy_config(struct rtl8169_private *tp,
@@ -3469,7 +3463,7 @@ static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa5c, 0x10, 0x0400, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
 
-	rtl8125_config_eee_phy(tp);
+	rtl8125_config_eee_phy(phydev);
 }
 
 static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
@@ -3534,7 +3528,7 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	phy_modify_paged(phydev, 0xa44, 0x11, 0x0000, 0x0800);
 
-	rtl8125_config_eee_phy(tp);
+	rtl8125_config_eee_phy(phydev);
 }
 
 static void r8169_hw_phy_config(struct rtl8169_private *tp,
-- 
2.24.1


