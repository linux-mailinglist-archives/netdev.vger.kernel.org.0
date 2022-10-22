Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9D16084A7
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJVFkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJVFka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:40:30 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D9B4236421;
        Fri, 21 Oct 2022 22:40:20 -0700 (PDT)
X-QQ-mid: bizesmtp80t1666417182tcklwhm4
Received: from localhost.localdomain ( [182.148.15.254])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Oct 2022 13:39:40 +0800 (CST)
X-QQ-SSF: 01000000000000C0E000000A0000000
X-QQ-FEAT: 83ShfzFP0oB30QryaHc0taU9uhQ2Mmux70uAmTAzQV+AOPnEGnpTNrarzmniF
        cBYjOv2OrZcuQ8K0V2J6UVs0uQZWaW5ECBp75sIIkVvDFqmDey8A+Q/jAHlxS4JhuUVcgfQ
        3vYjeMKQRX4paGUoO5PSHyPtSDytw/h6in6c2ogPKjDJZkQ6emboEzxxawntWEVIvG8+onI
        KKdKVq2XFi2Zg5RNf8MFMsHdXniNVXI1hoz9nEIlH4Z9/Nu6JZ/Q+mAYVqhoQW1aNVdQCeJ
        3djRuga9jHHygRJQ0A6Eg+xPVx3KlIoM9jmNOD9FJ0xWZ++4hWwyopetbk80ANVf8qOA8Mx
        D+oDY18DoTNB/OC1bc6vmGF806nwpVF44tWYKQ00LPFIprhboA=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] intel/iwlwifi: fix repeated words in comments
Date:   Sat, 22 Oct 2022 13:39:34 +0800
Message-Id: <20221022053934.28668-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index d659ccd065f7..7aca20cff007 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -489,7 +489,7 @@ struct iwl_trans_rxq_dma_data {
  *	If RFkill is asserted in the middle of a SYNC host command, it must
  *	return -ERFKILL straight away.
  *	May sleep only if CMD_ASYNC is not set
- * @tx: send an skb. The transport relies on the op_mode to zero the
+ * @tx: send an skb. The transport relies on the op_mode to zero
  *	the ieee80211_tx_info->driver_data. If the MPDU is an A-MSDU, all
  *	the CSUM will be taken care of (TCP CSUM and IP header in case of
  *	IPv4). If the MPDU is a single MSDU, the op_mode must compute the IP
-- 
2.36.1

