Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D35B1C55
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388122AbfIMLb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:58 -0400
Received: from correo.us.es ([193.147.175.20]:42600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388123AbfIMLbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EBD39DA717
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD925A7E19
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2977A7E11; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81EDC10219C;
        Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4E06E4265A5A;
        Fri, 13 Sep 2019 13:31:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/27] netfilter: fix coding-style errors.
Date:   Fri, 13 Sep 2019 13:30:46 +0200
Message-Id: <20190913113102.15776-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Several header-files, Kconfig files and Makefiles have trailing
white-space.  Remove it.

In netfilter/Kconfig, indent the type of CONFIG_NETFILTER_NETLINK_ACCT
correctly.

There are semicolons at the end of two function definitions in
include/net/netfilter/nf_conntrack_acct.h and
include/net/netfilter/nf_conntrack_ecache.h. Remove them.

Fix indentation in nf_conntrack_l4proto.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h           |  2 +-
 include/linux/netfilter_ipv6.h               |  2 +-
 include/net/netfilter/nf_conntrack_acct.h    |  2 +-
 include/net/netfilter/nf_conntrack_ecache.h  |  2 +-
 include/net/netfilter/nf_conntrack_expect.h  |  2 +-
 include/net/netfilter/nf_conntrack_l4proto.h | 14 +++++++-------
 include/net/netfilter/nf_conntrack_tuple.h   |  2 +-
 net/ipv4/netfilter/Kconfig                   |  8 ++++----
 net/ipv4/netfilter/Makefile                  |  2 +-
 net/netfilter/Kconfig                        |  8 ++++----
 net/netfilter/Makefile                       |  2 +-
 11 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index ae62bf1c6824..b9bc25f57c8e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -340,7 +340,7 @@ void xt_free_table_info(struct xt_table_info *info);
 
 /**
  * xt_recseq - recursive seqcount for netfilter use
- * 
+ *
  * Packet processing changes the seqcount only if no recursion happened
  * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
  * because we use the normal seqcount convention :
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 7beb681e1ce5..a889e376d197 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -1,7 +1,7 @@
 /* IPv6-specific defines for netfilter. 
  * (C)1998 Rusty Russell -- This code is GPL.
  * (C)1999 David Jeffery
- *   this header was blatantly ripped from netfilter_ipv4.h 
+ *   this header was blatantly ripped from netfilter_ipv4.h
  *   it's amazing what adding a bunch of 6s can do =8^)
  */
 #ifndef __LINUX_IP6_NETFILTER_H
diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index ad9f2172dee1..5b5287bb49db 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -45,7 +45,7 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 #else
 	return NULL;
 #endif
-};
+}
 
 /* Check if connection tracking accounting is enabled */
 static inline bool nf_ct_acct_enabled(struct net *net)
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 52b44192b43f..0815bfadfefe 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -61,7 +61,7 @@ nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
 #else
 	return NULL;
 #endif
-};
+}
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 /* This structure is passed to event handler */
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 573429be4d59..0855b60fba17 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -126,7 +126,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
-int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
+int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 				u32 portid, int report, unsigned int flags);
 static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 				       unsigned int flags)
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index c200b95d27ae..97240f1a3f5f 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -181,41 +181,41 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static inline struct nf_generic_net *nf_generic_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.generic;
+	return &net->ct.nf_ct_proto.generic;
 }
 
 static inline struct nf_tcp_net *nf_tcp_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.tcp;
+	return &net->ct.nf_ct_proto.tcp;
 }
 
 static inline struct nf_udp_net *nf_udp_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.udp;
+	return &net->ct.nf_ct_proto.udp;
 }
 
 static inline struct nf_icmp_net *nf_icmp_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.icmp;
+	return &net->ct.nf_ct_proto.icmp;
 }
 
 static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.icmpv6;
+	return &net->ct.nf_ct_proto.icmpv6;
 }
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 static inline struct nf_dccp_net *nf_dccp_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.dccp;
+	return &net->ct.nf_ct_proto.dccp;
 }
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 static inline struct nf_sctp_net *nf_sctp_pernet(struct net *net)
 {
-       return &net->ct.nf_ct_proto.sctp;
+	return &net->ct.nf_ct_proto.sctp;
 }
 #endif
 
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 480c87b44a96..68ea9b932736 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -124,7 +124,7 @@ struct nf_conntrack_tuple_hash {
 #if IS_ENABLED(CONFIG_NETFILTER)
 static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
-{ 
+{
 	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
 		t1->src.u.all == t2->src.u.all &&
 		t1->src.l3num == t2->src.l3num);
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 69e76d677f9e..f17b402111ce 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -272,7 +272,7 @@ config IP_NF_TARGET_CLUSTERIP
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
 	  router/server/switch.
-	
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_ECN
@@ -281,7 +281,7 @@ config IP_NF_TARGET_ECN
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a `ECN' target, which can be used in the iptables mangle
-	  table.  
+	  table.
 
 	  You can use this target to remove the ECN bits from the IPv4 header of
 	  an IP packet.  This is particularly useful, if you need to work around
@@ -306,7 +306,7 @@ config IP_NF_RAW
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
 	  and OUTPUT chains.
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.rst>.  If unsure, say `N'.
 
@@ -318,7 +318,7 @@ config IP_NF_SECURITY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
-	 
+
 	  If unsure, say N.
 
 endif # IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index c50e0ec095d2..7c497c78105f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 # flow table support
 obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
 
-# generic IP tables 
+# generic IP tables
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
 # the three instances of ip_tables
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0d65f4d39494..34ec7afec116 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -20,7 +20,7 @@ config NETFILTER_FAMILY_ARP
 	bool
 
 config NETFILTER_NETLINK_ACCT
-tristate "Netfilter NFACCT over NFNETLINK interface"
+	tristate "Netfilter NFACCT over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_NETLINK
 	help
@@ -34,7 +34,7 @@ config NETFILTER_NETLINK_QUEUE
 	help
 	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
-	  
+
 config NETFILTER_NETLINK_LOG
 	tristate "Netfilter LOG over NFNETLINK interface"
 	default m if NETFILTER_ADVANCED=n
@@ -1502,7 +1502,7 @@ config NETFILTER_XT_MATCH_REALM
 	  This option adds a `realm' match, which allows you to use the realm
 	  key from the routing subsystem inside iptables.
 
-	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option 
+	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option
 	  in tc world.
 
 	  If you want to compile it as a module, say M here and read
@@ -1523,7 +1523,7 @@ config NETFILTER_XT_MATCH_SCTP
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
-	  With this option enabled, you will be able to use the 
+	  With this option enabled, you will be able to use the
 	  `sctp' match in order to match on SCTP source/destination ports
 	  and SCTP chunk types.
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9270a7fae484..4fc075b612fe 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -124,7 +124,7 @@ nf_flow_table-objs := nf_flow_table_core.o nf_flow_table_ip.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
-# generic X tables 
+# generic X tables
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
 # combos
-- 
2.11.0

