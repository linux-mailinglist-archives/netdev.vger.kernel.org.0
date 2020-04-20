Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3931B195B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgDTWY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:24:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58282 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgDTWY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 18:24:56 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jQeqP-0001Tw-E5; Mon, 20 Apr 2020 22:24:49 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: remove redundant assignment to variable ret
Date:   Mon, 20 Apr 2020 23:24:49 +0100
Message-Id: <20200420222449.99481-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being assigned with a value that is never read
and it is being updated later with a new value. The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index c1aba2bf73cf..852ccfc65378 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -604,7 +604,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_mvm *mvm,
 				     struct iwl_lq_sta *lq_data, u8 tid,
 				     struct ieee80211_sta *sta)
 {
-	int ret = -EAGAIN;
+	int ret;
 
 	IWL_DEBUG_HT(mvm, "Starting Tx agg: STA: %pM tid: %d\n",
 		     sta->addr, tid);
-- 
2.25.1

