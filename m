Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFFF35684B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 11:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350257AbhDGJq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 05:46:28 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36534 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233438AbhDGJq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 05:46:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UUmyvhi_1617788767;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UUmyvhi_1617788767)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 17:46:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     merez@codeaurora.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] wil6210: wmi: Remove useless code
Date:   Wed,  7 Apr 2021 17:46:06 +0800
Message-Id: <1617788766-91433-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following whitescan warning:

An unsigned value can never be less than 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 823ec6e..02ad449 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1456,7 +1456,7 @@ static void wil_link_stats_store_basic(struct wil6210_vif *vif,
 	u8 cid = basic->cid;
 	struct wil_sta_info *sta;
 
-	if (cid < 0 || cid >= wil->max_assoc_sta) {
+	if (cid >= wil->max_assoc_sta) {
 		wil_err(wil, "invalid cid %d\n", cid);
 		return;
 	}
-- 
1.8.3.1

