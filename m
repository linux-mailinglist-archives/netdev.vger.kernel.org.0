Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615A66B2C4A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCIRrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCIRrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:47:04 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEA03FB253;
        Thu,  9 Mar 2023 09:47:03 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/4] netfilter: nft_redir: correct value of inet type `.maxattrs`
Date:   Thu,  9 Mar 2023 18:46:55 +0100
Message-Id: <20230309174655.69816-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309174655.69816-1-pablo@netfilter.org>
References: <20230309174655.69816-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

`nft_redir_inet_type.maxattrs` was being set, presumably because of a
cut-and-paste error, to `NFTA_MASQ_MAX`, instead of `NFTA_REDIR_MAX`.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index dbc642f5d32a..67cec56bc84a 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -236,7 +236,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.30.2

