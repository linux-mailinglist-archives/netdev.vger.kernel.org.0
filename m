Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F080656CA14
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGIOb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiGIObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:31:21 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67C13123C;
        Sat,  9 Jul 2022 07:31:15 -0700 (PDT)
X-QQ-Spam: true
X-QQ-mid: bizesmtp86t1657375080t8mj947j
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:57:57 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gregory.greenman@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: dvm: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:57:41 +0800
Message-Id: <20220709135741.45904-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'to'.
 Delete the redundant word 'when'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 40d790b36d85..83ceb3b5d918 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -931,7 +931,7 @@ static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
 
 		/*
 		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
+		 * mac80211 use TID 0 (as they need to avoid replay attacks)
 		 * for checking the IV in the frames.
 		 */
 		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
index 7ace052fc78a..f9bae2b40752 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tt.h
@@ -69,7 +69,7 @@ struct iwl_tt_trans {
  * @state:          current Thermal Throttling state
  * @tt_power_mode:  Thermal Throttling power mode index
  *		    being used to set power level when
- *		    when thermal throttling state != IWL_TI_0
+ *		    thermal throttling state != IWL_TI_0
  *		    the tt_power_mode should set to different
  *		    power mode based on the current tt state
  * @tt_previous_temperature: last measured temperature
-- 
2.36.1

