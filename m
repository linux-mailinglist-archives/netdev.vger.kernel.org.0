Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED57B1917
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 09:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfIMHnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 03:43:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47589 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbfIMHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 03:43:45 -0400
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1i8gF3-0003Jj-62; Fri, 13 Sep 2019 07:43:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: fix spelling mistake "eanble" -> "enable"
Date:   Fri, 13 Sep 2019 08:43:39 +0100
Message-Id: <20190913074339.27280-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a ath10k_warn warning message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 12dad659bf68..a3d612f5f652 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7418,7 +7418,7 @@ static bool ath10k_mac_set_vht_bitrate_mask_fixup(struct ath10k *ar,
 	err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
 					WMI_PEER_PARAM_FIXED_RATE, rate);
 	if (err)
-		ath10k_warn(ar, "failed to eanble STA %pM peer fixed rate: %d\n",
+		ath10k_warn(ar, "failed to enable STA %pM peer fixed rate: %d\n",
 			    sta->addr, err);
 
 	return true;
-- 
2.20.1

