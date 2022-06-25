Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4655A77E
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiFYGeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiFYGeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:34:19 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605874AE17;
        Fri, 24 Jun 2022 23:34:13 -0700 (PDT)
X-QQ-mid: bizesmtp65t1656138771t2lklo41
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 25 Jun 2022 14:32:46 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: 1al0Ay5k4U33JnV8rDMg3BQWJQWbjLIB8QGOwWLbU8NxsKzwo+DU+81Bh00Z7
        4D2RLZMt8/HCc+ofeYwuYGOE9MwGCsqKBAwOlfoEaZ2dYvUrPytFPnHZ+RwNObeEcK2xEgj
        OdowCqUh8WugBM3fjuHlyMkYVQcXf3AmbR1GrseHsLGbZodl96NjSLvXqSZh3SptwUCQa7i
        PVu1EZb1OhzuBCUoMEU59g0p2Vd88qEsedGIzn7zMhk4wiawhmmxWCQuBjSGK8yJFs5MD9T
        bYYqSBXEj3aOHfaNBgIkIWSIxruemGjTQVeClkSjo0lRO5CVkQ5nxd1JsL0/ub4UU0f+NTd
        kxwxLdpVDbFXqH26hk=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] sfc:falcon: fix repeated words in comments
Date:   Sat, 25 Jun 2022 14:32:40 +0800
Message-Id: <20220625063240.55133-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'in'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/sfc/falcon/bitfield.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/bitfield.h b/drivers/net/ethernet/sfc/falcon/bitfield.h
index 5eb178d0c149..78537a53009e 100644
--- a/drivers/net/ethernet/sfc/falcon/bitfield.h
+++ b/drivers/net/ethernet/sfc/falcon/bitfield.h
@@ -117,7 +117,7 @@ typedef union ef4_oword {
  *
  *   ( element ) << 4
  *
- * The result will contain the relevant bits filled in in the range
+ * The result will contain the relevant bits filled in the range
  * [0,high-low), with garbage in bits [high-low+1,...).
  */
 #define EF4_EXTRACT_NATIVE(native_element, min, max, low, high)		\
-- 
2.36.1

