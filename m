Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E41E46C7
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437447AbfJYJMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:12:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50384 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393522AbfJYJMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 05:12:17 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F0B85A2AF2293B7914DC;
        Fri, 25 Oct 2019 17:12:01 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 17:11:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath10k: remove unneeded semicolon
Date:   Fri, 25 Oct 2019 17:10:41 +0800
Message-ID: <20191025091041.34056-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unneeded semicolon.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9f0e7b4..d95b63f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2073,7 +2073,7 @@ static void ath10k_htt_rx_mpdu_desc_pn_hl(struct htt_hl_rx_desc *rx_desc,
 	case 24:
 		pn->pn24 = __le32_to_cpu(rx_desc->pn_31_0);
 		break;
-	};
+	}
 }
 
 static bool ath10k_htt_rx_pn_cmp48(union htt_rx_pn_t *new_pn,
-- 
2.7.4


