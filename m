Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AA1E46DF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 11:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408772AbfJYJQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 05:16:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfJYJQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 05:16:33 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A6DE0466B7B9160D03B0;
        Fri, 25 Oct 2019 17:16:28 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 25 Oct 2019
 17:16:21 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <royluo@google.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mt76: mt7615: remove unneeded semicolon
Date:   Fri, 25 Oct 2019 17:16:16 +0800
Message-ID: <20191025091616.26740-1-yuehaibing@huawei.com>
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
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index b6d7821..63600e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -58,7 +58,7 @@ static int get_omac_idx(enum nl80211_iftype type, u32 mask)
 	default:
 		WARN_ON(1);
 		break;
-	};
+	}
 
 	return -1;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 842cd81..164619f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1076,7 +1076,7 @@ int mt7615_mcu_set_sta_rec(struct mt7615_dev *dev, struct ieee80211_vif *vif,
 	default:
 		WARN_ON(1);
 		break;
-	};
+	}
 
 	if (en) {
 		req.basic.conn_state = CONN_STATE_PORT_SECURE;
-- 
2.7.4


