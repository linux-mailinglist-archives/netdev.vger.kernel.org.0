Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23D9560042
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiF2Mi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiF2Miz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:38:55 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86FE255B7;
        Wed, 29 Jun 2022 05:38:49 -0700 (PDT)
X-QQ-mid: bizesmtp70t1656506298t8vefo77
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 20:38:03 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: hOPADF7UwX5GqrFxp402i0kbzfOWpsECqKT+0UlFe66LzAmsZB64PsLhDEG0k
        MXnD+RynF2GD2DQ2+poyHMA3LXxiIx2HJyfiWSFZzdxqHmJY+lOkQ+nAuYv6FHuLF+XRmg/
        5XUB5I6HXHyGFlFBz7ePaOvjhDHE9ZPwEdx5xVdovg6mUE+kDCF5nvDFCiAL6bb6Ww2BFoR
        7duEpTvlfZj4WS0RKlc4p81LB+xckoE15ILIa0tricUxJT1bReNOKd36trIbyQ4bh7PfLoB
        JZcWdfdnbPg1FnIzPBVrRigyqnUx6WKUyOsg7ONccqmnK+FqV8nzKJAKFpFOpPC7G9hnjm9
        9WButwjJX6piW8FD3I=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/emulex:fix repeated words in comments
Date:   Wed, 29 Jun 2022 20:37:56 +0800
Message-Id: <20220629123756.48860-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index cd4e243da5fa..41acd18a3fd2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3178,7 +3178,7 @@ static irqreturn_t be_intx(int irq, void *dev)
 	}
 	be_eq_notify(adapter, eqo->q.id, false, true, num_evts, 0);
 
-	/* Return IRQ_HANDLED only for the the first spurious intr
+	/* Return IRQ_HANDLED only for the first spurious intr
 	 * after a valid intr to stop the kernel from branding
 	 * this irq as a bad one!
 	 */
-- 
2.36.1

