Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7FD57C141
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiGTX6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGTX6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:58:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453A919C12
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4664B8214E
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 23:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D88FC3411E;
        Wed, 20 Jul 2022 23:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658361481;
        bh=kzQkIwrgVK+OqsOdqeP8rErzjAGH4hJoPZecs7lFSN8=;
        h=From:To:Cc:Subject:Date:From;
        b=Q+hazYscXjLoabNwTqa53SX38tA+0NfNxtqFj39RwZK5cQ0ue10rK/KLBuKehpndr
         NnXWnjF3xsXFhoMUt1FGjpfEnunSvLHEfprTlYueXwxr24Ll9crPk3R9gnZtw64/XR
         fc0VSTYSJnGek8gNnspHnFLKI3iRfOzrN9HyFh9+MLFcLtK3drVgdAZYioypmwCSUj
         qxwqHfzWR2lOhyegqd7EUliPper3CZyLx5m8vwFYphzIXTltpJQIpgrKzhg0SH6clG
         zw7MtbH6vQskQZo+sD5MHFjWfXjqu0/ihtgaas1Wpz11SvaTwtBLVjtUHppYa6zLXq
         v68ZfsOvIp7Ew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: add missing includes and forward declarations under net/
Date:   Wed, 20 Jul 2022 16:57:58 -0700
Message-Id: <20220720235758.2373415-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds missing includes to headers under include/net.
All these problems are currently masked by the existing users
including the missing dependency before the broken header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/lapb.h                |  5 +++++
 include/net/af_vsock.h              |  1 +
 include/net/amt.h                   |  3 +++
 include/net/ax88796.h               |  2 ++
 include/net/bond_options.h          |  8 ++++++++
 include/net/codel_qdisc.h           |  1 +
 include/net/datalink.h              |  7 +++++++
 include/net/dcbevent.h              |  2 ++
 include/net/dcbnl.h                 |  2 ++
 include/net/dn_dev.h                |  1 +
 include/net/dn_fib.h                |  2 ++
 include/net/dn_neigh.h              |  2 ++
 include/net/dn_nsp.h                |  6 ++++++
 include/net/dn_route.h              |  3 +++
 include/net/erspan.h                |  3 +++
 include/net/esp.h                   |  1 +
 include/net/ethoc.h                 |  3 +++
 include/net/firewire.h              |  2 ++
 include/net/fq.h                    |  4 ++++
 include/net/garp.h                  |  2 ++
 include/net/gtp.h                   |  4 ++++
 include/net/gue.h                   |  3 +++
 include/net/hwbm.h                  |  2 ++
 include/net/ila.h                   |  2 ++
 include/net/inet6_connection_sock.h |  2 ++
 include/net/inet_common.h           |  6 ++++++
 include/net/inet_frag.h             |  3 +++
 include/net/ip6_route.h             | 20 ++++++++++----------
 include/net/ipcomp.h                |  2 ++
 include/net/ipconfig.h              |  2 ++
 include/net/llc_c_ac.h              |  7 +++++++
 include/net/llc_c_st.h              |  4 ++++
 include/net/llc_s_ac.h              |  4 ++++
 include/net/llc_s_ev.h              |  1 +
 include/net/mpls_iptunnel.h         |  3 +++
 include/net/mrp.h                   |  4 ++++
 include/net/ncsi.h                  |  2 ++
 include/net/netevent.h              |  1 +
 include/net/netns/can.h             |  1 +
 include/net/netns/core.h            |  2 ++
 include/net/netns/generic.h         |  1 +
 include/net/netns/ipv4.h            |  1 +
 include/net/netns/mctp.h            |  1 +
 include/net/netns/mpls.h            |  2 ++
 include/net/netns/nexthop.h         |  1 +
 include/net/netns/sctp.h            |  3 +++
 include/net/netns/unix.h            |  2 ++
 include/net/netrom.h                |  1 +
 include/net/p8022.h                 |  5 +++++
 include/net/phonet/pep.h            |  3 +++
 include/net/phonet/phonet.h         |  4 ++++
 include/net/phonet/pn_dev.h         |  5 +++++
 include/net/pptp.h                  |  3 +++
 include/net/psnap.h                 |  5 +++++
 include/net/regulatory.h            |  3 +++
 include/net/rose.h                  |  1 +
 include/net/secure_seq.h            |  2 ++
 include/net/smc.h                   |  7 +++++++
 include/net/stp.h                   |  2 ++
 include/net/transp_v6.h             |  2 ++
 include/net/tun_proto.h             |  3 ++-
 include/net/udplite.h               |  1 +
 include/net/xdp_priv.h              |  1 +
 63 files changed, 183 insertions(+), 11 deletions(-)

diff --git a/include/linux/lapb.h b/include/linux/lapb.h
index eb56472f23b2..b5333f9413dc 100644
--- a/include/linux/lapb.h
+++ b/include/linux/lapb.h
@@ -6,6 +6,11 @@
 #ifndef	LAPB_KERNEL_H
 #define	LAPB_KERNEL_H
 
+#include <linux/skbuff.h>
+#include <linux/timer.h>
+
+struct net_device;
+
 #define	LAPB_OK			0
 #define	LAPB_BADTOKEN		1
 #define	LAPB_INVALUE		2
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index f742e50207fb..1c53c4c4d88f 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
+#include <net/sock.h>
 #include <uapi/linux/vm_sockets.h>
 
 #include "vsock_addr.h"
diff --git a/include/net/amt.h b/include/net/amt.h
index 0e40c3d64fcf..b154ecb3d1c4 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -7,6 +7,9 @@
 
 #include <linux/siphash.h>
 #include <linux/jhash.h>
+#include <linux/netdevice.h>
+#include <net/gro_cells.h>
+#include <net/rtnetlink.h>
 
 enum amt_msg_type {
 	AMT_MSG_DISCOVERY = 1,
diff --git a/include/net/ax88796.h b/include/net/ax88796.h
index 2ed23a368602..b658471f97f0 100644
--- a/include/net/ax88796.h
+++ b/include/net/ax88796.h
@@ -8,6 +8,8 @@
 #ifndef __NET_AX88796_PLAT_H
 #define __NET_AX88796_PLAT_H
 
+#include <linux/types.h>
+
 struct sk_buff;
 struct net_device;
 struct platform_device;
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index d2aea5cf1e41..69292ecc0325 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -7,6 +7,14 @@
 #ifndef _NET_BOND_OPTIONS_H
 #define _NET_BOND_OPTIONS_H
 
+#include <linux/bits.h>
+#include <linux/limits.h>
+#include <linux/types.h>
+#include <linux/string.h>
+
+struct netlink_ext_ack;
+struct nlattr;
+
 #define BOND_OPT_MAX_NAMELEN 32
 #define BOND_OPT_VALID(opt) ((opt) < BOND_OPT_LAST)
 #define BOND_MODE_ALL_EX(x) (~(x))
diff --git a/include/net/codel_qdisc.h b/include/net/codel_qdisc.h
index 58b6d0ebea10..7d3d9219f4fe 100644
--- a/include/net/codel_qdisc.h
+++ b/include/net/codel_qdisc.h
@@ -49,6 +49,7 @@
  * Implemented on linux by Dave Taht and Eric Dumazet
  */
 
+#include <net/codel.h>
 #include <net/pkt_sched.h>
 
 /* Qdiscs using codel plugin must use codel_skb_cb in their own cb[] */
diff --git a/include/net/datalink.h b/include/net/datalink.h
index d9b7faaa539f..c837ffc7ebf8 100644
--- a/include/net/datalink.h
+++ b/include/net/datalink.h
@@ -2,6 +2,13 @@
 #ifndef _NET_INET_DATALINK_H_
 #define _NET_INET_DATALINK_H_
 
+#include <linux/list.h>
+
+struct llc_sap;
+struct net_device;
+struct packet_type;
+struct sk_buff;
+
 struct datalink_proto {
         unsigned char   type[8];
 
diff --git a/include/net/dcbevent.h b/include/net/dcbevent.h
index 43e34131a53f..02700262f71a 100644
--- a/include/net/dcbevent.h
+++ b/include/net/dcbevent.h
@@ -8,6 +8,8 @@
 #ifndef _DCB_EVENT_H
 #define _DCB_EVENT_H
 
+struct notifier_block;
+
 enum dcbevent_notif_type {
 	DCB_APP_EVENT = 1,
 };
diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
index e4ad58c4062c..2b2d86fb3131 100644
--- a/include/net/dcbnl.h
+++ b/include/net/dcbnl.h
@@ -10,6 +10,8 @@
 
 #include <linux/dcbnl.h>
 
+struct net_device;
+
 struct dcb_app_type {
 	int	ifindex;
 	struct dcb_app	  app;
diff --git a/include/net/dn_dev.h b/include/net/dn_dev.h
index 595b4f6c1eb1..bec303ea8367 100644
--- a/include/net/dn_dev.h
+++ b/include/net/dn_dev.h
@@ -2,6 +2,7 @@
 #ifndef _NET_DN_DEV_H
 #define _NET_DN_DEV_H
 
+#include <linux/netdevice.h>
 
 struct dn_dev;
 
diff --git a/include/net/dn_fib.h b/include/net/dn_fib.h
index ddd6565957b3..1929a3cd5ebe 100644
--- a/include/net/dn_fib.h
+++ b/include/net/dn_fib.h
@@ -4,6 +4,8 @@
 
 #include <linux/netlink.h>
 #include <linux/refcount.h>
+#include <linux/rtnetlink.h>
+#include <net/fib_rules.h>
 
 extern const struct nla_policy rtm_dn_policy[];
 
diff --git a/include/net/dn_neigh.h b/include/net/dn_neigh.h
index 2e3e7793973a..1f7df98bfc33 100644
--- a/include/net/dn_neigh.h
+++ b/include/net/dn_neigh.h
@@ -2,6 +2,8 @@
 #ifndef _NET_DN_NEIGH_H
 #define _NET_DN_NEIGH_H
 
+#include <net/neighbour.h>
+
 /*
  * The position of the first two fields of
  * this structure are critical - SJW
diff --git a/include/net/dn_nsp.h b/include/net/dn_nsp.h
index f83932b864a9..a4a18fee0b7c 100644
--- a/include/net/dn_nsp.h
+++ b/include/net/dn_nsp.h
@@ -6,6 +6,12 @@
     
 *******************************************************************************/
 /* dn_nsp.c functions prototyping */
+#include <linux/atomic.h>
+#include <linux/types.h>
+#include <net/sock.h>
+
+struct sk_buff;
+struct sk_buff_head;
 
 void dn_nsp_send_data_ack(struct sock *sk);
 void dn_nsp_send_oth_ack(struct sock *sk);
diff --git a/include/net/dn_route.h b/include/net/dn_route.h
index 6f1e94ac0bdf..88c0300236cc 100644
--- a/include/net/dn_route.h
+++ b/include/net/dn_route.h
@@ -7,6 +7,9 @@
     
 *******************************************************************************/
 
+#include <linux/types.h>
+#include <net/dst.h>
+
 struct sk_buff *dn_alloc_skb(struct sock *sk, int size, gfp_t pri);
 int dn_route_output_sock(struct dst_entry __rcu **pprt, struct flowidn *,
 			 struct sock *sk, int flags);
diff --git a/include/net/erspan.h b/include/net/erspan.h
index 0d9e86bd9893..6cb4cbd6a48f 100644
--- a/include/net/erspan.h
+++ b/include/net/erspan.h
@@ -58,6 +58,9 @@
  * GRE proto ERSPAN type I/II = 0x88BE, type III = 0x22EB
  */
 
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/skbuff.h>
 #include <uapi/linux/erspan.h>
 
 #define ERSPAN_VERSION	0x1	/* ERSPAN type II */
diff --git a/include/net/esp.h b/include/net/esp.h
index 9c5637d41d95..322950727dd0 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -5,6 +5,7 @@
 #include <linux/skbuff.h>
 
 struct ip_esp_hdr;
+struct xfrm_state;
 
 static inline struct ip_esp_hdr *ip_esp_hdr(const struct sk_buff *skb)
 {
diff --git a/include/net/ethoc.h b/include/net/ethoc.h
index 78519ed42ab4..73810f3ca492 100644
--- a/include/net/ethoc.h
+++ b/include/net/ethoc.h
@@ -10,6 +10,9 @@
 #ifndef LINUX_NET_ETHOC_H
 #define LINUX_NET_ETHOC_H 1
 
+#include <linux/if.h>
+#include <linux/types.h>
+
 struct ethoc_platform_data {
 	u8 hwaddr[IFHWADDRLEN];
 	s8 phy_id;
diff --git a/include/net/firewire.h b/include/net/firewire.h
index 299e5df38552..2442d645e412 100644
--- a/include/net/firewire.h
+++ b/include/net/firewire.h
@@ -2,6 +2,8 @@
 #ifndef _NET_FIREWIRE_H
 #define _NET_FIREWIRE_H
 
+#include <linux/types.h>
+
 /* Pseudo L2 address */
 #define FWNET_ALEN	16
 union fwnet_hwaddr {
diff --git a/include/net/fq.h b/include/net/fq.h
index 2eccbbd2b559..07b5aff6ec58 100644
--- a/include/net/fq.h
+++ b/include/net/fq.h
@@ -7,6 +7,10 @@
 #ifndef __NET_SCHED_FQ_H
 #define __NET_SCHED_FQ_H
 
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
 struct fq_tin;
 
 /**
diff --git a/include/net/garp.h b/include/net/garp.h
index 4d9a0c6a2e5f..59a07b171def 100644
--- a/include/net/garp.h
+++ b/include/net/garp.h
@@ -2,6 +2,8 @@
 #ifndef _NET_GARP_H
 #define _NET_GARP_H
 
+#include <linux/if_ether.h>
+#include <linux/types.h>
 #include <net/stp.h>
 
 #define GARP_PROTOCOL_ID	0x1
diff --git a/include/net/gtp.h b/include/net/gtp.h
index c1d6169df331..2a503f035d18 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -2,6 +2,10 @@
 #ifndef _GTP_H_
 #define _GTP_H_
 
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <net/rtnetlink.h>
+
 /* General GTP protocol related definitions. */
 
 #define GTP0_PORT	3386
diff --git a/include/net/gue.h b/include/net/gue.h
index e42402f180b7..dfca298bec9c 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -30,6 +30,9 @@
  * may refer to options placed after this field.
  */
 
+#include <asm/byteorder.h>
+#include <linux/types.h>
+
 struct guehdr {
 	union {
 		struct {
diff --git a/include/net/hwbm.h b/include/net/hwbm.h
index c81444611a22..aa495decec35 100644
--- a/include/net/hwbm.h
+++ b/include/net/hwbm.h
@@ -2,6 +2,8 @@
 #ifndef _HWBM_H
 #define _HWBM_H
 
+#include <linux/mutex.h>
+
 struct hwbm_pool {
 	/* Capacity of the pool */
 	int size;
diff --git a/include/net/ila.h b/include/net/ila.h
index f98dcd5791b0..73ebe5eab272 100644
--- a/include/net/ila.h
+++ b/include/net/ila.h
@@ -8,6 +8,8 @@
 #ifndef _NET_ILA_H
 #define _NET_ILA_H
 
+struct sk_buff;
+
 int ila_xlat_outgoing(struct sk_buff *skb);
 int ila_xlat_incoming(struct sk_buff *skb);
 
diff --git a/include/net/inet6_connection_sock.h b/include/net/inet6_connection_sock.h
index 7392f959a405..025bd8d3c769 100644
--- a/include/net/inet6_connection_sock.h
+++ b/include/net/inet6_connection_sock.h
@@ -11,6 +11,8 @@
 
 #include <linux/types.h>
 
+struct flowi;
+struct flowi6;
 struct request_sock;
 struct sk_buff;
 struct sock;
diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cad2a611efde..cec453c18f1d 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -3,6 +3,10 @@
 #define _INET_COMMON_H
 
 #include <linux/indirect_call_wrapper.h>
+#include <linux/net.h>
+#include <linux/netdev_features.h>
+#include <linux/types.h>
+#include <net/sock.h>
 
 extern const struct proto_ops inet_stream_ops;
 extern const struct proto_ops inet_dgram_ops;
@@ -12,6 +16,8 @@ extern const struct proto_ops inet_dgram_ops;
  */
 
 struct msghdr;
+struct net;
+struct page;
 struct sock;
 struct sockaddr;
 struct socket;
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 911ad930867d..0b0876610553 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -4,6 +4,9 @@
 
 #include <linux/rhashtable-types.h>
 #include <linux/completion.h>
+#include <linux/in6.h>
+#include <linux/rbtree_types.h>
+#include <linux/refcount.h>
 
 /* Per netns frag queues directory */
 struct fqdir {
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index ca2d6b60e1ec..035d61d50a98 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -2,6 +2,16 @@
 #ifndef _NET_IP6_ROUTE_H
 #define _NET_IP6_ROUTE_H
 
+#include <net/addrconf.h>
+#include <net/flow.h>
+#include <net/ip6_fib.h>
+#include <net/sock.h>
+#include <net/lwtunnel.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/route.h>
+#include <net/nexthop.h>
+
 struct route_info {
 	__u8			type;
 	__u8			length;
@@ -19,16 +29,6 @@ struct route_info {
 	__u8			prefix[];	/* 0,8 or 16 */
 };
 
-#include <net/addrconf.h>
-#include <net/flow.h>
-#include <net/ip6_fib.h>
-#include <net/sock.h>
-#include <net/lwtunnel.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/route.h>
-#include <net/nexthop.h>
-
 #define RT6_LOOKUP_F_IFACE		0x00000001
 #define RT6_LOOKUP_F_REACHABLE		0x00000002
 #define RT6_LOOKUP_F_HAS_SADDR		0x00000004
diff --git a/include/net/ipcomp.h b/include/net/ipcomp.h
index fee6fc451597..c31108295079 100644
--- a/include/net/ipcomp.h
+++ b/include/net/ipcomp.h
@@ -2,11 +2,13 @@
 #ifndef _NET_IPCOMP_H
 #define _NET_IPCOMP_H
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
 #define IPCOMP_SCRATCH_SIZE     65400
 
 struct crypto_comp;
+struct ip_comp_hdr;
 
 struct ipcomp_data {
 	u16 threshold;
diff --git a/include/net/ipconfig.h b/include/net/ipconfig.h
index e3534299bd2a..8276897d0c2e 100644
--- a/include/net/ipconfig.h
+++ b/include/net/ipconfig.h
@@ -7,6 +7,8 @@
 
 /* The following are initdata: */
 
+#include <linux/types.h>
+
 extern int ic_proto_enabled;	/* Protocols enabled (see IC_xxx) */
 extern int ic_set_manually;	/* IPconfig parameters set manually */
 
diff --git a/include/net/llc_c_ac.h b/include/net/llc_c_ac.h
index e766300b3e99..3e1f76786d7b 100644
--- a/include/net/llc_c_ac.h
+++ b/include/net/llc_c_ac.h
@@ -16,6 +16,13 @@
  * Connection state transition actions
  * (Fb = F bit; Pb = P bit; Xb = X bit)
  */
+
+#include <linux/types.h>
+
+struct sk_buff;
+struct sock;
+struct timer_list;
+
 #define LLC_CONN_AC_CLR_REMOTE_BUSY			 1
 #define LLC_CONN_AC_CONN_IND				 2
 #define LLC_CONN_AC_CONN_CONFIRM			 3
diff --git a/include/net/llc_c_st.h b/include/net/llc_c_st.h
index 48f3f891b2f9..53823d61d8b6 100644
--- a/include/net/llc_c_st.h
+++ b/include/net/llc_c_st.h
@@ -11,6 +11,10 @@
  *
  * See the GNU General Public License for more details.
  */
+
+#include <net/llc_c_ac.h>
+#include <net/llc_c_ev.h>
+
 /* Connection component state management */
 /* connection states */
 #define LLC_CONN_OUT_OF_SVC		 0	/* prior to allocation */
diff --git a/include/net/llc_s_ac.h b/include/net/llc_s_ac.h
index a61b98c108ee..f71790305bc9 100644
--- a/include/net/llc_s_ac.h
+++ b/include/net/llc_s_ac.h
@@ -11,6 +11,10 @@
  *
  * See the GNU General Public License for more details.
  */
+
+struct llc_sap;
+struct sk_buff;
+
 /* SAP component actions */
 #define SAP_ACT_UNITDATA_IND	1
 #define SAP_ACT_SEND_UI		2
diff --git a/include/net/llc_s_ev.h b/include/net/llc_s_ev.h
index 84db3a59ed28..fb7df1d70af3 100644
--- a/include/net/llc_s_ev.h
+++ b/include/net/llc_s_ev.h
@@ -13,6 +13,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <net/llc.h>
 
 /* Defines SAP component events */
 /* Types of events (possible values in 'ev->type') */
diff --git a/include/net/mpls_iptunnel.h b/include/net/mpls_iptunnel.h
index 9deb3a3735da..0c71c27979fb 100644
--- a/include/net/mpls_iptunnel.h
+++ b/include/net/mpls_iptunnel.h
@@ -6,6 +6,9 @@
 #ifndef _NET_MPLS_IPTUNNEL_H
 #define _NET_MPLS_IPTUNNEL_H 1
 
+#include <linux/types.h>
+#include <net/lwtunnel.h>
+
 struct mpls_iptunnel_encap {
 	u8	labels;
 	u8	ttl_propagate;
diff --git a/include/net/mrp.h b/include/net/mrp.h
index 1c308c034e1a..92cd3fb6cf9d 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -2,6 +2,10 @@
 #ifndef _NET_MRP_H
 #define _NET_MRP_H
 
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
 #define MRP_END_MARK		0x0
 
 struct mrp_pdu_hdr {
diff --git a/include/net/ncsi.h b/include/net/ncsi.h
index fbefe80361ee..08a50d9acb0a 100644
--- a/include/net/ncsi.h
+++ b/include/net/ncsi.h
@@ -2,6 +2,8 @@
 #ifndef __NET_NCSI_H
 #define __NET_NCSI_H
 
+#include <linux/types.h>
+
 /*
  * The NCSI device states seen from external. More NCSI device states are
  * only visible internally (in net/ncsi/internal.h). When the NCSI device
diff --git a/include/net/netevent.h b/include/net/netevent.h
index 4107016c3bb4..1be3757a8b7f 100644
--- a/include/net/netevent.h
+++ b/include/net/netevent.h
@@ -14,6 +14,7 @@
 
 struct dst_entry;
 struct neighbour;
+struct notifier_block ;
 
 struct netevent_redirect {
 	struct dst_entry *old;
diff --git a/include/net/netns/can.h b/include/net/netns/can.h
index 52fbd8291a96..48b79f7e6236 100644
--- a/include/net/netns/can.h
+++ b/include/net/netns/can.h
@@ -7,6 +7,7 @@
 #define __NETNS_CAN_H__
 
 #include <linux/spinlock.h>
+#include <linux/timer.h>
 
 struct can_dev_rcv_lists;
 struct can_pkg_stats;
diff --git a/include/net/netns/core.h b/include/net/netns/core.h
index 388244e315e7..8249060cf5d0 100644
--- a/include/net/netns/core.h
+++ b/include/net/netns/core.h
@@ -2,6 +2,8 @@
 #ifndef __NETNS_CORE_H__
 #define __NETNS_CORE_H__
 
+#include <linux/types.h>
+
 struct ctl_table_header;
 struct prot_inuse;
 
diff --git a/include/net/netns/generic.h b/include/net/netns/generic.h
index 8a1ab47c3fb3..7ce68183f6e1 100644
--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -8,6 +8,7 @@
 
 #include <linux/bug.h>
 #include <linux/rcupdate.h>
+#include <net/net_namespace.h>
 
 /*
  * Generic net pointers are to be used by modules to put some private
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index ce0cc4e8d8c7..c7320ef356d9 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -9,6 +9,7 @@
 #include <linux/uidgid.h>
 #include <net/inet_frag.h>
 #include <linux/rcupdate.h>
+#include <linux/seqlock.h>
 #include <linux/siphash.h>
 
 struct ctl_table_header;
diff --git a/include/net/netns/mctp.h b/include/net/netns/mctp.h
index acedef12a35e..1db8f9aaddb4 100644
--- a/include/net/netns/mctp.h
+++ b/include/net/netns/mctp.h
@@ -6,6 +6,7 @@
 #ifndef __NETNS_MCTP_H__
 #define __NETNS_MCTP_H__
 
+#include <linux/mutex.h>
 #include <linux/types.h>
 
 struct netns_mctp {
diff --git a/include/net/netns/mpls.h b/include/net/netns/mpls.h
index a7bdcfbb0b28..19ad2574b267 100644
--- a/include/net/netns/mpls.h
+++ b/include/net/netns/mpls.h
@@ -6,6 +6,8 @@
 #ifndef __NETNS_MPLS_H__
 #define __NETNS_MPLS_H__
 
+#include <linux/types.h>
+
 struct mpls_route;
 struct ctl_table_header;
 
diff --git a/include/net/netns/nexthop.h b/include/net/netns/nexthop.h
index 1849e77eb68a..434239b37014 100644
--- a/include/net/netns/nexthop.h
+++ b/include/net/netns/nexthop.h
@@ -6,6 +6,7 @@
 #ifndef __NETNS_NEXTHOP_H__
 #define __NETNS_NEXTHOP_H__
 
+#include <linux/notifier.h>
 #include <linux/rbtree.h>
 
 struct netns_nexthop {
diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index 40240722cdca..a681147aecd8 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -2,6 +2,9 @@
 #ifndef __NETNS_SCTP_H__
 #define __NETNS_SCTP_H__
 
+#include <linux/timer.h>
+#include <net/snmp.h>
+
 struct sock;
 struct proc_dir_entry;
 struct sctp_mib;
diff --git a/include/net/netns/unix.h b/include/net/netns/unix.h
index 6f1a33df061d..9859d134d5a8 100644
--- a/include/net/netns/unix.h
+++ b/include/net/netns/unix.h
@@ -5,6 +5,8 @@
 #ifndef __NETNS_UNIX_H__
 #define __NETNS_UNIX_H__
 
+#include <linux/spinlock.h>
+
 struct unix_table {
 	spinlock_t		*locks;
 	struct hlist_head	*buckets;
diff --git a/include/net/netrom.h b/include/net/netrom.h
index 80f15b1c1a48..f0565a5987d1 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <linux/refcount.h>
 #include <linux/seq_file.h>
+#include <net/ax25.h>
 
 #define	NR_NETWORK_LEN			15
 #define	NR_TRANSPORT_LEN		5
diff --git a/include/net/p8022.h b/include/net/p8022.h
index c2bacc66bfbc..b690ffcad66b 100644
--- a/include/net/p8022.h
+++ b/include/net/p8022.h
@@ -1,6 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NET_P8022_H
 #define _NET_P8022_H
+
+struct net_device;
+struct packet_type;
+struct sk_buff;
+
 struct datalink_proto *
 register_8022_client(unsigned char type,
 		     int (*func)(struct sk_buff *skb,
diff --git a/include/net/phonet/pep.h b/include/net/phonet/pep.h
index 27b1ab5e4e6d..645dddf5ce77 100644
--- a/include/net/phonet/pep.h
+++ b/include/net/phonet/pep.h
@@ -10,6 +10,9 @@
 #ifndef NET_PHONET_PEP_H
 #define NET_PHONET_PEP_H
 
+#include <linux/skbuff.h>
+#include <net/phonet/phonet.h>
+
 struct pep_sock {
 	struct pn_sock		pn_sk;
 
diff --git a/include/net/phonet/phonet.h b/include/net/phonet/phonet.h
index a27bdc6cfeab..862f1719b523 100644
--- a/include/net/phonet/phonet.h
+++ b/include/net/phonet/phonet.h
@@ -10,6 +10,10 @@
 #ifndef AF_PHONET_H
 #define AF_PHONET_H
 
+#include <linux/phonet.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
 /*
  * The lower layers may not require more space, ever. Make sure it's
  * enough.
diff --git a/include/net/phonet/pn_dev.h b/include/net/phonet/pn_dev.h
index 05b49d4d2b11..e9dc8dca5817 100644
--- a/include/net/phonet/pn_dev.h
+++ b/include/net/phonet/pn_dev.h
@@ -10,6 +10,11 @@
 #ifndef PN_DEV_H
 #define PN_DEV_H
 
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+struct net;
+
 struct phonet_device_list {
 	struct list_head list;
 	struct mutex lock;
diff --git a/include/net/pptp.h b/include/net/pptp.h
index 383e25ca53a7..e63176bdd4c8 100644
--- a/include/net/pptp.h
+++ b/include/net/pptp.h
@@ -2,6 +2,9 @@
 #ifndef _NET_PPTP_H
 #define _NET_PPTP_H
 
+#include <linux/types.h>
+#include <net/gre.h>
+
 #define PPP_LCP_ECHOREQ 0x09
 #define PPP_LCP_ECHOREP 0x0A
 #define SC_RCV_BITS     (SC_RCV_B7_1|SC_RCV_B7_0|SC_RCV_ODDP|SC_RCV_EVNP)
diff --git a/include/net/psnap.h b/include/net/psnap.h
index 7cb0c8ab4171..88802b0754ad 100644
--- a/include/net/psnap.h
+++ b/include/net/psnap.h
@@ -2,6 +2,11 @@
 #ifndef _NET_PSNAP_H
 #define _NET_PSNAP_H
 
+struct datalink_proto;
+struct sk_buff;
+struct packet_type;
+struct net_device;
+
 struct datalink_proto *
 register_snap_client(const unsigned char *desc,
 		     int (*rcvfunc)(struct sk_buff *, struct net_device *,
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 47f06f6f5a67..896191f420d5 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -1,3 +1,4 @@
+
 #ifndef __NET_REGULATORY_H
 #define __NET_REGULATORY_H
 /*
@@ -19,6 +20,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/ieee80211.h>
+#include <linux/nl80211.h>
 #include <linux/rcupdate.h>
 
 /**
diff --git a/include/net/rose.h b/include/net/rose.h
index 0f0a4ce0fee7..f192a64ddef2 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -9,6 +9,7 @@
 #define _ROSE_H 
 
 #include <linux/rose.h>
+#include <net/ax25.h>
 #include <net/sock.h>
 
 #define	ROSE_ADDR_LEN			5
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index dac91aa38c5a..21e7fa2a1813 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,6 +4,8 @@
 
 #include <linux/types.h>
 
+struct net;
+
 u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
 u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
diff --git a/include/net/smc.h b/include/net/smc.h
index e441aa97ad61..37f829d9c6e5 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -11,6 +11,13 @@
 #ifndef _SMC_H
 #define _SMC_H
 
+#include <linux/device.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+struct sock;
+
 #define SMC_MAX_PNETID_LEN	16	/* Max. length of PNET id */
 
 struct smc_hashinfo {
diff --git a/include/net/stp.h b/include/net/stp.h
index 2914e6d53490..528103fce2c0 100644
--- a/include/net/stp.h
+++ b/include/net/stp.h
@@ -2,6 +2,8 @@
 #ifndef _NET_STP_H
 #define _NET_STP_H
 
+#include <linux/if_ether.h>
+
 struct stp_proto {
 	unsigned char	group_address[ETH_ALEN];
 	void		(*rcv)(const struct stp_proto *, struct sk_buff *,
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index da06613c9603..b830463e3dff 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -3,6 +3,7 @@
 #define _TRANSP_V6_H
 
 #include <net/checksum.h>
+#include <net/sock.h>
 
 /* IPv6 transport protocols */
 extern struct proto rawv6_prot;
@@ -12,6 +13,7 @@ extern struct proto tcpv6_prot;
 extern struct proto pingv6_prot;
 
 struct flowi6;
+struct ipcm6_cookie;
 
 /* extension headers */
 int ipv6_exthdrs_init(void);
diff --git a/include/net/tun_proto.h b/include/net/tun_proto.h
index 2ea3deba4c99..7b0de7852908 100644
--- a/include/net/tun_proto.h
+++ b/include/net/tun_proto.h
@@ -1,7 +1,8 @@
 #ifndef __NET_TUN_PROTO_H
 #define __NET_TUN_PROTO_H
 
-#include <linux/kernel.h>
+#include <linux/if_ether.h>
+#include <linux/types.h>
 
 /* One byte protocol values as defined by VXLAN-GPE and NSH. These will
  * hopefully get a shared IANA registry.
diff --git a/include/net/udplite.h b/include/net/udplite.h
index a3c53110d30b..0143b373602e 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -6,6 +6,7 @@
 #define _UDPLITE_H
 
 #include <net/ip6_checksum.h>
+#include <net/udp.h>
 
 /* UDP-Lite socket options */
 #define UDPLITE_SEND_CSCOV   10 /* sender partial coverage (as sent)      */
diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index a2d58b1a12e1..c9df68d5f258 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -3,6 +3,7 @@
 #define __LINUX_NET_XDP_PRIV_H__
 
 #include <linux/rhashtable.h>
+#include <net/xdp.h>
 
 /* Private to net/core/xdp.c, but used by trace/events/xdp.h */
 struct xdp_mem_allocator {
-- 
2.36.1

