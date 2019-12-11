Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCDF211A5ED
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfLKIex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:34:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33929 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfLKIew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:34:52 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iexSF-00042B-PL; Wed, 11 Dec 2019 08:34:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: fix several spelling mistakes
Date:   Wed, 11 Dec 2019 08:34:43 +0000
Message-Id: <20191211083443.372506-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several spelling mistakes in warning and debug messages,
fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/debug.c           | 4 ++--
 drivers/net/wireless/ath/ath11k/debug_htt_stats.c | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.c             | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.c b/drivers/net/wireless/ath/ath11k/debug.c
index c27fffd13a5d..e00b5739fb00 100644
--- a/drivers/net/wireless/ath/ath11k/debug.c
+++ b/drivers/net/wireless/ath/ath11k/debug.c
@@ -704,7 +704,7 @@ static ssize_t ath11k_write_extd_rx_stats(struct file *file,
 					       DP_RX_BUFFER_SIZE, &tlv_filter);
 
 	if (ret) {
-		ath11k_warn(ar->ab, "failed to set rx filter for moniter status ring\n");
+		ath11k_warn(ar->ab, "failed to set rx filter for monitor status ring\n");
 		goto exit;
 	}
 
@@ -948,7 +948,7 @@ static ssize_t ath11k_write_pktlog_filter(struct file *file,
 					       HAL_RXDMA_MONITOR_STATUS,
 					       DP_RX_BUFFER_SIZE, &tlv_filter);
 	if (ret) {
-		ath11k_warn(ar->ab, "failed to set rx filter for moniter status ring\n");
+		ath11k_warn(ar->ab, "failed to set rx filter for monitor status ring\n");
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
index 27b301bc1a1b..a824826f562c 100644
--- a/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debug_htt_stats.c
@@ -3512,7 +3512,7 @@ htt_print_rx_pdev_fw_stats_phy_err_tlv(const void *tag_buf,
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "HTT_RX_PDEV_FW_STATS_PHY_ERR_TLV:");
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "mac_id__word = %u",
 			   htt_stats_buf->mac_id__word);
-	len += HTT_DBG_OUT(buf + len, buf_len - len, "tota_phy_err_nct = %u",
+	len += HTT_DBG_OUT(buf + len, buf_len - len, "total_phy_err_nct = %u",
 			   htt_stats_buf->total_phy_err_cnt);
 
 	ARRAY_TO_STRING(phy_errs,
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index b05642617b78..682563ccfe5a 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2544,7 +2544,7 @@ ath11k_wmi_send_twt_disable_cmd(struct ath11k *ar, u32 pdev_id)
 	ret = ath11k_wmi_cmd_send(wmi, skb,
 				  WMI_TWT_DISABLE_CMDID);
 	if (ret) {
-		ath11k_warn(ab, "Failed to send WMI_TWT_DIeABLE_CMDID");
+		ath11k_warn(ab, "Failed to send WMI_TWT_DISABLE_CMDID");
 		dev_kfree_skb(skb);
 	}
 	return ret;
-- 
2.24.0

