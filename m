Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA285739C5
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 17:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbiGMPKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 11:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbiGMPKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 11:10:34 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49ACB422DE;
        Wed, 13 Jul 2022 08:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KjPlb
        DKcLWB+1EGG+lpIBMAfm5r9Mc1T965dRiQ7mpw=; b=jFxYXY76nAzcsEuiOJRaM
        m76MS5DVFlipdeW+VgvfmAdKNtmUCXrhmyZmURf0XIO8gyXpn810yyLRFwWRkhcP
        etRFSZGhy9PKzrEXg+BSB3UZRl0uiCL+tMsmW0LulN0nG94oH9Pk5YNZIy5GFeUD
        /CtO3OXiZw9zQCwgAoSi1A=
Received: from localhost.localdomain (unknown [113.246.106.84])
        by smtp13 (Coremail) with SMTP id EcCowACnxXcz4M5ilUxpNQ--.46211S2;
        Wed, 13 Jul 2022 23:09:41 +0800 (CST)
From:   iamwjia@163.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rajur@chelsio.com, Wang Jia <iamwjia@163.com>
Subject: [PATCH -next] cxgb4: cleanup double word in comment
Date:   Wed, 13 Jul 2022 23:09:34 +0800
Message-Id: <20220713150934.49166-1-iamwjia@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowACnxXcz4M5ilUxpNQ--.46211S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF4UCrWrWF4DXw4UCr18Grg_yoW8Cr47pF
        s3AFyxuwn7tayUXaykJws7JF9Iqa4Dt348Kr4xJ3yrZ34fArWDAr1FqFWjgFykArW8GF4a
        yrs0vFnrCFnay3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMbyA-UUUUU=
X-Originating-IP: [113.246.106.84]
X-CM-SenderInfo: pldp4ylld6il2tof0z/xtbB0RU94FzIB5J0GgAAs2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Jia <iamwjia@163.com>

Remove the second 'to'.

Fixes: c6e0d91464da2 ("cxgb4vf: Add T4 Virtual Function Scatter-Gather Engine DMA code")
Fixes: b5e281ab5a96e ("cxgb4: when max_tx_rate is 0 disable tx rate limiting")
Signed-off-by: Wang Jia <iamwjia@163.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0c78c0db8937..edcd7cf09884 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3307,7 +3307,7 @@ static int cxgb4_mgmt_set_vf_rate(struct net_device *dev, int vf,
 	}
 
 	if (max_tx_rate == 0) {
-		/* unbind VF to to any Traffic Class */
+		/* unbind VF to any Traffic Class */
 		fw_pfvf =
 		    (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_PFVF) |
 		     FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_PFVF_SCHEDCLASS_ETH));
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 43b2ceb6aa32..b2e0bf46a9fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -2191,7 +2191,7 @@ static void __iomem *bar2_address(struct adapter *adapter,
 /**
  *	t4vf_sge_alloc_rxq - allocate an SGE RX Queue
  *	@adapter: the adapter
- *	@rspq: pointer to to the new rxq's Response Queue to be filled in
+ *	@rspq: pointer to the new rxq's Response Queue to be filled in
  *	@iqasynch: if 0, a normal rspq; if 1, an asynchronous event queue
  *	@dev: the network device associated with the new rspq
  *	@intr_dest: MSI-X vector index (overriden in MSI mode)
-- 
2.25.1

