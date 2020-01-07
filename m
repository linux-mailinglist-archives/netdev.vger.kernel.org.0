Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AE9133539
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgAGVvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:51:10 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:57577 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgAGVvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:51:10 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MJmbB-1j8wTR45Dl-00K4yP; Tue, 07 Jan 2020 22:50:41 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        Bhagavathi Perumal S <bperumal@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ganesh Sesetti <gseset@codeaurora.org>,
        Govindaraj Saminathan <gsamin@codeaurora.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        kbuild test robot <lkp@intel.com>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Miles Hu <milehu@codeaurora.org>,
        Muna Sinada <msinada@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Sriram R <srirrama@codeaurora.org>,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tamizh chelvam <tamizhr@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: fix debugfs build failure
Date:   Tue,  7 Jan 2020 22:50:04 +0100
Message-Id: <20200107215036.1333983-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:1IwwBGhuOz0cd0fMgrQmU/t4gEgEbaY4kf54G9AmPByhjQQY7fh
 QQff/ZJNDnmGx924TaQblUyv7rp3cQfsvSoH8yH7/yXdJR1ISoA/dR7lC8paPX8lGQAcWWZ
 LHqBUDplT7XEGiO3wen35XFc1XN3SwaDPM9McT45/lQhibx/jMp5gZS6lq/Clz9Kv40V0ad
 42xWSqOCYKQpqsJnlflBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nUUMxddKHx0=:WTvF1Wfyj2/ouKy4oFxjNw
 hYhq8wgb4UfSK0NVybZqABq/OCKo+QSD65xfbimTwoZkgEWSPHD30YGFwrA3ADZVtGBYwCSoN
 JMDHy8rGgJv8gcUDWDkR42jx176v3QRRpj2r7plNJQI3WOO3XyY5i3e0oZLW46c02jdzFJhiZ
 XOzZJLI2xPVvYmyRqBGHJO9JAaB6qazdzNAIO7cqrXiB0Cw6FYg3XIBB2/uA2HU44a8kuxoch
 G7jF1sTwsZlWOrpLQqMfS800wdQkHNMeWp/OELaPXZwD5JTdda0xfiSG+Do0VgZxhHmkjgzTv
 GqTmpfU/alK6h8WeQAW3E9AIpuKWMtTGu0+hovPlfdEJ+29HL5eBUK5F9GqlB4QwT1tn+3AZL
 A2X2HkWXX7OMYdkN0ffXod/iGxsZuT4eZG01APUc5GKX+8invc8U07FRC8w83cRDdYoFx3LJv
 ik8ZKoxDADlUY3niMFmNXpt66uJT19w5i2caMsAjiOK+udmbdo+5y4/tEyMi4URj+TXUcA7AY
 683/vRlsCokJTINAaizPjipJAfKL+kxsTvmxXoNEWT5wl0fbE51iNtnPqLa6vFZyVvuq/lYlG
 sn3/gaWyRxRgBIB/H5NuLIhCmTGWb/EPMf/YQcsK48ZEgSXEWcnUgtzMMEDffc94JzToB+j2b
 23c2JhWhrYfRvYDU8ziN7twGCF2nuAFPotQyoFJbHuCjYeSzRrZKnLjZdsmAL+Eqfww+QHwTa
 fjCPE3GH3SqM1noEi8zvojf5VnXYjxA9yCs8jwyYNmva++Ts5HI+RIJqHh58+fEzI3DtzEEFJ
 HbplIo6Cq4kCf6Lj/SV0AwtiKYyRSPJ8TvsAGL8tVSo0DhvJISMplhpE0qC4cXeVageGUbKAg
 OHrnrI0r9VGXgW/XnUGQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_ATH11K_DEBUGFS is disabled, but CONFIG_MAC80211_DEBUGFS
is turned on, the driver fails to build:

drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function 'ath11k_dbg_sta_open_htt_peer_stats':
drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: 'struct ath11k' has no member named 'debug'
  ar->debug.htt_stats.stats_req = stats_req;
    ^~

It appears that just using the former symbol is sufficient here,
adding a Kconfig dependency takes care of the corner cases.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath11k/Kconfig  |  2 +-
 drivers/net/wireless/ath/ath11k/Makefile |  3 +--
 drivers/net/wireless/ath/ath11k/debug.h  | 22 ++++++++++------------
 drivers/net/wireless/ath/ath11k/mac.c    |  2 +-
 4 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
index cfab4fb86aef..c88e16d4022b 100644
--- a/drivers/net/wireless/ath/ath11k/Kconfig
+++ b/drivers/net/wireless/ath/ath11k/Kconfig
@@ -22,7 +22,7 @@ config ATH11K_DEBUG
 
 config ATH11K_DEBUGFS
 	bool "QCA ath11k debugfs support"
-	depends on ATH11K && DEBUG_FS
+	depends on ATH11K && DEBUG_FS && MAC80211_DEBUGFS
 	---help---
 	  Enable ath11k debugfs support
 
diff --git a/drivers/net/wireless/ath/ath11k/Makefile b/drivers/net/wireless/ath/ath11k/Makefile
index a91d75c1cfeb..2761d07d938e 100644
--- a/drivers/net/wireless/ath/ath11k/Makefile
+++ b/drivers/net/wireless/ath/ath11k/Makefile
@@ -17,8 +17,7 @@ ath11k-y += core.o \
 	    ce.o \
 	    peer.o
 
-ath11k-$(CONFIG_ATH11K_DEBUGFS) += debug_htt_stats.o
-ath11k-$(CONFIG_MAC80211_DEBUGFS) += debugfs_sta.o
+ath11k-$(CONFIG_ATH11K_DEBUGFS) += debug_htt_stats.o debugfs_sta.o
 ath11k-$(CONFIG_NL80211_TESTMODE) += testmode.o
 ath11k-$(CONFIG_ATH11K_TRACING) += trace.o
 
diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index a317a7bdb9a2..8e8d5588b541 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -172,6 +172,16 @@ static inline int ath11k_debug_is_extd_rx_stats_enabled(struct ath11k *ar)
 {
 	return ar->debug.extd_rx_stats;
 }
+
+void ath11k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, struct dentry *dir);
+void
+ath11k_accumulate_per_peer_tx_stats(struct ath11k_sta *arsta,
+				    struct ath11k_per_peer_tx_stats *peer_stats,
+				    u8 legacy_rate_idx);
+void ath11k_update_per_peer_stats_from_txcompl(struct ath11k *ar,
+					       struct sk_buff *msdu,
+					       struct hal_tx_status *ts);
 #else
 static inline int ath11k_debug_soc_create(struct ath11k_base *ab)
 {
@@ -243,19 +253,7 @@ static inline bool ath11k_debug_is_pktlog_peer_valid(struct ath11k *ar, u8 *addr
 {
 	return false;
 }
-#endif /* CONFIG_ATH11K_DEBUGFS */
 
-#ifdef CONFIG_MAC80211_DEBUGFS
-void ath11k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, struct dentry *dir);
-void
-ath11k_accumulate_per_peer_tx_stats(struct ath11k_sta *arsta,
-				    struct ath11k_per_peer_tx_stats *peer_stats,
-				    u8 legacy_rate_idx);
-void ath11k_update_per_peer_stats_from_txcompl(struct ath11k *ar,
-					       struct sk_buff *msdu,
-					       struct hal_tx_status *ts);
-#else /* !CONFIG_MAC80211_DEBUGFS */
 static inline void
 ath11k_accumulate_per_peer_tx_stats(struct ath11k_sta *arsta,
 				    struct ath11k_per_peer_tx_stats *peer_stats,
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 556eef9881a7..0ed3e4d19f7a 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5468,7 +5468,7 @@ static const struct ieee80211_ops ath11k_ops = {
 	.flush				= ath11k_mac_op_flush,
 	.sta_statistics			= ath11k_mac_op_sta_statistics,
 	CFG80211_TESTMODE_CMD(ath11k_tm_cmd)
-#ifdef CONFIG_MAC80211_DEBUGFS
+#ifdef CONFIG_ATH11K_DEBUGFS
 	.sta_add_debugfs		= ath11k_sta_add_debugfs,
 #endif
 };
-- 
2.20.0

