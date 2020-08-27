Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F8C25492D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgH0Lb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 07:31:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728400AbgH0LaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 07:30:00 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D6D4D1EA6CFD8E40146B;
        Thu, 27 Aug 2020 19:29:05 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 27 Aug 2020
 19:28:58 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <pabeni@redhat.com>, <fw@strlen.de>, <edumazet@google.com>,
        <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <rdunlap@infradead.org>, <pablo@netfilter.org>,
        <decui@microsoft.com>, <jakub@cloudflare.com>, <jeremy@azazel.net>,
        <kafai@fb.com>, <ast@kernel.org>, <keescook@chromium.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix some comments
Date:   Thu, 27 Aug 2020 07:27:49 -0400
Message-ID: <20200827112749.47698-1-linmiaohe@huawei.com>
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

Fix some comments, including wrong function name, duplicated word and so
on.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/skbuff.h  | 4 ++--
 include/uapi/linux/in.h | 2 +-
 net/core/sock.c         | 2 +-
 net/ipv4/raw.c          | 2 +-
 net/l3mdev/l3mdev.c     | 2 +-
 net/socket.c            | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e8bca74857a3..8d9ab50b08c9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -71,7 +71,7 @@
  *	NETIF_F_IPV6_CSUM - Driver (device) is only able to checksum plain
  *			  TCP or UDP packets over IPv6. These are specifically
  *			  unencapsulated packets of the form IPv6|TCP or
- *			  IPv4|UDP where the Next Header field in the IPv6
+ *			  IPv6|UDP where the Next Header field in the IPv6
  *			  header is either TCP or UDP. IPv6 extension headers
  *			  are not supported with this feature. This feature
  *			  cannot be set in features for a device with
@@ -2667,7 +2667,7 @@ static inline int pskb_network_may_pull(struct sk_buff *skb, unsigned int len)
  *
  * Using max(32, L1_CACHE_BYTES) makes sense (especially with RPS)
  * to reduce average number of cache lines per packet.
- * get_rps_cpus() for example only access one 64 bytes aligned block :
+ * get_rps_cpu() for example only access one 64 bytes aligned block :
  * NET_IP_ALIGN(2) + ethernet_header(14) + IP_header(20/40) + ports(8)
  */
 #ifndef NET_SKB_PAD
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 3d0d8231dc19..7d6687618d80 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -135,7 +135,7 @@ struct in_addr {
  * this socket to prevent accepting spoofed ones.
  */
 #define IP_PMTUDISC_INTERFACE		4
-/* weaker version of IP_PMTUDISC_INTERFACE, which allos packets to get
+/* weaker version of IP_PMTUDISC_INTERFACE, which allows packets to get
  * fragmented if they exeed the interface mtu
  */
 #define IP_PMTUDISC_OMIT		5
diff --git a/net/core/sock.c b/net/core/sock.c
index 64d2aec5ed45..7ed32a8fc132 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3240,7 +3240,7 @@ void sk_common_release(struct sock *sk)
 		sk->sk_prot->destroy(sk);
 
 	/*
-	 * Observation: when sock_common_release is called, processes have
+	 * Observation: when sk_common_release is called, processes have
 	 * no access to socket. But net still has.
 	 * Step one, detach it from networking:
 	 *
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index ea4c36e93824..1170653a89cd 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -611,7 +611,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	} else if (!ipc.oif) {
 		ipc.oif = inet->uc_index;
 	} else if (ipv4_is_lbcast(daddr) && inet->uc_index) {
-		/* oif is set, packet is to local broadcast and
+		/* oif is set, packet is to local broadcast
 		 * and uc_index is set. oif is most likely set
 		 * by sk_bound_dev_if. If uc_index != oif check if the
 		 * oif is an L3 master and uc_index is an L3 slave.
diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index e71ca5aec684..864326f150e2 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -154,7 +154,7 @@ int l3mdev_master_upper_ifindex_by_index_rcu(struct net *net, int ifindex)
 EXPORT_SYMBOL_GPL(l3mdev_master_upper_ifindex_by_index_rcu);
 
 /**
- *	l3mdev_fib_table - get FIB table id associated with an L3
+ *	l3mdev_fib_table_rcu - get FIB table id associated with an L3
  *                             master interface
  *	@dev: targeted interface
  */
diff --git a/net/socket.c b/net/socket.c
index dbbe8ea7d395..0c0144604f81 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3610,7 +3610,7 @@ int kernel_getsockname(struct socket *sock, struct sockaddr *addr)
 EXPORT_SYMBOL(kernel_getsockname);
 
 /**
- *	kernel_peername - get the address which the socket is connected (kernel space)
+ *	kernel_getpeername - get the address which the socket is connected (kernel space)
  *	@sock: socket
  *	@addr: address holder
  *
@@ -3671,7 +3671,7 @@ int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
 EXPORT_SYMBOL(kernel_sendpage_locked);
 
 /**
- *	kernel_shutdown - shut down part of a full-duplex connection (kernel space)
+ *	kernel_sock_shutdown - shut down part of a full-duplex connection (kernel space)
  *	@sock: socket
  *	@how: connection part
  *
-- 
2.19.1

