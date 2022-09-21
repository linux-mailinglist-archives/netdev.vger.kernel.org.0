Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1445BFBB9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiIUJxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiIUJw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:52:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB7A2F669;
        Wed, 21 Sep 2022 02:50:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oawN9-0006Ql-7W; Wed, 21 Sep 2022 11:50:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/4] netfilter: rpfilter: Remove unused variable 'ret'.
Date:   Wed, 21 Sep 2022 11:50:00 +0200
Message-Id: <20220921095000.29569-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921095000.29569-1-fw@strlen.de>
References: <20220921095000.29569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

Commit 91a178258aea ("netfilter: rpfilter: Convert
rpfilter_lookup_reverse to new dev helper") removed the need for the
'ret' variable. This went unnoticed because of the __maybe_unused
annotation.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8cd3224d913e..8183bbcabb4a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -33,7 +33,6 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 				const struct net_device *dev, u8 flags)
 {
 	struct fib_result res;
-	int ret __maybe_unused;
 
 	if (fib_lookup(net, fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return false;
-- 
2.35.1

