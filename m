Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A366D2F2A27
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404508AbhALIk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:40:28 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:33440 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728310AbhALIkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:40:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0ULVRswd_1610440752;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULVRswd_1610440752)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 12 Jan 2021 16:39:22 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] wireless: realtek: Simplify bool comparison
Date:   Tue, 12 Jan 2021 16:39:11 +0800
Message-Id: <1610440751-79543-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/wireless/realtek/rtlwifi/ps.c:803:7-21: WARNING:
Comparison to bool

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/ps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index f9988225..629c032 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 		ie += 3 + noa_len;
 	}
 
-	if (find_p2p_ie == true) {
+	if (find_p2p_ie) {
 		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
-		    (find_p2p_ps_ie == false))
+		    (!find_p2p_ps_ie))
 			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 	}
 }
-- 
1.8.3.1

