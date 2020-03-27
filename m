Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E3195E98
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgC0T0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:26:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39296 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgC0T0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:26:49 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jHucp-0001vg-Tu; Fri, 27 Mar 2020 19:26:40 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ath11k: fix error message to correctly report the command that failed
Date:   Fri, 27 Mar 2020 19:26:39 +0000
Message-Id: <20200327192639.363354-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error message refers to the command WMI_TWT_DIeABLE_CMDID
which looks like a cut-n-paste mangled typo. Fix the message to match
the command WMI_BSS_COLOR_CHANGE_ENABLE_CMDID that failed.

Fixes: 5a032c8d1953 ("ath11k: add WMI calls required for handling BSS color")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e7ce36966d6a..6fec62846279 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2779,7 +2779,7 @@ int ath11k_wmi_send_bss_color_change_enable_cmd(struct ath11k *ar, u32 vdev_id,
 	ret = ath11k_wmi_cmd_send(wmi, skb,
 				  WMI_BSS_COLOR_CHANGE_ENABLE_CMDID);
 	if (ret) {
-		ath11k_warn(ab, "Failed to send WMI_TWT_DIeABLE_CMDID");
+		ath11k_warn(ab, "Failed to send WMI_BSS_COLOR_CHANGE_ENABLE_CMDID");
 		dev_kfree_skb(skb);
 	}
 	return ret;
-- 
2.25.1

