Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6278D20C761
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 12:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgF1KSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 06:18:03 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:35278 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725921AbgF1KSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 06:18:01 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id DB0A7100E7B42;
        Sun, 28 Jun 2020 10:17:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:1:41:69:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2639:2828:3138:3139:3140:3141:3142:3865:3866:3870:4250:4321:5007:6119:7903:10004:10848:11026:11473:11657:11658:11914:12043:12296:12297:12438:12555:12760:12986:13019:13439:14096:14097:14394:14659:21080:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: fish10_56116cb26e65
X-Filterd-Recvd-Size: 13992
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sun, 28 Jun 2020 10:17:57 +0000 (UTC)
Message-ID: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
Subject: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 28 Jun 2020 03:17:56 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce data usage about 1KB by using const.

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |  4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 98 ++++++++++++----------
 3 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index dceb04a9b3f5..1ffa188a65c9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -870,11 +870,11 @@ static void dm_txpower_track_cb_therm(struct ieee80211_hw *hw)
 	/*0.1 the following TWO tables decide the
 	 *final index of OFDM/CCK swing table
 	 */
-	s8 delta_swing_table_idx[2][15]  = {
+	static const s8 delta_swing_table_idx[2][15]  = {
 		{0, 0, 2, 3, 4, 4, 5, 6, 7, 7, 8, 9, 10, 10, 11},
 		{0, 0, -1, -2, -3, -4, -4, -4, -4, -5, -7, -8, -9, -9, -10}
 	};
-	u8 thermal_threshold[2][15] = {
+	static const u8 thermal_threshold[2][15] = {
 		{0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 27},
 		{0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 25, 25, 25}
 	};
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
index b13fd3c0c832..c9b3d9d09c48 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
@@ -736,11 +736,11 @@ static void rtl8723be_dm_txpower_tracking_callback_thermalmeter(
 	u8 ofdm_min_index = 6;
 	u8 index_for_channel = 0;
 
-	s8 delta_swing_table_idx_tup_a[TXSCALE_TABLE_SIZE] = {
+	static const s8 delta_swing_table_idx_tup_a[TXSCALE_TABLE_SIZE] = {
 		0, 0, 1, 2, 2, 2, 3, 3, 3, 4,  5,
 		5, 6, 6, 7, 7, 8, 8, 9, 9, 9, 10,
 		10, 11, 11, 12, 12, 13, 14, 15};
-	s8 delta_swing_table_idx_tdown_a[TXSCALE_TABLE_SIZE] = {
+	static const s8 delta_swing_table_idx_tdown_a[TXSCALE_TABLE_SIZE] = {
 		0, 0, 1, 2, 2, 2, 3, 3, 3, 4,  5,
 		5, 6, 6, 6, 6, 7, 7, 7, 8, 8,  9,
 		9, 10, 10, 11, 12, 13, 14, 15};
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index f57e8794f0ec..b8e653eb8817 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -115,47 +115,47 @@ static const u32 edca_setting_ul[PEER_MAX] = {
 	0x5ea44f,	/* 7 MARV */
 };
 
-static u8 rtl8818e_delta_swing_table_idx_24gb_p[] = {
+static const u8 rtl8818e_delta_swing_table_idx_24gb_p[] = {
 	0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 4,
 	4, 4, 4, 5, 5, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9};
 
-static u8 rtl8818e_delta_swing_table_idx_24gb_n[] = {
+static const u8 rtl8818e_delta_swing_table_idx_24gb_n[] = {
 	0, 0, 0, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 6, 6,
 	7, 7, 7, 7, 8, 8, 9, 9, 10, 10, 10, 11, 11, 11, 11};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gb_n[]  = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gb_n[]  = {
 	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6,
 	6, 6, 7, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gb_p[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gb_p[] = {
 	0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6,
 	6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 9};
 
-static u8 rtl8812ae_delta_swing_table_idx_24ga_n[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24ga_n[] = {
 	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6,
 	6, 6, 7, 8, 8, 9, 9, 9, 10, 10, 10, 10, 11, 11};
 
-static u8 rtl8812ae_delta_swing_table_idx_24ga_p[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24ga_p[] = {
 	0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6,
 	6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 9};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gcckb_n[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gcckb_n[] = {
 	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6,
 	6, 6, 7, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gcckb_p[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gcckb_p[] = {
 	0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6,
 	6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 9};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gccka_n[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gccka_n[] = {
 	0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 5, 6,
 	6, 6, 7, 8, 8, 9, 9, 9, 10, 10, 10, 10, 11, 11};
 
-static u8 rtl8812ae_delta_swing_table_idx_24gccka_p[] = {
+static const u8 rtl8812ae_delta_swing_table_idx_24gccka_p[] = {
 	0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6,
 	6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 9, 9};
 
-static u8 rtl8812ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8812ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
 	{0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7,
 	7, 8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13},
 	{0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7,
@@ -164,7 +164,7 @@ static u8 rtl8812ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
 	12, 12, 13, 14, 14, 14, 15, 16, 17, 17, 17, 18, 18, 18},
 };
 
-static u8 rtl8812ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8812ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
 	{0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11},
 	{0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8,
@@ -173,7 +173,7 @@ static u8 rtl8812ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
 	9, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
 };
 
-static u8 rtl8812ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8812ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
 	{0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 13, 13, 13},
 	{0, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 8, 9,
@@ -182,7 +182,7 @@ static u8 rtl8812ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
 	12, 13, 14, 14, 15, 15, 15, 16, 16, 16, 17, 17, 18, 18},
 };
 
-static u8 rtl8812ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8812ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
 	{0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 11, 11, 11, 11, 11, 11},
 	{0, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, 6, 7, 7, 8,
@@ -191,39 +191,39 @@ static u8 rtl8812ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
 	10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
 };
 
-static u8 rtl8821ae_delta_swing_table_idx_24gb_n[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gb_n[] = {
 	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
 	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
 
-static u8 rtl8821ae_delta_swing_table_idx_24gb_p[]  = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gb_p[]  = {
 	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
 
-static u8 rtl8821ae_delta_swing_table_idx_24ga_n[]  = {
+static const u8 rtl8821ae_delta_swing_table_idx_24ga_n[]  = {
 	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
 	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
 
-static u8 rtl8821ae_delta_swing_table_idx_24ga_p[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24ga_p[] = {
 	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
 
-static u8 rtl8821ae_delta_swing_table_idx_24gcckb_n[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gcckb_n[] = {
 	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
 	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
 
-static u8 rtl8821ae_delta_swing_table_idx_24gcckb_p[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gcckb_p[] = {
 	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
 
-static u8 rtl8821ae_delta_swing_table_idx_24gccka_n[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gccka_n[] = {
 	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
 	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
 
-static u8 rtl8821ae_delta_swing_table_idx_24gccka_p[] = {
+static const u8 rtl8821ae_delta_swing_table_idx_24gccka_p[] = {
 	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
 	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
 
-static u8 rtl8821ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8821ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
@@ -232,7 +232,7 @@ static u8 rtl8821ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] = {
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 };
 
-static u8 rtl8821ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8821ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
@@ -241,7 +241,7 @@ static u8 rtl8821ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] = {
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 };
 
-static u8 rtl8821ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8821ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
@@ -250,7 +250,7 @@ static u8 rtl8821ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] = {
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 };
 
-static u8 rtl8821ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
+static const u8 rtl8821ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
 	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
 	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
@@ -962,8 +962,10 @@ static void rtl8821ae_dm_iq_calibrate(struct ieee80211_hw *hw)
 }
 
 static void rtl8812ae_get_delta_swing_table(struct ieee80211_hw *hw,
-					    u8 **up_a, u8 **down_a,
-					    u8 **up_b, u8 **down_b)
+					    const u8 **up_a,
+					    const u8 **down_a,
+					    const u8 **up_b,
+					    const u8 **down_b)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -1492,17 +1494,17 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 	/* 1. The following TWO tables decide
 	 * the final index of OFDM/CCK swing table.
 	 */
-	u8 *delta_swing_table_idx_tup_a;
-	u8 *delta_swing_table_idx_tdown_a;
-	u8 *delta_swing_table_idx_tup_b;
-	u8 *delta_swing_table_idx_tdown_b;
+	const u8 *delta_swing_table_idx_tup_a;
+	const u8 *delta_swing_table_idx_tdown_a;
+	const u8 *delta_swing_table_idx_tup_b;
+	const u8 *delta_swing_table_idx_tdown_b;
 
 	/*2. Initilization ( 7 steps in total )*/
 	rtl8812ae_get_delta_swing_table(hw,
-		(u8 **)&delta_swing_table_idx_tup_a,
-		(u8 **)&delta_swing_table_idx_tdown_a,
-		(u8 **)&delta_swing_table_idx_tup_b,
-		(u8 **)&delta_swing_table_idx_tdown_b);
+		&delta_swing_table_idx_tup_a,
+		&delta_swing_table_idx_tdown_a,
+		&delta_swing_table_idx_tup_b,
+		&delta_swing_table_idx_tdown_b);
 
 	rtldm->txpower_trackinginit = true;
 
@@ -1830,8 +1832,11 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 		 "<===rtl8812ae_dm_txpower_tracking_callback_thermalmeter\n");
 }
 
-static void rtl8821ae_get_delta_swing_table(struct ieee80211_hw *hw, u8 **up_a,
-					    u8 **down_a, u8 **up_b, u8 **down_b)
+static void rtl8821ae_get_delta_swing_table(struct ieee80211_hw *hw,
+					    const u8 **up_a,
+					    const u8 **down_a,
+					    const u8 **up_b,
+					    const u8 **down_b)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -2075,16 +2080,17 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 	/* 1. The following TWO tables decide the final
 	 * index of OFDM/CCK swing table.
 	 */
-	u8 *delta_swing_table_idx_tup_a;
-	u8 *delta_swing_table_idx_tdown_a;
-	u8 *delta_swing_table_idx_tup_b;
-	u8 *delta_swing_table_idx_tdown_b;
+	const u8 *delta_swing_table_idx_tup_a;
+	const u8 *delta_swing_table_idx_tdown_a;
+	const u8 *delta_swing_table_idx_tup_b;
+	const u8 *delta_swing_table_idx_tdown_b;
 
 	/*2. Initilization ( 7 steps in total )*/
-	rtl8821ae_get_delta_swing_table(hw, (u8 **)&delta_swing_table_idx_tup_a,
-					(u8 **)&delta_swing_table_idx_tdown_a,
-					(u8 **)&delta_swing_table_idx_tup_b,
-					(u8 **)&delta_swing_table_idx_tdown_b);
+	rtl8821ae_get_delta_swing_table(hw,
+					&delta_swing_table_idx_tup_a,
+					&delta_swing_table_idx_tdown_a,
+					&delta_swing_table_idx_tup_b,
+					&delta_swing_table_idx_tdown_b);
 
 	rtldm->txpower_trackinginit = true;
 



