Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6254D22878D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgGURlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730590AbgGURlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:05 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6761C0619E2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 55E6B9158B;
        Tue, 21 Jul 2020 18:32:58 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352778; bh=S0cFR0DUFpTglkZGmxsG26fBm9U79CrEjctmEp8y94Y=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2001/29]=20l2tp:=20cleanup=20whitespace=20around=20operators|D
         ate:=20Tue,=2021=20Jul=202020=2018:31:53=20+0100|Message-Id:=20<20
         200721173221.4681-2-tparkin@katalix.com>|In-Reply-To:=20<202007211
         73221.4681-1-tparkin@katalix.com>|References:=20<20200721173221.46
         81-1-tparkin@katalix.com>;
        b=G1Sh+UO+P9itgZexDGSIX46mNL/ebE9lGVhGfgc3ubbp8UhXAp5qJw5P61uU4Qi6N
         iNXVCYY0UbG1obqzRv49HjuMlXK1aFsd3g9QufKCaAgdiCsEjjXREkFh9/5TlOpB8w
         mO3FoxiocN55Iw5ZseFdY6W0QEhJpsGqC+Cn029nlex4wMlbUxzJuafQyxsT87lmVd
         FXmo0EAHxJjrOIQd+sQKaB06r6NiXUtVg+W6IB4TzfUDmg3BvJ+Q8g+R0ZhsQW6iC/
         t9NFWcaqkQf5T2Gt+mZklG+wuecn4HcBHZH3nJ/n6kj7xthPay42DUtfEn/u+IS83o
         HvrzxCptHyPWQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 01/29] l2tp: cleanup whitespace around operators
Date:   Tue, 21 Jul 2020 18:31:53 +0100
Message-Id: <20200721173221.4681-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warned about whitespace around various operators in the
l2tp code.

The checkpatch suggestions help make the code more readable, so
update the l2tp code accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 34 +++++++++++++++++-----------------
 net/l2tp/l2tp_eth.c  | 13 ++++++-------
 net/l2tp/l2tp_ip.c   | 12 ++++++------
 net/l2tp/l2tp_ip6.c  | 14 +++++++-------
 net/l2tp/l2tp_ppp.c  |  6 +++---
 5 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6434d17e6e8e..4031149b7d44 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -94,7 +94,7 @@ struct l2tp_skb_cb {
 	unsigned long		expires;
 };
 
-#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *) &skb->cb[sizeof(struct inet_skb_parm)])
+#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)])
 
 static struct workqueue_struct *l2tp_wq;
 
@@ -648,9 +648,9 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 	L2TP_SKB_CB(skb)->has_seq = 0;
 	if (tunnel->version == L2TP_HDR_VER_2) {
 		if (hdrflags & L2TP_HDRFLAG_S) {
-			ns = ntohs(*(__be16 *) ptr);
+			ns = ntohs(*(__be16 *)ptr);
 			ptr += 2;
-			nr = ntohs(*(__be16 *) ptr);
+			nr = ntohs(*(__be16 *)ptr);
 			ptr += 2;
 
 			/* Store L2TP info in the skb */
@@ -662,7 +662,7 @@ void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 				 session->name, ns, nr, session->nr);
 		}
 	} else if (session->l2specific_type == L2TP_L2SPECTYPE_DEFAULT) {
-		u32 l2h = ntohl(*(__be32 *) ptr);
+		u32 l2h = ntohl(*(__be32 *)ptr);
 
 		if (l2h & 0x40000000) {
 			ns = l2h & 0x00ffffff;
@@ -828,7 +828,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	optr = ptr = skb->data;
 
 	/* Get L2TP header flags */
-	hdrflags = ntohs(*(__be16 *) ptr);
+	hdrflags = ntohs(*(__be16 *)ptr);
 
 	/* Check protocol version */
 	version = hdrflags & L2TP_HDR_VER_MASK;
@@ -859,14 +859,14 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 			ptr += 2;
 
 		/* Extract tunnel and session ID */
-		tunnel_id = ntohs(*(__be16 *) ptr);
+		tunnel_id = ntohs(*(__be16 *)ptr);
 		ptr += 2;
-		session_id = ntohs(*(__be16 *) ptr);
+		session_id = ntohs(*(__be16 *)ptr);
 		ptr += 2;
 	} else {
 		ptr += 2;	/* skip reserved bits */
 		tunnel_id = tunnel->tunnel_id;
-		session_id = ntohl(*(__be32 *) ptr);
+		session_id = ntohl(*(__be32 *)ptr);
 		ptr += 4;
 	}
 
@@ -971,13 +971,13 @@ static int l2tp_build_l2tpv3_header(struct l2tp_session *session, void *buf)
 	 */
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		u16 flags = L2TP_HDR_VER_3;
-		*((__be16 *) bufp) = htons(flags);
+		*((__be16 *)bufp) = htons(flags);
 		bufp += 2;
-		*((__be16 *) bufp) = 0;
+		*((__be16 *)bufp) = 0;
 		bufp += 2;
 	}
 
-	*((__be32 *) bufp) = htonl(session->peer_session_id);
+	*((__be32 *)bufp) = htonl(session->peer_session_id);
 	bufp += 4;
 	if (session->cookie_len) {
 		memcpy(bufp, &session->cookie[0], session->cookie_len);
@@ -1305,9 +1305,9 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			memcpy(&udp_conf.peer_ip6, cfg->peer_ip6,
 			       sizeof(udp_conf.peer_ip6));
 			udp_conf.use_udp6_tx_checksums =
-			  ! cfg->udp6_zero_tx_checksums;
+			  !cfg->udp6_zero_tx_checksums;
 			udp_conf.use_udp6_rx_checksums =
-			  ! cfg->udp6_zero_rx_checksums;
+			  !cfg->udp6_zero_rx_checksums;
 		} else
 #endif
 		{
@@ -1340,7 +1340,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			memcpy(&ip6_addr.l2tp_addr, cfg->local_ip6,
 			       sizeof(ip6_addr.l2tp_addr));
 			ip6_addr.l2tp_conn_id = tunnel_id;
-			err = kernel_bind(sock, (struct sockaddr *) &ip6_addr,
+			err = kernel_bind(sock, (struct sockaddr *)&ip6_addr,
 					  sizeof(ip6_addr));
 			if (err < 0)
 				goto out;
@@ -1350,7 +1350,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			       sizeof(ip6_addr.l2tp_addr));
 			ip6_addr.l2tp_conn_id = peer_tunnel_id;
 			err = kernel_connect(sock,
-					     (struct sockaddr *) &ip6_addr,
+					     (struct sockaddr *)&ip6_addr,
 					     sizeof(ip6_addr), 0);
 			if (err < 0)
 				goto out;
@@ -1367,7 +1367,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			ip_addr.l2tp_family = AF_INET;
 			ip_addr.l2tp_addr = cfg->local_ip;
 			ip_addr.l2tp_conn_id = tunnel_id;
-			err = kernel_bind(sock, (struct sockaddr *) &ip_addr,
+			err = kernel_bind(sock, (struct sockaddr *)&ip_addr,
 					  sizeof(ip_addr));
 			if (err < 0)
 				goto out;
@@ -1375,7 +1375,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			ip_addr.l2tp_family = AF_INET;
 			ip_addr.l2tp_addr = cfg->peer_ip;
 			ip_addr.l2tp_conn_id = peer_tunnel_id;
-			err = kernel_connect(sock, (struct sockaddr *) &ip_addr,
+			err = kernel_connect(sock, (struct sockaddr *)&ip_addr,
 					     sizeof(ip_addr), 0);
 			if (err < 0)
 				goto out;
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 3099efa19249..86e111d7d73c 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -94,13 +94,12 @@ static void l2tp_eth_get_stats64(struct net_device *dev,
 {
 	struct l2tp_eth *priv = netdev_priv(dev);
 
-	stats->tx_bytes   = (unsigned long) atomic_long_read(&priv->tx_bytes);
-	stats->tx_packets = (unsigned long) atomic_long_read(&priv->tx_packets);
-	stats->tx_dropped = (unsigned long) atomic_long_read(&priv->tx_dropped);
-	stats->rx_bytes   = (unsigned long) atomic_long_read(&priv->rx_bytes);
-	stats->rx_packets = (unsigned long) atomic_long_read(&priv->rx_packets);
-	stats->rx_errors  = (unsigned long) atomic_long_read(&priv->rx_errors);
-
+	stats->tx_bytes   = (unsigned long)atomic_long_read(&priv->tx_bytes);
+	stats->tx_packets = (unsigned long)atomic_long_read(&priv->tx_packets);
+	stats->tx_dropped = (unsigned long)atomic_long_read(&priv->tx_dropped);
+	stats->rx_bytes   = (unsigned long)atomic_long_read(&priv->rx_bytes);
+	stats->rx_packets = (unsigned long)atomic_long_read(&priv->rx_packets);
+	stats->rx_errors  = (unsigned long)atomic_long_read(&priv->rx_errors);
 }
 
 static const struct net_device_ops l2tp_eth_netdev_ops = {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 2a3fd31fb589..c52eb2510ca4 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -126,7 +126,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 
 	/* Point to L2TP header */
 	optr = ptr = skb->data;
-	session_id = ntohl(*((__be32 *) ptr));
+	session_id = ntohl(*((__be32 *)ptr));
 	ptr += 4;
 
 	/* RFC3931: L2TP/IP packets have the first 4 bytes containing
@@ -176,7 +176,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	if ((skb->data[0] & 0xc0) != 0xc0)
 		goto discard;
 
-	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
+	tunnel_id = ntohl(*(__be32 *)&skb->data[4]);
 	iph = (struct iphdr *)skb_network_header(skb);
 
 	read_lock_bh(&l2tp_ip_lock);
@@ -260,7 +260,7 @@ static void l2tp_ip_destroy_sock(struct sock *sk)
 static int l2tp_ip_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	struct sockaddr_l2tpip *addr = (struct sockaddr_l2tpip *) uaddr;
+	struct sockaddr_l2tpip *addr = (struct sockaddr_l2tpip *)uaddr;
 	struct net *net = sock_net(sk);
 	int ret;
 	int chk_addr_ret;
@@ -316,7 +316,7 @@ static int l2tp_ip_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 
 static int l2tp_ip_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
-	struct sockaddr_l2tpip *lsa = (struct sockaddr_l2tpip *) uaddr;
+	struct sockaddr_l2tpip *lsa = (struct sockaddr_l2tpip *)uaddr;
 	int rc;
 
 	if (addr_len < sizeof(*lsa))
@@ -456,7 +456,7 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	skb_reset_transport_header(skb);
 
 	/* Insert 0 session_id */
-	*((__be32 *) skb_put(skb, 4)) = 0;
+	*((__be32 *)skb_put(skb, 4)) = 0;
 
 	/* Copy user data into skb */
 	rc = memcpy_from_msg(skb_put(skb, len), msg, len);
@@ -467,7 +467,7 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl4 = &inet->cork.fl.u.ip4;
 	if (connected)
-		rt = (struct rtable *) __sk_dst_check(sk, 0);
+		rt = (struct rtable *)__sk_dst_check(sk, 0);
 
 	rcu_read_lock();
 	if (rt == NULL) {
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 4799bec87b33..d17b9fe1180f 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -138,7 +138,7 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 
 	/* Point to L2TP header */
 	optr = ptr = skb->data;
-	session_id = ntohl(*((__be32 *) ptr));
+	session_id = ntohl(*((__be32 *)ptr));
 	ptr += 4;
 
 	/* RFC3931: L2TP/IP packets have the first 4 bytes containing
@@ -188,7 +188,7 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	if ((skb->data[0] & 0xc0) != 0xc0)
 		goto discard;
 
-	tunnel_id = ntohl(*(__be32 *) &skb->data[4]);
+	tunnel_id = ntohl(*(__be32 *)&skb->data[4]);
 	iph = ipv6_hdr(skb);
 
 	read_lock_bh(&l2tp_ip6_lock);
@@ -276,7 +276,7 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct sockaddr_l2tpip6 *addr = (struct sockaddr_l2tpip6 *) uaddr;
+	struct sockaddr_l2tpip6 *addr = (struct sockaddr_l2tpip6 *)uaddr;
 	struct net *net = sock_net(sk);
 	__be32 v4addr = 0;
 	int bound_dev_if;
@@ -375,8 +375,8 @@ static int l2tp_ip6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 static int l2tp_ip6_connect(struct sock *sk, struct sockaddr *uaddr,
 			    int addr_len)
 {
-	struct sockaddr_l2tpip6 *lsa = (struct sockaddr_l2tpip6 *) uaddr;
-	struct sockaddr_in6	*usin = (struct sockaddr_in6 *) uaddr;
+	struct sockaddr_l2tpip6 *lsa = (struct sockaddr_l2tpip6 *)uaddr;
+	struct sockaddr_in6	*usin = (struct sockaddr_in6 *)uaddr;
 	struct in6_addr	*daddr;
 	int	addr_type;
 	int rc;
@@ -548,7 +548,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		daddr = &lsa->l2tp_addr;
 		if (np->sndflow) {
 			fl6.flowlabel = lsa->l2tp_flowinfo & IPV6_FLOWINFO_MASK;
-			if (fl6.flowlabel&IPV6_FLOWLABEL_MASK) {
+			if (fl6.flowlabel & IPV6_FLOWLABEL_MASK) {
 				flowlabel = fl6_sock_lookup(sk, fl6.flowlabel);
 				if (IS_ERR(flowlabel))
 					return -EINVAL;
@@ -594,7 +594,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			if (IS_ERR(flowlabel))
 				return -EINVAL;
 		}
-		if (!(opt->opt_nflen|opt->opt_flen))
+		if (!(opt->opt_nflen | opt->opt_flen))
 			opt = NULL;
 	}
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index c54cb59593ef..a0bd39f0d5fe 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -351,7 +351,7 @@ static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
  */
 static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 {
-	struct sock *sk = (struct sock *) chan->private;
+	struct sock *sk = (struct sock *)chan->private;
 	struct l2tp_session *session;
 	struct l2tp_tunnel *tunnel;
 	int uhlen, headroom;
@@ -1343,7 +1343,7 @@ static int pppol2tp_session_getsockopt(struct sock *sk,
 		break;
 
 	case PPPOL2TP_SO_REORDERTO:
-		*val = (int) jiffies_to_msecs(session->reorder_timeout);
+		*val = (int)jiffies_to_msecs(session->reorder_timeout);
 		l2tp_info(session, L2TP_MSG_CONTROL,
 			  "%s: get reorder_timeout=%d\n", session->name, *val);
 		break;
@@ -1407,7 +1407,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	if (put_user(len, optlen))
 		goto end_put_sess;
 
-	if (copy_to_user((void __user *) optval, &val, len))
+	if (copy_to_user((void __user *)optval, &val, len))
 		goto end_put_sess;
 
 	err = 0;
-- 
2.17.1

