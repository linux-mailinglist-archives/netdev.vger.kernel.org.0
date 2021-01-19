Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877412FB3C6
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbhASIJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:09:54 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:50956 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728812AbhASIJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 03:09:25 -0500
Received: from localhost.localdomain (unknown [124.16.141.241])
        by APP-03 (Coremail) with SMTP id rQCowADHqfpokwZgsmXUAA--.58238S2;
        Tue, 19 Jan 2021 16:08:10 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, shayne.chen@mediatek.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7915: Remove unneeded semicolon
Date:   Tue, 19 Jan 2021 08:08:05 +0000
Message-Id: <20210119080805.18191-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowADHqfpokwZgsmXUAA--.58238S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw1UAryxJr1rKFWfuF1DAwb_yoW3ZFc_Wr
        4vgFn3Wr1UGw1DKr429FW7C3y0y395CF18GFW3trWY93y7AFW7Gr9Ivry7JrsrCrs29r13
        Jrn8XFyFqanIqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVxYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr
        1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kI
        c2xKxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjxUcqXHDUUUU
X-Originating-IP: [124.16.141.241]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQoGA102Z4O8+wAAsO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix semicolon.cocci warnings:
drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1694:2-3: Unneeded semicolon

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index f504eeb221f9..a24d5b792a26 100644
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
2.17.1

