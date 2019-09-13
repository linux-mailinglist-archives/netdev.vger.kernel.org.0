Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01173B1C51
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbfIMLbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:55 -0400
Received: from correo.us.es ([193.147.175.20]:42650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbfIMLbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 973C14FFE09
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E852A7E21
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DB37A7E1F; Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33C53A7E99;
        Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 03D904265A5A;
        Fri, 13 Sep 2019 13:31:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/27] netfilter: update include directives.
Date:   Fri, 13 Sep 2019 13:30:49 +0200
Message-Id: <20190913113102.15776-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Include some headers in files which require them, and remove others
which are not required.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h  |  3 ++-
 include/net/netfilter/nf_conntrack_zones.h |  3 ++-
 include/net/netfilter/nf_nat.h             | 13 ++++++-------
 include/net/netfilter/nf_nat_masquerade.h  |  1 +
 net/bridge/netfilter/nf_conntrack_bridge.c |  1 -
 net/ipv6/netfilter/nf_socket_ipv6.c        |  1 -
 net/netfilter/nf_conntrack_ecache.c        |  1 +
 net/netfilter/nf_conntrack_expect.c        |  2 ++
 net/netfilter/nf_conntrack_helper.c        |  5 +++--
 net/netfilter/nf_conntrack_timeout.c       |  1 +
 net/netfilter/nf_flow_table_core.c         |  1 +
 net/netfilter/nf_nat_core.c                |  6 +++---
 net/netfilter/nft_flow_offload.c           |  3 ++-
 net/netfilter/xt_connlimit.c               |  2 ++
 net/sched/act_ct.c                         |  2 +-
 15 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71a2d9cb64ea..d340886e012d 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -14,8 +14,9 @@
 #define _NF_CONNTRACK_CORE_H
 
 #include <linux/netfilter.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 
 /* This header is used to share core functionality between the
    standalone connection tracking module, and the compatibility layer's use
diff --git a/include/net/netfilter/nf_conntrack_zones.h b/include/net/netfilter/nf_conntrack_zones.h
index 52950baa3ab5..33b91d19cb7d 100644
--- a/include/net/netfilter/nf_conntrack_zones.h
+++ b/include/net/netfilter/nf_conntrack_zones.h
@@ -5,7 +5,8 @@
 #include <linux/netfilter/nf_conntrack_zones_common.h>
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-#include <net/netfilter/nf_conntrack_extend.h>
+
+#include <net/netfilter/nf_conntrack.h>
 
 static inline const struct nf_conntrack_zone *
 nf_ct_zone(const struct nf_conn *ct)
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index eec208fb9c23..eeb336809679 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -1,9 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_NAT_H
 #define _NF_NAT_H
+
+#include <linux/list.h>
 #include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_conntrack_pptp.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <uapi/linux/netfilter/nf_nat.h>
 
 enum nf_nat_manip_type {
 	NF_NAT_MANIP_SRC,
@@ -14,10 +19,6 @@ enum nf_nat_manip_type {
 #define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
 			     (hooknum) != NF_INET_LOCAL_IN)
 
-#include <linux/list.h>
-#include <linux/netfilter/nf_conntrack_pptp.h>
-#include <net/netfilter/nf_conntrack_extend.h>
-
 /* per conntrack: nat application helper private data */
 union nf_conntrack_nat_help {
 	/* insert nat helper private data here */
@@ -26,8 +27,6 @@ union nf_conntrack_nat_help {
 #endif
 };
 
-struct nf_conn;
-
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
diff --git a/include/net/netfilter/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
index 54a14d643c34..be7abc9d5f22 100644
--- a/include/net/netfilter/nf_nat_masquerade.h
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -2,6 +2,7 @@
 #ifndef _NF_NAT_MASQUERADE_H_
 #define _NF_NAT_MASQUERADE_H_
 
+#include <linux/skbuff.h>
 #include <net/netfilter/nf_nat.h>
 
 unsigned int
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 4f5444d2a526..c9ce321fcac1 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -17,7 +17,6 @@
 #include <net/netfilter/nf_conntrack_bridge.h>
 
 #include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_tables.h>
 
 #include "../br_private.h"
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index 437d95545c31..b9df879c48d3 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -12,7 +12,6 @@
 #include <net/sock.h>
 #include <net/inet_sock.h>
 #include <net/inet6_hashtables.h>
-#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
 #include <net/netfilter/nf_socket.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 5e2812ee2149..6fba74b5aaf7 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -24,6 +24,7 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 65364de915d1..42557d2b6a90 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -25,8 +25,10 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 8d729e7c36ff..118f415928ae 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -21,10 +21,11 @@
 #include <linux/rtnetlink.h>
 
 #include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_conntrack_l4proto.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_log.h>
 
 static DEFINE_MUTEX(nf_ct_helper_mutex);
diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 13d0f4a92647..14387e0b8008 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
 struct nf_ct_timeout *
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 80a8f9ae4c93..09310a1bd91f 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -11,6 +11,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 struct flow_offload_entry {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3f6023ed4966..bfc555fcbc72 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -18,12 +18,12 @@
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_nat_helper.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_zones.h>
-#include <linux/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_helper.h>
+#include <uapi/linux/netfilter/nf_nat.h>
 
 #include "nf_internals.h"
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 01705ad74a9a..22cf236eb5d5 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -6,12 +6,13 @@
 #include <linux/netfilter.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/ip.h> /* for ipv4 options. */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_conntrack_core.h>
-#include <linux/netfilter/nf_conntrack_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_flow_table.h>
 
 struct nft_flow_offload {
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index bc6c8ab0fa62..46fcac75f726 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -13,6 +13,8 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index cdd6f3818097..fcc46025e790 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -24,12 +24,12 @@
 #include <uapi/linux/tc_act/tc_ct.h>
 #include <net/tc_act/tc_ct.h>
 
-#include <linux/netfilter/nf_nat.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <uapi/linux/netfilter/nf_nat.h>
 
 static struct tc_action_ops act_ct_ops;
 static unsigned int ct_net_id;
-- 
2.11.0

