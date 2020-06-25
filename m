Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2E20A4F4
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404183AbgFYS1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:27:02 -0400
Received: from correo.us.es ([193.147.175.20]:33490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406169AbgFYS0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C76F4FC5F2
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2BE7DA844
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4F2ADA793; Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D367EDA844;
        Thu, 25 Jun 2020 20:26:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A585F42EE38F;
        Thu, 25 Jun 2020 20:26:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/7] netfilter: Add MODULE_DESCRIPTION entries to kernel modules
Date:   Thu, 25 Jun 2020 20:26:30 +0200
Message-Id: <20200625182635.1958-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200625182635.1958-1-pablo@netfilter.org>
References: <20200625182635.1958-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rob Gill <rrobgill@protonmail.com>

The user tool modinfo is used to get information on kernel modules, including a
description where it is available.

This patch adds a brief MODULE_DESCRIPTION to netfilter kernel modules
(descriptions taken from Kconfig file or code comments)

Signed-off-by: Rob Gill <rrobgill@protonmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c   | 1 +
 net/bridge/netfilter/nft_reject_bridge.c | 1 +
 net/ipv4/netfilter/ipt_SYNPROXY.c        | 1 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c  | 1 +
 net/ipv4/netfilter/nft_dup_ipv4.c        | 1 +
 net/ipv4/netfilter/nft_fib_ipv4.c        | 1 +
 net/ipv4/netfilter/nft_reject_ipv4.c     | 1 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c       | 1 +
 net/ipv6/netfilter/nf_flow_table_ipv6.c  | 1 +
 net/ipv6/netfilter/nft_dup_ipv6.c        | 1 +
 net/ipv6/netfilter/nft_fib_ipv6.c        | 1 +
 net/ipv6/netfilter/nft_reject_ipv6.c     | 1 +
 net/netfilter/nf_dup_netdev.c            | 1 +
 net/netfilter/nf_flow_table_core.c       | 1 +
 net/netfilter/nf_flow_table_inet.c       | 1 +
 net/netfilter/nf_synproxy_core.c         | 1 +
 net/netfilter/nfnetlink.c                | 1 +
 net/netfilter/nft_compat.c               | 1 +
 net/netfilter/nft_connlimit.c            | 1 +
 net/netfilter/nft_counter.c              | 1 +
 net/netfilter/nft_ct.c                   | 1 +
 net/netfilter/nft_dup_netdev.c           | 1 +
 net/netfilter/nft_fib_inet.c             | 1 +
 net/netfilter/nft_fib_netdev.c           | 1 +
 net/netfilter/nft_flow_offload.c         | 1 +
 net/netfilter/nft_hash.c                 | 1 +
 net/netfilter/nft_limit.c                | 1 +
 net/netfilter/nft_log.c                  | 1 +
 net/netfilter/nft_masq.c                 | 1 +
 net/netfilter/nft_nat.c                  | 1 +
 net/netfilter/nft_numgen.c               | 1 +
 net/netfilter/nft_objref.c               | 1 +
 net/netfilter/nft_osf.c                  | 1 +
 net/netfilter/nft_queue.c                | 1 +
 net/netfilter/nft_quota.c                | 1 +
 net/netfilter/nft_redir.c                | 1 +
 net/netfilter/nft_reject.c               | 1 +
 net/netfilter/nft_reject_inet.c          | 1 +
 net/netfilter/nft_synproxy.c             | 1 +
 net/netfilter/nft_tunnel.c               | 1 +
 net/netfilter/xt_nat.c                   | 1 +
 41 files changed, 41 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 7c9e92b2f806..8e8ffac037cd 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -155,3 +155,4 @@ module_exit(nft_meta_bridge_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "meta");
+MODULE_DESCRIPTION("Support for bridge dedicated meta key");
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index f48cf4cfb80f..deae2c9a0f69 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -455,3 +455,4 @@ module_exit(nft_reject_bridge_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_BRIDGE, "reject");
+MODULE_DESCRIPTION("Reject packets from bridge via nftables");
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 748dc3ce58d3..f2984c7eef40 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -118,3 +118,4 @@ module_exit(synproxy_tg4_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Intercept TCP connections and establish them using syncookies");
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index e32e41b99f0f..aba65fe90345 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -34,3 +34,4 @@ module_exit(nf_flow_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
+MODULE_DESCRIPTION("Netfilter flow table support");
diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index abf89b972094..bcdb37f86a94 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -107,3 +107,4 @@ module_exit(nft_dup_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "dup");
+MODULE_DESCRIPTION("IPv4 nftables packet duplication support");
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index ce294113dbcd..03df986217b7 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -210,3 +210,4 @@ module_exit(nft_fib4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(2, "fib");
+MODULE_DESCRIPTION("nftables fib / ip route lookup support");
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 7e6fd5cde50f..e408f813f5d8 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -71,3 +71,4 @@ module_exit(nft_reject_ipv4_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "reject");
+MODULE_DESCRIPTION("IPv4 packet rejection for nftables");
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index fd1f52a21bf1..d51d0c3e5fe9 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -121,3 +121,4 @@ module_exit(synproxy_tg6_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Intercept IPv6 TCP connections and establish them using syncookies");
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index a8566ee12e83..667b8af2546a 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -35,3 +35,4 @@ module_exit(nf_flow_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
+MODULE_DESCRIPTION("Netfilter flow table IPv6 module");
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 2af32200507d..8b5193efb1f1 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -105,3 +105,4 @@ module_exit(nft_dup_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "dup");
+MODULE_DESCRIPTION("IPv6 nftables packet duplication support");
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 7ece86afd079..e204163c7036 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -255,3 +255,4 @@ module_exit(nft_fib6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(10, "fib");
+MODULE_DESCRIPTION("nftables fib / ipv6 route lookup support");
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 680a28ce29fd..c1098a1968e1 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -72,3 +72,4 @@ module_exit(nft_reject_ipv6_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "reject");
+MODULE_DESCRIPTION("IPv6 packet rejection for nftables");
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index f108a76925dd..2b01a151eaa8 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -73,3 +73,4 @@ EXPORT_SYMBOL_GPL(nft_fwd_dup_netdev_offload);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Netfilter packet duplication support");
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index afa85171df38..b1eb5272b379 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -594,3 +594,4 @@ module_exit(nf_flow_table_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_DESCRIPTION("Netfilter flow table module");
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 88bedf1ff1ae..bc4126d8ef65 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -72,3 +72,4 @@ module_exit(nf_flow_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
+MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index b9cbe1e2453e..ebcdc8e54476 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -1237,3 +1237,4 @@ EXPORT_SYMBOL_GPL(nf_synproxy_ipv6_fini);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("nftables SYNPROXY expression support");
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 99127e2d95a8..5f24edf95830 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -33,6 +33,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NETFILTER);
+MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 
 #define nfnl_dereference_protected(id) \
 	rcu_dereference_protected(table[(id)].subsys, \
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f9adca62ccb3..aa1a066cb74b 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -902,3 +902,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("match");
 MODULE_ALIAS_NFT_EXPR("target");
+MODULE_DESCRIPTION("x_tables over nftables support");
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 69d6173f91e2..7d0761fad37e 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -280,3 +280,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso");
 MODULE_ALIAS_NFT_EXPR("connlimit");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CONNLIMIT);
+MODULE_DESCRIPTION("nftables connlimit rule support");
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f6d4d0fa23a6..85ed461ec24e 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -303,3 +303,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("counter");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_COUNTER);
+MODULE_DESCRIPTION("nftables counter rule support");
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index faea72c2df32..77258af1fce0 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1345,3 +1345,4 @@ MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_EXPECT);
+MODULE_DESCRIPTION("Netfilter nf_tables conntrack module");
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index c2e78c160fd7..40788b3f1071 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -102,3 +102,4 @@ module_exit(nft_dup_netdev_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_AF_EXPR(5, "dup");
+MODULE_DESCRIPTION("nftables netdev packet duplication support");
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index 465432e0531b..a88d44e163d1 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -76,3 +76,4 @@ module_exit(nft_fib_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
 MODULE_ALIAS_NFT_AF_EXPR(1, "fib");
+MODULE_DESCRIPTION("nftables fib inet support");
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index a2e726ae7f07..3f3478abd845 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -85,3 +85,4 @@ module_exit(nft_fib_netdev_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo M. Bermudo Garay <pablombg@gmail.com>");
 MODULE_ALIAS_NFT_AF_EXPR(5, "fib");
+MODULE_DESCRIPTION("nftables netdev fib lookups support");
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index b70b48996801..3b9b97aa4b32 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -286,3 +286,4 @@ module_exit(nft_flow_offload_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("flow_offload");
+MODULE_DESCRIPTION("nftables hardware flow offload module");
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index b836d550b919..96371d878e7e 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -248,3 +248,4 @@ module_exit(nft_hash_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
 MODULE_ALIAS_NFT_EXPR("hash");
+MODULE_DESCRIPTION("Netfilter nftables hash module");
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 35b67d7e3694..0e2c315c3b5e 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -372,3 +372,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("limit");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_LIMIT);
+MODULE_DESCRIPTION("nftables limit expression support");
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index fe4831f2258f..57899454a530 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -298,3 +298,4 @@ module_exit(nft_log_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("log");
+MODULE_DESCRIPTION("Netfilter nf_tables log module");
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index bc9fd98c5d6d..71390b727040 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -305,3 +305,4 @@ module_exit(nft_masq_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_EXPR("masq");
+MODULE_DESCRIPTION("Netfilter nftables masquerade expression support");
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 23a7bfd10521..4bcf33b049c4 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -402,3 +402,4 @@ module_exit(nft_nat_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
 MODULE_ALIAS_NFT_EXPR("nat");
+MODULE_DESCRIPTION("Network Address Translation support");
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 48edb9d5f012..f1fc824f9737 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -217,3 +217,4 @@ module_exit(nft_ng_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Laura Garcia <nevola@gmail.com>");
 MODULE_ALIAS_NFT_EXPR("numgen");
+MODULE_DESCRIPTION("nftables number generator module");
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bfd18d2b65a2..5f9207a9f485 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -252,3 +252,4 @@ module_exit(nft_objref_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("objref");
+MODULE_DESCRIPTION("nftables stateful object reference module");
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index b42247aa48a9..c261d57a666a 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -149,3 +149,4 @@ module_exit(nft_osf_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
 MODULE_ALIAS_NFT_EXPR("osf");
+MODULE_DESCRIPTION("nftables passive OS fingerprint support");
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 5ece0a6aa8c3..23265d757acb 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -216,3 +216,4 @@ module_exit(nft_queue_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Eric Leblond <eric@regit.org>");
 MODULE_ALIAS_NFT_EXPR("queue");
+MODULE_DESCRIPTION("Netfilter nftables queue module");
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 4413690591f2..0363f533a42b 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -254,3 +254,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("quota");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_QUOTA);
+MODULE_DESCRIPTION("Netfilter nftables quota module");
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 5b779171565c..2056051c0af0 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -292,3 +292,4 @@ module_exit(nft_redir_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_EXPR("redir");
+MODULE_DESCRIPTION("Netfilter nftables redirect support");
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 00f865fb80ca..86eafbb0fdd0 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -119,3 +119,4 @@ EXPORT_SYMBOL_GPL(nft_reject_icmpv6_code);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Netfilter x_tables over nftables module");
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index f41f414b72d1..cf8f2646e93c 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -149,3 +149,4 @@ module_exit(nft_reject_inet_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_AF_EXPR(1, "reject");
+MODULE_DESCRIPTION("Netfilter nftables reject inet support");
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index e2c1fc608841..4fda8b3f1762 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -388,3 +388,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
 MODULE_ALIAS_NFT_EXPR("synproxy");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_SYNPROXY);
+MODULE_DESCRIPTION("nftables SYNPROXY expression support");
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 30be5787fbde..d3eb953d0333 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -719,3 +719,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NFT_EXPR("tunnel");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_TUNNEL);
+MODULE_DESCRIPTION("nftables tunnel expression support");
diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index a8e5f6c8db7a..b4f7bbc3f3ca 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -244,3 +244,4 @@ MODULE_ALIAS("ipt_SNAT");
 MODULE_ALIAS("ipt_DNAT");
 MODULE_ALIAS("ip6t_SNAT");
 MODULE_ALIAS("ip6t_DNAT");
+MODULE_DESCRIPTION("SNAT and DNAT targets support");
-- 
2.20.1

