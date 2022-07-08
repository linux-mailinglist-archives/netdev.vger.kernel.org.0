Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B3B56BC17
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 17:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238443AbiGHPFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiGHPFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:05:00 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5212CE37;
        Fri,  8 Jul 2022 08:04:55 -0700 (PDT)
X-QQ-mid: bizesmtp68t1657292646tnxdblf7
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:04:01 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: qZu16BA30Err+swO0ObxsJvuzg/K2BB5PMsEr3EdcHw0malLovmoCSEn9VV4q
        xM9Ta7LPg7o2Av4TbQxU4r8lLZRTlZChb2lSBg/ZfAzZmV3EIISX0IS7tU55pkwYJc8uko4
        E0G2kY5MwA8/BNuh1EiRdDrrTTSjZHwLmRPxgtU2sqqrY6ixOS4Zpzl8HVl/2bWqsFfEZ/s
        pTNjznhBjWSLtKIoirIFtRBRra38t3HYZHLePDONlkt5nUO5ZquS1npNVSptc41Sg3yCQUt
        WN8WAxnlLSrKZmOJTxReL0Kxtod+1Pw2PqvD7JaXgs/hBengpXg18Y8bvASAg0me3XMfKJ4
        tFv6CfDZRVF/APTiD+k8uQ6zxMHXY/DtaU0G4F5R7ixJM+N75mDYOiddEoTPg==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] fddi/skfp: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:03:54 +0800
Message-Id: <20220708150354.40101-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'test'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/fddi/skfp/fplustm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/fplustm.c b/drivers/net/fddi/skfp/fplustm.c
index 4cbb145c74ab..036062376c06 100644
--- a/drivers/net/fddi/skfp/fplustm.c
+++ b/drivers/net/fddi/skfp/fplustm.c
@@ -1314,7 +1314,7 @@ void mac_set_rx_mode(struct s_smc *smc, int mode)
 	o Connect a UPPS ISA or EISA station to the network.
 	o Give the FORMAC of UPPS station the command to send
 	  restricted tokens until the ring becomes instable.
-	o Now connect your test test client.
+	o Now connect your test client.
 	o The restricted token monitor should detect the restricted token,
 	  and your break point will be reached.
 	o You can ovserve how the station will clean the ring.
-- 
2.36.1

