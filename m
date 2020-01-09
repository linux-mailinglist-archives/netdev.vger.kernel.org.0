Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E0013613A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgAITfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55885 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730653AbgAITfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so4248839wmj.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rKeRKnNkHGW+ZEZ4sgaWb/IKMGQvvKPxFE+aq8/SRbM=;
        b=pJcIGhF6hIxgoRhmOiiulMLqaXsEC3jYy1lc0UjEfBcVnzLU8iuboQMQsqwGu1ncvP
         MS76mTmCLAiJC/y95DrxxyBmPIUYxfN4RVaxnklVA7b4xfp29dXp0TteeEVUJdKgU5qU
         sqzJP4vv8Lgr/wDACTMt/4IGiIhtO8fZuxyUjP9LaFYpoe/ptAUwQQw5W+I/7DuulZBe
         O0oXHRV622mZAlk0801OvayUQSJs2RJ19HXZOJ56YLhCSGy14YLfD+mjHyvWLmt90wSS
         +Y7CKOLzbl+8LqxtrLLKM06cnFRTq03wxv/LerzzqEAtrrMIrtYtvVGiV8UrKlvUIzFO
         D2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rKeRKnNkHGW+ZEZ4sgaWb/IKMGQvvKPxFE+aq8/SRbM=;
        b=TZf6ER8zJ8QPU0pMFQKOJMbYlbR65b8EoGbl4DFbYWL0dBLQLCDSPiaKx9hiUbp7Ua
         u4xsai46x5pxblIJD8pTV9XV6rzt8uY291foim9hpqs0tMYCwqUPmf669AGEHlwmcWj2
         Gp1S6aW15RlkvuOAgTMhKftLe8Cv4ur24MiuqSXJ7zF6u2dFzrEjPga2JxreyHEqoZZl
         IbIi7B8uEBLii5y/mk+E63NALCQMvyeO1KRmI6W3opVkJuUCMd97KBXfejua0JAiWWW5
         FJ9r5TvFwVvh1MvS4SJVZQ+L1bXKMHFcRgUg+OFZrW12fAX0PfMG+uacxzhKEl6VDle2
         8+LQ==
X-Gm-Message-State: APjAAAUqFqdJub6Wjm84ZyEJ/JVOKl0QCjQ6FiA0aKHn/TS7eyAY+6Ju
        2fpsRz11aYWu4mpaACa7drxCZi3G
X-Google-Smtp-Source: APXvYqyN9wMhK8eU442x7FAAcJiBmFLZwvhSShit0uFafFVjLvwwnIRVtcBpuqhVndaA3ipYfrD+xQ==
X-Received: by 2002:a1c:407:: with SMTP id 7mr6381869wme.29.1578598539515;
        Thu, 09 Jan 2020 11:35:39 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id u24sm3817582wml.10.2020.01.09.11.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:39 -0800 (PST)
Subject: [PATCH net-next 05/15] r8169: change argument type of
 RTL8168g-specific PHY config functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <1a08153e-df00-1478-7098-949c232e98d7@gmail.com>
Date:   Thu, 9 Jan 2020 20:28:08 +0100
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
 drivers/net/ethernet/realtek/r8169_main.c | 26 +++++++++++------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dcb6fedf8..94bad2b09 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3058,15 +3058,13 @@ static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168g_disable_aldps(struct rtl8169_private *tp)
+static void rtl8168g_disable_aldps(struct phy_device *phydev)
 {
-	phy_modify_paged(tp->phydev, 0x0a43, 0x10, BIT(2), 0);
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(2), 0);
 }
 
-static void rtl8168g_phy_adjust_10m_aldps(struct rtl8169_private *tp)
+static void rtl8168g_phy_adjust_10m_aldps(struct phy_device *phydev)
 {
-	struct phy_device *phydev = tp->phydev;
-
 	phy_modify_paged(phydev, 0x0bcc, 0x14, BIT(8), 0);
 	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(7) | BIT(6));
 	r8168g_phy_param(phydev, 0x8084, 0x6000, 0x0000);
@@ -3095,7 +3093,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 	/* Enable PHY auto speed down */
 	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
-	rtl8168g_phy_adjust_10m_aldps(tp);
+	rtl8168g_phy_adjust_10m_aldps(phydev);
 
 	/* EEE auto-fallback function */
 	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
@@ -3117,7 +3115,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x14, 0x1065);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
 
@@ -3190,7 +3188,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168h_config_eee_phy(phydev);
 }
 
@@ -3244,7 +3242,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
 
@@ -3254,7 +3252,7 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
 	/* Enable PHY auto speed down */
 	phy_modify_paged(phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
 
-	rtl8168g_phy_adjust_10m_aldps(tp);
+	rtl8168g_phy_adjust_10m_aldps(phydev);
 
 	/* Enable EEE auto-fallback function */
 	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(2));
@@ -3265,14 +3263,14 @@ static void rtl8168ep_1_hw_phy_config(struct rtl8169_private *tp,
 	/* set rg_sel_sdm_rate */
 	phy_modify_paged(phydev, 0x0c42, 0x11, BIT(13), BIT(14));
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
 
 static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
 				      struct phy_device *phydev)
 {
-	rtl8168g_phy_adjust_10m_aldps(tp);
+	rtl8168g_phy_adjust_10m_aldps(phydev);
 
 	/* Enable UC LPF tune function */
 	r8168g_phy_param(phydev, 0x8012, 0x0000, 0x8000);
@@ -3315,7 +3313,7 @@ static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy(tp, 0x14, 0x1065);
 	rtl_writephy(tp, 0x1f, 0x0000);
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
 
@@ -3353,7 +3351,7 @@ static void rtl8117_hw_phy_config(struct rtl8169_private *tp,
 
 	r8168g_phy_param(phydev, 0x8016, 0x0000, 0x0400);
 
-	rtl8168g_disable_aldps(tp);
+	rtl8168g_disable_aldps(phydev);
 	rtl8168h_config_eee_phy(phydev);
 }
 
-- 
2.24.1


