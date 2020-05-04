Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDA1C3837
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgEDLeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 07:34:22 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3405 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgEDLeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 07:34:22 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 03CFBF5CE244F857BAC4;
        Mon,  4 May 2020 19:34:20 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 4 May 2020
 19:34:13 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <srirrama@codeaurora.org>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] ath11k: use true,false for bool variables
Date:   Mon, 4 May 2020 19:33:36 +0800
Message-ID: <20200504113336.41249-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/ath/ath11k/dp_rx.c:2964:1-39: WARNING: Assignment
of 0/1 to bool variable
drivers/net/wireless/ath/ath11k/dp_rx.c:2965:1-38: WARNING: Assignment
of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index bbd7da48518f..8d3ab3b5213d 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2961,8 +2961,8 @@ static int ath11k_dp_rx_h_verify_tkip_mic(struct ath11k *ar, struct ath11k_peer
 	return 0;
 
 mic_fail:
-	(ATH11K_SKB_RXCB(msdu))->is_first_msdu = 1;
-	(ATH11K_SKB_RXCB(msdu))->is_last_msdu = 1;
+	(ATH11K_SKB_RXCB(msdu))->is_first_msdu = true;
+	(ATH11K_SKB_RXCB(msdu))->is_last_msdu = true;
 
 	rxs->flag |= RX_FLAG_MMIC_ERROR | RX_FLAG_MMIC_STRIPPED |
 		    RX_FLAG_IV_STRIPPED | RX_FLAG_DECRYPTED;
-- 
2.21.1

