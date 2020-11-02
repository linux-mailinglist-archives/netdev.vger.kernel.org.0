Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF12A2942
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgKBL1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728782AbgKBLYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:54 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5CC061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:53 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k18so9123323wmj.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gMQuO0TF59EhdWIenxAilBMJX+Rp4fB3DjjI99oSCiw=;
        b=BHv1+3SomxmuPswX/ZGrW1AXpziJDvex16QbzeRf/DRoK+AH6DXYdXPMdd6umh+R5I
         4Qf+/Wz0veGBXlVbhhBueHReG4KVgjg3nM0Gt2buLDoOCI1me92W9rdpAoPI/1zKCm1q
         cOemdk8wDVdoPeQrx5sxjV4z8VwIvDjwYsm7V8mx32WCIXE5mlp+fZNm6KWRI0J5qgtc
         ZRn/e71vqC1vc0SvjIKz31s0CjKnI9k+WTunGOOVa/r5287XZti+UiaqH9d4JDtCrA8K
         HepVguCGrex+KQ3YbEZTuXMIsAxmEpJGM80uZFCTuNtN3/Yh0WLjB4GuE3KC0jkGZNFP
         x3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gMQuO0TF59EhdWIenxAilBMJX+Rp4fB3DjjI99oSCiw=;
        b=NtV7xvYZZJFXNxS5+44GYJEwXjRS0jpP61ZSdc10b7qZ0OXtWCqqmMK9h7+1/9hOeZ
         M9WusxuPrOa4+rj/sRmpvv5B+BOvIUA+ZfVQ7he+u/tPLycFektFv4ZxQ2IBSGIlQ6XQ
         x/17SuyB8GaIOoK8jmaMPJlQcFnhghQT11cADKjpgy9zpOMUfmB722R2gT1WVIzqOpla
         K60nN4ny0q3I1JLeDai3NqqsH9tywl6+tvlc4jqQmTtIQFrYnDgVsY/etDpU+zKiAXKk
         yP7KAQNdemNjl6qEP9VL+ScSZdY5F/BkXrogtJagYahAVlmggvZCylHhqgDSkSFE8vGw
         so4g==
X-Gm-Message-State: AOAM531SXAOfH8IRy49B8sZLgXt1rP8RPoW5w57XzH9HY+ewtQ9Z0bfU
        8xzb80BBQqQmbNkjKESj0e5c/KI6BceSmA==
X-Google-Smtp-Source: ABdhPJwMDhnzvBexMyPHGfiCbnnbtTXRuLVR3F3xGz5sejFZlWKqHkSci2Q/45LmneOlsj19L/5t5Q==
X-Received: by 2002:a1c:e006:: with SMTP id x6mr17661455wmg.107.1604316292584;
        Mon, 02 Nov 2020 03:24:52 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:51 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 25/41] rtlwifi: halbtc8723b2ant: Remove a bunch of set but unused variables
Date:   Mon,  2 Nov 2020 11:23:54 +0000
Message-Id: <20201102112410.1049272-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_wifi_idle_process’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:1631:40: warning: variable ‘bt_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:1631:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_sco’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2767:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_hid’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2810:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_a2dp’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2855:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_a2dp_pan_hs’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2929:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_pan_edr’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:2976:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_pan_hs’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3028:22: warning: variable ‘wifi_rssi_state1’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3028:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_pan_edr_a2dp’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3066:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_pan_edr_hid’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3121:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_hid_a2dp_pan_edr’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3185:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c: In function ‘btc8723b2ant_action_hid_a2dp’:
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c:3244:5: warning: variable ‘wifi_rssi_state’ set but not used [-Wunused-but-set-variable]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../rtlwifi/btcoexist/halbtc8723b2ant.c       | 48 +++++++++----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index fb57cc8b2e471..7a71f063015ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -1628,17 +1628,17 @@ static void btc8723b2ant_action_wifi_link_process(struct btc_coexist
 static bool btc8723b2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1;
 	u8 ap_num = 0;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 		 coex_dm->switch_thres_offset - coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
 	      coex_dm->switch_thres_offset - coex_dm->switch_thres_offset;
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
+	btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
 
@@ -2764,10 +2764,10 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 /* SCO only or SCO+PAN(HS) */
 static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 bt_rssi_state;
 	u32 wifi_bw;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8723b2ant_bt_rssi_state(
 		btcoexist, 2, BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
 					       coex_dm->switch_thres_offset,
@@ -2807,12 +2807,12 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
@@ -2852,13 +2852,13 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 ap_num = 0;
 	u8 tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2, 40, 0);
 	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
@@ -2926,12 +2926,12 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -2973,12 +2973,12 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -3025,13 +3025,13 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 /* PAN(HS) only */
 static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
@@ -3063,12 +3063,12 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 /* PAN(EDR) + A2DP */
 static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -3118,12 +3118,12 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -3182,12 +3182,12 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID + A2DP + PAN(EDR) */
 static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -3241,13 +3241,13 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 ap_num = 0;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
 			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
 							tmp, 0);
 	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
-- 
2.25.1

