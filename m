Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20CB58FBB1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbiHKL4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiHKL4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:56:52 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26926F541;
        Thu, 11 Aug 2022 04:56:50 -0700 (PDT)
X-QQ-mid: bizesmtp91t1660218989tbzq6aab
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 19:56:28 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: k0mQ4ihyJQMcgnb2QO8p/lOKPeQB/ThXdak+zUWfibywXTBegxOe1ijfv9uZz
        aEalpuq+KAIkME/YcYzfs2LySzeFBAOoQWAV47JETWkoVOnZzeSWAFGcuAhmmsqOUPko1t/
        mQDfxQD18SEloJgbhhFaKbgGrioTZIWhTZQ5gNZD93P/gbTMvg5s5EhKcGplqk/QY85bnoV
        ObRxN9Vde+o+kM2WvimoqDpm3fmX8jV2zGyvyF/imUo1YRMJRP0hq7WQKcBt6fPHt+SBnvn
        xk+PAxPox2RM5X4h9c3oQ5Z47gIGYfUefZfdgZNeuQkaNKB5pErGGkcjjogVIdXCztxdrKM
        LDTdKiNZo8VlgQ4wggXIMxgYLRvuSw1HQfyUQl0JvCz27gBSdyxMrVMfbb4ViFUmpPvDIC2
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     aelior@marvell.com, skalluru@marvell.com, manishc@marvell.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] bnx2x: Fix comment typo
Date:   Thu, 11 Aug 2022 19:56:20 +0800
Message-Id: <20220811115620.3596-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 7071604f9984..02808513ffe4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -13844,7 +13844,7 @@ static void bnx2x_check_kr2_wa(struct link_params *params,
 
 	/* Once KR2 was disabled, wait 5 seconds before checking KR2 recovery
 	 * Since some switches tend to reinit the AN process and clear the
-	 * the advertised BP/NP after ~2 seconds causing the KR2 to be disabled
+	 * advertised BP/NP after ~2 seconds causing the KR2 to be disabled
 	 * and recovered many times
 	 */
 	if (vars->check_kr2_recovery_cnt > 0) {
-- 
2.36.1

