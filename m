Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA31160035
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgBOTmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:42:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52058 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgBOTmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 14:42:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=lzzBz0lyO7DqqZ12iR3gF2tgGZrcch7TH2HzAyRrzgM=; b=gIMoGpAjWxsyRpiL4hDvVR4wDt
        UfzyI3UsgG0ZNCS+72FYh2hJdhvD58gIwU+rVC4HFJyAgwU8cycymstcKzfBBph7TdFZrkxyCvh7m
        UO/yRawgwmPt6hDKxlvGKwxtdPtCy7aw57ldwWFtGZpKlgcB3ZDVtJzWpuz5KT0rc/F4jK/JErxl/
        D57YbsOUr/Xs1i9Z74Kez9ot1bFYX49xVgsVYtq5WU9uevN/p68cH4ES6/AJz56VPP+nzdKMq4hc7
        qc1E9kipweX+oE+x363V8JXNWCHH2aoei7xVcgMfirz0GK/FOhEVl5JljDqXSgFt+Lu6QOLt/RmSm
        DUOzLFtg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j33Kp-00007w-5D; Sat, 15 Feb 2020 19:42:39 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] net/sock.h: fix all kernel-doc warnings
Message-ID: <f679d925-9645-51a5-53ba-f85d35bb8a24@infradead.org>
Date:   Sat, 15 Feb 2020 11:42:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix all kernel-doc warnings for <net/sock.h>.
Fixes these warnings:

../include/net/sock.h:232: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_listener' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_tw_dr' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_rcv_wnd' not described in 'sock_common'
../include/net/sock.h:232: warning: Function parameter or member 'skc_tw_rcv_nxt' not described in 'sock_common'

../include/net/sock.h:498: warning: Function parameter or member 'sk_rx_skb_cache' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_wq_raw' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'tcp_rtx_queue' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_tx_skb_cache' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_route_forced_caps' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_txtime_report_errors' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_validate_xmit_skb' not described in 'sock'
../include/net/sock.h:498: warning: Function parameter or member 'sk_bpf_storage' not described in 'sock'

../include/net/sock.h:2024: warning: No description found for return value of 'sk_wmem_alloc_get'
../include/net/sock.h:2035: warning: No description found for return value of 'sk_rmem_alloc_get'
../include/net/sock.h:2046: warning: No description found for return value of 'sk_has_allocations'
../include/net/sock.h:2082: warning: No description found for return value of 'skwq_has_sleeper'
../include/net/sock.h:2244: warning: No description found for return value of 'sk_page_frag'
../include/net/sock.h:2444: warning: Function parameter or member 'tcp_rx_skb_cache_key' not described in 'DECLARE_STATIC_KEY_FALSE'
../include/net/sock.h:2444: warning: Excess function parameter 'sk' description in 'DECLARE_STATIC_KEY_FALSE'
../include/net/sock.h:2444: warning: Excess function parameter 'skb' description in 'DECLARE_STATIC_KEY_FALSE'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Alternatively, some fields could be marked as "private:" to exclude
them from the documentation process completely, as is done for sk_wq_raw
here.

 include/net/sock.h |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

--- lnx-56-rc1.orig/include/net/sock.h
+++ lnx-56-rc1/include/net/sock.h
@@ -117,19 +117,26 @@ typedef __u64 __bitwise __addrpair;
  *	struct sock_common - minimal network layer representation of sockets
  *	@skc_daddr: Foreign IPv4 addr
  *	@skc_rcv_saddr: Bound local IPv4 addr
+ *	@skc_addrpair: 8-byte-aligned __u64 union of @skc_daddr & @skc_rcv_saddr
  *	@skc_hash: hash value used with various protocol lookup tables
  *	@skc_u16hashes: two u16 hash values used by UDP lookup tables
  *	@skc_dport: placeholder for inet_dport/tw_dport
  *	@skc_num: placeholder for inet_num/tw_num
+ *	@skc_portpair: __u32 union of @skc_dport & @skc_num
  *	@skc_family: network address family
  *	@skc_state: Connection state
  *	@skc_reuse: %SO_REUSEADDR setting
  *	@skc_reuseport: %SO_REUSEPORT setting
+ *	@skc_ipv6only: socket is IPV6 only
+ *	@skc_net_refcnt: socket is using net ref counting
  *	@skc_bound_dev_if: bound device index if != 0
  *	@skc_bind_node: bind hash linkage for various protocol lookup tables
  *	@skc_portaddr_node: second hash linkage for UDP/UDP-Lite protocol
  *	@skc_prot: protocol handlers inside a network family
  *	@skc_net: reference to the network namespace of this socket
+ *	@skc_v6_daddr: IPV6 destination address
+ *	@skc_v6_rcv_saddr: IPV6 source address
+ *	@skc_cookie: socket's cookie value
  *	@skc_node: main hash linkage for various protocol lookup tables
  *	@skc_nulls_node: main hash linkage for TCP/UDP/UDP-Lite protocol
  *	@skc_tx_queue_mapping: tx queue number for this connection
@@ -137,7 +144,15 @@ typedef __u64 __bitwise __addrpair;
  *	@skc_flags: place holder for sk_flags
  *		%SO_LINGER (l_onoff), %SO_BROADCAST, %SO_KEEPALIVE,
  *		%SO_OOBINLINE settings, %SO_TIMESTAMPING settings
+ *	@skc_listener: connection request listener socket (aka rsk_listener)
+ *		[union with @skc_flags]
+ *	@skc_tw_dr: (aka tw_dr) ptr to &struct inet_timewait_death_row
+ *		[union with @skc_flags]
  *	@skc_incoming_cpu: record/match cpu processing incoming packets
+ *	@skc_rcv_wnd: (aka rsk_rcv_wnd) TCP receive window size (possibly scaled)
+ *		[union with @skc_incoming_cpu]
+ *	@skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
+ *		[union with @skc_incoming_cpu]
  *	@skc_refcnt: reference count
  *
  *	This is the minimal network layer representation of sockets, the header
@@ -245,6 +260,7 @@ struct bpf_sk_storage;
   *	@sk_dst_cache: destination cache
   *	@sk_dst_pending_confirm: need to confirm neighbour
   *	@sk_policy: flow policy
+  *	@sk_rx_skb_cache: cache copy of recently accessed RX skb
   *	@sk_receive_queue: incoming packets
   *	@sk_wmem_alloc: transmit queue bytes committed
   *	@sk_tsq_flags: TCP Small Queues flags
@@ -265,6 +281,8 @@ struct bpf_sk_storage;
   *	@sk_no_check_rx: allow zero checksum in RX packets
   *	@sk_route_caps: route capabilities (e.g. %NETIF_F_TSO)
   *	@sk_route_nocaps: forbidden route capabilities (e.g NETIF_F_GSO_MASK)
+  *	@sk_route_forced_caps: static, forced route capabilities
+  *		(set in tcp_init_sock())
   *	@sk_gso_type: GSO type (e.g. %SKB_GSO_TCPV4)
   *	@sk_gso_max_size: Maximum GSO segment size to build
   *	@sk_gso_max_segs: Maximum number of GSO segments
@@ -303,6 +321,8 @@ struct bpf_sk_storage;
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
+  *	@tcp_rtx_queue: TCP re-transmit queue [union with @sk_send_head]
+  *	@sk_tx_skb_cache: cache copy of recently accessed TX skb
   *	@sk_security: used by security modules
   *	@sk_mark: generic packet mark
   *	@sk_cgrp_data: cgroup data for this cgroup
@@ -313,11 +333,14 @@ struct bpf_sk_storage;
   *	@sk_write_space: callback to indicate there is bf sending space available
   *	@sk_error_report: callback to indicate errors (e.g. %MSG_ERRQUEUE)
   *	@sk_backlog_rcv: callback to process the backlog
+  *	@sk_validate_xmit_skb: ptr to an optional validate function
   *	@sk_destruct: called at sock freeing time, i.e. when all refcnt == 0
   *	@sk_reuseport_cb: reuseport group container
+  *	@sk_bpf_storage: ptr to cache and control for bpf_sk_storage
   *	@sk_rcu: used during RCU grace period
   *	@sk_clockid: clockid used by time-based scheduling (SO_TXTIME)
   *	@sk_txtime_deadline_mode: set deadline mode for SO_TXTIME
+  *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
   */
 struct sock {
@@ -393,7 +416,9 @@ struct sock {
 	struct sk_filter __rcu	*sk_filter;
 	union {
 		struct socket_wq __rcu	*sk_wq;
+		/* private: */
 		struct socket_wq	*sk_wq_raw;
+		/* public: */
 	};
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
@@ -2017,7 +2042,7 @@ static inline int skb_copy_to_page_nocac
  * sk_wmem_alloc_get - returns write allocations
  * @sk: socket
  *
- * Returns sk_wmem_alloc minus initial offset of one
+ * Return: sk_wmem_alloc minus initial offset of one
  */
 static inline int sk_wmem_alloc_get(const struct sock *sk)
 {
@@ -2028,7 +2053,7 @@ static inline int sk_wmem_alloc_get(cons
  * sk_rmem_alloc_get - returns read allocations
  * @sk: socket
  *
- * Returns sk_rmem_alloc
+ * Return: sk_rmem_alloc
  */
 static inline int sk_rmem_alloc_get(const struct sock *sk)
 {
@@ -2039,7 +2064,7 @@ static inline int sk_rmem_alloc_get(cons
  * sk_has_allocations - check if allocations are outstanding
  * @sk: socket
  *
- * Returns true if socket has write or read allocations
+ * Return: true if socket has write or read allocations
  */
 static inline bool sk_has_allocations(const struct sock *sk)
 {
@@ -2050,7 +2075,7 @@ static inline bool sk_has_allocations(co
  * skwq_has_sleeper - check if there are any waiting processes
  * @wq: struct socket_wq
  *
- * Returns true if socket_wq has waiting processes
+ * Return: true if socket_wq has waiting processes
  *
  * The purpose of the skwq_has_sleeper and sock_poll_wait is to wrap the memory
  * barrier call. They were added due to the race found within the tcp code.
@@ -2238,6 +2263,9 @@ struct sk_buff *sk_stream_alloc_skb(stru
  * gfpflags_allow_blocking() isn't enough here as direct reclaim may nest
  * inside other socket operations and end up recursing into sk_page_frag()
  * while it's already in use.
+ *
+ * Return: a per task page_frag if context allows that,
+ * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
@@ -2432,6 +2460,7 @@ static inline void skb_setup_tx_timestam
 			   &skb_shinfo(skb)->tskey);
 }
 
+DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
@@ -2440,7 +2469,6 @@ static inline void skb_setup_tx_timestam
  * This routine must be called with interrupts disabled or with the socket
  * locked so that the sk_buff queue operation is ok.
 */
-DECLARE_STATIC_KEY_FALSE(tcp_rx_skb_cache_key);
 static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);


