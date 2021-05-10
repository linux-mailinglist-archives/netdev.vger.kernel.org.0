Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A028379175
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbhEJOzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:55:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2618 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236670AbhEJOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:53:06 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Ff3qZ58kQzmVRp;
        Mon, 10 May 2021 22:49:46 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 22:51:49 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] b43: phy_n: Delete some useless empty code
Date:   Mon, 10 May 2021 22:51:17 +0800
Message-ID: <20210510145117.4066-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These TODO empty code are added by
commit 9442e5b58edb ("b43: N-PHY: partly implement SPUR workaround"). It's
been more than a decade now. I don't think anyone who wants to perfect
this workaround can follow this TODO tip exactly. Instead, it limits them
to new thinking. Remove it will be better.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index 665b737fbb0d820..13cc62695f4cc93 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -4601,16 +4601,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	if (nphy->gband_spurwar_en) {
-		/* TODO: N PHY Adjust Analog Pfbw (7) */
-		if (channel == 11 && b43_is_40mhz(dev)) {
-			; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
-		} else {
-			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
-		}
-		/* TODO: N PHY Adjust CRS Min Power (0x1E) */
-	}
-
 	if (nphy->aband_spurwar_en) {
 		if (channel == 54) {
 			tone[0] = 0x20;
@@ -4636,12 +4626,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 			tone[0] = 0;
 			noise[0] = 0;
 		}
-
-		if (!tone[0] && !noise[0]) {
-			; /* TODO: N PHY Adjust Min Noise Var(1, tone, noise)*/
-		} else {
-			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
-		}
 	}
 
 	if (nphy->hang_avoid)
-- 
2.26.0.106.g9fadedd


