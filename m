Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702E8256665
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgH2JWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:22:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726405AbgH2JWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:22:49 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E62AF79499588168783C;
        Sat, 29 Aug 2020 17:22:45 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 29 Aug 2020
 17:22:39 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: clean up codestyle
Date:   Sat, 29 Aug 2020 05:21:30 -0400
Message-ID: <20200829092130.26639-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a pure codestyle cleanup patch. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/net/dst.h    |  2 +-
 include/net/sock.h   |  2 +-
 net/ipv4/icmp.c      |  2 +-
 net/ipv4/ip_output.c |  2 +-
 net/ipv4/ping.c      |  6 ++++--
 net/ipv4/route.c     | 10 +++++-----
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 6ae2e625050d..8ea8812b0b41 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -214,7 +214,7 @@ dst_allfrag(const struct dst_entry *dst)
 static inline int
 dst_metric_locked(const struct dst_entry *dst, int metric)
 {
-	return dst_metric(dst, RTAX_LOCK) & (1<<metric);
+	return dst_metric(dst, RTAX_LOCK) & (1 << metric);
 }
 
 static inline void dst_hold(struct dst_entry *dst)
diff --git a/include/net/sock.h b/include/net/sock.h
index 064637d1ddf6..b943731fa879 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1478,7 +1478,7 @@ sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 {
 	if (!sk_has_account(sk))
 		return true;
-	return size<= sk->sk_forward_alloc ||
+	return size <= sk->sk_forward_alloc ||
 		__sk_mem_schedule(sk, size, SK_MEM_RECV) ||
 		skb_pfmemalloc(skb);
 }
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 3b387dc3864f..8f2e974a1e4d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -784,7 +784,7 @@ EXPORT_SYMBOL(icmp_ndo_send);
 
 static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	const struct net_protocol *ipprot;
 	int protocol = iph->protocol;
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f0f234727547..b931d0b02e49 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1536,7 +1536,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	ip_select_ident(net, skb, sk);
 
 	if (opt) {
-		iph->ihl += opt->optlen>>2;
+		iph->ihl += opt->optlen >> 2;
 		ip_options_build(skb, opt, cork->addr, rt, 0);
 	}
 
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 265676fd2bbd..db364b2e2a69 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -293,7 +293,8 @@ EXPORT_SYMBOL_GPL(ping_close);
 
 /* Checks the bind address and possibly modifies sk->sk_bound_dev_if. */
 static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
-				struct sockaddr *uaddr, int addr_len) {
+				struct sockaddr *uaddr, int addr_len)
+{
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
@@ -634,7 +635,8 @@ static int ping_v4_push_pending_frames(struct sock *sk, struct pingfakehdr *pfh,
 }
 
 int ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
-			void *user_icmph, size_t icmph_len) {
+			void *user_icmph, size_t icmph_len)
+{
 	u8 type, code;
 
 	if (len > 0xFFFF)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 96fcdfb9bb26..2c05b863ae43 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -623,7 +623,7 @@ static inline u32 fnhe_hashfun(__be32 daddr)
 	u32 hval;
 
 	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32) daddr, fnhe_hashrnd);
+	hval = jhash_1word((__force u32)daddr, fnhe_hashrnd);
 	return hash_32(hval, FNHE_HASH_SHIFT);
 }
 
@@ -1062,7 +1062,7 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
 		      int oif, u8 protocol)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
 	u32 mark = IP4_REPLY_MARK(net, skb->mark);
@@ -1097,7 +1097,7 @@ static void __ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 
 void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
 	struct dst_entry *odst = NULL;
@@ -1152,7 +1152,7 @@ EXPORT_SYMBOL_GPL(ipv4_sk_update_pmtu);
 void ipv4_redirect(struct sk_buff *skb, struct net *net,
 		   int oif, u8 protocol)
 {
-	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	const struct iphdr *iph = (const struct iphdr *)skb->data;
 	struct flowi4 fl4;
 	struct rtable *rt;
 
@@ -1308,7 +1308,7 @@ static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 
 static unsigned int ipv4_mtu(const struct dst_entry *dst)
 {
-	const struct rtable *rt = (const struct rtable *) dst;
+	const struct rtable *rt = (const struct rtable *)dst;
 	unsigned int mtu = rt->rt_pmtu;
 
 	if (!mtu || time_after_eq(jiffies, rt->dst.expires))
-- 
2.19.1

