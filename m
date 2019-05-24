Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0848029BB9
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390380AbfEXQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:03:54 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:56080 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390349AbfEXQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:03:53 -0400
Received: by mail-pg1-f202.google.com with SMTP id g38so6535548pgl.22
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/agTypiXcmlVuwQFfVEiQWHFR3072xHyFKSywbkGVFU=;
        b=RVm37QuD2Mg8s8yGN2ZON8qxppjkMEXF7P0LK3zHdY9HcNQZPziv6um644V9UA4vr0
         wOH48Ov+2vVTDLgHpncgoml7yRE27jkiHmsMjQzpEc3MGQi/Clgy4Uk/7MJVgVE2mtjX
         qwVnf6ItDOU5yObW9OJg5TUI0VWK4UwJQQOQemWKGsD05bjhAuRzXU1lVcJQ4uDmLhbQ
         lWcrtawrGnCMtya4+/WrVqU0aWjDVc4kWZBKTdkjN6Ds9IAhYmfEQpw+zxOic7onYBJI
         F0DNmZNPy9vZwo4eOvA5QL/c9IhzCTsBjT7NYJa8oEtvTVB7glmJzcyH4/ySd8WAySju
         fgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/agTypiXcmlVuwQFfVEiQWHFR3072xHyFKSywbkGVFU=;
        b=SC6m3C6sYYqffJvLQiAi8uX/jj9QABjJ4n8MPQT+5Mxm6m9m6bT+EzKtNiMxtSX2G3
         ZLlpPZe0pHdDEMzdgVELjFA0C6gpxIRS/1EQ6DtUWWCS+Lt1pSuxu8WAgwo7qjGwwaAK
         e1Kd/Aq+b8dYJFhMltVv4+PKBDcH6UDJE6ct0PVqi6dxroM4FaeiL1vFI/p1cgAkfNzu
         kMi8tYJCY/L4mkTs85EAZFU+mCfFGTl95pcukXBLSsqAzU9lCHZeP9pRVZ4PwDHodg/L
         1I5TOuUlpfKdamuLhlkIioikEmIIRWuQ4cR5BCPxDRXwhIF8ferLH86700o+y3+kDSmv
         NcGA==
X-Gm-Message-State: APjAAAVbj8W1SopeHhHVVZEhg7Tkbd7ZQlWzc85eX4UIHfvpRZMWpKfL
        dXqkGwUmCkF7MdtCh1lDoGsqxhgcn0TYgA==
X-Google-Smtp-Source: APXvYqwMpmBOvWjnLPA9IKc4QJZbZ/OvlA5kGA+yTmsry83Rhv29TgLc1REcCcVHT7kGKwBGVpsNwtD8fsf1+w==
X-Received: by 2002:a65:63c8:: with SMTP id n8mr7404440pgv.96.1558713832944;
 Fri, 24 May 2019 09:03:52 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:32 -0700
In-Reply-To: <20190524160340.169521-1-edumazet@google.com>
Message-Id: <20190524160340.169521-4-edumazet@google.com>
Mime-Version: 1.0
References: <20190524160340.169521-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 03/11] net: rename struct fqdir fields
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the @frags fields from structs netns_ipv4, netns_ipv6,
netns_nf_frag and netns_ieee802154_lowpan to @fqdir

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ieee802154_6lowpan.h  |  2 +-
 include/net/netns/ipv4.h                |  2 +-
 include/net/netns/ipv6.h                |  4 +-
 net/ieee802154/6lowpan/reassembly.c     | 36 ++++++++---------
 net/ipv4/ip_fragment.c                  | 52 ++++++++++++-------------
 net/ipv4/proc.c                         |  4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c | 40 +++++++++----------
 net/ipv6/proc.c                         |  4 +-
 net/ipv6/reassembly.c                   | 40 +++++++++----------
 9 files changed, 92 insertions(+), 92 deletions(-)

diff --git a/include/net/netns/ieee802154_6lowpan.h b/include/net/netns/ieee802154_6lowpan.h
index 48897cbcb538cbae7658bb03e5a5a702c2036739..d27ac64f8dfefcc2253c14c04af193e6265b9e02 100644
--- a/include/net/netns/ieee802154_6lowpan.h
+++ b/include/net/netns/ieee802154_6lowpan.h
@@ -16,7 +16,7 @@ struct netns_sysctl_lowpan {
 
 struct netns_ieee802154_lowpan {
 	struct netns_sysctl_lowpan sysctl;
-	struct fqdir	frags;
+	struct fqdir		fqdir;
 };
 
 #endif
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 22f712141962c2c86cd0210ea97a7f111de5ee16..3c270baa32e030b36594627a77abe3b4ffc775f5 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -72,7 +72,7 @@ struct netns_ipv4 {
 
 	struct inet_peer_base	*peers;
 	struct sock  * __percpu	*tcp_sk;
-	struct fqdir	frags;
+	struct fqdir		fqdir;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*iptable_filter;
 	struct xt_table		*iptable_mangle;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a22e8702d82866576c235489a810040adb4267c7..3dd2ae2a38e2aead40f2bcf13e40b79ca492ad48 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -58,7 +58,7 @@ struct netns_ipv6 {
 	struct ipv6_devconf	*devconf_all;
 	struct ipv6_devconf	*devconf_dflt;
 	struct inet_peer_base	*peers;
-	struct fqdir	frags;
+	struct fqdir		fqdir;
 #ifdef CONFIG_NETFILTER
 	struct xt_table		*ip6table_filter;
 	struct xt_table		*ip6table_mangle;
@@ -116,7 +116,7 @@ struct netns_ipv6 {
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 struct netns_nf_frag {
-	struct fqdir	frags;
+	struct fqdir	fqdir;
 };
 #endif
 
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index dc73452d3224b7b125405ba577e8d222e2ee9db3..955047fe797a10995845bca51cb9770e3356a351 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -79,7 +79,7 @@ fq_find(struct net *net, const struct lowpan_802154_cb *cb,
 	key.src = *src;
 	key.dst = *dst;
 
-	q = inet_frag_find(&ieee802154_lowpan->frags, &key);
+	q = inet_frag_find(&ieee802154_lowpan->fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -326,23 +326,23 @@ int lowpan_frag_rcv(struct sk_buff *skb, u8 frag_type)
 static struct ctl_table lowpan_frags_ns_ctl_table[] = {
 	{
 		.procname	= "6lowpanfrag_high_thresh",
-		.data		= &init_net.ieee802154_lowpan.frags.high_thresh,
+		.data		= &init_net.ieee802154_lowpan.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ieee802154_lowpan.frags.low_thresh
+		.extra1		= &init_net.ieee802154_lowpan.fqdir.low_thresh
 	},
 	{
 		.procname	= "6lowpanfrag_low_thresh",
-		.data		= &init_net.ieee802154_lowpan.frags.low_thresh,
+		.data		= &init_net.ieee802154_lowpan.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ieee802154_lowpan.frags.high_thresh
+		.extra2		= &init_net.ieee802154_lowpan.fqdir.high_thresh
 	},
 	{
 		.procname	= "6lowpanfrag_time",
-		.data		= &init_net.ieee802154_lowpan.frags.timeout,
+		.data		= &init_net.ieee802154_lowpan.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -377,11 +377,11 @@ static int __net_init lowpan_frags_ns_sysctl_register(struct net *net)
 		if (table == NULL)
 			goto err_alloc;
 
-		table[0].data = &ieee802154_lowpan->frags.high_thresh;
-		table[0].extra1 = &ieee802154_lowpan->frags.low_thresh;
-		table[1].data = &ieee802154_lowpan->frags.low_thresh;
-		table[1].extra2 = &ieee802154_lowpan->frags.high_thresh;
-		table[2].data = &ieee802154_lowpan->frags.timeout;
+		table[0].data = &ieee802154_lowpan->fqdir.high_thresh;
+		table[0].extra1 = &ieee802154_lowpan->fqdir.low_thresh;
+		table[1].data = &ieee802154_lowpan->fqdir.low_thresh;
+		table[1].extra2 = &ieee802154_lowpan->fqdir.high_thresh;
+		table[2].data = &ieee802154_lowpan->fqdir.timeout;
 
 		/* Don't export sysctls to unprivileged users */
 		if (net->user_ns != &init_user_ns)
@@ -454,17 +454,17 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 		net_ieee802154_lowpan(net);
 	int res;
 
-	ieee802154_lowpan->frags.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	ieee802154_lowpan->frags.low_thresh = IPV6_FRAG_LOW_THRESH;
-	ieee802154_lowpan->frags.timeout = IPV6_FRAG_TIMEOUT;
-	ieee802154_lowpan->frags.f = &lowpan_frags;
+	ieee802154_lowpan->fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
+	ieee802154_lowpan->fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
+	ieee802154_lowpan->fqdir.timeout = IPV6_FRAG_TIMEOUT;
+	ieee802154_lowpan->fqdir.f = &lowpan_frags;
 
-	res = inet_frags_init_net(&ieee802154_lowpan->frags);
+	res = inet_frags_init_net(&ieee802154_lowpan->fqdir);
 	if (res < 0)
 		return res;
 	res = lowpan_frags_ns_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&ieee802154_lowpan->frags);
+		fqdir_exit(&ieee802154_lowpan->fqdir);
 	return res;
 }
 
@@ -474,7 +474,7 @@ static void __net_exit lowpan_frags_exit_net(struct net *net)
 		net_ieee802154_lowpan(net);
 
 	lowpan_frags_ns_sysctl_unregister(net);
-	fqdir_exit(&ieee802154_lowpan->frags);
+	fqdir_exit(&ieee802154_lowpan->fqdir);
 }
 
 static struct pernet_operations lowpan_frags_ops = {
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 9de13b5d23e37f585aa50e636e009e9d21083d02..f1831367cc2b188bdcc93f25818dda13e4348427 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -83,7 +83,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 {
 	struct ipq *qp = container_of(q, struct ipq, q);
 	struct netns_ipv4 *ipv4 = container_of(q->fqdir, struct netns_ipv4,
-					       frags);
+					       fqdir);
 	struct net *net = container_of(ipv4, struct net, ipv4);
 
 	const struct frag_v4_compare_key *key = a;
@@ -142,7 +142,7 @@ static void ip_expire(struct timer_list *t)
 	int err;
 
 	qp = container_of(frag, struct ipq, q);
-	net = container_of(qp->q.fqdir, struct net, ipv4.frags);
+	net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
 
 	rcu_read_lock();
 	spin_lock(&qp->q.lock);
@@ -211,7 +211,7 @@ static struct ipq *ip_find(struct net *net, struct iphdr *iph,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(&net->ipv4.frags, &key);
+	q = inet_frag_find(&net->ipv4.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -239,7 +239,7 @@ static int ip_frag_too_far(struct ipq *qp)
 	if (rc) {
 		struct net *net;
 
-		net = container_of(qp->q.fqdir, struct net, ipv4.frags);
+		net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
 		__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	}
 
@@ -273,7 +273,7 @@ static int ip_frag_reinit(struct ipq *qp)
 /* Add new segment to existing queue. */
 static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 {
-	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.frags);
+	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
 	int ihl, end, flags, offset;
 	struct sk_buff *prev_tail;
 	struct net_device *dev;
@@ -399,7 +399,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 			 struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.frags);
+	struct net *net = container_of(qp->q.fqdir, struct net, ipv4.fqdir);
 	struct iphdr *iph;
 	void *reasm_data;
 	int len, err;
@@ -544,30 +544,30 @@ static int dist_min;
 static struct ctl_table ip4_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ipfrag_high_thresh",
-		.data		= &init_net.ipv4.frags.high_thresh,
+		.data		= &init_net.ipv4.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ipv4.frags.low_thresh
+		.extra1		= &init_net.ipv4.fqdir.low_thresh
 	},
 	{
 		.procname	= "ipfrag_low_thresh",
-		.data		= &init_net.ipv4.frags.low_thresh,
+		.data		= &init_net.ipv4.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ipv4.frags.high_thresh
+		.extra2		= &init_net.ipv4.fqdir.high_thresh
 	},
 	{
 		.procname	= "ipfrag_time",
-		.data		= &init_net.ipv4.frags.timeout,
+		.data		= &init_net.ipv4.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "ipfrag_max_dist",
-		.data		= &init_net.ipv4.frags.max_dist,
+		.data		= &init_net.ipv4.fqdir.max_dist,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
@@ -600,12 +600,12 @@ static int __net_init ip4_frags_ns_ctl_register(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		table[0].data = &net->ipv4.frags.high_thresh;
-		table[0].extra1 = &net->ipv4.frags.low_thresh;
-		table[1].data = &net->ipv4.frags.low_thresh;
-		table[1].extra2 = &net->ipv4.frags.high_thresh;
-		table[2].data = &net->ipv4.frags.timeout;
-		table[3].data = &net->ipv4.frags.max_dist;
+		table[0].data = &net->ipv4.fqdir.high_thresh;
+		table[0].extra1 = &net->ipv4.fqdir.low_thresh;
+		table[1].data = &net->ipv4.fqdir.low_thresh;
+		table[1].extra2 = &net->ipv4.fqdir.high_thresh;
+		table[2].data = &net->ipv4.fqdir.timeout;
+		table[3].data = &net->ipv4.fqdir.max_dist;
 	}
 
 	hdr = register_net_sysctl(net, "net/ipv4", table);
@@ -668,31 +668,31 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	 * we will prune down to 3MB, making room for approx 8 big 64K
 	 * fragments 8x128k.
 	 */
-	net->ipv4.frags.high_thresh = 4 * 1024 * 1024;
-	net->ipv4.frags.low_thresh  = 3 * 1024 * 1024;
+	net->ipv4.fqdir.high_thresh = 4 * 1024 * 1024;
+	net->ipv4.fqdir.low_thresh  = 3 * 1024 * 1024;
 	/*
 	 * Important NOTE! Fragment queue must be destroyed before MSL expires.
 	 * RFC791 is wrong proposing to prolongate timer each fragment arrival
 	 * by TTL.
 	 */
-	net->ipv4.frags.timeout = IP_FRAG_TIME;
+	net->ipv4.fqdir.timeout = IP_FRAG_TIME;
 
-	net->ipv4.frags.max_dist = 64;
-	net->ipv4.frags.f = &ip4_frags;
+	net->ipv4.fqdir.max_dist = 64;
+	net->ipv4.fqdir.f = &ip4_frags;
 
-	res = inet_frags_init_net(&net->ipv4.frags);
+	res = inet_frags_init_net(&net->ipv4.fqdir);
 	if (res < 0)
 		return res;
 	res = ip4_frags_ns_ctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->ipv4.frags);
+		fqdir_exit(&net->ipv4.fqdir);
 	return res;
 }
 
 static void __net_exit ipv4_frags_exit_net(struct net *net)
 {
 	ip4_frags_ns_ctl_unregister(net);
-	fqdir_exit(&net->ipv4.frags);
+	fqdir_exit(&net->ipv4.fqdir);
 }
 
 static struct pernet_operations ip4_frags_ops = {
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index c3610b37bb4ce665b1976d8cc907b6dd0de42ab9..3927e00084e8eacc237c4bb46554458ad0266dcf 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -72,8 +72,8 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW: inuse %d\n",
 		   sock_prot_inuse_get(net, &raw_prot));
 	seq_printf(seq,  "FRAG: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv4.frags.rhashtable.nelems),
-		   frag_mem_limit(&net->ipv4.frags));
+		   atomic_read(&net->ipv4.fqdir.rhashtable.nelems),
+		   frag_mem_limit(&net->ipv4.fqdir));
 	return 0;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index f08e1422c56dcd207d148ecb578df4a8f7ac2d9d..46073e9a6c566b0f019c94de902f347f6e0f0cba 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -58,26 +58,26 @@ static struct inet_frags nf_frags;
 static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
-		.data		= &init_net.nf_frag.frags.timeout,
+		.data		= &init_net.nf_frag.fqdir.timeout,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nf_conntrack_frag6_low_thresh",
-		.data		= &init_net.nf_frag.frags.low_thresh,
+		.data		= &init_net.nf_frag.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.nf_frag.frags.high_thresh
+		.extra2		= &init_net.nf_frag.fqdir.high_thresh
 	},
 	{
 		.procname	= "nf_conntrack_frag6_high_thresh",
-		.data		= &init_net.nf_frag.frags.high_thresh,
+		.data		= &init_net.nf_frag.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.nf_frag.frags.low_thresh
+		.extra1		= &init_net.nf_frag.fqdir.low_thresh
 	},
 	{ }
 };
@@ -94,12 +94,12 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 		if (table == NULL)
 			goto err_alloc;
 
-		table[0].data = &net->nf_frag.frags.timeout;
-		table[1].data = &net->nf_frag.frags.low_thresh;
-		table[1].extra2 = &net->nf_frag.frags.high_thresh;
-		table[2].data = &net->nf_frag.frags.high_thresh;
-		table[2].extra1 = &net->nf_frag.frags.low_thresh;
-		table[2].extra2 = &init_net.nf_frag.frags.high_thresh;
+		table[0].data = &net->nf_frag.fqdir.timeout;
+		table[1].data = &net->nf_frag.fqdir.low_thresh;
+		table[1].extra2 = &net->nf_frag.fqdir.high_thresh;
+		table[2].data = &net->nf_frag.fqdir.high_thresh;
+		table[2].extra1 = &net->nf_frag.fqdir.low_thresh;
+		table[2].extra2 = &init_net.nf_frag.fqdir.high_thresh;
 	}
 
 	hdr = register_net_sysctl(net, "net/netfilter", table);
@@ -151,7 +151,7 @@ static void nf_ct_frag6_expire(struct timer_list *t)
 	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.fqdir, struct net, nf_frag.frags);
+	net = container_of(fq->q.fqdir, struct net, nf_frag.fqdir);
 
 	ip6frag_expire_frag_queue(net, fq);
 }
@@ -169,7 +169,7 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
-	q = inet_frag_find(&net->nf_frag.frags, &key);
+	q = inet_frag_find(&net->nf_frag.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -496,24 +496,24 @@ static int nf_ct_net_init(struct net *net)
 {
 	int res;
 
-	net->nf_frag.frags.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->nf_frag.frags.low_thresh = IPV6_FRAG_LOW_THRESH;
-	net->nf_frag.frags.timeout = IPV6_FRAG_TIMEOUT;
-	net->nf_frag.frags.f = &nf_frags;
+	net->nf_frag.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
+	net->nf_frag.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
+	net->nf_frag.fqdir.timeout = IPV6_FRAG_TIMEOUT;
+	net->nf_frag.fqdir.f = &nf_frags;
 
-	res = inet_frags_init_net(&net->nf_frag.frags);
+	res = inet_frags_init_net(&net->nf_frag.fqdir);
 	if (res < 0)
 		return res;
 	res = nf_ct_frag6_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->nf_frag.frags);
+		fqdir_exit(&net->nf_frag.fqdir);
 	return res;
 }
 
 static void nf_ct_net_exit(struct net *net)
 {
 	nf_ct_frags6_sysctl_unregister(net);
-	fqdir_exit(&net->nf_frag.frags);
+	fqdir_exit(&net->nf_frag.fqdir);
 }
 
 static struct pernet_operations nf_ct_net_ops = {
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 2356b4af7309c06bf1572ab4cbf8299b5ca86e51..f3e3118393c4b4841228797c168e757585dbb17b 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -48,8 +48,8 @@ static int sockstat6_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW6: inuse %d\n",
 		       sock_prot_inuse_get(net, &rawv6_prot));
 	seq_printf(seq, "FRAG6: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv6.frags.rhashtable.nelems),
-		   frag_mem_limit(&net->ipv6.frags));
+		   atomic_read(&net->ipv6.fqdir.rhashtable.nelems),
+		   frag_mem_limit(&net->ipv6.fqdir));
 	return 0;
 }
 
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index f1142f5d5075a56164aa3f1f56c12328ab99747c..5160fd9ed223b723249b1c3f8ac3e2a97c7ffc43 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -79,7 +79,7 @@ static void ip6_frag_expire(struct timer_list *t)
 	struct net *net;
 
 	fq = container_of(frag, struct frag_queue, q);
-	net = container_of(fq->q.fqdir, struct net, ipv6.frags);
+	net = container_of(fq->q.fqdir, struct net, ipv6.fqdir);
 
 	ip6frag_expire_frag_queue(net, fq);
 }
@@ -100,7 +100,7 @@ fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
 					    IPV6_ADDR_LINKLOCAL)))
 		key.iif = 0;
 
-	q = inet_frag_find(&net->ipv6.frags, &key);
+	q = inet_frag_find(&net->ipv6.fqdir, &key);
 	if (!q)
 		return NULL;
 
@@ -254,7 +254,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			  struct sk_buff *prev_tail, struct net_device *dev)
 {
-	struct net *net = container_of(fq->q.fqdir, struct net, ipv6.frags);
+	struct net *net = container_of(fq->q.fqdir, struct net, ipv6.fqdir);
 	unsigned int nhoff;
 	void *reasm_data;
 	int payload_len;
@@ -401,23 +401,23 @@ static const struct inet6_protocol frag_protocol = {
 static struct ctl_table ip6_frags_ns_ctl_table[] = {
 	{
 		.procname	= "ip6frag_high_thresh",
-		.data		= &init_net.ipv6.frags.high_thresh,
+		.data		= &init_net.ipv6.fqdir.high_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &init_net.ipv6.frags.low_thresh
+		.extra1		= &init_net.ipv6.fqdir.low_thresh
 	},
 	{
 		.procname	= "ip6frag_low_thresh",
-		.data		= &init_net.ipv6.frags.low_thresh,
+		.data		= &init_net.ipv6.fqdir.low_thresh,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra2		= &init_net.ipv6.frags.high_thresh
+		.extra2		= &init_net.ipv6.fqdir.high_thresh
 	},
 	{
 		.procname	= "ip6frag_time",
-		.data		= &init_net.ipv6.frags.timeout,
+		.data		= &init_net.ipv6.fqdir.timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -449,11 +449,11 @@ static int __net_init ip6_frags_ns_sysctl_register(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		table[0].data = &net->ipv6.frags.high_thresh;
-		table[0].extra1 = &net->ipv6.frags.low_thresh;
-		table[1].data = &net->ipv6.frags.low_thresh;
-		table[1].extra2 = &net->ipv6.frags.high_thresh;
-		table[2].data = &net->ipv6.frags.timeout;
+		table[0].data = &net->ipv6.fqdir.high_thresh;
+		table[0].extra1 = &net->ipv6.fqdir.low_thresh;
+		table[1].data = &net->ipv6.fqdir.low_thresh;
+		table[1].extra2 = &net->ipv6.fqdir.high_thresh;
+		table[2].data = &net->ipv6.fqdir.timeout;
 	}
 
 	hdr = register_net_sysctl(net, "net/ipv6", table);
@@ -517,25 +517,25 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 {
 	int res;
 
-	net->ipv6.frags.high_thresh = IPV6_FRAG_HIGH_THRESH;
-	net->ipv6.frags.low_thresh = IPV6_FRAG_LOW_THRESH;
-	net->ipv6.frags.timeout = IPV6_FRAG_TIMEOUT;
-	net->ipv6.frags.f = &ip6_frags;
+	net->ipv6.fqdir.high_thresh = IPV6_FRAG_HIGH_THRESH;
+	net->ipv6.fqdir.low_thresh = IPV6_FRAG_LOW_THRESH;
+	net->ipv6.fqdir.timeout = IPV6_FRAG_TIMEOUT;
+	net->ipv6.fqdir.f = &ip6_frags;
 
-	res = inet_frags_init_net(&net->ipv6.frags);
+	res = inet_frags_init_net(&net->ipv6.fqdir);
 	if (res < 0)
 		return res;
 
 	res = ip6_frags_ns_sysctl_register(net);
 	if (res < 0)
-		fqdir_exit(&net->ipv6.frags);
+		fqdir_exit(&net->ipv6.fqdir);
 	return res;
 }
 
 static void __net_exit ipv6_frags_exit_net(struct net *net)
 {
 	ip6_frags_ns_sysctl_unregister(net);
-	fqdir_exit(&net->ipv6.frags);
+	fqdir_exit(&net->ipv6.fqdir);
 }
 
 static struct pernet_operations ip6_frags_ops = {
-- 
2.22.0.rc1.257.g3120a18244-goog

