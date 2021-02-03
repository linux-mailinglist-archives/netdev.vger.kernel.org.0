Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A38B30D1BC
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhBCCmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:42:20 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55450 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229889AbhBCCmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 21:42:17 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UNjXycJ_1612320082;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNjXycJ_1612320082)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 10:41:22 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] mt76: mt7915: remove unneeded semicolon
Date:   Wed,  3 Feb 2021 10:41:20 +0800
Message-Id: <1612320080-126736-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1694:2-3: Unneeded
semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index f504eeb..a24d5b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1691,7 +1691,7 @@ void mt7915_mac_work(struct work_struct *work)
 	if (++phy->sta_work_count == 10) {
 		phy->sta_work_count = 0;
 		mt7915_mac_sta_stats_work(phy);
-	};
+	}
 
 	mutex_unlock(&mdev->mutex);
 
-- 
1.8.3.1

