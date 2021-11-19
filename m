Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76224576F9
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhKSTZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 14:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhKSTZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 14:25:37 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F85C06173E
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 11:22:35 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so8871002plf.3
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 11:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GejJnaPkSdrFBUEbq1HDLo/AXrHzrj+OVR/ih9nOsZI=;
        b=PSHqGmKsG+m7qQBnw3EW0+1KOv87ZgTDhqln7oOivL6UFHMBY7l4TfW2O2fsVfXGcI
         s7bR4NUYnR2fH5y/GrcRhm7fRAbJS2tMpPr4AyyxrJy7CAQ4n3Ytx9lbX+HuCeZE8Acn
         9uvPNWdAWVvsaoF+zv5Jcq8iiMx7tgsOVECII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GejJnaPkSdrFBUEbq1HDLo/AXrHzrj+OVR/ih9nOsZI=;
        b=y2VyxZhOXzMCk3Zb4PI6lm0kDYWKFWNIvRDRfv/Bbh/URCVsPaJTGiq4M0jv64lFPy
         DQyCU6y3yvxM3gCaQ87RZKaffq2LWn01alhGutHVZ1JBDO2WGE/nob1Y/mbyr4Mlos9M
         ioj++oHfgK1quT2S60cg6VbAloj2rhf8SniorAW+i3DdZ4TJxYeKaQ1ZH4WjBOkBcBrY
         lCREs5QUvz7AV+vASqhwn9vUiXXYbJLO1HDpEluVNocOilhc6syskuc2kVxUUsidj7LZ
         zUMrpbwnENztOOt0A6nyHFTuyi+c9PQVN1IWVdKfxsb2JCRtAUYUtFWuRT8vfCVZnISN
         cE+A==
X-Gm-Message-State: AOAM531Muu/yyfNWqe5ickbaTuM8xtCaRwoG9x2sQVKW6HP7sctqp8sK
        s2FLzaP6uBjEf/2oztOJEI1GqA==
X-Google-Smtp-Source: ABdhPJyKHIxH8p0bpnGSbVWFIXipL9g/p5kYWTvl/90i/NpfNdV1nleVUk34JWHLVyovxNwrMJzVNQ==
X-Received: by 2002:a17:90a:d995:: with SMTP id d21mr2595804pjv.154.1637349754891;
        Fri, 19 Nov 2021 11:22:34 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q30sm350921pgl.46.2021.11.19.11.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:22:34 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        Colin Ian King <colin.king@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3] rtlwifi: rtl8192de: Style clean-ups
Date:   Fri, 19 Nov 2021 11:22:33 -0800
Message-Id: <20211119192233.1021063-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3433; h=from:subject; bh=eEEiVQZ8A0ttuPc+NS1yMiJkzEQSZvVCMArXF7UacbE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhl/l45aCKMNhG3EDjrpaJL8xAaPqrQt/Q38fyqPMr 0+roXumJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZf5eAAKCRCJcvTf3G3AJoTHEA CXQ5lFUssY2ECMJpO/wfh4002jlaJUm83BkQxBB1fHFsOfHoekMLh+iHH+dASVqHPWevbroCK8EUKP DC5iIonTvUkWKz8KTkMgFSCbptvpzDtjB4rtBswsrDPaIUJS9efI4f5Rgkmk03jRY0RoKq+LFKrN9y xTpX1Dip9B6CrFHZkkNKOf8nuA01t0tpn4yYArxP+alkdDgJQS6Nr4u3TKSEjH62fmqLnvZPgokztf WzvcEHABcQylkSIWw5uZ5+5ayBJo3OE2xW5hOissCM6mXvBh2cghrYTjlan0QNSWrHxo8BTsObm4Jv A6xmrsGwlzodq73Ardg5k91FpGfAOMo3PbxY8gH7JU+Y8DihuMxU1ruj7+6RefBHLEhXTZbCH90kZq C/cN1hNWt1wYtLDGRSxdHtrvLl6vPaFfJtX+HotWq4e1r2OTl9ikOgYcKKM1kh5wwWkwM8JeOdOdPM Xe/JD+rBsXhx0ERcs+yhqsAyWgBlfR3j4j76DzqW380ECf5ENK38FG40dWf7/Q92pgEReF/pz/p81e Ig9BQCb38qvxxufBc7Ke2gBpSXjyhUqatsi05pxRSsXHn5/PrPfooeO6/GKzGwI0dw5qxfoDtMoxw5 5lXGoo1iT3TSAZ9/c0P/HQSO+DpwmNJBh0eB0rTUgifemH2AsulWo5NA5SZQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up some style issues:
- Use ARRAY_SIZE() even though it's a u8 array.
- Remove redundant CHANNEL_MAX_NUMBER_2G define.
Additionally fix some dead code WARNs.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/lkml/57d0d1b6064342309f680f692192556c@realtek.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2->v3: rebase, add ack
---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c    | 17 +++++++----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h     |  1 -
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 9b83c710c9b8..51fe51bb0504 100644
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
 	u8 place;
 
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

