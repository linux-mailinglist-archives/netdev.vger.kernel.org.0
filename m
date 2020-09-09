Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFBE726312B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbgIIQCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:02:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730702AbgIIQA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:00:57 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2EFB16363AE265E31F7C;
        Wed,  9 Sep 2020 21:58:46 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:58:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ
Date:   Wed, 9 Sep 2020 21:58:34 +0800
Message-ID: <20200909135834.38448-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no caller in tree, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fed8682f266f..5991d0ac41ad 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7033,8 +7033,6 @@ static int ath10k_conf_tx(struct ieee80211_hw *hw,
 	return ret;
 }
 
-#define ATH10K_ROC_TIMEOUT_HZ (2 * HZ)
-
 static int ath10k_remain_on_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_channel *chan,
-- 
2.17.1


