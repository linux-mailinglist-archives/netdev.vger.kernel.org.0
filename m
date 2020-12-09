Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D492D43AC
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbgLIN5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 08:57:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9572 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732065AbgLIN5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:57:40 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Crdr022HlzM2RQ;
        Wed,  9 Dec 2020 21:56:16 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 21:56:49 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <pizza@shaftnet.org>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH wireless -next] mt76: mt7915: convert comma to semicolon
Date:   Wed, 9 Dec 2020 21:57:17 +0800
Message-ID: <20201209135717.2110-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index a3ccc1785661..0fd3a16f736a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1148,7 +1148,7 @@ mt7915_mcu_sta_ba_tlv(struct sk_buff *skb,
 	tlv = mt7915_mcu_add_tlv(skb, STA_REC_BA, sizeof(*ba));
 
 	ba = (struct sta_rec_ba *)tlv;
-	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT,
+	ba->ba_type = tx ? MT_BA_TYPE_ORIGINATOR : MT_BA_TYPE_RECIPIENT;
 	ba->winsize = cpu_to_le16(params->buf_size);
 	ba->ssn = cpu_to_le16(params->ssn);
 	ba->ba_en = enable << params->tid;
-- 
2.22.0

