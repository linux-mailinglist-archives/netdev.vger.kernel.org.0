Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB8B6A079
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbfGPCNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:13:18 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43957 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733110AbfGPCNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:13:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so2296409pld.10;
        Mon, 15 Jul 2019 19:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SWincevzgCliFtReWorLpwpIuJCNow0H+hUHTSLvkGM=;
        b=X/cQu2NKWB7hORhprxi0Sju2QbLiTgI6nmZH+pwFqrQRR1gm3TUm2KR60rZ/0z/eSn
         s/fYs1z1olZByNmO11wFAw0ffxxinuoLH+duVNu1XYHxLE4dFeqi3pfACLeMvZ2hs6si
         k7t4+pep+GfK77Mp8yPzoM2YrIO37otEAbv3ln53HK8nV0ApTdx2F3yZWRtJYQYcRfXy
         74WNDOqxHOGjYq6xXu85PNx2Muq7PjcHMoLVa16LyYPUR8t1MapiMANm39ljwjOrG1HY
         +LH2NK8wzSJFDhse5MmGheWcaKb/GMGeoGCs2gfh4uNmBHFwrlMIhayTkI0F3rs3SEy6
         MCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SWincevzgCliFtReWorLpwpIuJCNow0H+hUHTSLvkGM=;
        b=jLHqJF+zFJ2TrNj08lT2eIf47cFfSdrEJc6H8TfsAVjFhgxzPIVBS2v5IAITHPSMMl
         P/l6Z0JdM8NQ0SxxJ2Pv3jAOKHDEMbeVE+DIFwFL6STO43zU3ftgObj+ElnzBtdr++c5
         //9t5ie7RGlXNkxacv3vzcqemBgzhufvI2objjWR2F1LNUQ9W5Hr4+5DACP7VaATo4IB
         umt8KoQ3ZpLv79ubITyNbGaeNxlKwt8Gobp839DrEq9lGRPsc+Gi9ZjZSIOumPBD6MIK
         m0UbxT9/utcQJ7iWKs9QwaZHsgAyzOwc+jfqlbodvwepeRDroX40HqDEYNxez83+fqsJ
         9ZJQ==
X-Gm-Message-State: APjAAAXKcjWBBMkOftu9NP27Kf3DiZe8M0HwXFuy5aK6a8b1ndE2NZ5x
        wa5ppdBSbjU1UkbO8gCB6yI=
X-Google-Smtp-Source: APXvYqya/fcF7vhyXOIAIpPD2Q+ZlFRMJBxrSmz213TKDFJ0IWsCNJ4K4fcwa4Tb6Kz6zDHFIhakbQ==
X-Received: by 2002:a17:902:8203:: with SMTP id x3mr32271187pln.304.1563243196658;
        Mon, 15 Jul 2019 19:13:16 -0700 (PDT)
Received: from localhost.localdomain ([116.66.213.65])
        by smtp.gmail.com with ESMTPSA id w1sm15007360pjt.30.2019.07.15.19.13.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 15 Jul 2019 19:13:15 -0700 (PDT)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     pablo@netfilter.org
Cc:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH v2] net/netfilter: remove unnecessary spaces
Date:   Tue, 16 Jul 2019 10:13:01 +0800
Message-Id: <20190716021301.27753-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190715082747.fdlpvekbqyhwx724@salvia>
References: <20190715082747.fdlpvekbqyhwx724@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this patch removes extra spaces

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
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
index 10f6196..eb907d2 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -954,7 +954,7 @@ struct htype {
 		mtype_data_netmask(d, NCIDR_GET(h->nets[j].cidr[0]));
 #endif
 		key = HKEY(d, h->initval, t->htable_bits);
-		n =  rcu_dereference_bh(hbucket(t, key));
+		n = rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
 		for (i = 0; i < n->pos; i++) {
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 8ada318..5c2be76 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -289,7 +289,7 @@ struct list_set {
 	if (n &&
 	    !(SET_WITH_TIMEOUT(set) &&
 	      ip_set_timeout_expired(ext_timeout(n, set))))
-		n =  NULL;
+		n = NULL;
 
 	e = kzalloc(set->dsize, GFP_ATOMIC);
 	if (!e)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 7138556..6b3ae76 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -615,7 +615,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		unsigned int flags = (svc->flags & IP_VS_SVC_F_ONEPACKET &&
 				      iph->protocol == IPPROTO_UDP) ?
 				      IP_VS_CONN_F_ONE_PACKET : 0;
-		union nf_inet_addr daddr =  { .all = { 0, 0, 0, 0 } };
+		union nf_inet_addr daddr = { .all = { 0, 0, 0, 0 } };
 
 		/* create a new connection entry */
 		IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __func__);
diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs_mh.c
index 94d9d34..da0280c 100644
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
index 915ac82..c7b46a9 100644
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
index 8c6c11b..26c1ff8 100644
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
index 1e2cc83..48f3a67 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1225,7 +1225,7 @@ static int tcp_to_nlattr(struct sk_buff *skb, struct nlattr *nla,
 	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL] = { .type = NLA_U8 },
 	[CTA_PROTOINFO_TCP_WSCALE_REPLY]    = { .type = NLA_U8 },
 	[CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  = { .len = sizeof(struct nf_ct_tcp_flags) },
-	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len =  sizeof(struct nf_ct_tcp_flags) },
+	[CTA_PROTOINFO_TCP_FLAGS_REPLY]	    = { .len = sizeof(struct nf_ct_tcp_flags) },
 };
 
 #define TCP_NLATTR_SIZE	( \
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6dee4f9..d69e186 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -651,7 +651,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 	/* FIXME: do we want to make the size calculation conditional based on
 	 * what is actually present?  way more branches and checks, but more
 	 * memory efficient... */
-	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
+	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
@@ -668,7 +668,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
-		size +=   nla_total_size(skb->dev->hard_header_len)
+		size += nla_total_size(skb->dev->hard_header_len)
 			+ nla_total_size(sizeof(u_int16_t))	/* hwtype */
 			+ nla_total_size(sizeof(u_int16_t));	/* hwlen */
 	}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 89750f7..a1ef6e3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -394,7 +394,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	char *secdata = NULL;
 	u32 seclen = 0;
 
-	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
+	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
@@ -453,7 +453,7 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
 	}
 
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
-		size +=  (nla_total_size(sizeof(u_int32_t))	/* uid */
+		size += (nla_total_size(sizeof(u_int32_t))	/* uid */
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 9cec9ea..f56d3ed 100644
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
1.8.3.1

