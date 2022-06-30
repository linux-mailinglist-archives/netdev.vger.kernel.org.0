Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102655611EA
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 07:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiF3FuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 01:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiF3FuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 01:50:15 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD51024091;
        Wed, 29 Jun 2022 22:50:10 -0700 (PDT)
X-QQ-mid: bizesmtp75t1656568184tl9in6hy
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 13:49:41 +0800 (CST)
X-QQ-SSF: 0100000000200070C000B00A0000000
X-QQ-FEAT: RMVj0UrY8cC86zkyM/sTHILcmu4TcWO/dhVWA42VaDHmX5IaW7nBIvRVgyT/8
        bzDLCLRbD1BraZVDxg1Zjd4lIFaO6AT3y9WfF22JL1hU0V7qEVHLXgwaxhrbDdx/RDO6oiW
        Mep0A+t0VWzeqvYMDaIX53GgIoHxnGIRVnkwsGfQzXhL6h/VGrAIu5IZTTtpWWIASfwNhfP
        V3H5uGpAmQ0eP/OJ9MAkc3bR+OWnU0WhRLr1WrW+hIR0MK6HqlS5xcS6UCIdh92L2sYd9xg
        SKeGyUhAoshC0NaBbDDIgcIS1DngcE1henwDMLqizwcalfZABbQVg6Bq6uLv3wx+E4SK78j
        Q5i9CrpfuqP6wC+n/k=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ethernet/marvell: fix repeated words in comments
Date:   Thu, 30 Jun 2022 13:49:25 +0800
Message-Id: <20220630054925.49173-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index a1e907c85217..9f1a7ec0491a 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4711,7 +4711,7 @@ static irqreturn_t sky2_test_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Test interrupt path by forcing a a software IRQ */
+/* Test interrupt path by forcing a software IRQ */
 static int sky2_test_msi(struct sky2_hw *hw)
 {
 	struct pci_dev *pdev = hw->pdev;
-- 
2.36.1

