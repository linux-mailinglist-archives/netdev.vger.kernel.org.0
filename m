Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2E554DE3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358749AbiFVOuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358782AbiFVOul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:50:41 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABB33CA7E;
        Wed, 22 Jun 2022 07:50:07 -0700 (PDT)
X-QQ-mid: bizesmtp76t1655909327to1dg4y5
Received: from ubuntu.localdomain ( [106.117.78.84])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 22:48:43 +0800 (CST)
X-QQ-SSF: 01000000008000B0B000E00A0000000
X-QQ-FEAT: FXvDfBZI5O6qR3DJvS7Q5bQUq4JQscHVhJ2/0ZFetAJDUPiDSJUeIaq9Eu2yu
        YQqT5rNFRPFc9053BLewyJt1Xp5DM1Ft4JpaT14Qpm4rmehhHh/zQ8s4f+SKg32GalMeJoU
        PvJJYQL9SerKRVuR/KqOYMG9DrTvlyrJ4e/VWCraxXTCFJqTgfNkwjmE6sbnRsFnIV2mYtz
        p7I32Fnpzl9G7kWSXZddV2fzAACbt3fNzROH4CBHAcErSEE3AS7L/uzVbEXJB4qTfewUEST
        mOMyEMUUSZXFK7qDScBSgae5+HcDJQT4dzwu7uiKq5NzS2qeuCqNUA01uSC5RDM4VWAniIt
        aOlKXj2pyc7Q7KO55jSq/AUfUR8JtAYHzcoH90h
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] cxgb4/cxgb4vf: Fix typo in comments
Date:   Wed, 22 Jun 2022 22:48:41 +0800
Message-Id: <20220622144841.21274-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated word 'and' from comments

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index d546993bda09..1c52592d3b65 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -877,7 +877,7 @@ int t4vf_get_sge_params(struct adapter *adapter)
 
 	/* T4 uses a single control field to specify both the PCIe Padding and
 	 * Packing Boundary.  T5 introduced the ability to specify these
-	 * separately with the Padding Boundary in SGE_CONTROL and and Packing
+	 * separately with the Padding Boundary in SGE_CONTROL and Packing
 	 * Boundary in SGE_CONTROL2.  So for T5 and later we need to grab
 	 * SGE_CONTROL in order to determine how ingress packet data will be
 	 * laid out in Packed Buffer Mode.  Unfortunately, older versions of
-- 
2.17.1

