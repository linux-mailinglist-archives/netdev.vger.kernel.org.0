Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD52560191
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiF2NmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiF2NmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:42:00 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D81C16585;
        Wed, 29 Jun 2022 06:41:55 -0700 (PDT)
X-QQ-mid: bizesmtp69t1656510095tfjod3ji
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 21:41:32 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: XcJ1Se6WjemIkNAHg25b978jKUBDTPupJVdN5gEvjEznt7dXK2BHQm93f7fi9
        gdqSljLpE/iaZ4pvh+supcRcO+y1A0zi03/mXbLQc7h94EPDaeq/r5uojiEReUFvH35p3QI
        sVy4TGh0rYgajBDaY9vOuagMeU8JXco7jJjphrb3MQrIWGlgf4b5WnXgT7iRWhlseLqfLnf
        xEfvsdGlMF9FAt9V1GEzmUKRDhk/56C6KCpSVt6KKwGZ70y8+wT/m6fed3SInsuPXNbZfey
        k9KDIhb/oX3GdvbpRrk9A2SYN0Phv0Sm6S3i/BWkZLRTS0vBqObQ7RH6FVDDDlaqzT5VtEE
        aHwdWwueX1lG86QYP8=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/i40e:fix repeated words in comments
Date:   Wed, 29 Jun 2022 21:41:25 +0800
Message-Id: <20220629134125.49734-1-yuanjilin@cdjrlc.com>
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
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 332a608dbaa6..a6e05b14fec6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13028,7 +13028,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	}
 
 	/* No need to validate L4LEN as TCP is the only protocol with a
-	 * a flexible value and we support all possible values supported
+	 * flexible value and we support all possible values supported
 	 * by TCP, which is at most 15 dwords
 	 */
 
-- 
2.36.1

