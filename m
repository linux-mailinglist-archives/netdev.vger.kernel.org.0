Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B315354B2D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 05:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbhDFDVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 23:21:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbhDFDVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 23:21:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FDt6K1yfgz9wdL;
        Tue,  6 Apr 2021 11:19:05 +0800 (CST)
Received: from DESKTOP-EFRLNPK.china.huawei.com (10.174.176.196) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 6 Apr 2021 11:21:05 +0800
From:   Qiheng Lin <linqiheng@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <matthias.bgg@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Qiheng Lin <linqiheng@huawei.com>
Subject: [PATCH net-next] mt76: mt7921: remove unneeded semicolon
Date:   Tue, 6 Apr 2021 11:20:51 +0800
Message-ID: <20210406032051.7750-1-linqiheng@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.174.176.196]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c:1402:2-3: Unneeded semicolon

Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 3f9097481a5e..e56cde3a19ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1399,7 +1399,7 @@ void mt7921_mac_work(struct work_struct *work)
 	if (++phy->sta_work_count == 10) {
 		phy->sta_work_count = 0;
 		mt7921_mac_sta_stats_work(phy);
-	};
+	}
 
 	mt7921_mutex_release(phy->dev);
 
-- 
2.31.1

