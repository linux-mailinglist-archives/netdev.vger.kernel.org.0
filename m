Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69D26FDEA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIRNNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:13:08 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34778 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbgIRNNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:13:08 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 186A3F47338AB17091FE;
        Fri, 18 Sep 2020 21:13:06 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 21:12:57 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath11k: Remove unused function ath11k_htc_restore_tx_skb()
Date:   Fri, 18 Sep 2020 21:12:42 +0800
Message-ID: <20200918131242.24000-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath11k/htc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/htc.c b/drivers/net/wireless/ath/ath11k/htc.c
index e9e354fc11fa..4de2350dfbf3 100644
--- a/drivers/net/wireless/ath/ath11k/htc.c
+++ b/drivers/net/wireless/ath/ath11k/htc.c
@@ -50,15 +50,6 @@ static struct sk_buff *ath11k_htc_build_tx_ctrl_skb(void *ab)
 	return skb;
 }
 
-static inline void ath11k_htc_restore_tx_skb(struct ath11k_htc *htc,
-					     struct sk_buff *skb)
-{
-	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB(skb);
-
-	dma_unmap_single(htc->ab->dev, skb_cb->paddr, skb->len, DMA_TO_DEVICE);
-	skb_pull(skb, sizeof(struct ath11k_htc_hdr));
-}
-
 static void ath11k_htc_prepare_tx_skb(struct ath11k_htc_ep *ep,
 				      struct sk_buff *skb)
 {
-- 
2.17.1

