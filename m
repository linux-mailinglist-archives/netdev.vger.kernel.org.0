Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6144A55DB
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 05:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiBAEPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 23:15:53 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:33452 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbiBAEPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 23:15:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V3MiBa9_1643688950;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V3MiBa9_1643688950)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Feb 2022 12:15:50 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, kvalo@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] wcn36xx: clean up some inconsistent indenting
Date:   Tue,  1 Feb 2022 12:15:48 +0800
Message-Id: <20220201041548.18464-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warnings:
drivers/net/wireless/ath/wcn36xx/main.c:1394 wcn36xx_get_survey() warn:
inconsistent indenting
drivers/net/wireless/ath/wcn36xx/txrx.c:379 wcn36xx_rx_skb() warn:
inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 10 +++++-----
 drivers/net/wireless/ath/wcn36xx/txrx.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 75661d449712..0cb5f1a9532a 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1391,11 +1391,11 @@ static int wcn36xx_get_survey(struct ieee80211_hw *hw, int idx,
 
 	spin_unlock_irqrestore(&wcn->survey_lock, flags);
 
-	 wcn36xx_dbg(WCN36XX_DBG_MAC,
-		     "ch %d rssi %d snr %d noise %d filled %x freq %d\n",
-		     HW_VALUE_CHANNEL(survey->channel->hw_value),
-		     chan_survey->rssi, chan_survey->snr, survey->noise,
-		     survey->filled, survey->channel->center_freq);
+	wcn36xx_dbg(WCN36XX_DBG_MAC,
+		    "ch %d rssi %d snr %d noise %d filled %x freq %d\n",
+		    HW_VALUE_CHANNEL(survey->channel->hw_value),
+		    chan_survey->rssi, chan_survey->snr, survey->noise,
+		    survey->filled, survey->channel->center_freq);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index c04983718d02..df749b114568 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -376,8 +376,8 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		status.freq = WCN36XX_CENTER_FREQ(wcn);
 	}
 
-	 wcn36xx_update_survey(wcn, status.signal, get_snr(bd),
-			       status.band, status.freq);
+	wcn36xx_update_survey(wcn, status.signal, get_snr(bd),
+			      status.band, status.freq);
 
 	if (bd->rate_id < ARRAY_SIZE(wcn36xx_rate_table)) {
 		rate = &wcn36xx_rate_table[bd->rate_id];
-- 
2.20.1.7.g153144c

