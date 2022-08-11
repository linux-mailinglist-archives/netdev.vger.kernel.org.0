Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB76B58FBCF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiHKMCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbiHKMBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:01:37 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A296777
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:01:35 -0700 (PDT)
X-QQ-mid: bizesmtp71t1660219145tsz6jflk
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 19:59:03 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000000
X-QQ-FEAT: 4T5cXmihZDp6QV4di6KvMH+L6MJgNYaWdg2v3Q6xnyKpPInIgV0WEAzzKPXO7
        ik2Q+FUoo6Qpm5akFbksoE1oHzrqBto+7dhSL0awwaQWFaddDWJ0m/06BY25oZ3YH/If9Kp
        k/DmetiJf+M49G90xxNJv6bf3GmdOS86RW9t+09tpWGWdCXY1q7inDBJprce5LsRlJ/juRY
        utxap5XUBmd/oeAEPa49bI2UjtuzoURdQZ9UIFXuGEsvYU3DtSnoNVKdoHRn4n2+fp4VKs0
        lqtdLOHaaHIN2El+8W2lSCREcHbhyDjaTgWkXeg7EWvgC8+TcF1L0BHdc7XLo0DXGiIwoVz
        pQxgp71x3TmKMMw7ClOBDGW0GfFsDqaAzZ9PZ978yYj3t9xdmpaLgveeoPlGBhcCTQwyBB4
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, luciano.coelho@intel.com,
        johannes.berg@intel.com, miriam.rachel.korenblit@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] iwlwifi: mvm: Fix comment typo
Date:   Thu, 11 Aug 2022 19:58:56 +0800
Message-Id: <20220811115856.6725-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

