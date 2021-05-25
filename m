Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D002638FF9B
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhEYK65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:58:57 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:47541 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhEYK64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:58:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua4GhRl_1621940235;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua4GhRl_1621940235)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 25 May 2021 18:57:25 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] cfg80211: Fix inconsistent indenting
Date:   Tue, 25 May 2021 18:57:13 +0800
Message-Id: <1621940233-70879-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/wireless/ath/ath6kl/cfg80211.c:3308
ath6kl_cfg80211_sscan_start() warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 29527e8..b722104 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3303,7 +3303,7 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 		if (ret < 0)
 			return ret;
 	} else {
-		 ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+		ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
 						MATCHED_SSID_FILTER, 0);
 		if (ret < 0)
 			return ret;
-- 
1.8.3.1

