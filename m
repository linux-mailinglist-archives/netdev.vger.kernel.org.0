Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CBD8C0B3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfHMShY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:24 -0400
Received: from correo.us.es ([193.147.175.20]:58780 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727697AbfHMShX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CA018B6327
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B956B4CA35
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AEE42A75E; Tue, 13 Aug 2019 20:37:18 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9036A4CA35;
        Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4529D4265A2F;
        Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/17] netfilter: remove unnecessary spaces
Date:   Tue, 13 Aug 2019 20:36:48 +0200
Message-Id: <20190813183701.4002-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

This patch removes extra spaces.

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h  | 2 +-
 net/netfilter/ipset/ip_set_list_set.c  | 2 +-
 net/netfilter/ipvs/ip_vs_core.c        | 2 +-
 net/netfilter/ipvs/ip_vs_mh.c          | 4 ++--
 net/netfilter/ipvs/ip_vs_proto_tcp.c   | 2 +-
 net/netfilter/nf_conntrack_ftp.c       | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
 net/netfilter/nfnetlink_log.c          | 4 ++--
 net/netfilter/nfnetlink_queue.c        | 4 ++--
 net/netfilter/xt_IDLETIMER.c           | 2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 0feb77fa9edc..3fced06ab752 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -953,7 +953,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
-		n =  rcu_dereference_bh(hbucket(t, key));
+		n = rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
 		for (i = 0; i < n->pos; i++) {
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 6f9ead6319e0..67ac50104e6f 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -288,7 +288,7 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (n &&
 	    !(SET_WITH_TIMEOUT(set) &&
 	      ip_set_timeout_expired(ext_timeout(n, set))))
-		n =  NULL;
+		n = NULL;
 
 	e = kzalloc(set->dsize, GFP_ATOMIC);
 	if (!e)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 46f06f92ab8f..8b80ab794a92 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -617,7 +617,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		unsigned int flags = (svc->flags & IP_VS_SVC_F_ONEPACKET &&
 				      iph->protocol == IPPROTO_UDP) ?
 				      IP_VS_CONN_F_ONE_PACKET : 0;
-		union nf_inet_addr daddr =  { .all = { 0, 0, 0, 0 } };
+		union nf_inet_addr daddr = { .all = { 0, 0, 0, 0 } };
 
 		/* create a new connection entry */
 		IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __func__);
diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 94d9d349ebb0..da0280cec506 100644
--- a/net/netfilter/ipvs/ip_vs_mh.c
+++ b/net/netfilter/ipvs/ip_vs_mh.c
@@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_state *s,
 		return 0;
 	}
 
-	table =  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
-			 sizeof(unsigned long), GFP_KERNEL);
+	table = kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
+			sizeof(unsigned long), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 000d961b97e4..32b028853a7c 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -710,7 +710,7 @@ static int __ip_vs_tcp_init(struct netns_ipvs *ipvs, struct ip_vs_proto_data *pd
 							sizeof(tcp_timeouts));
 	if (!pd->timeout_table)
 		return -ENOMEM;
-	pd->tcp_state_table =  tcp_states;
+	pd->tcp_state_table = tcp_states;
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 0ecb3e289ef2..c57d2348c505 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -162,7 +162,7 @@ static int try_rfc959(const char *data, size_t dlen,
 	if (length == 0)
 		return 0;
 
-	cmd->u3.ip =  htonl((array[0] << 24) | (array[1] << 16) |
+	cmd->u3.ip = htonl((array[0] << 24) | (array[1] << 16) |
 				    (array[2] << 8) | array[3]);
 	cmd->u.tcp.port = htons((array[4] << 8) | array[5]);
 	return length;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 85c1f8c213b0..1926fd56df56 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1227,7 +1227,7 @@ static const struct nla_policy tcp_nla_policy[CTA_PROTOINFO_TCP_MAX+1] = {
 	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
 	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
 	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
-	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len =  sizeof(struct nf_ct_tcp_flags) },
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len = sizeof(struct nf_ct_tcp_flags) },
 };
 
 #define TCP_NLATTR_SIZE	( \
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6dee4f9a944c..d69e1863e536 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -651,7 +651,7 @@ nfulnl_log_packet(struct net *net,
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
+	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
@@ -668,7 +668,7 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
-		size +=   nla_total_size(skb->dev->hard_header_len)
+		size += nla_total_size(skb->dev->hard_header_len)
 			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
 			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b6a7ce622c72..feabdfb22920 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -394,7 +394,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	char *secdata = NULL;
 	u32 seclen = 0;
 
-	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
+	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
@@ -453,7 +453,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
-		size +=  (nla_total_size(sizeof(u_int32_t))	/* uid */
+		size += (nla_total_size(sizeof(u_int32_t))	/* uid */
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 9cec9eae556a..f56d3ed93e56 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -283,7 +283,7 @@ static int __init idletimer_tg_init(void)
 
 	idletimer_tg_kobj = &idletimer_tg_device->kobj;
 
-	err =  xt_register_target(&idletimer_tg);
+	err = xt_register_target(&idletimer_tg);
 	if (err < 0) {
 		pr_debug("couldn't register xt target\n");
 		goto out_dev;
-- 
2.11.0


