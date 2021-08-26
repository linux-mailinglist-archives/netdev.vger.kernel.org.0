Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648943F807F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 04:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbhHZCdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 22:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhHZCdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 22:33:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69758C061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:32:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id n12so824007plk.10
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 19:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sa/nW4B31bLiuXLun+YFSekb3642FEfxwXU0dTsAlnE=;
        b=ZBuTlfplIkQb+vR5ip3wVmXdUxEEOH1wxloijrdnzs+f/S0pQk9kJovxrg9D+lWhqj
         Vm9mcR0i1n5d9xZRDPVXKdMKeBDXm5nr61rdjKONWqkMfAvcOFxcx+Iih6waiGir8fPX
         7EuoL3M1gBfMN8ry0QCWW07peLlJiAplQSzq0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sa/nW4B31bLiuXLun+YFSekb3642FEfxwXU0dTsAlnE=;
        b=eAAF9oChOaZkESI0U7YAGOusweZIdi9ZZ05cqKksZ4BDcKeagfSd3PG5Hh1UGRf9mV
         J3/hfYQTrT8gu3PqquH2L0luhaH5OCYmC89Zy9EGYAnN1PXI4eLbhURZ0aVYcGCUgp4Y
         PZoa4U/JRXMCUosKEHEUiPLvUfX+tvI0gJkvUBNFCPWh2L6lE3VnhAACBSRY7pB5wdrq
         KcSe74zMmQ3XGPb9jWzfD7C6M2ZOE2w/V2kle/LCdeBC0DBPJ4BR5Nt+090lWMDDwaRK
         oItaNNf62fQt7ge4uIUjdY1FJQQ5Cgrefjs1gxirVYTdHnNrvuK9h10/ilEvbo9OCkx/
         N3RQ==
X-Gm-Message-State: AOAM532vbct62OlNYLGkUvaXVenhiMNyuvlogvUTZO3dHJqGbwYl8pTO
        egop0AulkPW19ZRMaVHdfO6p0g==
X-Google-Smtp-Source: ABdhPJwG0OmgF8T2Bnu61CNWcQJbxDyUgb85RYFbTKg0hsA7liR0FTDs0T8UMHjGh6ZumqMzNe73Ug==
X-Received: by 2002:a17:903:410b:b0:137:c1d1:78da with SMTP id r11-20020a170903410b00b00137c1d178damr1566164pld.8.1629945152976;
        Wed, 25 Aug 2021 19:32:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g6sm861512pfv.156.2021.08.25.19.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 19:32:32 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2] rtlwifi: rtl8192de: Style clean-ups
Date:   Wed, 25 Aug 2021 19:32:30 -0700
Message-Id: <20210826023230.1148924-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3604; h=from:subject; bh=Nk85qP5mbq9tmesp4DRR/h+08jrOCCvAl9nQvtsIsB8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhJv09j1hxATAHrt4DQPNUVX517LRlIh6QF+knxxZZ slv/y+uJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYSb9PQAKCRCJcvTf3G3AJmVRD/ kBx4q7+vGSsn7a7qzkLKNkPwOmwW2Rjbvs50U496QZKQXznRU6WNH32WQDAEDjTTo9WGkgI0GFsgSH KzGCocxCNuPZlZ4ozZrt1j4SPq4G5o6BMdo5RfjCd4mPlMaDuzqcADQ+V/hEP1r4c6vqwVI5ONPEEI q8cArDxrdCA/Yx5KxPo2Fn/1AsndjNm/1DarOQMmEQ/BvyX1rxf4SfapXMaTedMztDsl8cQ/wQLo4z p+GOEyz/I5TIGEK5oInUbaGuTuQXUPLus7mCOaIl0mWR8EhG7YCHziyhCqc6Ja+ea+4scxV6P3BePn 6h5YFD7eO5j2nHd2gV/0UNCuQhYj0oiEwMQztQ0Zxx8R9zD/SdzWsLWuHDKlaXYAPVGftl7i7DxbYG 1011nWdsNVipd8sY7oLzGiBTPkt3EShGqZYH4E1wsI02hd3lwfvJNPGa0h2Ybfd76gcvbnHjxTe35Q xe1E48Irfuv9cvJXQRlkUJEUI4IcaCNprYUS+z64Woxqs1H4nMwGwFjQK0DakSidLJYzNuIFatwA70 nH+dMqXAW5xj2StHIvjDdeu5KHVgN4deqEm3QzZw+R3BZ8viHhtM1CIlg1SzQNRJE7g6YSQ0B5gxU4 0/ZqyOBUaIeIpWsvLLyVGLuxxzLHR4qMfltpd8u77+Sbfyrpnet0WpC30liA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up some style issues:
- Use ARRAY_SIZE() for arrays (even when u8 sized)
- Remove redundant CHANNEL_MAX_NUMBER_2G define.
Additionally fix some dead code WARNs.

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c    | 17 +++++++----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h     |  1 -
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index b32fa7a75f17..d73148805b9c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -899,7 +899,7 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel5g); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
 			if (channel5g[place] == chnl) {
 				place++;
 				break;
@@ -1366,7 +1366,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel_all); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
 			if (channel_all[place] == chnl)
 				return place - 13;
 		}
@@ -2428,7 +2428,7 @@ static bool _rtl92d_is_legal_5g_channel(struct ieee80211_hw *hw, u8 channel)
 
 	int i;
 
-	for (i = 0; i < sizeof(channel5g); i++)
+	for (i = 0; i < ARRAY_SIZE(channel5g); i++)
 		if (channel == channel5g[i])
 			return true;
 	return false;
@@ -2692,9 +2692,8 @@ void rtl92d_phy_reset_iqk_result(struct ieee80211_hw *hw)
 	u8 i;
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"settings regs %d default regs %d\n",
-		(int)(sizeof(rtlphy->iqk_matrix) /
-		      sizeof(struct iqk_matrix_regs)),
+		"settings regs %zu default regs %d\n",
+		ARRAY_SIZE(rtlphy->iqk_matrix),
 		IQK_MATRIX_REG_NUM);
 	/* 0xe94, 0xe9c, 0xea4, 0xeac, 0xeb4, 0xebc, 0xec4, 0xecc */
 	for (i = 0; i < IQK_MATRIX_SETTINGS_NUM; i++) {
@@ -2861,16 +2860,14 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
 	case BAND_ON_5G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel <= 14)
+		if (WARN_ONCE(channel <= 14, "rtl8192de: 5G but channel<=14\n"))
 			return 0;
-		WARN_ONCE((channel <= 14), "rtl8192de: 5G but channel<=14\n");
 		break;
 	case BAND_ON_2_4G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel > 14)
+		if (WARN_ONCE(channel > 14, "rtl8192de: 2G but channel>14\n"))
 			return 0;
-		WARN_ONCE((channel > 14), "rtl8192de: 2G but channel>14\n");
 		break;
 	default:
 		WARN_ONCE(true, "rtl8192de: Invalid WirelessMode(%#x)!!\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index aa07856411b1..31f9e9e5c680 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -108,7 +108,6 @@
 #define	CHANNEL_GROUP_IDX_5GM		6
 #define	CHANNEL_GROUP_IDX_5GH		9
 #define	CHANNEL_GROUP_MAX_5G		9
-#define CHANNEL_MAX_NUMBER_2G		14
 #define AVG_THERMAL_NUM			8
 #define AVG_THERMAL_NUM_88E		4
 #define AVG_THERMAL_NUM_8723BE		4
-- 
2.30.2

