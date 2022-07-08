Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D114456BD52
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiGHPVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbiGHPVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:21:11 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB171ADA3;
        Fri,  8 Jul 2022 08:21:06 -0700 (PDT)
X-QQ-mid: bizesmtp66t1657293648t1bpiyjn
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:20:45 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: +HVWQWZs/U14RI5AL/nek+wt3LHA5NtsHl0z4aqL3kVFCSyAaqy6yApCJxRva
        I+J0tKxTeI9OsvVyhUgFC4Z402Vc0tDrlueo3Jy74Rb483/Ru3l+9/4CtghJMjD2+OQLswQ
        qEMl75w3ByWf9Z51bO7ovU/51bsV9nRlOmm/dO9ABCtaklV4NjWX12qB8l3iD8B/PaFJngN
        2GbIIpPHbMC9+5+NU09nfVjDHXmxJ2sTcsu1HxKBFtQsDiFprl4P2MxusouobMiZi1ykIDV
        hvRKVnbMzVhgNVOzne059X/MveqLFOTadVXZO5EjogN8G9v9Z69Y1sNUCqBg65Z/qDkZznm
        HfgxQ2wsm+uGTrmAPBXiOdE0BvIfW3P1PYSybg3oqfPEz1Kjis=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] net/ipa: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:20:38 +0800
Message-Id: <20220708152038.55840-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ipa/gsi_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index ea333a244cf5..d7065e23c92e 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -108,7 +108,7 @@ void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
  * gsi_channel_tx_queued() - Report the number of bytes queued to hardware
  * @channel:	Channel whose bytes have been queued
  *
- * This arranges for the the number of transactions and bytes for
+ * This arranges for the number of transactions and bytes for
  * transfer that have been queued to hardware to be reported.  It
  * passes this information up the network stack so it can be used to
  * throttle transmissions.
-- 
2.36.1


