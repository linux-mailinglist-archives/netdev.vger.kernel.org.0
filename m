Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F632129620
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLWMw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:52:28 -0500
Received: from srv2.anyservers.com ([77.79.239.202]:55646 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfLWMw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:52:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TjhyZtVGXeZiT/7ziQoThyRywRWC9b0F5fUg+oxiM5Y=; b=rX6KxPMVrkp6MBh3aQqgueT0Nf
        MlMdBwLJeOXAtFX1QO5P4C6iTT0ASsbIZPNqE7WQg44BbWrGQ/Hjsa605y8yDF4zmzRrUdhwtUnLn
        ayLfW7q9raV8TaZVI495E0ERkQBh91JzZITMADzFXZwhHoeuEo3AWmunbE9IZ466FjdyhZcs+JWuH
        G6kJ53tarH53zTmik6/3LAtXkaANYEJ0gDzo7LaIi0CAQxB/Ly7q8uGchgX5KoqlioFaPDnmpDw4c
        Eai3/KpVK6CnXo49D0kfDUITuN8i2EAtvWjXqfbDsxB98nwzSxLtRoNE2Byh0ABSJiDUIUFejQIJb
        KDocwIOg==;
Received: from 89-64-37-27.dynamic.chello.pl ([89.64.37.27]:49046 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <amade@asmblr.net>)
        id 1ijMxP-00Gi5o-61; Mon, 23 Dec 2019 13:37:07 +0100
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [PATCH 1/9] rtlwifi: rtl8192cu: Fix typo
Date:   Mon, 23 Dec 2019 13:37:07 +0100
Message-Id: <20191223123715.7177-2-amade@asmblr.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223123715.7177-1-amade@asmblr.net>
References: <20191223123715.7177-1-amade@asmblr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace USB_VENDER_ID_REALTEK with USB_VENDOR_ID_REALTEK.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 .../wireless/realtek/rtlwifi/rtl8192cu/sw.c   | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index ab3e4aebad39..6b954059e830 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -252,45 +252,45 @@ static struct rtl_hal_cfg rtl92cu_hal_cfg = {
 	.maps[RTL_RC_HT_RATEMCS15] = DESC_RATEMCS15,
 };
 
-#define USB_VENDER_ID_REALTEK		0x0bda
+#define USB_VENDOR_ID_REALTEK		0x0bda
 
 /* 2010-10-19 DID_USB_V3.4 */
 static const struct usb_device_id rtl8192c_usb_ids[] = {
 
 	/*=== Realtek demoboard ===*/
 	/* Default ID */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8191, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8191, rtl92cu_hal_cfg)},
 
 	/****** 8188CU ********/
 	/* RTL8188CTV */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x018a, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x018a, rtl92cu_hal_cfg)},
 	/* 8188CE-VAU USB minCard */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8170, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8170, rtl92cu_hal_cfg)},
 	/* 8188cu 1*1 dongle */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8176, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8176, rtl92cu_hal_cfg)},
 	/* 8188cu 1*1 dongle, (b/g mode only) */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8177, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8177, rtl92cu_hal_cfg)},
 	/* 8188cu Slim Solo */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817a, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817a, rtl92cu_hal_cfg)},
 	/* 8188cu Slim Combo */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817b, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817b, rtl92cu_hal_cfg)},
 	/* 8188RU High-power USB Dongle */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817d, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817d, rtl92cu_hal_cfg)},
 	/* 8188CE-VAU USB minCard (b/g mode only) */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817e, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817e, rtl92cu_hal_cfg)},
 	/* 8188RU in Alfa AWUS036NHR */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
 	/* RTL8188CUS-VL */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x819a, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x819a, rtl92cu_hal_cfg)},
 	/* 8188 Combo for BC4 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
 
 	/****** 8192CU ********/
 	/* 8192cu 2*2 */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8178, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x8178, rtl92cu_hal_cfg)},
 	/* 8192CE-VAU USB minCard */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817c, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x817c, rtl92cu_hal_cfg)},
 
 	/*=== Customer ID ===*/
 	/****** 8188CU ********/
@@ -329,7 +329,7 @@ static const struct usb_device_id rtl8192c_usb_ids[] = {
 
 	/****** 8188 RU ********/
 	/* Netcore */
-	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x317f, rtl92cu_hal_cfg)},
+	{RTL_USB_DEVICE(USB_VENDOR_ID_REALTEK, 0x317f, rtl92cu_hal_cfg)},
 
 	/****** 8188CUS Slim Solo********/
 	{RTL_USB_DEVICE(0x04f2, 0xaff7, rtl92cu_hal_cfg)}, /*Xavi*/
-- 
2.24.1

