Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBEE319D77
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhBLLhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 06:37:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54049 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhBLLhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 06:37:15 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lAWkN-0006Xt-LS; Fri, 12 Feb 2021 11:36:27 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: debugfs: Fix spelling mistake "Opportunies" -> "Opportunities"
Date:   Fri, 12 Feb 2021 11:36:27 +0000
Message-Id: <20210212113627.212787-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in some debug text, fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
index e13684343ec3..ec93f14e6d2a 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs_htt_stats.c
@@ -3851,7 +3851,7 @@ htt_print_pdev_obss_pd_stats_tlv_v(const void *tag_buf,
 			   htt_stats_buf->num_non_srg_ppdu_tried);
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "Non-SRG success PPDU = %u\n",
 			   htt_stats_buf->num_non_srg_ppdu_success);
-	len += HTT_DBG_OUT(buf + len, buf_len - len, "SRG Opportunies = %u\n",
+	len += HTT_DBG_OUT(buf + len, buf_len - len, "SRG Opportunities = %u\n",
 			   htt_stats_buf->num_srg_opportunities);
 	len += HTT_DBG_OUT(buf + len, buf_len - len, "SRG tried PPDU = %u\n",
 			   htt_stats_buf->num_srg_ppdu_tried);
-- 
2.30.0

