Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485B922D9C0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 21:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgGYT4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 15:56:25 -0400
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:36004 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728031AbgGYT4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 15:56:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 5AA211802926E;
        Sat, 25 Jul 2020 19:56:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:541:800:960:973:988:989:1260:1311:1314:1345:1359:1515:1535:1606:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3876:3877:4117:4250:4321:5007:6114:6261:6642:7903:10004:10848:11026:11473:11657:11658:11914:12043:12297:12438:12555:12895:12986:13894:14394:21080:21627:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: verse03_3401d9026f52
X-Filterd-Recvd-Size: 6761
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:20 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/6] rtlwifi: Convert sleeped to slept in rtl_dbg uses
Date:   Sat, 25 Jul 2020 12:55:08 -0700
Message-Id: <33734b374f82d41425c926ec9d2f136be3b65dc2.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a more standard word.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 4771b76bdefa..507cd44661fa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -2189,7 +2189,7 @@ static bool _rtl88ee_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index b0a978ff6193..aef4d88ebbe9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -454,7 +454,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 						  RT_RF_OFF_LEVL_HALT_NIC);
 			} else {
 				rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-					"Set ERFON sleeped:%d ms\n",
+					"Set ERFON slept:%d ms\n",
 					jiffies_to_msecs(jiffies -
 							 ppsc->last_sleep_jiffies));
 				ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
index 1787b82422f2..a8d9fe269f31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
@@ -398,7 +398,7 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index f7419b4b3d8d..1a79e1c046cf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -3074,7 +3074,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_POWER, DBG_DMESG,
-				"awake, sleeped:%d ms state_inap:%x\n",
+				"awake, slept:%d ms state_inap:%x\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies),
 				rtlpriv->psc.state_inap);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 56d795418e18..48d9fe4054af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -539,7 +539,7 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
 						  RT_RF_OFF_LEVL_HALT_NIC);
 			} else {
 				rtl_dbg(rtlpriv, COMP_POWER, DBG_DMESG,
-					"awake, sleeped:%d ms state_inap:%x\n",
+					"awake, slept:%d ms state_inap:%x\n",
 					jiffies_to_msecs(jiffies -
 							 ppsc->last_sleep_jiffies),
 					rtlpriv->psc.state_inap);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index e7445fb74075..349275c45622 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -1562,7 +1562,7 @@ static bool _rtl8723e_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index b43574c44117..f742b9069668 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -2528,7 +2528,7 @@ static bool _rtl8723be_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 2255c9b9fc16..852f452d3fd3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -4736,7 +4736,7 @@ static bool _rtl8821ae_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  RT_RF_OFF_LEVL_HALT_NIC);
 		} else {
 			rtl_dbg(rtlpriv, COMP_RF, DBG_DMESG,
-				"Set ERFON sleeped:%d ms\n",
+				"Set ERFON slept:%d ms\n",
 				jiffies_to_msecs(jiffies -
 						 ppsc->last_sleep_jiffies));
 			ppsc->last_awake_jiffies = jiffies;
-- 
2.26.0

