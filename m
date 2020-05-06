Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB931C71E2
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgEFNm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 09:42:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3824 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgEFNm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 09:42:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A380299D6FA32FB08C48;
        Wed,  6 May 2020 21:42:52 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 21:42:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] iwlwifi: mvm: Remove unused inline function iwl_mvm_tid_to_ac_queue
Date:   Wed, 6 May 2020 21:42:17 +0800
Message-ID: <20200506134217.49760-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit cfbc6c4c5b91 ("iwlwifi: mvm: support mac80211 TXQs model")
left behind this, remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 56ae72debb96..f271bb264ddc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1364,14 +1364,6 @@ static int iwl_mvm_sta_alloc_queue(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static inline u8 iwl_mvm_tid_to_ac_queue(int tid)
-{
-	if (tid == IWL_MAX_TID_COUNT)
-		return IEEE80211_AC_VO; /* MGMT */
-
-	return tid_to_mac80211_ac[tid];
-}
-
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm,
-- 
2.17.1


