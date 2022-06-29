Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A8B55FCA1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiF2Jys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiF2Jys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:54:48 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6997F3DA4C;
        Wed, 29 Jun 2022 02:54:42 -0700 (PDT)
X-QQ-mid: bizesmtp81t1656496459t4saokzn
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 17:54:13 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: 3uawQE1sH+0v5heQUvT1QOgrXPZb/ALCIXVftPDcXAWg5KnzQgbFepZRhHwUI
        S6wvFilIN/B3sEIhmPZBlu63vl1MHePGTAgaYV+hiigvoR4i/xXAJh36Usd2jjD1rRdu2g0
        GLzHgfQtaz4wKvd6+fWi9xihHfGrxuxinfSJpJJCb1SVqljHiBPxkaW5cEsIPEL31bA1g55
        yJDWO+cvMxBMwC+mB3yMfIxUTo71YBTI0gKnEV22v4XmSW1ossp9LbPb0Q+fRBxqSOfK9hG
        3RunsmZ+k8DlAVITRnvwqG/Kr9VVYpHx4GeQi+gYGTnZx990yPxAQt2wzKPnHLpttGovoQ/
        aMnnlaF
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] dec/tulip:fix repeated words in comments
Date:   Wed, 29 Jun 2022 17:54:05 +0800
Message-Id: <20220629095405.8668-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'this'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/dec/tulip/xircom_cb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/xircom_cb.c b/drivers/net/ethernet/dec/tulip/xircom_cb.c
index 8759f9f76b62..61825c9bd6be 100644
--- a/drivers/net/ethernet/dec/tulip/xircom_cb.c
+++ b/drivers/net/ethernet/dec/tulip/xircom_cb.c
@@ -742,7 +742,7 @@ static void activate_receiver(struct xircom_private *card)
 
 /*
 deactivate_receiver disables the receiver on the card.
-To achieve this this code disables the receiver first;
+To achieve this code disables the receiver first;
 then it waits for the receiver to become inactive.
 
 must be called with the lock held and interrupts disabled.
@@ -829,7 +829,7 @@ static void activate_transmitter(struct xircom_private *card)
 
 /*
 deactivate_transmitter disables the transmitter on the card.
-To achieve this this code disables the transmitter first;
+To achieve this code disables the transmitter first;
 then it waits for the transmitter to become inactive.
 
 must be called with the lock held and interrupts disabled.
-- 
2.36.1

