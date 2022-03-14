Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAD34D8554
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237088AbiCNMtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbiCNMr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:47:58 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955BD3A1A2;
        Mon, 14 Mar 2022 05:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+hYUu2G/bq68s9f2SGkYZi4xlcaxcWwYD94UHu9GgRY=;
  b=p9GC6OpXJFvaT9UgALjpX+KCc0W9t9BgRzlCd4QoDwR4er5TD0eMzJXf
   DzriE/66opaOKETRTPjE9OG0m7KC1tMUXl7LiKztQkRo8CQrgGKYtj8jC
   QkOqFsWa0Hcrkc3qfiXAVUjObxEM1YZHFPRQ9Qi9fLqe470ItuvysdJfW
   k=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,180,1643670000"; 
   d="scan'208";a="25997352"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 12:54:00 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     kernel-janitors@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/30] rtlwifi: rtl8821ae: fix typos in comments
Date:   Mon, 14 Mar 2022 12:53:43 +0100
Message-Id: <20220314115354.144023-20-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index f6bff0ebd6b0..f3fe16798c59 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -872,7 +872,7 @@ static void rtl8821ae_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 	else
 		falsealm_cnt->cnt_all = falsealm_cnt->cnt_ofdm_fail;
 
-	/*reset OFDM FA coutner*/
+	/*reset OFDM FA counter*/
 	rtl_set_bbreg(hw, ODM_REG_OFDM_FA_RST_11AC, BIT(17), 1);
 	rtl_set_bbreg(hw, ODM_REG_OFDM_FA_RST_11AC, BIT(17), 0);
 	/* reset CCK FA counter*/
@@ -1464,7 +1464,7 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 	const u8 *delta_swing_table_idx_tup_b;
 	const u8 *delta_swing_table_idx_tdown_b;
 
-	/*2. Initilization ( 7 steps in total )*/
+	/*2. Initialization ( 7 steps in total )*/
 	rtl8812ae_get_delta_swing_table(hw,
 		&delta_swing_table_idx_tup_a,
 		&delta_swing_table_idx_tdown_a,
@@ -2502,7 +2502,7 @@ static void rtl8821ae_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	rtlpriv->dm.dbginfo.num_non_be_pkt = 0;
 
 	/*===============================
-	 * list paramter for different platform
+	 * list parameter for different platform
 	 *===============================
 	 */
 	pb_is_cur_rdl_state = &rtlpriv->dm.is_cur_rdlstate;

