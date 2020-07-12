Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8C221CC16
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 01:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGLXQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 19:16:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728411AbgGLXPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 19:15:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1julBt-004mPW-TT; Mon, 13 Jul 2020 01:15:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 10/20] net: netfilter: kerneldoc fixes
Date:   Mon, 13 Jul 2020 01:15:06 +0200
Message-Id: <20200712231516.1139335-11-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200712231516.1139335-1-andrew@lunn.ch>
References: <20200712231516.1139335-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simple fixes which require no deep knowledge of the code.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 net/netfilter/nf_tables_api.c     | 8 ++++----
 net/netfilter/nft_set_pipapo.c    | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 79cd9dde457b..cb83a1f8badd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1006,7 +1006,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
  *
  * @skb: skb that causes the clash
  * @h: tuplehash of the clashing entry already in table
- * @hash_reply: hash slot for reply direction
+ * @reply_hash: hash slot for reply direction
  *
  * A conntrack entry can be inserted to the connection tracking table
  * if there is no existing entry with an identical tuple.
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f96785586f64..6708a4f2eec8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2375,7 +2375,7 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
 
 /**
  *	nft_register_expr - register nf_tables expr type
- *	@ops: expr type
+ *	@type: expr type
  *
  *	Registers the expr type for use with nf_tables. Returns zero on
  *	success or a negative errno code otherwise.
@@ -2394,7 +2394,7 @@ EXPORT_SYMBOL_GPL(nft_register_expr);
 
 /**
  *	nft_unregister_expr - unregister nf_tables expr type
- *	@ops: expr type
+ *	@type: expr type
  *
  * 	Unregisters the expr typefor use with nf_tables.
  */
@@ -5595,7 +5595,7 @@ struct nft_set_gc_batch *nft_set_gc_batch_alloc(const struct nft_set *set,
 
 /**
  *	nft_register_obj- register nf_tables stateful object type
- *	@obj: object type
+ *	@obj_type: object type
  *
  *	Registers the object type for use with nf_tables. Returns zero on
  *	success or a negative errno code otherwise.
@@ -5614,7 +5614,7 @@ EXPORT_SYMBOL_GPL(nft_register_obj);
 
 /**
  *	nft_unregister_obj - unregister nf_tables object type
- *	@obj: object type
+ *	@obj_type: object type
  *
  * 	Unregisters the object type for use with nf_tables.
  */
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 313de1d73168..cc6082a5f7ad 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -401,7 +401,7 @@ int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *dst,
  * nft_pipapo_lookup() - Lookup function
  * @net:	Network namespace
  * @set:	nftables API set representation
- * @elem:	nftables API element representation containing key data
+ * @key:	nftables API element representation containing key data
  * @ext:	nftables API extension pointer, filled with matching reference
  *
  * For more details, see DOC: Theory of Operation.
@@ -1075,7 +1075,7 @@ static int pipapo_expand(struct nft_pipapo_field *f,
  * @m:		Matching data, including mapping table
  * @map:	Table of rule maps: array of first rule and amount of rules
  *		in next field a given rule maps to, for each field
- * @ext:	For last field, nft_set_ext pointer matching rules map to
+ * @e:		For last field, nft_set_ext pointer matching rules map to
  */
 static void pipapo_map(struct nft_pipapo_match *m,
 		       union nft_pipapo_map_bucket map[NFT_PIPAPO_MAX_FIELDS],
@@ -1099,7 +1099,7 @@ static void pipapo_map(struct nft_pipapo_match *m,
 /**
  * pipapo_realloc_scratch() - Reallocate scratch maps for partial match results
  * @clone:	Copy of matching data with pending insertions and deletions
- * @bsize_max	Maximum bucket size, scratch maps cover two buckets
+ * @bsize_max:	Maximum bucket size, scratch maps cover two buckets
  *
  * Return: 0 on success, -ENOMEM on failure.
  */
@@ -1447,7 +1447,7 @@ static void pipapo_unmap(union nft_pipapo_map_bucket *mt, int rules,
 /**
  * pipapo_drop() - Delete entry from lookup and mapping tables, given rule map
  * @m:		Matching data
- * @rulemap	Table of rule maps, arrays of first rule and amount of rules
+ * @rulemap:	Table of rule maps, arrays of first rule and amount of rules
  *		in next field a given entry maps to, for each field
  *
  * For each rule in lookup table buckets mapping to this set of rules, drop
-- 
2.27.0.rc2

