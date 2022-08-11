Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843C358FBB9
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 13:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiHKL53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 07:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiHKL50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 07:57:26 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599F09676C;
        Thu, 11 Aug 2022 04:57:25 -0700 (PDT)
X-QQ-mid: bizesmtp85t1660219029twzjx72b
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 19:57:07 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: 2023CglrJyJC7a6s2DvHvdcNM4p2OjaTlJm0wvj2XHjKuIZdtlSA40W43+Esd
        /KVyG8Sr3B94LoR2+KkO1GJsMZpq6HWCJ18l8K1GHoBQcideRENPoCL5yJ7p1Mi1pfJCAZf
        ETtGuioLUWkfsQS3YGkRSvjFNkpGQeLJytpdFq3z0NWEVvtq17q+RxlsoXu8ee/8Pq2yOM4
        kv4SUYnp0eGrytlr0mxuHvMNbSfdJHaMKgFcIw/rFYwTiEuaAFq/4bLgA7z2hYnRGl7Ph7/
        zXskr/c4FtPDpgyRU0AoCfa3TejP6KfCf6Rhxs74gtCfacEEFKuiFju/HNHx1vuDJfQxx2t
        DhsvWWcyvxTyhGkB+MGT+LalC/TruGwOrNmEqU/wr3xXjqtjsxuD4qWSoVxRQ==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: cxgb3: Fix comment typo
Date:   Thu, 11 Aug 2022 19:57:01 +0800
Message-Id: <20220811115701.4578-1-wangborong@cdjrlc.com>
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
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
index 84604aff53ce..89256b866840 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -243,7 +243,7 @@ static int cxgb_ulp_iscsi_ctl(struct adapter *adapter, unsigned int req,
 
 		/*
 		 * on rx, the iscsi pdu has to be < rx page size and the
-		 * the max rx data length programmed in TP
+		 * max rx data length programmed in TP
 		 */
 		val = min(adapter->params.tp.rx_pg_size,
 			  ((t3_read_reg(adapter, A_TP_PARA_REG2)) >>
-- 
2.36.1

