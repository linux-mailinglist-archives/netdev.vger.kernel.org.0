Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC6B61EAF7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 07:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiKGG0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 01:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiKGG0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 01:26:31 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF2712AFA;
        Sun,  6 Nov 2022 22:26:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VU6xedu_1667802385;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VU6xedu_1667802385)
          by smtp.aliyun-inc.com;
          Mon, 07 Nov 2022 14:26:26 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] lib: Fix some kernel-doc comments
Date:   Mon,  7 Nov 2022 14:26:23 +0800
Message-Id: <20221107062623.6709-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the description of @policy to @p in nla_policy_len()
to clear the below warnings:

lib/nlattr.c:660: warning: Function parameter or member 'p' not described in 'nla_policy_len'
lib/nlattr.c:660: warning: Excess function parameter 'policy' description in 'nla_policy_len'

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2736
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 lib/nlattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index b67a53e29b8f..9055e8b4d144 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -646,7 +646,7 @@ EXPORT_SYMBOL(__nla_validate);
 
 /**
  * nla_policy_len - Determine the max. length of a policy
- * @policy: policy to use
+ * @p: policy to use
  * @n: number of policies
  *
  * Determines the max. length of the policy.  It is currently used
-- 
2.20.1.7.g153144c

