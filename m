Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC7D6084AC
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJVFlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJVFli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:41:38 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41222B0925;
        Fri, 21 Oct 2022 22:41:36 -0700 (PDT)
X-QQ-mid: bizesmtp78t1666417268tlhfzo3k
Received: from localhost.localdomain ( [182.148.15.254])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Oct 2022 13:41:06 +0800 (CST)
X-QQ-SSF: 01000000000000C0E000000A0000000
X-QQ-FEAT: 6ArnuSDJ+in4EeIG92JgWxQwoWx5R/AGXbjJCS5GRcwdh/lpoZcW74/N2mF8m
        9/V3dbC1LBoWQG/K16oWVMuY3K/NIFdGYfSyo0SnMD4s+zjbH0GNg402gDWSMEgtj6ax1nv
        QoZqJwkImJgyV1C2AP+1DQDmPdX3XMoZ8N/M+iXbh9kxiL+PB/VSv7LjTDOplOKTmtWKy8u
        C6L9Iu7E+shWTd8puhjKRN/o5u2bc3o/HvYezaPMgpA4rO9xWP3xLFVeK8P1I9UvpRtpeL7
        7GHUZLMrKYdJa2ETbqoOTQcoNKdP7EKSwMXkEQGGRcRFgdwBxfvp9Qdka5goxX8tmu8DZQ/
        MPw6AWggXk6DwsG3dzWC4sy0hzXiHyY0Xqo8o+n9V9q1JluX0s=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org, wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] fw/api: fix repeated words in comments
Date:   Sat, 22 Oct 2022 13:41:00 +0800
Message-Id: <20221022054100.30299-1-wangjianli@cdjrlc.com>
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
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index ecc6706f66ed..742a6b7b029d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -200,7 +200,7 @@ enum iwl_tx_offload_assist_bz {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @reserved2: reserved
  * @key: security key
-- 
2.36.1

