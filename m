Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F9A136132
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgAITfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38855 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730715AbgAITft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id y17so8695486wrh.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ft92tPNlrmt+WUO39FqzBvZSRASZ5FvhLBaBncngl9M=;
        b=XbhR23N+qbFj3VoS2vEbepx50YNLlsEiRXN4XWTNpFdsLgYQyQ7BvcfdWXE+MtXyou
         9RBVyp9V///Kf7M4XXvYnLPn/l506Zmf9nSh/XUDFXcosfW1hoKUiP5xPuLYOG6L9xnA
         XgcFhXIzJca4H1msCyUQuNslNMxGKiXR4ArtCvV3gBkSNTwHNrZz/TJ3aEu1NaFI67ek
         yyoaqHPxR70Gn5XEcoybbmnGzt3qSmKBgPv9SlzmpkHNW7cDfE2xQzvlEF/8/8gKZqhK
         79833bbea6IeC2xfnUoqubtDaUohIQE7by7e4dphzaFEOdbrD8Oey2VeSBVi8g1psNvF
         wt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ft92tPNlrmt+WUO39FqzBvZSRASZ5FvhLBaBncngl9M=;
        b=ENx30cSAwJ3L3aFWMwz2mlH5Lqjd1BrxBpNgyLg8l1OIskDE88PWYBYUyaYW5FFPwv
         BAZ+sjqNIVHNKhXr8C3Zy92p3UQn/aKe09Smw0smhBRJHNhkVu4Si50BXJ9x6nA49yLM
         M4U697KYabEe5CRpnEDIWgxrVGKoPtW7Qda5f5k/dS2CW0O3QzIhmrq6k6E/Wq8yHd+I
         5aJDmjT+hapgZVhf2fd+FLiDch6OsPN9xqkOUePQgA0+BUW7c0IFbyC7FNCe5gh3CBDF
         26UqFGBAWqdTXKWbbaNSqqQKm8VKnGmN1Ldnd/HttJQs9/u59RXmI3OLdZv4P6IHLYBL
         eX7g==
X-Gm-Message-State: APjAAAV3TATAs1cfSCpa1uwd6914yc9iRR0mkvITp5luWl01CIJEQt4/
        L0846NDQxYG1arB/psd5H3JGDHNH
X-Google-Smtp-Source: APXvYqwBSNXXx2YNBzQEis6oFg4v7Li2QE3I9FOOMRq8AOeIGAgqua3I6lAC7Lfi1PIAzJMJpjIFyQ==
X-Received: by 2002:adf:dd8a:: with SMTP id x10mr12512585wrl.117.1578598547745;
        Thu, 09 Jan 2020 11:35:47 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id s65sm4015010wmf.48.2020.01.09.11.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:47 -0800 (PST)
Subject: [PATCH net-next 13/15] r8169: rename rtl_apply_firmware
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <760aa801-0eda-756e-9690-3912eb508f47@gmail.com>
Date:   Thu, 9 Jan 2020 20:33:13 +0100
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

Rename rtl_apply_firmware() to r8169_apply_firmware() before exporting
it to avoid namespace clashes with other drivers for Realtek hardware.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 32 +++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e022f5551..f243f3695 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2287,7 +2287,7 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 	}
 }
 
-static void rtl_apply_firmware(struct rtl8169_private *tp)
+static void r8169_apply_firmware(struct rtl8169_private *tp)
 {
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
 	if (tp->rtl_fw)
@@ -2683,7 +2683,7 @@ static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
 	if (reg_val != val)
 		phydev_warn(phydev, "chipset not ready for firmware\n");
 	else
-		rtl_apply_firmware(tp);
+		r8169_apply_firmware(tp);
 }
 
 static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
@@ -2859,7 +2859,7 @@ static void rtl8168e_1_hw_phy_config(struct rtl8169_private *tp,
 		{ 0x1f, 0x0000 },
 	};
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* Enable Delay cap */
 	r8168d_phy_param(phydev, 0x8b80, 0xffff, 0xc896);
@@ -2907,7 +2907,7 @@ static void rtl_rar_exgmac_set(struct rtl8169_private *tp, u8 *addr)
 static void rtl8168e_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* Enable Delay cap */
 	r8168d_modify_extpage(phydev, 0x00ac, 0x18, 0xffff, 0x0006);
@@ -2965,7 +2965,7 @@ static void rtl8168f_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* Channel estimation fine tune */
 	phy_write_paged(phydev, 0x0003, 0x09, 0xa20f);
@@ -2993,7 +2993,7 @@ static void rtl8168f_1_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	rtl8168f_hw_phy_config(tp, phydev);
 }
@@ -3001,7 +3001,7 @@ static void rtl8168f_2_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8411_hw_phy_config(struct rtl8169_private *tp,
 				  struct phy_device *phydev)
 {
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	rtl8168f_hw_phy_config(tp, phydev);
 
@@ -3062,7 +3062,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 {
 	int ret;
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	ret = phy_read_paged(phydev, 0x0a46, 0x10);
 	if (ret & BIT(8))
@@ -3108,7 +3108,7 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp,
 static void rtl8168g_2_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 	rtl8168g_config_eee_phy(phydev);
 }
 
@@ -3118,7 +3118,7 @@ static void rtl8168h_1_hw_phy_config(struct rtl8169_private *tp,
 	u16 dout_tapbin;
 	u32 data;
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* CHN EST parameters adjust - giga master */
 	r8168g_phy_param(phydev, 0x809b, 0xf800, 0x8000);
@@ -3200,7 +3200,7 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	u16 ioffset, rlen;
 	u32 data;
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* CHIN EST parameter update */
 	r8168g_phy_param(phydev, 0x808a, 0x003f, 0x000a);
@@ -3365,7 +3365,7 @@ static void rtl8105e_hw_phy_config(struct rtl8169_private *tp,
 	phy_write(phydev, 0x18, 0x0310);
 	msleep(100);
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	phy_write_paged(phydev, 0x0005, 0x1a, 0x0000);
 	phy_write_paged(phydev, 0x0004, 0x1c, 0x0000);
@@ -3379,7 +3379,7 @@ static void rtl8402_hw_phy_config(struct rtl8169_private *tp,
 	phy_write(phydev, 0x18, 0x0310);
 	msleep(20);
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	/* EEE setting */
 	phy_write(phydev, 0x1f, 0x0004);
@@ -3402,7 +3402,7 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 	phy_write(phydev, 0x18, 0x0310);
 	msleep(100);
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	rtl_writephy_batch(phydev, phy_reg_init);
 }
@@ -3494,7 +3494,7 @@ static void rtl8125_2_hw_phy_config(struct rtl8169_private *tp,
 	r8168g_phy_param(phydev, 0x8257, 0xffff, 0x020F);
 	r8168g_phy_param(phydev, 0x80ea, 0xffff, 0x7843);
 
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	phy_modify_paged(phydev, 0xd06, 0x14, 0x0000, 0x2000);
 
@@ -4857,7 +4857,7 @@ static void rtl_hw_start_8117(struct rtl8169_private *tp)
 	r8168_mac_ocp_write(tp, 0xc09e, 0x0000);
 
 	/* firmware is for MAC only */
-	rtl_apply_firmware(tp);
+	r8169_apply_firmware(tp);
 
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
-- 
2.24.1


