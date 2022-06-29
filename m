Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDE8560203
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiF2OEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiF2OEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:04:49 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B73F2529E;
        Wed, 29 Jun 2022 07:04:43 -0700 (PDT)
X-QQ-mid: bizesmtp63t1656511447t5k5iapr
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:03:59 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: 3uawQE1sH+2MKe39u4T+sQMZuK7zrFp2/8EpLwS4FOyKK8QBIIkGb6ZhK+FVV
        VyvUFiDUrUD9efbZQkW8A5KeW2IFH5aZ6ngwzVCnB01UMfdV5m/hc86xqccf1l6vVrf89ZZ
        +RSSwjwNh+s9N0/B1X+GgyGcH3e1cFoa+gnDD9pNO7hM9HqE3X7XDSiY2ZRTlqhlRblhLil
        s4hjRGc13E23C50JsrnZwA/e6LKZd4OUDlN5U6x0ADvPxvt2EK9em5AoUYBXVgTjYVjp3pL
        MM2Ub6HzZLpa6ysLB1+5+OHBu/0DlBpkX7PHD0Yvt1m00rHpPaqwfW2+5oHqFubGPw2eBxr
        arUS3qO
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/iavf:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:03:52 +0800
Message-Id: <20220629140352.51610-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 7dfcf78b57fb..548302b1cb8d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4162,7 +4162,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	}
 
 	/* No need to validate L4LEN as TCP is the only protocol with a
-	 * a flexible value and we support all possible values supported
+	 * flexible value and we support all possible values supported
 	 * by TCP, which is at most 15 dwords
 	 */
 
-- 
2.36.1

