Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E043E6E97A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfGSQpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:45:51 -0400
Received: from mail.us.es ([193.147.175.20]:49910 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731908AbfGSQpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6509BAEEF
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACDD5115116
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A098115105; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 654081150DA;
        Fri, 19 Jul 2019 18:45:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E46E940705C4;
        Fri, 19 Jul 2019 18:45:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/14] netfilter: Update obsolete comments referring to ip_conntrack
Date:   Fri, 19 Jul 2019 18:45:07 +0200
Message-Id: <20190719164517.29496-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>

In 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.") the new
generic nf_conntrack was introduced, and it came to supersede the old
ip_conntrack.

This change updates (some) of the obsolete comments referring to old
file/function names of the ip_conntrack mechanism, as well as removes a
few self-referencing comments that we shouldn't maintain anymore.

I did not update any comments referring to historical actions (e.g,
comments like "this file was derived from ..." were left untouched, even
if the referenced file is no longer here).

Signed-off-by: Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_h323_asn1.h | 3 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c               | 4 ++--
 net/netfilter/Kconfig                            | 6 ++----
 net/netfilter/nf_conntrack_core.c                | 4 +---
 net/netfilter/nf_conntrack_h323_asn1.c           | 5 ++---
 net/netfilter/nf_conntrack_proto_gre.c           | 2 --
 net/netfilter/nf_conntrack_proto_icmp.c          | 2 +-
 net/netfilter/nf_nat_core.c                      | 2 +-
 8 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index 91d6275292a5..19df78341fb3 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /****************************************************************************
- * ip_conntrack_h323_asn1.h - BER and PER decoding library for H.323
- * 			      conntrack/NAT module.
+ * BER and PER decoding library for H.323 conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  *
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 4d6bf7ac0792..6bdb1ab8af61 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -416,8 +416,8 @@ clusterip_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	     ctinfo == IP_CT_RELATED_REPLY))
 		return XT_CONTINUE;
 
-	/* ip_conntrack_icmp guarantees us that we only have ICMP_ECHO,
-	 * TIMESTAMP, INFO_REQUEST or ADDRESS type icmp packets from here
+	/* nf_conntrack_proto_icmp guarantees us that we only have ICMP_ECHO,
+	 * TIMESTAMP, INFO_REQUEST or ICMP_ADDRESS type icmp packets from here
 	 * on, which all have an ID field [relevant for hashing]. */
 
 	hash = clusterip_hashfn(skb, cipinfo->config);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32a45c03786e..0d65f4d39494 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -223,8 +223,6 @@ config NF_CONNTRACK_FTP
 	  of Network Address Translation on them.
 
 	  This is FTP support on Layer 3 independent connection tracking.
-	  Layer 3 independent connection tracking is experimental scheme
-	  which generalize ip_conntrack to support other layer 3 protocols.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -338,7 +336,7 @@ config NF_CONNTRACK_SIP
 	help
 	  SIP is an application-layer control protocol that can establish,
 	  modify, and terminate multimedia sessions (conferences) such as
-	  Internet telephony calls. With the ip_conntrack_sip and
+	  Internet telephony calls. With the nf_conntrack_sip and
 	  the nf_nat_sip modules you can support the protocol on a connection
 	  tracking/NATing firewall.
 
@@ -1313,7 +1311,7 @@ config NETFILTER_XT_MATCH_HELPER
 	depends on NETFILTER_ADVANCED
 	help
 	  Helper matching allows you to match packets in dynamic connections
-	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
+	  tracked by a conntrack-helper, ie. nf_conntrack_ftp
 
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index bdfeacee0817..a542761e90d1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1817,9 +1817,7 @@ EXPORT_SYMBOL_GPL(nf_ct_kill_acct);
 #include <linux/netfilter/nfnetlink_conntrack.h>
 #include <linux/mutex.h>
 
-/* Generic function for tcp/udp/sctp/dccp and alike. This needs to be
- * in ip_conntrack_core, since we don't want the protocols to autoload
- * or depend on ctnetlink */
+/* Generic function for tcp/udp/sctp/dccp and alike. */
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple)
 {
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 8f6ba8162f0b..573cb4481481 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -1,11 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_helper_h323_asn1.c - BER and PER decoding library for H.323
- * 			      	     conntrack/NAT module.
+ * BER and PER decoding library for H.323 conntrack/NAT module.
  *
  * Copyright (c) 2006 by Jing Min Zhao <zhaojingmin@users.sourceforge.net>
  *
- * See ip_conntrack_helper_h323_asn1.h for details.
+ * See nf_conntrack_helper_h323_asn1.h for details.
  */
 
 #ifdef __KERNEL__
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index c2eb365f1723..5b05487a60d2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ip_conntrack_proto_gre.c - Version 3.0
- *
  * Connection tracking protocol helper module for GRE.
  *
  * GRE is a generic encapsulation protocol, which is generally not very
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index dd53e2b20f6b..097deba7441a 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -215,7 +215,7 @@ int nf_conntrack_icmpv4_error(struct nf_conn *tmpl,
 		return -NF_ACCEPT;
 	}
 
-	/* See ip_conntrack_proto_tcp.c */
+	/* See nf_conntrack_proto_tcp.c */
 	if (state->net->ct.sysctl_checksum &&
 	    state->hook == NF_INET_PRE_ROUTING &&
 	    nf_ip_checksum(skb, state->hook, dataoff, IPPROTO_ICMP)) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 9ab410455992..3f6023ed4966 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -519,7 +519,7 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
  * and NF_INET_LOCAL_OUT, we change the destination to map into the
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
- * __ip_conntrack_confirm and drop the packet. */
+ * __nf_conntrack_confirm and drop the packet. */
 static void
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_tuple *orig_tuple,
-- 
2.11.0


