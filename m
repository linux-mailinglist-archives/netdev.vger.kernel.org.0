Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A786B618F50
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiKDDzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKDDzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:55:46 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D874E1CFCF;
        Thu,  3 Nov 2022 20:55:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VTvE7XQ_1667534137;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VTvE7XQ_1667534137)
          by smtp.aliyun-inc.com;
          Fri, 04 Nov 2022 11:55:41 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] netfilter: rpfilter/fib: clean up some inconsistent indenting
Date:   Fri,  4 Nov 2022 11:55:04 +0800
Message-Id: <20221104035504.14957-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional modification involved.

net/ipv4/netfilter/nft_fib_ipv4.c:141 nft_fib4_eval() warn: inconsistent indenting.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2733
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index fc65d69f23e1..9eee535c64dd 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -138,12 +138,11 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		break;
 	}
 
-       if (!oif) {
-               found = FIB_RES_DEV(res);
+	if (!oif) {
+		found = FIB_RES_DEV(res);
 	} else {
 		if (!fib_info_nh_uses_dev(res.fi, oif))
 			return;
-
 		found = oif;
 	}
 
-- 
2.20.1.7.g153144c

