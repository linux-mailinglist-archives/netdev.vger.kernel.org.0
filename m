Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4614197C
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgARUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:52 -0500
Received: from correo.us.es ([193.147.175.20]:48410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728826AbgARUOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE8DC2EFEBA
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBE93DA713
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C1628DA70E; Sat, 18 Jan 2020 21:14:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C51DBDA710;
        Sat, 18 Jan 2020 21:14:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9F04D41E4801;
        Sat, 18 Jan 2020 21:14:28 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/21] netfilter: nf_tables: white-space fixes.
Date:   Sat, 18 Jan 2020 21:14:08 +0100
Message-Id: <20200118201417.334111-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Indentation fixes for the parameters of a few nft functions.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c    | 4 ++--
 net/netfilter/nft_set_bitmap.c | 4 ++--
 net/netfilter/nft_set_hash.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 10e9d50e4e19..e8ca1ec105f8 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -130,8 +130,8 @@ static int nft_bitwise_dump(struct sk_buff *skb, const struct nft_expr *expr)
 static struct nft_data zero;
 
 static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
-                               struct nft_flow_rule *flow,
-                               const struct nft_expr *expr)
+			       struct nft_flow_rule *flow,
+			       const struct nft_expr *expr)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 087a056e34d1..87e8d9ba0c9b 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -259,8 +259,8 @@ static u64 nft_bitmap_privsize(const struct nlattr * const nla[],
 }
 
 static int nft_bitmap_init(const struct nft_set *set,
-			 const struct nft_set_desc *desc,
-			 const struct nlattr * const nla[])
+			   const struct nft_set_desc *desc,
+			   const struct nlattr * const nla[])
 {
 	struct nft_bitmap *priv = nft_set_priv(set);
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index b331a3c9a3a8..d350a7cd3af0 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -645,7 +645,7 @@ static bool nft_hash_estimate(const struct nft_set_desc *desc, u32 features,
 }
 
 static bool nft_hash_fast_estimate(const struct nft_set_desc *desc, u32 features,
-			      struct nft_set_estimate *est)
+				   struct nft_set_estimate *est)
 {
 	if (!desc->size)
 		return false;
-- 
2.11.0

