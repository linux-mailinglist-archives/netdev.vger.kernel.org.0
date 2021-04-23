Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62363693DF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhDWNmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:42:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47747 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhDWNmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:42:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lZw3p-0002wi-8X; Fri, 23 Apr 2021 13:41:33 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ath11k@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k/ath11k: fix spelling mistake "requed" -> "requeued"
Date:   Fri, 23 Apr 2021 14:41:33 +0100
Message-Id: <20210423134133.339751-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are multiple occurrances of the misspelling of requeued in
the drivers with symbol names and debug text. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/core.h              | 2 +-
 drivers/net/wireless/ath/ath10k/debug.c             | 4 ++--
 drivers/net/wireless/ath/ath10k/htt.h               | 4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c               | 6 +++---
 drivers/net/wireless/ath/ath10k/wmi.h               | 8 ++++----
 drivers/net/wireless/ath/ath11k/core.h              | 4 ++--
 drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c | 2 +-
 drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.c               | 4 ++--
 drivers/net/wireless/ath/ath11k/wmi.h               | 4 ++--
 10 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 648ed36f845f..5aeff2d9f6cf 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -301,7 +301,7 @@ struct ath10k_fw_stats_pdev {
 	s32 underrun;
 	u32 hw_paused;
 	s32 tx_abort;
-	s32 mpdus_requed;
+	s32 mpdus_requeued;
 	u32 tx_ko;
 	u32 data_rc;
 	u32 self_triggers;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fd052f6ed019..39378e3f9b2b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1105,7 +1105,7 @@ static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"d_tx_ppdu_reaped",
 	"d_tx_fifo_underrun",
 	"d_tx_ppdu_abort",
-	"d_tx_mpdu_requed",
+	"d_tx_mpdu_requeued",
 	"d_tx_excessive_retries",
 	"d_tx_hw_rate",
 	"d_tx_dropped_sw_retries",
@@ -1205,7 +1205,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	data[i++] = pdev_stats->hw_reaped;
 	data[i++] = pdev_stats->underrun;
 	data[i++] = pdev_stats->tx_abort;
-	data[i++] = pdev_stats->mpdus_requed;
+	data[i++] = pdev_stats->mpdus_requeued;
 	data[i++] = pdev_stats->tx_ko;
 	data[i++] = pdev_stats->data_rc;
 	data[i++] = pdev_stats->sw_retry_failure;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 956157946106..4e11ee775b4d 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1282,8 +1282,8 @@ struct htt_dbg_stats_wal_tx_stats {
 	/* Num PPDUs cleaned up in TX abort */
 	__le32 tx_abort;
 
-	/* Num MPDUs requed by SW */
-	__le32 mpdus_requed;
+	/* Num MPDUs requeued by SW */
+	__le32 mpdus_requeued;
 
 	/* excessive retries */
 	__le32 tx_ko;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d48b922215eb..f42bf2c8f9e7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2867,7 +2867,7 @@ void ath10k_wmi_pull_pdev_stats_tx(const struct wmi_pdev_stats_tx *src,
 	dst->hw_reaped = __le32_to_cpu(src->hw_reaped);
 	dst->underrun = __le32_to_cpu(src->underrun);
 	dst->tx_abort = __le32_to_cpu(src->tx_abort);
-	dst->mpdus_requed = __le32_to_cpu(src->mpdus_requed);
+	dst->mpdus_requeued = __le32_to_cpu(src->mpdus_requeued);
 	dst->tx_ko = __le32_to_cpu(src->tx_ko);
 	dst->data_rc = __le32_to_cpu(src->data_rc);
 	dst->self_triggers = __le32_to_cpu(src->self_triggers);
@@ -2895,7 +2895,7 @@ ath10k_wmi_10_4_pull_pdev_stats_tx(const struct wmi_10_4_pdev_stats_tx *src,
 	dst->hw_reaped = __le32_to_cpu(src->hw_reaped);
 	dst->underrun = __le32_to_cpu(src->underrun);
 	dst->tx_abort = __le32_to_cpu(src->tx_abort);
-	dst->mpdus_requed = __le32_to_cpu(src->mpdus_requed);
+	dst->mpdus_requeued = __le32_to_cpu(src->mpdus_requeued);
 	dst->tx_ko = __le32_to_cpu(src->tx_ko);
 	dst->data_rc = __le32_to_cpu(src->data_rc);
 	dst->self_triggers = __le32_to_cpu(src->self_triggers);
@@ -8270,7 +8270,7 @@ ath10k_wmi_fw_pdev_tx_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "PPDUs cleaned", pdev->tx_abort);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs requed", pdev->mpdus_requed);
+			 "MPDUs requeued", pdev->mpdus_requeued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "Excessive retries", pdev->tx_ko);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d870f7067cb7..dd980c81793e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4371,8 +4371,8 @@ struct wmi_pdev_stats_tx {
 	/* Num PPDUs cleaned up in TX abort */
 	__le32 tx_abort;
 
-	/* Num MPDUs requed by SW */
-	__le32 mpdus_requed;
+	/* Num MPDUs requeued by SW */
+	__le32 mpdus_requeued;
 
 	/* excessive retries */
 	__le32 tx_ko;
@@ -4444,8 +4444,8 @@ struct wmi_10_4_pdev_stats_tx {
 	/* Num PPDUs cleaned up in TX abort */
 	__le32 tx_abort;
 
-	/* Num MPDUs requed by SW */
-	__le32 mpdus_requed;
+	/* Num MPDUs requeued by SW */
+	__le32 mpdus_requeued;
 
 	/* excessive retries */
 	__le32 tx_ko;
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index 55af982deca7..382df5318b61 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -795,8 +795,8 @@ struct ath11k_fw_stats_pdev {
 	s32 underrun;
 	/* Num PPDUs cleaned up in TX abort */
 	s32 tx_abort;
-	/* Num MPDUs requed by SW */
-	s32 mpdus_requed;
+	/* Num MPDUs requeued by SW */
+	s32 mpdus_requeued;
 	/* excessive retries */
 	u32 tx_ko;
 	/* data hw rate code */
diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
index ec93f14e6d2a..9e0c90da99d3 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
@@ -89,7 +89,7 @@ static inline void htt_print_tx_pdev_stats_cmn_tlv(const void *tag_buf,
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "tx_abort = %u",
 			   htt_stats_buf->tx_abort);
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "mpdu_requeued = %u",
-			   htt_stats_buf->mpdu_requed);
+			   htt_stats_buf->mpdu_requeued);
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "tx_xretry = %u",
 			   htt_stats_buf->tx_xretry);
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "data_rc = %u",
diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
index 567a26d485a9..d428f52003a4 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.h
@@ -147,7 +147,7 @@ struct htt_tx_pdev_stats_cmn_tlv {
 	u32 hw_flush;
 	u32 hw_filt;
 	u32 tx_abort;
-	u32 mpdu_requed;
+	u32 mpdu_requeued;
 	u32 tx_xretry;
 	u32 data_rc;
 	u32 mpdu_dropped_xretry;
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 5ca2d80679b6..6c253eae9d06 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5235,7 +5235,7 @@ ath11k_wmi_pull_pdev_stats_tx(const struct wmi_pdev_stats_tx *src,
 	dst->hw_reaped = src->hw_reaped;
 	dst->underrun = src->underrun;
 	dst->tx_abort = src->tx_abort;
-	dst->mpdus_requed = src->mpdus_requed;
+	dst->mpdus_requeued = src->mpdus_requeued;
 	dst->tx_ko = src->tx_ko;
 	dst->data_rc = src->data_rc;
 	dst->self_triggers = src->self_triggers;
@@ -5505,7 +5505,7 @@ ath11k_wmi_fw_pdev_tx_stats_fill(const struct ath11k_fw_stats_pdev *pdev,
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
 			 "PPDUs cleaned", pdev->tx_abort);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10d\n",
-			 "MPDUs requed", pdev->mpdus_requed);
+			 "MPDUs requeued", pdev->mpdus_requeued);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
 			 "Excessive retries", pdev->tx_ko);
 	len += scnprintf(buf + len, buf_len - len, "%30s %10u\n",
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 3ade1ddd35c9..d35c47e0b19d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -4171,8 +4171,8 @@ struct wmi_pdev_stats_tx {
 	/* Num PPDUs cleaned up in TX abort */
 	s32 tx_abort;
 
-	/* Num MPDUs requed by SW */
-	s32 mpdus_requed;
+	/* Num MPDUs requeued by SW */
+	s32 mpdus_requeued;
 
 	/* excessive retries */
 	u32 tx_ko;
-- 
2.30.2

