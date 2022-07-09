Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B250A56CA0D
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiGIOat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGIOas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:30:48 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167652A958;
        Sat,  9 Jul 2022 07:30:42 -0700 (PDT)
X-QQ-Spam: true
X-QQ-mid: bizesmtp70t1657375989tfudpi47
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 22:13:06 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        quic_srirrama@quicinc.com, yuanjilin@cdjrlc.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mvm: fix repeated words in comments
Date:   Sat,  9 Jul 2022 22:12:59 +0800
Message-Id: <20220709141259.60127-1-yuanjilin@cdjrlc.com>
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
 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 61f9136a333d..a3ffecad1f53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -251,7 +251,7 @@ static void iwl_mvm_wowlan_get_rsc_tsc_data(struct ieee80211_hw *hw,
 
 		/*
 		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
+		 * mac80211 use TID 0 (as they need to avoid replay attacks)
 		 * for checking the IV in the frames.
 		 */
 		for (i = 0; i < IWL_NUM_RSC; i++) {
@@ -387,7 +387,7 @@ static void iwl_mvm_wowlan_get_rsc_v5_data(struct ieee80211_hw *hw,
 
 		/*
 		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
+		 * mac80211 use TID 0 (as they need to avoid replay attacks)
 		 * for checking the IV in the frames.
 		 */
 		for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index a3cefbc43e80..abf8585bf3bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -29,7 +29,7 @@ u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
-- 
2.36.1

