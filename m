Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773C784E72
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388179AbfHGORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:18 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45996 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729808AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jpH5z7UM6bjd5bxctaGXKEKzzODwIonhJhRhKCx8otE=; b=tS23KI77UZD0SLy7yFMqVs+V/z
        2i8Ixi6p8XXxyvy/RtMBYUK6XrQSGVSP218TM/fScCoLnpqu3P6v0y81Ky80YmjOOrQb1fE4Bwb85
        TKLDQPMdz+eCgNuuyqcszIsRmiR2Z/RL2hcdbDfEbaEcwEK9vArVui7cBLfKyoE0N1/yuNtZyYA2J
        +xVO7+hRRTDBd0ACtkAL3TGKoM7R//Hs7eVjHGBtvAeLJ3uDyEkK+mRdTymsXmqUYieEzzHlzBlds
        XAYgjrVdKhbmX5D9lzYrDI30W4Xym+NPb0aU6UPREaEuQar5L9gZpTuxd0RIEI3iGWHkzc7y3azlH
        CcZMIhcg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-Dt; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 2/8] netfilter: added missing includes to a number of header-files.
Date:   Wed,  7 Aug 2019 15:16:59 +0100
Message-Id: <20190807141705.4864-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of netfilter header-files used declarations and definitions
from other headers without including them.  Added include directives to
make those declarations and definitions available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set_getport.h   | 4 ++++
 include/linux/netfilter/nf_conntrack_amanda.h    | 4 ++++
 include/linux/netfilter/nf_conntrack_ftp.h       | 8 +++++---
 include/linux/netfilter/nf_conntrack_h323.h      | 7 +++++--
 include/linux/netfilter/nf_conntrack_h323_asn1.h | 2 ++
 include/linux/netfilter/nf_conntrack_irc.h       | 4 ++++
 include/linux/netfilter/nf_conntrack_pptp.h      | 9 +++++----
 include/linux/netfilter/nf_conntrack_sip.h       | 4 ++--
 include/linux/netfilter/nf_conntrack_snmp.h      | 3 +++
 include/linux/netfilter/nf_conntrack_tftp.h      | 5 +++++
 include/net/netfilter/br_netfilter.h             | 2 ++
 include/net/netfilter/ipv4/nf_dup_ipv4.h         | 3 +++
 include/net/netfilter/ipv6/nf_defrag_ipv6.h      | 4 +++-
 include/net/netfilter/ipv6/nf_dup_ipv6.h         | 2 ++
 include/net/netfilter/nf_conntrack_bridge.h      | 4 ++++
 include/net/netfilter/nf_conntrack_count.h       | 3 +++
 include/net/netfilter/nf_dup_netdev.h            | 2 ++
 include/net/netfilter/nf_flow_table.h            | 1 +
 include/net/netfilter/nf_nat_helper.h            | 4 ++--
 include/net/netfilter/nf_nat_redirect.h          | 3 +++
 include/net/netfilter/nf_queue.h                 | 2 ++
 include/net/netfilter/nf_reject.h                | 3 +++
 include/net/netfilter/nf_tables_ipv6.h           | 1 +
 include/net/netfilter/nft_fib.h                  | 2 ++
 include/net/netfilter/nft_meta.h                 | 2 ++
 include/net/netfilter/nft_reject.h               | 5 +++++
 include/uapi/linux/netfilter/xt_policy.h         | 1 +
 27 files changed, 80 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index ac6a11d38a19..a906df06948b 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -2,6 +2,10 @@
 #ifndef _IP_SET_GETPORT_H
 #define _IP_SET_GETPORT_H
 
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <uapi/linux/in.h>
+
 extern bool ip_set_get_ip4_port(const struct sk_buff *skb, bool src,
 				__be16 *port, u8 *proto);
 
diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 34345e543ba2..6f0ac896fcc9 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -3,6 +3,10 @@
 #define _NF_CONNTRACK_AMANDA_H
 /* AMANDA tracking. */
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
 extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
 					  enum ip_conntrack_info ctinfo,
 					  unsigned int protoff,
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 73a296dfd019..0e38302820b9 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -2,8 +2,12 @@
 #ifndef _NF_CONNTRACK_FTP_H
 #define _NF_CONNTRACK_FTP_H
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <uapi/linux/netfilter/nf_conntrack_ftp.h>
-
+#include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define FTP_PORT	21
 
@@ -20,8 +24,6 @@ struct nf_ct_ftp_master {
 	u_int16_t flags[IP_CT_DIR_MAX];
 };
 
-struct nf_conntrack_expect;
-
 /* For NAT to hook in when we find a packet which describes what other
  * connection we should expect. */
 extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index f76ed373a2a5..96dfa886f8c0 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -4,7 +4,12 @@
 
 #ifdef __KERNEL__
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
 #include <linux/netfilter/nf_conntrack_h323_asn1.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define RAS_PORT 1719
 #define Q931_PORT 1720
@@ -28,8 +33,6 @@ struct nf_ct_h323_master {
 	};
 };
 
-struct nf_conn;
-
 int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 		  TransportAddress *taddr, union nf_inet_addr *addr,
 		  __be16 *port);
diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index 19df78341fb3..bd6797f823b2 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -37,6 +37,8 @@
 /*****************************************************************************
  * H.323 Types
  ****************************************************************************/
+
+#include <linux/types.h>
 #include <linux/netfilter/nf_conntrack_h323_types.h>
 
 typedef struct {
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index 00c2b74206e1..f75e005db969 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -4,6 +4,10 @@
 
 #ifdef __KERNEL__
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
 #define IRC_PORT	6667
 
 extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 833a5b2255ea..3f10e806f0dc 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -3,7 +3,12 @@
 #ifndef _NF_CONNTRACK_PPTP_H
 #define _NF_CONNTRACK_PPTP_H
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
 #include <linux/netfilter/nf_conntrack_common.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+#include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
 extern const char *const pptp_msg_name[];
 
@@ -297,10 +302,6 @@ union pptp_ctrl_union {
 	struct PptpSetLinkInfo		setlink;
 };
 
-/* crap needed for nf_conntrack_compat.h */
-struct nf_conn;
-struct nf_conntrack_expect;
-
 extern int
 (*nf_nat_pptp_hook_outbound)(struct sk_buff *skb,
 			     struct nf_conn *ct, enum ip_conntrack_info ctinfo,
diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index c7fc38807a33..f6437f7841af 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -3,9 +3,9 @@
 #define __NF_CONNTRACK_SIP_H__
 #ifdef __KERNEL__
 
-#include <net/netfilter/nf_conntrack_expect.h>
-
+#include <linux/skbuff.h>
 #include <linux/types.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
diff --git a/include/linux/netfilter/nf_conntrack_snmp.h b/include/linux/netfilter/nf_conntrack_snmp.h
index 818088c47475..87e4f33eb55f 100644
--- a/include/linux/netfilter/nf_conntrack_snmp.h
+++ b/include/linux/netfilter/nf_conntrack_snmp.h
@@ -2,6 +2,9 @@
 #ifndef _NF_CONNTRACK_SNMP_H
 #define _NF_CONNTRACK_SNMP_H
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+
 extern int (*nf_nat_snmp_hook)(struct sk_buff *skb,
 				unsigned int protoff,
 				struct nf_conn *ct,
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index 5769e12dd0a2..dc4c1b9beac0 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -4,6 +4,11 @@
 
 #define TFTP_PORT 69
 
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/netfilter/nf_conntrack_expect.h>
+
 struct tftphdr {
 	__be16 opcode;
 };
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 302fcd3aade2..ca121ed906df 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -2,6 +2,8 @@
 #ifndef _BR_NETFILTER_H_
 #define _BR_NETFILTER_H_
 
+#include <linux/netfilter.h>
+
 #include "../../../net/bridge/br_private.h"
 
 static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
diff --git a/include/net/netfilter/ipv4/nf_dup_ipv4.h b/include/net/netfilter/ipv4/nf_dup_ipv4.h
index c962e0be3549..a2bc16cdbcd3 100644
--- a/include/net/netfilter/ipv4/nf_dup_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_dup_ipv4.h
@@ -2,6 +2,9 @@
 #ifndef _NF_DUP_IPV4_H_
 #define _NF_DUP_IPV4_H_
 
+#include <linux/skbuff.h>
+#include <uapi/linux/in.h>
+
 void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in_addr *gw, int oif);
 
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index 9d7e28736da9..6d31cd041143 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -2,7 +2,9 @@
 #ifndef _NF_DEFRAG_IPV6_H
 #define _NF_DEFRAG_IPV6_H
 
-struct net;
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
 int nf_defrag_ipv6_enable(struct net *);
 
 int nf_ct_frag6_init(void);
diff --git a/include/net/netfilter/ipv6/nf_dup_ipv6.h b/include/net/netfilter/ipv6/nf_dup_ipv6.h
index caf0c2dd8ee7..f6312bb04a13 100644
--- a/include/net/netfilter/ipv6/nf_dup_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_dup_ipv6.h
@@ -2,6 +2,8 @@
 #ifndef _NF_DUP_IPV6_H_
 #define _NF_DUP_IPV6_H_
 
+#include <linux/skbuff.h>
+
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif);
 
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 9a5514d5bc51..8f2e5b2ab523 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -1,6 +1,10 @@
 #ifndef NF_CONNTRACK_BRIDGE_
 #define NF_CONNTRACK_BRIDGE_
 
+#include <linux/module.h>
+#include <linux/types.h>
+#include <uapi/linux/if_ether.h>
+
 struct nf_ct_bridge_info {
 	struct nf_hook_ops	*ops;
 	unsigned int		ops_size;
diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index f32fc8289473..9645b47fa7e4 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -2,6 +2,9 @@
 #define _NF_CONNTRACK_COUNT_H
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 struct nf_conncount_data;
 
diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 2a6f6dcad3d9..181672672160 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -2,6 +2,8 @@
 #ifndef _NF_DUP_NETDEV_H_
 #define _NF_DUP_NETDEV_H_
 
+#include <net/netfilter/nf_tables.h>
+
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d8c187936bec..7249e331bd0b 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/rhashtable-types.h>
 #include <linux/rcupdate.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/dst.h>
 
diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index 97d7033e93a4..efae84646353 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -3,9 +3,9 @@
 #define _NF_NAT_HELPER_H
 /* NAT protocol helper routines. */
 
+#include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack.h>
-
-struct sk_buff;
+#include <net/netfilter/nf_conntrack_expect.h>
 
 /* These return true or false. */
 bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/include/net/netfilter/nf_nat_redirect.h b/include/net/netfilter/nf_nat_redirect.h
index c129aacc8ae8..2418653a66db 100644
--- a/include/net/netfilter/nf_nat_redirect.h
+++ b/include/net/netfilter/nf_nat_redirect.h
@@ -2,6 +2,9 @@
 #ifndef _NF_NAT_REDIRECT_H_
 #define _NF_NAT_REDIRECT_H_
 
+#include <linux/skbuff.h>
+#include <uapi/linux/netfilter/nf_nat.h>
+
 unsigned int
 nf_nat_redirect_ipv4(struct sk_buff *skb,
 		     const struct nf_nat_ipv4_multi_range_compat *mr,
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 3cb6dcf53a4e..359b80b43169 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -5,6 +5,8 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/jhash.h>
+#include <linux/netfilter.h>
+#include <linux/skbuff.h>
 
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
index 221f877f29d1..9051c3a0c8e7 100644
--- a/include/net/netfilter/nf_reject.h
+++ b/include/net/netfilter/nf_reject.h
@@ -2,6 +2,9 @@
 #ifndef _NF_REJECT_H
 #define _NF_REJECT_H
 
+#include <linux/types.h>
+#include <uapi/linux/in.h>
+
 static inline bool nf_reject_verify_csum(__u8 proto)
 {
 	/* Skip protocols that don't use 16-bit one's complement checksum
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index dabe6fdb553a..d0f1c537b017 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -4,6 +4,7 @@
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/ipv6.h>
+#include <net/netfilter/nf_tables.h>
 
 static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 					struct sk_buff *skb)
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index e4c4d8eaca8c..628b6fa579cd 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -2,6 +2,8 @@
 #ifndef _NFT_FIB_H_
 #define _NFT_FIB_H_
 
+#include <net/netfilter/nf_tables.h>
+
 struct nft_fib {
 	enum nft_registers	dreg:8;
 	u8			result;
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 5c69e9b09388..07e2fd507963 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -2,6 +2,8 @@
 #ifndef _NFT_META_H_
 #define _NFT_META_H_
 
+#include <net/netfilter/nf_tables.h>
+
 struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index de80c50761f0..56b123a42220 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -2,6 +2,11 @@
 #ifndef _NFT_REJECT_H_
 #define _NFT_REJECT_H_
 
+#include <linux/types.h>
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+#include <uapi/linux/netfilter/nf_tables.h>
+
 struct nft_reject {
 	enum nft_reject_types	type:8;
 	u8			icmp_code;
diff --git a/include/uapi/linux/netfilter/xt_policy.h b/include/uapi/linux/netfilter/xt_policy.h
index 323bfa3074c5..4cf2ce2a8a44 100644
--- a/include/uapi/linux/netfilter/xt_policy.h
+++ b/include/uapi/linux/netfilter/xt_policy.h
@@ -2,6 +2,7 @@
 #ifndef _XT_POLICY_H
 #define _XT_POLICY_H
 
+#include <linux/netfilter.h>
 #include <linux/types.h>
 #include <linux/in.h>
 #include <linux/in6.h>
-- 
2.20.1

