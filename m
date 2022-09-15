Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142445B92ED
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiIODLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIODLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:11:36 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D32910BD;
        Wed, 14 Sep 2022 20:11:34 -0700 (PDT)
X-QQ-mid: bizesmtp73t1663211456twhryh5c
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 11:10:55 +0800 (CST)
X-QQ-SSF: 01000000000000E0G000000A0000000
X-QQ-FEAT: //oo7IHNoNUzSTuAFG0KH3gdhvbfbUZ/KgztgKTIOYFtNQJr6yO8+QPsPi5WB
        kX9G3chCOVOWp/3Ixwc7xSFvbPGlm63f0kCbnYmnLfWHuekTSih08n5NebUZRy0nl9RwqxE
        wiE3947GKhjyhC+U5zS/KFs6FfJp5g2eyaFw0CmTkORHO80MeTZx+ttigencZJwUXf8Nhww
        YGfyY2FPQfVNUFd9YgZkr2JBKqVRCrh42SG218zPR9f+YK/08qtNDjZLk9mQGNB4iCuNoiO
        vrZJF9WotiIfsK/qJ8PAiYcVbo+rCW3Y1NR8TDtwXhrII1rbt561EMZXgu8VnqtM5vtYE6r
        nOco2lgZ2G6wrN23lysTRmOxRtudPqMZMgrAFbKPEDyNn700jB9rBGFAvCN2rB6CszTn0LS
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] iwlwifi: fix repeated words in comments
Date:   Thu, 15 Sep 2022 11:10:49 +0800
Message-Id: <20220915031049.47298-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index d659ccd065f7..e6adc2dc0485 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -490,7 +490,7 @@ struct iwl_trans_rxq_dma_data {
  *	return -ERFKILL straight away.
  *	May sleep only if CMD_ASYNC is not set
  * @tx: send an skb. The transport relies on the op_mode to zero the
- *	the ieee80211_tx_info->driver_data. If the MPDU is an A-MSDU, all
+ *	ieee80211_tx_info->driver_data. If the MPDU is an A-MSDU, all
  *	the CSUM will be taken care of (TCP CSUM and IP header in case of
  *	IPv4). If the MPDU is a single MSDU, the op_mode must compute the IP
  *	header if it is IPv4.
-- 
2.36.1

