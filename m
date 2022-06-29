Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22D1560152
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiF2NcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiF2NcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:32:07 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F82237034;
        Wed, 29 Jun 2022 06:32:02 -0700 (PDT)
X-QQ-mid: bizesmtp79t1656509476tvvsidqs
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 21:31:14 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: 1XNERxhHvDkrposPQr1R9uI+G46sLpNhx7g2/nAcD2JgwXoFIB6qmrUCtgDBK
        bSSrDdzaR7ncxD9lnDnRIKtbRR1AoCWlULtBM//uuIV0cEJB46Yi1w6aVCPSYP23T+C2Zb/
        TKQt+W3oMnZfY5ERe13/7O8rB2dR8SNgxk/Tf+Gcu7bccOpJZKFG7LrXTejybK8Xx8ZlAy+
        lqoeytznuYD2y0vKTfZ6N/KylLcr4dwm+ERycsEpDDO3MElhhro7nFsaa5AyPaG5tgYnLAe
        XPCmGr8Lj1dBfa7/dr7naKJoYvai2U9ICBv1X8uEaa0udpGlm3kyfRLeTposrbDwPpwK5/t
        SSuXLOh
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/e1000e:fix repeated words in comments
Date:   Wed, 29 Jun 2022 21:31:07 +0800
Message-Id: <20220629133107.36642-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,RCVD_IN_VALIDITY_RPBL,
        RDNS_DYNAMIC,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'frames'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/e1000e/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/mac.c b/drivers/net/ethernet/intel/e1000e/mac.c
index 51512a73fdd0..5df7ad93f3d7 100644
--- a/drivers/net/ethernet/intel/e1000e/mac.c
+++ b/drivers/net/ethernet/intel/e1000e/mac.c
@@ -957,7 +957,7 @@ s32 e1000e_force_mac_fc(struct e1000_hw *hw)
 	 *      1:  Rx flow control is enabled (we can receive pause
 	 *          frames but not send pause frames).
 	 *      2:  Tx flow control is enabled (we can send pause frames
-	 *          frames but we do not receive pause frames).
+	 *          but we do not receive pause frames).
 	 *      3:  Both Rx and Tx flow control (symmetric) is enabled.
 	 *  other:  No other values should be possible at this point.
 	 */
-- 
2.36.1

