Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727F539156A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhEZKyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:54:40 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:33522 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233980AbhEZKyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:54:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Ua9sKBq_1622026381;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua9sKBq_1622026381)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 May 2021 18:53:05 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2] ath6kl: Fix inconsistent indenting
Date:   Wed, 26 May 2021 18:52:56 +0800
Message-Id: <1622026376-68524-1-git-send-email-jiapeng.chong@linux.alibaba.com>
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
Changes in v2:
  -For the follow advice: https://lore.kernel.org/patchwork/patch/1435973/

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 29527e8..fefdc67 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3303,8 +3303,8 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 		if (ret < 0)
 			return ret;
 	} else {
-		 ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
-						MATCHED_SSID_FILTER, 0);
+		ret = ath6kl_wmi_bssfilter_cmd(ar->wmi, vif->fw_vif_idx,
+					       MATCHED_SSID_FILTER, 0);
 		if (ret < 0)
 			return ret;
 	}
-- 
1.8.3.1

