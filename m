Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78752629518
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbiKOJ7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238167AbiKOJ7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:59:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74066FD3E;
        Tue, 15 Nov 2022 01:59:28 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 5/6] netfilter: rpfilter/fib: clean up some inconsistent indenting
Date:   Tue, 15 Nov 2022 10:59:21 +0100
Message-Id: <20221115095922.139954-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221115095922.139954-1-pablo@netfilter.org>
References: <20221115095922.139954-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

net/ipv4/netfilter/nft_fib_ipv4.c:141 nft_fib4_eval() warn: inconsistent indenting.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2733
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

