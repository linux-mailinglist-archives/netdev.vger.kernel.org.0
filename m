Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52F355FC08
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbiF2J34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiF2J3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:29:55 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4220239BAC;
        Wed, 29 Jun 2022 02:29:50 -0700 (PDT)
X-QQ-mid: bizesmtp81t1656494959t66e1h5n
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 17:29:04 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: USLLWE2n1d9dfz29kxOfwYa0qzLZS4Id15dG4y0pvLDHfooTRSxTm3QWX+CgV
        0eLx/W2O01Em+eZzSC++T1CSV9o8QrfhyCV2BSiBQ8C0za5ynTHz11maKKhAHJkf7TeL6VA
        FgbDW77Z+w0cvxjuWOV5yAZG7KzIbcLDnf+u8vZRlwZYMOStnxCJ/v2GGz2ZEiygxlyX66k
        mDT4P+46l8MN4i0hVNeA+UwT0xOo0BhVfOszMqCABkjYaDMb5ceemxJx6iDGlIjwIoYRGhi
        Pjb/HPnv/7Oz7bRbnxpw/4L3yq8ZbPkXRfF15GJkW27dYgVnLQRXcXRjVFk0MYmbWlYeqk9
        AGswnoM
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] atheros/atl1e:fix repeated words in comments
Date:   Wed, 29 Jun 2022 17:28:56 +0800
Message-Id: <20220629092856.35678-1-yuanjilin@cdjrlc.com>
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
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 20681860a599..4fc9e6350c49 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2482,7 +2482,7 @@ atl1e_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.36.1

