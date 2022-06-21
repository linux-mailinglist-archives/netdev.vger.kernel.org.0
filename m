Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0D552D66
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348179AbiFUIv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344495AbiFUIv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:51:26 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A847526566;
        Tue, 21 Jun 2022 01:51:21 -0700 (PDT)
X-QQ-mid: bizesmtp76t1655801407tjxi2z2n
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:50:03 +0800 (CST)
X-QQ-SSF: 0100000000700020B000B00A0000000
X-QQ-FEAT: Jd++W0FxedGHpdP/eoJK8zi3TCearkPqcGcYeMXFRwht4nDzcBnRzGIODNWE2
        c45F3TwCjrNFucbw/tbQjEU2L0qKjB+Q0ZHuqR/2RP47vADltoqhfhagEL1vLPDzfWaO9MO
        uBbBtaqCFamICf0aZWMTDrvHHYsOAUGhjZXXnHAgyhw+1a4yogHRftLoeTaGax9RorFM2Sg
        EDAqbIqf9uVkUsLvSSOEouauDcFgqgP20hcF6xYY1LLiG3vl5WsSy0XqCvN9fFJybt/yKUn
        YG79pH0E8wuFejT4/LMlg4qHI2pIaA6TlwBs/sRDqNU0puBSuwvpuxPCPheJD5eIdmDp4RO
        BpfPkf27eQbc/yI0SE=
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiangjian@cdjrlc.com
Subject: [PATCH] net: ipa: remove unexpected word "the"
Date:   Tue, 21 Jun 2022 16:50:01 +0800
Message-Id: <20220621085001.61320-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word "the" in the comments that need to be removed

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ipa/gsi_trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index cf646dc8e36a..29496ca15825 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -339,7 +339,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	if (!gsi_trans_tre_reserve(trans_info, tre_count))
 		return NULL;
 
-	/* Allocate and initialize non-zero fields in the the transaction */
+	/* Allocate and initialize non-zero fields in the transaction */
 	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
 	trans->gsi = gsi;
 	trans->channel_id = channel_id;
@@ -669,7 +669,7 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
 	if (!gsi_trans_tre_reserve(trans_info, 1))
 		return -EBUSY;
 
-	/* Now fill the the reserved TRE and tell the hardware */
+	/* Now fill the reserved TRE and tell the hardware */
 
 	dest_tre = gsi_ring_virt(tre_ring, tre_ring->index);
 	gsi_trans_tre_fill(dest_tre, addr, 1, true, false, IPA_CMD_NONE);
-- 
2.17.1

