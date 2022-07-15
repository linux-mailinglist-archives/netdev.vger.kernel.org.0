Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E412C5782F8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiGRNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiGRNBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:01:35 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39ECA19F;
        Mon, 18 Jul 2022 06:01:30 -0700 (PDT)
X-QQ-mid: bizesmtp63t1658149272t5jqfoqf
Received: from localhost.localdomain ( [171.223.96.21])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 18 Jul 2022 21:01:10 +0800 (CST)
X-QQ-SSF: 01000000002000E0U000C00A0000020
X-QQ-FEAT: LL8Fg7akT3SqF2SkLcMv44bhStbMi5dMIsUSpTvRQqxhZrtq3O7qlTN3lAKAj
        w6shzrFDKvRGQJSZ4exX3As82EUgFFNoDiorXtlOMF5Ceg/ORjjzBg+iZ4a1sY3CtrnYwUP
        YZlyoBThYip/ZlJpAel9xt+G5gqHCNaCZkAVqFAJ1FrDt2YUU5rCpQKqGQasP6WdjOrXNBQ
        81iW3gat93JJDcVQIAbDCJcY3PQ1DxB1nS8HSr48aXvKOg4HYTsAsAD0lhQgcX65su7lGT9
        R1v01jyTRIOmq+THOzt0PfXKfY9SbEyNgr2QhVDAAb+67INjsDtG5OoU0LKb/DRFUpD1BC3
        nvfguPwe6ygAlINyAyAs/D7x3bWZKT1GkasyXpibiRTrY34iLvKNQ360JUT/k5tneVclfJg
        Z2s+BeWLLXo=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     edumazet@google.com
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: ethernet/sfc: Fix comment typo
Date:   Fri, 15 Jul 2022 12:59:14 +0800
Message-Id: <20220715045914.23629-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `that' is duplicated in line 2438, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/sfc/falcon/falcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
index 3324a6219a09..9fcd28500939 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon.c
@@ -2435,7 +2435,7 @@ static void falcon_init_rx_cfg(struct ef4_nic *efx)
 		 * supports scattering for user-mode queues, but will
 		 * split DMA writes at intervals of RX_USR_BUF_SIZE
 		 * (32-byte units) even for kernel-mode queues.  We
-		 * set it to be so large that that never happens.
+		 * set it to be so large that never happens.
 		 */
 		EF4_SET_OWORD_FIELD(reg, FRF_AA_RX_DESC_PUSH_EN, 0);
 		EF4_SET_OWORD_FIELD(reg, FRF_AA_RX_USR_BUF_SIZE,
-- 
2.35.1

