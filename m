Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9DE22D9BA
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 21:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgGYT4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 15:56:19 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:35990 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728031AbgGYT4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 15:56:18 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 874EB18029210;
        Sat, 25 Jul 2020 19:56:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:4:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1437:1515:1605:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3870:3876:4321:4605:5007:6117:6261:7904:7974:10004:10848:10954:11026:11233:11473:11657:11658:11914:12043:12296:12297:12438:12555:12895:12986:13255:13894:14394:14877:21080:21433:21451:21627:21740:21990:30030:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:0,LUA_SUMMARY:none
X-HE-Tag: event69_2e06efa26f52
X-Filterd-Recvd-Size: 19090
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:14 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] rtlwifi: Convert rtl_dbg embedded function names to %s: ..., __func__
Date:   Sat, 25 Jul 2020 12:55:06 -0700
Message-Id: <ae80c9cb4dd8315edd051f338a864690e5bdb6cf.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a more typical kernel style for embedded function names in
debug logging statements.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  3 +--
 drivers/net/wireless/realtek/rtlwifi/cam.c         | 14 ++++++--------
 drivers/net/wireless/realtek/rtlwifi/core.c        |  7 ++++---
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  8 ++++----
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  3 +--
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |  3 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  3 +--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |  2 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c     | 11 +++++------
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |  3 +--
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |  3 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 11 ++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  4 ++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 11 ++++-------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   | 10 ++++++----
 15 files changed, 42 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index f9a2d8a6730c..5f8baf78589b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -129,8 +129,7 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
 
 	if (rtlphy->current_channel != 0)
 		chnl = rtlphy->current_channel;
-	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"static halbtc_get_wifi_central_chnl:%d\n", chnl);
+	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "%s:%d\n", __func__, chnl);
 	return chnl;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
index fb321b34a592..7aa28da39409 100644
--- a/drivers/net/wireless/realtek/rtlwifi/cam.c
+++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
@@ -142,9 +142,9 @@ int rtl_cam_delete_one_entry(struct ieee80211_hw *hw,
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	rtl_dbg(rtlpriv, COMP_SEC, DBG_DMESG,
-		"rtl_cam_delete_one_entry(): WRITE A4: %x\n", 0);
+		"%s: WRITE A4: %x\n", __func__, 0);
 	rtl_dbg(rtlpriv, COMP_SEC, DBG_DMESG,
-		"rtl_cam_delete_one_entry(): WRITE A0: %x\n", ul_command);
+		"%s: WRITE A0: %x\n", __func__, ul_command);
 
 	return 0;
 
@@ -196,9 +196,9 @@ void rtl_cam_mark_invalid(struct ieee80211_hw *hw, u8 uc_index)
 	rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 	rtl_dbg(rtlpriv, COMP_SEC, DBG_DMESG,
-		"rtl_cam_mark_invalid(): WRITE A4: %x\n", ul_content);
+		"%s: WRITE A4: %x\n", __func__, ul_content);
 	rtl_dbg(rtlpriv, COMP_SEC, DBG_DMESG,
-		"rtl_cam_mark_invalid(): WRITE A0: %x\n", ul_command);
+		"%s: WRITE A0: %x\n", __func__, ul_command);
 }
 EXPORT_SYMBOL(rtl_cam_mark_invalid);
 
@@ -246,11 +246,9 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
 		rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM], ul_command);
 
 		rtl_dbg(rtlpriv, COMP_SEC, DBG_LOUD,
-			"rtl_cam_empty_entry(): WRITE A4: %x\n",
-			ul_content);
+			"%s: WRITE A4: %x\n", __func__, ul_content);
 		rtl_dbg(rtlpriv, COMP_SEC, DBG_LOUD,
-			"rtl_cam_empty_entry(): WRITE A0: %x\n",
-			ul_command);
+			"%s: WRITE A0: %x\n", __func__, ul_command);
 	}
 
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 6ecbcd6222eb..f97a88408a9b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1766,7 +1766,8 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 	do {
 		cfg_cmd = pwrcfgcmd[ary_idx];
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
-			"rtl_hal_pwrseqcmdparsing(): offset(%#x),cut_msk(%#x), famsk(%#x), interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), value(%#x)\n",
+			"%s: offset(%#x),cut_msk(%#x), famsk(%#x), interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), value(%#x)\n",
+			__func__,
 			GET_PWR_CFG_OFFSET(cfg_cmd),
 			GET_PWR_CFG_CUT_MASK(cfg_cmd),
 			GET_PWR_CFG_FAB_MASK(cfg_cmd),
@@ -1819,7 +1820,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				break;
 			case PWR_CMD_DELAY:
 				rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
-					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_DELAY\n");
+					"%s: PWR_CMD_DELAY\n", __func__);
 				if (GET_PWR_CFG_VALUE(cfg_cmd) ==
 				    PWRSEQ_DELAY_US)
 					udelay(GET_PWR_CFG_OFFSET(cfg_cmd));
@@ -1828,7 +1829,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				break;
 			case PWR_CMD_END:
 				rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
-					"rtl_hal_pwrseqcmdparsing(): PWR_CMD_END\n");
+					"%s: PWR_CMD_END\n", __func__);
 				return true;
 			default:
 				WARN_ONCE(true,
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index c7ee956ea92f..2e945554ed6d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -212,8 +212,8 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 
 	if ((_offset + _size_byte) > rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]) {
 		rtl_dbg(rtlpriv, COMP_EFUSE, DBG_LOUD,
-			"read_efuse(): Invalid offset(%#x) with read bytes(%#x)!!\n",
-			_offset, _size_byte);
+			"%s: Invalid offset(%#x) with read bytes(%#x)!!\n",
+			__func__, _offset, _size_byte);
 		return;
 	}
 
@@ -377,8 +377,8 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
 		result = false;
 
 	rtl_dbg(rtlpriv, COMP_EFUSE, DBG_LOUD,
-		"efuse_shadow_update_chk(): totalbytes(%#x), hdr_num(%#x), words_need(%#x), efuse_used(%d)\n",
-		totalbytes, hdr_num, words_need, efuse_used);
+		"%s: totalbytes(%#x), hdr_num(%#x), words_need(%#x), efuse_used(%d)\n",
+		__func__, totalbytes, hdr_num, words_need, efuse_used);
 
 	return result;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index fc05563117ad..bf640b082bd1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -881,8 +881,7 @@ static void dm_txpower_track_cb_therm(struct ieee80211_hw *hw)
 
 	/*Initilization (7 steps in total) */
 	rtlpriv->dm.txpower_trackinginit = true;
-	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		"dm_txpower_track_cb_therm\n");
+	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "%s\n", __func__);
 
 	thermalvalue = (u8)rtl_get_rfreg(hw, RF90_PATH_A, RF_T_METER,
 					 0xfc00);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 8c68a446b9e5..5d1a0307fc5d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -713,8 +713,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 	u8 ofdm_min_index = 6, rf;
 
 	rtlpriv->dm.txpower_trackinginit = true;
-	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		"rtl92c_dm_txpower_tracking_callback_thermalmeter\n");
+	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "%s\n", __func__);
 
 	thermalvalue = (u8) rtl_get_rfreg(hw, RF90_PATH_A, RF_T_METER, 0x1f);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 469dbdba57ef..6d1512cde593 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -606,8 +606,7 @@ static void phy_convert_txpwr_dbm_to_rel_val(struct ieee80211_hw *hw)
 			0, 3, base);
 	}
 
-	rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE,
-		"<==phy_convert_txpwr_dbm_to_rel_val()\n");
+	rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE, "<==%s\n", __func__);
 }
 
 static void _rtl92ee_phy_txpower_by_rate_configuration(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
index ac332811f46e..8ada31380efa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
@@ -827,7 +827,7 @@ void rtl8723e_dm_bt_coexist(struct ieee80211_hw *hw)
 
 	if (!rtlpriv->btcoexist.init_set) {
 		rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			"[DM][BT], rtl8723e_dm_bt_coexist()\n");
+			"[DM][BT], %s\n", __func__);
 		rtl8723e_dm_init_bt_coexist(hw);
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
index bfa736138034..c1ae9c30be65 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
@@ -343,8 +343,7 @@ long rtl8723e_dm_bt_get_rx_ss(struct ieee80211_hw *hw)
 			= rtlpriv->dm.entry_min_undec_sm_pwdb;
 	}
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
-		"rtl8723e_dm_bt_get_rx_ss() = %ld\n",
-		undecoratedsmoothed_pwdb);
+		"%s: %ld\n", __func__, undecoratedsmoothed_pwdb);
 
 	return undecoratedsmoothed_pwdb;
 }
@@ -461,13 +460,13 @@ void rtl8723e_dm_bt_sw_coex_all_off(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
-		"rtl8723e_dm_bt_sw_coex_all_off()\n");
+		"%s\n", __func__);
 
 	if (rtlpriv->btcoexist.sw_coexist_all_off)
 		return;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
-		"rtl8723e_dm_bt_sw_coex_all_off(), real Do\n");
+		"%s: real Do\n", __func__);
 	rtl8723e_dm_bt_sw_coex_all_off_8723a(hw);
 	rtlpriv->btcoexist.sw_coexist_all_off = true;
 }
@@ -477,12 +476,12 @@ void rtl8723e_dm_bt_hw_coex_all_off(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
-		"rtl8723e_dm_bt_hw_coex_all_off()\n");
+		"%s\n", __func__);
 
 	if (rtlpriv->btcoexist.hw_coexist_all_off)
 		return;
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
-		"rtl8723e_dm_bt_hw_coex_all_off(), real Do\n");
+		"%s: real Do\n", __func__);
 
 	rtl8723e_dm_bt_hw_coex_all_off_8723a(hw);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index a3fad0ff207f..ad6a366a7ed7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -747,8 +747,7 @@ static void rtl8723be_dm_txpower_tracking_callback_thermalmeter(
 
 	/*Initilization ( 7 steps in total )*/
 	rtlpriv->dm.txpower_trackinginit = true;
-	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		"rtl8723be_dm_txpower_tracking_callback_thermalmeter\n");
+	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "%s\n", __func__);
 
 	thermalvalue = (u8)rtl_get_rfreg(hw,
 		RF90_PATH_A, RF_T_METER, 0xfc00);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index d06f63ab36d9..b43574c44117 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -477,8 +477,7 @@ static void _rtl8723be_phy_convert_txpower_dbm_to_relative_value(
 	    &rtlphy->tx_power_by_rate_offset[BAND_ON_2_4G][rfpath][RF_2TX][7],
 	    0, 3, base);
 
-	rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE,
-		"<===_rtl8723be_phy_convert_txpower_dbm_to_relative_value()\n");
+	rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE, "<===%s\n", __func__);
 }
 
 static void phy_txpower_by_rate_config(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 9f4a9f3c0f60..a257cc21c18d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1187,8 +1187,7 @@ void rtl8812ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 		tx_rate =
 			rtl8821ae_hw_rate_to_mrate(hw, rtldm->tx_rate);
 
-	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		"===>rtl8812ae_dm_txpwr_track_set_pwr\n");
+	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "===>%s\n", __func__);
 	/*20130429 Mimic Modify High Rate BBSwing Limit.*/
 	if (tx_rate != 0xFF) {
 		/*CCK*/
@@ -1265,7 +1264,7 @@ void rtl8812ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 
 	if (method == BBSWING) {
 		rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-			"===>rtl8812ae_dm_txpwr_track_set_pwr\n");
+			"===>%s\n", __func__);
 
 		if (rf_path == RF90_PATH_A) {
 			u32 tmp;
@@ -1794,8 +1793,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 	if (delta_iqk >= IQK_THRESHOLD)
 		rtl8812ae_do_iqk(hw, delta_iqk, thermal_value, 8);
 
-	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		"<===rtl8812ae_dm_txpower_tracking_callback_thermalmeter\n");
+	rtl_dbg(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "<===%s\n", __func__);
 }
 
 static void rtl8821ae_get_delta_swing_table(struct ieee80211_hw *hw,
@@ -2492,8 +2490,7 @@ static void rtl8821ae_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	bool b_bias_on_rx = false;
 	bool b_edca_turbo_on = false;
 
-	rtl_dbg(rtlpriv, COMP_TURBO, DBG_LOUD,
-		"rtl8821ae_dm_check_edca_turbo=====>\n");
+	rtl_dbg(rtlpriv, COMP_TURBO, DBG_LOUD, "%s=====>\n", __func__);
 	rtl_dbg(rtlpriv, COMP_TURBO, DBG_LOUD,
 		"Original BE PARAM: 0x%x\n",
 		rtl_read_dword(rtlpriv, DM_REG_EDCA_BE_11N));
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 55f3e0f3b8f0..929441c8d8c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1987,7 +1987,7 @@ int rtl8821ae_hw_init(struct ieee80211_hw *hw)
 	rtl8821ae_dm_init(hw);
 	rtl8821ae_macid_initialize_mediastatus(hw);
 
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "rtl8821ae_hw_init() <====\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "%s <====\n", __func__);
 	return err;
 }
 
@@ -2183,7 +2183,7 @@ int rtl8821ae_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "rtl8821ae_set_network_type!\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "%s!\n", __func__);
 
 	if (_rtl8821ae_set_media_status(hw, type))
 		return -EOPNOTSUPP;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 1c6988d6d597..085d9e9c44ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -723,7 +723,7 @@ void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
 	}
 
 	rtl_dbg(rtlpriv, COMP_SCAN, DBG_TRACE,
-		"<==rtl8821ae_phy_switch_wirelessband():Switch Band OK.\n");
+		"<==%s:Switch Band OK\n", __func__);
 	return;
 }
 
@@ -1431,8 +1431,7 @@ static void _rtl8812ae_phy_convert_txpower_limit_to_power_index(struct ieee80211
 			}
 		}
 	}
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
-		"<===== _rtl8812ae_phy_convert_txpower_limit_to_power_index()\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE, "<===== %s\n", __func__);
 }
 
 static void _rtl8821ae_phy_init_txpower_limit(struct ieee80211_hw *hw)
@@ -1441,8 +1440,7 @@ static void _rtl8821ae_phy_init_txpower_limit(struct ieee80211_hw *hw)
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	u8 i, j, k, l, m;
 
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"=====> _rtl8821ae_phy_init_txpower_limit()!\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "=====> %s!\n", __func__);
 
 	for (i = 0; i < MAX_REGULATION_NUM; ++i) {
 		for (j = 0; j < MAX_2_4G_BANDWIDTH_NUM; ++j)
@@ -1463,8 +1461,7 @@ static void _rtl8821ae_phy_init_txpower_limit(struct ieee80211_hw *hw)
 							= MAX_POWER_INDEX;
 	}
 
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"<===== _rtl8821ae_phy_init_txpower_limit()!\n");
+	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "<===== %s!\n", __func__);
 }
 
 static void _rtl8821ae_phy_convert_txpower_dbm_to_relative_value(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 379c4de7aff1..740059de2603 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -559,8 +559,8 @@ static u8 rtl8821ae_bw_mapping(struct ieee80211_hw *hw,
 	u8 bw_setting_of_desc = 0;
 
 	rtl_dbg(rtlpriv, COMP_SEND, DBG_TRACE,
-		"rtl8821ae_bw_mapping, current_chan_bw %d, packet_bw %d\n",
-		rtlphy->current_chan_bw, ptcb_desc->packet_bw);
+		"%s: current_chan_bw %d, packet_bw %d\n",
+		__func__, rtlphy->current_chan_bw, ptcb_desc->packet_bw);
 
 	if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_80) {
 		if (ptcb_desc->packet_bw == HT_CHANNEL_WIDTH_80)
@@ -603,7 +603,8 @@ static u8 rtl8821ae_sc_mapping(struct ieee80211_hw *hw,
 					VHT_DATA_SC_40_UPPER_OF_80MHZ;
 			else
 				rtl_dbg(rtlpriv, COMP_SEND, DBG_LOUD,
-					"rtl8821ae_sc_mapping: Not Correct Primary40MHz Setting\n");
+					"%s: Not Correct Primary40MHz Setting\n",
+					__func__);
 		} else {
 			if ((mac->cur_40_prime_sc ==
 			     HAL_PRIME_CHNL_OFFSET_LOWER) &&
@@ -631,7 +632,8 @@ static u8 rtl8821ae_sc_mapping(struct ieee80211_hw *hw,
 					VHT_DATA_SC_20_UPPERST_OF_80MHZ;
 			else
 				rtl_dbg(rtlpriv, COMP_SEND, DBG_LOUD,
-					"rtl8821ae_sc_mapping: Not Correct Primary40MHz Setting\n");
+					"%s: Not Correct Primary40MHz Setting\n",
+					__func__);
 		}
 	} else if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40) {
 		if (ptcb_desc->packet_bw == HT_CHANNEL_WIDTH_20_40) {
-- 
2.26.0

