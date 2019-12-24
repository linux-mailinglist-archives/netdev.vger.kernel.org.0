Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B3012A203
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfLXOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:08:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46904 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfLXOI5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:08:57 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 711D199590958C13ADAC;
        Tue, 24 Dec 2019 22:08:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 22:08:46 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 3/6] ath9k: use true,false for bool variable
Date:   Tue, 24 Dec 2019 22:16:03 +0800
Message-ID: <1577196966-84926-4-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
References: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/ath/ath9k/ar9003_aic.c:409:2-12: WARNING: Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_aic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_aic.c b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
index 547cd46..d0f1e8b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_aic.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_aic.c
@@ -406,7 +406,7 @@ static bool ar9003_aic_cal_post_process(struct ath_hw *ah)
 		sram.com_att_6db =
 			ar9003_aic_find_index(1, fixed_com_att_db);

-		sram.valid = 1;
+		sram.valid = true;

 		sram.rot_dir_att_db =
 			min(max(rot_dir_path_att_db,
--
2.7.4

