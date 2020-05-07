Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC7E1C879D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgEGLI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:08:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49834 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725910AbgEGLI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:08:29 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 706F79169ECFE8040AF6;
        Thu,  7 May 2020 19:08:27 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:08:21 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <linux-wireless@vger.kernel.org>,
        <b43-dev@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] b43: remove dead function b43_rssinoise_postprocess()
Date:   Thu, 7 May 2020 19:07:41 +0800
Message-ID: <20200507110741.37757-1-yanaijie@huawei.com>
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

This function is dead for more than 10 years. Remove it.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/broadcom/b43/xmit.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/xmit.c b/drivers/net/wireless/broadcom/b43/xmit.c
index 058745219516..55babc6d1091 100644
--- a/drivers/net/wireless/broadcom/b43/xmit.c
+++ b/drivers/net/wireless/broadcom/b43/xmit.c
@@ -629,19 +629,6 @@ static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 	return (s8) tmp;
 }
 
-//TODO
-#if 0
-static s8 b43_rssinoise_postprocess(struct b43_wldev *dev, u8 in_rssi)
-{
-	struct b43_phy *phy = &dev->phy;
-	s8 ret;
-
-	ret = b43_rssi_postprocess(dev, in_rssi, 0, 1, 1);
-
-	return ret;
-}
-#endif
-
 void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 {
 	struct ieee80211_rx_status status;
-- 
2.21.1

