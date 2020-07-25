Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741D422D9BC
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 21:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGYT4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 15:56:23 -0400
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:55788 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728125AbgGYT4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 15:56:22 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8BAEA181D3026;
        Sat, 25 Jul 2020 19:56:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:69:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1437:1515:1605:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3870:3876:4250:4321:5007:6261:7903:7974:8957:10004:10848:10954:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12895:12986:13894:14394:21080:21611:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: crate03_310ca5526f52
X-Filterd-Recvd-Size: 19597
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:17 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 5/6] rtlwifi: Avoid multiline dereferences in rtl_dbg uses
Date:   Sat, 25 Jul 2020 12:55:07 -0700
Message-Id: <3a2fa7dadb9c0beb5e268dd2e6e71c537f29f9f5.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a more typical kernel style in rtl_dbg uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.c  |  3 +-
 .../realtek/rtlwifi/rtl8192c/phy_common.c     | 48 +++++++------------
 .../wireless/realtek/rtlwifi/rtl8192ce/phy.c  |  3 +-
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c  |  3 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/phy.c  | 48 +++++++------------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  |  3 +-
 6 files changed, 36 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 40ebc3f726f4..4771b76bdefa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -2191,8 +2191,7 @@ static bool _rtl88ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
 				"Set ERFON sleeped:%d ms\n",
 				jiffies_to_msecs(jiffies -
-						 ppsc->
-						 last_sleep_jiffies));
+						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
 			rtl88ee_phy_set_rf_on(hw);
 		}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index f7b3b55e9776..3f3a7f196843 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -230,8 +230,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][0] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][0]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][0]);
 	}
 	if (regaddr == RTXAGC_A_RATE54_24) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1] =
@@ -239,8 +238,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][1] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][1]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1]);
 	}
 	if (regaddr == RTXAGC_A_CCK1_MCS32) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6] =
@@ -248,8 +246,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][6] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][6]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6]);
 	}
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7] =
@@ -257,8 +254,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][7] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][7]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7]);
 	}
 	if (regaddr == RTXAGC_A_MCS03_MCS00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2] =
@@ -266,8 +262,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][2] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][2]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2]);
 	}
 	if (regaddr == RTXAGC_A_MCS07_MCS04) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3] =
@@ -275,8 +270,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][3] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][3]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3]);
 	}
 	if (regaddr == RTXAGC_A_MCS11_MCS08) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4] =
@@ -284,8 +278,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][4] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][4]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4]);
 	}
 	if (regaddr == RTXAGC_A_MCS15_MCS12) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5] =
@@ -293,8 +286,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][5] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][5]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5]);
 	}
 	if (regaddr == RTXAGC_B_RATE18_06) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8] =
@@ -302,8 +294,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][8] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][8]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8]);
 	}
 	if (regaddr == RTXAGC_B_RATE54_24) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9] =
@@ -311,8 +302,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][9] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][9]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9]);
 	}
 	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][14] =
@@ -320,8 +310,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][14] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][14]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][14]);
 	}
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][15] =
@@ -329,8 +318,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][15] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][15]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][15]);
 	}
 	if (regaddr == RTXAGC_B_MCS03_MCS00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10] =
@@ -338,8 +326,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][10] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][10]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10]);
 	}
 	if (regaddr == RTXAGC_B_MCS07_MCS04) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11] =
@@ -347,8 +334,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][11] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][11]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11]);
 	}
 	if (regaddr == RTXAGC_B_MCS11_MCS08) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12] =
@@ -356,8 +342,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][12] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][12]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12]);
 	}
 	if (regaddr == RTXAGC_B_MCS15_MCS12) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13] =
@@ -365,8 +350,7 @@ void _rtl92c_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][13] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][13]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13]);
 
 		rtlphy->pwrgroup_cnt++;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index 1e9978773c8d..b0a978ff6193 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -456,8 +456,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
 					"Set ERFON sleeped:%d ms\n",
 					jiffies_to_msecs(jiffies -
-							 ppsc->
-							 last_sleep_jiffies));
+							 ppsc->last_sleep_jiffies));
 				ppsc->last_awake_jiffies = jiffies;
 				rtl92ce_phy_set_rf_on(hw);
 			}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index db378370802d..56d795418e18 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -541,8 +541,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				rtl_dbg(rtlpriv, COMP_POWER, DBG_DMESG,
 					"awake, sleeped:%d ms state_inap:%x\n",
 					jiffies_to_msecs(jiffies -
-							 ppsc->
-							 last_sleep_jiffies),
+							 ppsc->last_sleep_jiffies),
 					rtlpriv->psc.state_inap);
 				ppsc->last_awake_jiffies = jiffies;
 				rtl_write_word(rtlpriv, CMDR, 0x37FC);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 393bec07618f..e7445fb74075 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -299,8 +299,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][0] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][0]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][0]);
 	}
 	if (regaddr == RTXAGC_A_RATE54_24) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1] =
@@ -308,8 +307,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][1] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][1]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1]);
 	}
 	if (regaddr == RTXAGC_A_CCK1_MCS32) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6] =
@@ -317,8 +315,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][6] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][6]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6]);
 	}
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7] =
@@ -326,8 +323,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][7] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][7]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7]);
 	}
 	if (regaddr == RTXAGC_A_MCS03_MCS00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2] =
@@ -335,8 +331,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][2] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][2]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2]);
 	}
 	if (regaddr == RTXAGC_A_MCS07_MCS04) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3] =
@@ -344,8 +339,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][3] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][3]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3]);
 	}
 	if (regaddr == RTXAGC_A_MCS11_MCS08) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4] =
@@ -353,8 +347,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][4] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][4]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4]);
 	}
 	if (regaddr == RTXAGC_A_MCS15_MCS12) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5] =
@@ -362,8 +355,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][5] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][5]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5]);
 	}
 	if (regaddr == RTXAGC_B_RATE18_06) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8] =
@@ -371,8 +363,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][8] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][8]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8]);
 	}
 	if (regaddr == RTXAGC_B_RATE54_24) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9] =
@@ -380,8 +371,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][9] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][9]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9]);
 	}
 	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][14] =
@@ -398,8 +388,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][15] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][15]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][15]);
 	}
 	if (regaddr == RTXAGC_B_MCS03_MCS00) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10] =
@@ -407,8 +396,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][10] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][10]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10]);
 	}
 	if (regaddr == RTXAGC_B_MCS07_MCS04) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11] =
@@ -416,8 +404,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][11] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][11]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11]);
 	}
 	if (regaddr == RTXAGC_B_MCS11_MCS08) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12] =
@@ -425,8 +412,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][12] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][12]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12]);
 	}
 	if (regaddr == RTXAGC_B_MCS15_MCS12) {
 		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13] =
@@ -434,8 +420,7 @@ static void store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"MCSTxPowerLevelOriginalOffset[%d][13] = 0x%x\n",
 			rtlphy->pwrgroup_cnt,
-			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							  pwrgroup_cnt][13]);
+			rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13]);
 
 		rtlphy->pwrgroup_cnt++;
 	}
@@ -1579,8 +1564,7 @@ static bool _rtl8723e_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
 				"Set ERFON sleeped:%d ms\n",
 				jiffies_to_msecs(jiffies -
-						 ppsc->
-						 last_sleep_jiffies));
+						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
 			rtl8723e_phy_set_rf_on(hw);
 		}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 085d9e9c44ed..2255c9b9fc16 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -4738,8 +4738,7 @@ static bool _rtl8821ae_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
 				"Set ERFON sleeped:%d ms\n",
 				jiffies_to_msecs(jiffies -
-						 ppsc->
-						 last_sleep_jiffies));
+						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
 			rtl8821ae_phy_set_rf_on(hw);
 		}
-- 
2.26.0

