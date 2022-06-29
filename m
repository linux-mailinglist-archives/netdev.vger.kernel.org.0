Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06DB55FA74
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiF2IZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiF2IZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:25:22 -0400
X-Greylist: delayed 466 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 01:25:17 PDT
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DAA3BF88;
        Wed, 29 Jun 2022 01:25:16 -0700 (PDT)
X-QQ-mid: bizesmtp87t1656490613t13byxwy
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 16:16:44 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: b4WVjWspmb8Wrbp/htVwhCohrQW3mCSAbCdrGRIHyT/RFZ4u21bkSnZPI/CI6
        Ntxxi7sbffmc3Ue8rU/211kxLE8a7OBk6BU+Jo2F61WWvRN/Jh9VYEUeIzny5V7Rdfee1xD
        IVdcI753KtsQR/3dGux7P6CwqfgFeSGrj4UFbGgr+pKCtwEFKAilb/ITcRYAeYePEU7I3E8
        hsgycVwdSN79iVkvOCq00LqEz/VXmHIwEF9QHdBRq1LEa1rEjdCDG6/s6z9fiNhKNnWOFOA
        eSjMooedFDKOWRCD9Z0FDcsxVHtTbbjKntJXJJl0jaNSGE
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] atheros/atl1c:fix repeated words in comments
Date:   Wed, 29 Jun 2022 16:16:32 +0800
Message-Id: <20220629081632.54445-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'slot'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 49459397993e..24fe967c18cd 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2849,7 +2849,7 @@ static pci_ers_result_t atl1c_io_error_detected(struct pci_dev *pdev,
 
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.36.1

