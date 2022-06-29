Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9135F560276
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiF2OWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiF2OW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:22:29 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B5E1CB38;
        Wed, 29 Jun 2022 07:22:24 -0700 (PDT)
X-QQ-mid: bizesmtp85t1656512516torh9h9i
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:21:53 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: c0j92dw6IxKSeiEhrm+PtPxktskjXZcL4jlLKZjz7sO7OU5wzT87U/K4i93M1
        SIXryARAEXvXxv8ewgPkqT8uNecc8E29dDtO47pw+aNrj8xqVlE/kxAyWin8eWOUZuZPioZ
        Hy8wKoBUlufjdCMEqtDETjL9Z2pK+a1WvihZ52kZzAZ6Suotgy44vC3to4tP0DUQzObdo2B
        qfKmyv7xsWx49nK79I1zbk4IxNW0jycTMfX6mLJzR8f8FmwPyt06ivN/9p3rVz/GEO3CpKA
        Aj6PBwEXzTTC1C7xwUjtV1AuLnVB1+gd4TviIieLQ9ClUfjaKhFp7pfKAeaK/KUOetFvPum
        ZWcs3f2roAscvhvtgg=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/igbvf:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:21:47 +0800
Message-Id: <20220629142147.15535-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'on'.
Delete the redundant word 'slot'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/igbvf/igbvf.h  | 2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/igbvf.h b/drivers/net/ethernet/intel/igbvf/igbvf.h
index 975eb47ee04d..57d39ee00b58 100644
--- a/drivers/net/ethernet/intel/igbvf/igbvf.h
+++ b/drivers/net/ethernet/intel/igbvf/igbvf.h
@@ -227,7 +227,7 @@ struct igbvf_adapter {
 
 	/* The VF counters don't clear on read so we have to get a base
 	 * count on driver start up and always subtract that base on
-	 * on the first update, thus the flag..
+	 * the first update, thus the flag..
 	 */
 	struct e1000_vf_stats stats;
 	u64 zero_base;
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 43ced78c3a2e..f4e91db89fe5 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2537,7 +2537,7 @@ static pci_ers_result_t igbvf_io_error_detected(struct pci_dev *pdev,
 		igbvf_down(adapter);
 	pci_disable_device(pdev);
 
-	/* Request a slot slot reset. */
+	/* Request a slot reset. */
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-- 
2.36.1

