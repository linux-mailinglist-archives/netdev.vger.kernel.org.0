Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D067DD82
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbfHAOLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:11:13 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40942 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731715AbfHAOLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:11:13 -0400
Received: by mail-wr1-f43.google.com with SMTP id r1so73738880wrl.7
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=f4LDeN1BCVpQRarigN0QFvT9Jwyy6FSKpUSE7RoU8GU=;
        b=N+r0mVpcbY1ypUv5b5L3aLu8N7hXY1c/pVW31zNAdgq38gMIcHrPfRRBZioOXxCZTk
         8iD4zZTT26mHDheeUJUramymZ2bNrB8xePbqObGraZ3YHJh2ufmw4JhgAli5XRNH0q2K
         UrvbG6lWf+HCN85PfF2iGXUuIeDb3tOkGcbUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=f4LDeN1BCVpQRarigN0QFvT9Jwyy6FSKpUSE7RoU8GU=;
        b=OpI1gWL7qTXN7Hu/9f8JOX3UVIEKxsEfqNmTBWPxhWmOIxAxVqQxDFic/yJgpeQa+1
         48zYFIduR5a/9EOFBSDgMoBkUprV7ddbv8bEOLsmXxgj9Tp3aZWWz3n3zcgo4vVQwMzf
         whg+NTcneKHyHzE6qoWINz4XdJyJnTcIBWeekTeEMWOpnHy9IIv80DFliPQNrDAcyuwR
         hE1uk3x5vM7XmPMe6VUo3VbP3lY7S3zFlS82PA3k0nMV57ogyE5BXiGqiYH0Mr9YgNqC
         WF4M9Vc4h+oKSmW5B1VydlxnNU28GTm1m+IBV8ZiksvuyxMg5zsOlNZzrh8BOLSzOoHD
         nCMw==
X-Gm-Message-State: APjAAAWb11I6J64KINYf1R+YlNKWmA6odhHFZqclG6Q6WhFRpN9eFlF9
        97WBp2vaktuZnaXbw/R8KIDfnQ==
X-Google-Smtp-Source: APXvYqy6qfRLKe7WJy1/4+MqooOvHOyR1TMuBGZzIiJsz1Uz1MVWWRH6XxLrMjRqpMfQa3UAaPxK5A==
X-Received: by 2002:a5d:5308:: with SMTP id e8mr5367339wrv.219.1564668669317;
        Thu, 01 Aug 2019 07:11:09 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c6sm74824752wma.25.2019.08.01.07.11.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 07:11:08 -0700 (PDT)
Subject: Re: [net-next,rfc] net: bridge: mdb: Extend with multicast LLADDR
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, idosch@mellanox.com,
        andrew@lunn.ch, allan.nielsen@microchip.com
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, petrm@mellanox.com,
        tglx@linutronix.de, fw@strlen.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1564663840-27721-1-git-send-email-horatiu.vultur@microchip.com>
 <f758fdbf-4e0a-57b3-f13d-23e893ba7458@cumulusnetworks.com>
Message-ID: <1db865a6-9deb-fbd2-dee6-83609fcc2d95@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 17:11:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f758fdbf-4e0a-57b3-f13d-23e893ba7458@cumulusnetworks.com>
Content-Type: multipart/mixed;
 boundary="------------D7A5C32EF7AAAB22C7D9BE02"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------D7A5C32EF7AAAB22C7D9BE02
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 01/08/2019 17:07, Nikolay Aleksandrov wrote:
> Hi Horatiu,
> Overall I think MDB is the right way, we'd like to contain the multicast code.
> A few comments below.
> 
> On 01/08/2019 15:50, Horatiu Vultur wrote:
[snip]
>>
>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>> Co-developed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
>> Signed-off-by: Allan W. Nielsen <allan.nielsen@microchip.com>
>> ---
>>  include/linux/if_bridge.h      |  1 +
>>  include/uapi/linux/if_bridge.h |  1 +
>>  net/bridge/br_device.c         |  7 +++++--
>>  net/bridge/br_forward.c        |  3 ++-
>>  net/bridge/br_input.c          | 13 ++++++++++--
>>  net/bridge/br_mdb.c            | 47 +++++++++++++++++++++++++++++++++++-------
>>  net/bridge/br_multicast.c      |  4 +++-
>>  net/bridge/br_private.h        |  3 ++-
>>  8 files changed, 64 insertions(+), 15 deletions(-)
>>
> 
> Overall I don't think we need this BR_PKT_MULTICAST_L2, we could do the below much
> easier and without the checks if you use a per-mdb flag that says it's to be treated
> as a MULTICAST_L2 entry. Then you remove all of the BR_PKT_MULTICAST_L2 code (see the
> attached patch based on this one for example). and continue processing it as it is processed today.
> We'll keep the fast-path with minimal number of new conditionals.
> 
> Something like the patch I've attached to this reply, note that it is not complete
> just to show the intent, you'll have to re-work br_mdb_notify() to make it proper
> and there're most probably other details I've missed. If you find even better/less
> complex way to do it then please do.
> 
> Cheers,
>  Nik

Oops, I sent back your original patch. Here's the actually changed version
I was talking about.

Thanks,
 Nik




--------------D7A5C32EF7AAAB22C7D9BE02
Content-Type: text/x-patch;
 name="0001-net-bridge-mdb-Extend-with-multicast-LLADDR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-net-bridge-mdb-Extend-with-multicast-LLADDR.patch"

From 01dbe0b22da96efcc6fbf46bd3b22353fca32f5d Mon Sep 17 00:00:00 2001
From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Thu, 1 Aug 2019 14:50:40 +0200
Subject: [RFC incomplete] net: bridge: mdb: Extend with multicast LLADDR

Based on the discussion on the topic[1], we extend the functionality of
the 'bridge mdb' command to accept link layer multicast address. This
required only few changes and it fits nicely with the current
implementation and also the old implementation was not changed.

In this patch, we have added a MAC address to the union in 'struct br_ip'.
If we want to continue like this we should properly rename the structure as
it is not an IP any more.

To create a group for two of the front ports the following entries can
be added:
bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1

Now the entries will be display as following:
dev br0 port eth0 grp 01:00:00:00:00:04 permanent offload vid 1
dev br0 port eth1 grp 01:00:00:00:00:04 permanent offload vid 1

This requires changes to iproute2 as well, see the follogin patch for that.

Now if frame with dmac '01:00:00:00:00:04' will arrive at one of the front
ports. If we have HW offload support, then the frame will be forwarded by
the switch, and need not to go to the CPU. In a pure SW world, the frame is
forwarded by the SW bridge, which will flooded it only the ports which are
part of the group.

So far so good. This is an important part of the problem we wanted to solve.

But, there is one drawback of this approach. If you want to add two of the
front ports and br0 to receive the frame then I can't see a way of doing it
with the bridge mdb command. To do that it requireds many more changes to
the existing code.

Example:
bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
bridge mdb add dev br0 port br0 grp 01:00:00:00:00:04 permanent vid 1 // This looks wrong.

We believe we come a long way by re-using the facilities in MDB (thanks for
convincing us in doing this), but we are still not completely happy with
the result.

If I only look at the user-interface (iproute2), and completely ignore all
the implementation details, then I still think that the FDB sub command is
more suitable for this. Today, FDB is for unicast, and MDB is for multicast.
We could change this such that MDB is for IP-multicast, and FDB is
forwarding in general (we should prevent FDB in install IP-multicast rules,
but we suggest to allow it to install MAC-Multicast rules).

The example from above would now look like this:
bridge fdb add 01:00:00:00:00:04 dev eth0 static self master
bridge fdb add 01:00:00:00:00:04 dev eth1 static self master
bridge fdb add 01:00:00:00:00:04 dev br0 static self master

It would be very similar to the "bridge vlan" command which also allow to
specify groups with and without br0.

Next observation is on the hashing data structure. In 'net_bridge_mdb_entry'
we only use/need the net_bridge_port_group/ports member (and the MAC
address, which we hacked into the br_ip struct) when we are a L2-multicast
entry. This type allow use to re-use the br_multicast_flood function
which does a lot of the work for us.

Also, the key used to do the lookup in the FDB is already a MAC address
(no need to hack the br_ip).

Regarding the events generated by switchdev: In the current proposal this
is a SWITCHDEV_OBJ_ID_PORT_MDB which refer to the switchdev_obj_port_mdb
type. If we changed to use the SWITCHDEV_FDB_ADD_TO_BRIDGE event, then
the associated data type would be switchdev_notifier_fdb_info - which also
has the information we need.

Using the FDB database, can still reuse the net_bridge_port_group type (and
associated functions), and I other parts from the MDB call graph as well.

If this sounds appealing, then we can do a proposal based on the idea.

If the MDB patch is what we can agree on, then we will continue polish this
and look for a solution to control the inclusion/exclusion of the br0
device (hints will be most appreciated).

[1] https://patchwork.ozlabs.org/patch/1136878/

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Co-developed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
Signed-off-by: Allan W. Nielsen <allan.nielsen@microchip.com>
---
 include/linux/if_bridge.h      |  1 +
 include/uapi/linux/if_bridge.h |  2 ++
 net/bridge/br_device.c         |  2 +-
 net/bridge/br_input.c          |  2 +-
 net/bridge/br_mdb.c            | 58 ++++++++++++++++++++++++++++------
 net/bridge/br_multicast.c      |  6 ++--
 net/bridge/br_private.h        | 10 ++++--
 7 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 9e57c4411734..68f2558b1a23 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -16,6 +16,7 @@
 struct br_ip {
 	union {
 		__be32	ip4;
+		__u8	mac[ETH_ALEN];
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr ip6;
 #endif
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1b3c2b643a02..50b4b481fac5 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -238,12 +238,14 @@ struct br_mdb_entry {
 	__u8 state;
 #define MDB_FLAGS_OFFLOAD	(1 << 0)
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
+#define MDB_FLAGS_L2MCAST	(1 << 2)
 	__u8 flags;
 	__u16 vid;
 	struct {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			__u8	mac[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 681b72862c16..8ffceaac4c80 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -94,7 +94,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb)))
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst))
 			br_multicast_flood(mdst, skb, false, true);
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 09b1dd8cd853..331a1ee87c62 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -130,7 +130,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	case BR_PKT_MULTICAST:
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
-		    br_multicast_querier_exists(br, eth_hdr(skb))) {
+		    br_multicast_querier_exists(br, eth_hdr(skb), mdst)) {
 			if ((mdst && mdst->host_joined) ||
 			    br_multicast_is_router(br)) {
 				local_rcv = true;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 428af1abf8cc..2da17b769760 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -62,6 +62,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 		e->flags |= MDB_FLAGS_OFFLOAD;
 	if (flags & MDB_PG_FLAGS_FAST_LEAVE)
 		e->flags |= MDB_FLAGS_FAST_LEAVE;
+	if (flags & MDB_PG_FLAGS_L2MCAST)
+		e->flags |= MDB_FLAGS_L2MCAST;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
@@ -69,12 +71,19 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
 	memset(ip, 0, sizeof(struct br_ip));
 	ip->vid = entry->vid;
 	ip->proto = entry->addr.proto;
-	if (ip->proto == htons(ETH_P_IP))
+	switch (ip->proto) {
+	case htons(ETH_P_IP):
 		ip->u.ip4 = entry->addr.u.ip4;
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-	else
+	case htons(ETH_P_IPV6):
 		ip->u.ip6 = entry->addr.u.ip6;
+		break;
 #endif
+	default:
+		ether_addr_copy(ip->u.mac, entry->addr.u.mac);
+		break;
+	}
 }
 
 static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
@@ -110,6 +119,7 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 		      pp = &p->next) {
 			struct nlattr *nest_ent;
 			struct br_mdb_entry e;
+			u16 flags = p->flags;
 
 			port = p->port;
 			if (!port)
@@ -118,13 +128,22 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			memset(&e, 0, sizeof(e));
 			e.ifindex = port->dev->ifindex;
 			e.vid = p->addr.vid;
-			__mdb_entry_fill_flags(&e, p->flags);
-			if (p->addr.proto == htons(ETH_P_IP))
+			if (mp->l2_mcast)
+				flags |= MDB_PG_FLAGS_L2MCAST;
+			__mdb_entry_fill_flags(&e, flags);
+			switch (p->addr.proto) {
+			case htons(ETH_P_IP):
 				e.addr.u.ip4 = p->addr.u.ip4;
+				break;
 #if IS_ENABLED(CONFIG_IPV6)
-			if (p->addr.proto == htons(ETH_P_IPV6))
+			case htons(ETH_P_IPV6):
 				e.addr.u.ip6 = p->addr.u.ip6;
+				break;
 #endif
+			default:
+				ether_addr_copy(e.addr.u.mac, p->addr.u.mac);
+				break;
+			}
 			e.addr.proto = p->addr.proto;
 			nest_ent = nla_nest_start_noflag(skb,
 							 MDBA_MDB_ENTRY_INFO);
@@ -324,12 +343,19 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
 		.vid = entry->vid,
 	};
 
-	if (entry->addr.proto == htons(ETH_P_IP))
+	switch (entry->addr.proto) {
+	case htons(ETH_P_IP):
 		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-	else
+	case htons(ETH_P_IPV6):
 		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
+		break;
 #endif
+	default:
+		ether_addr_copy(mdb.addr, entry->addr.u.mac);
+		break;
+	}
 
 	mdb.obj.orig_dev = dev;
 	switch (type) {
@@ -369,12 +395,19 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
 	int err = -ENOBUFS;
 
 	port_dev = __dev_get_by_index(net, entry->ifindex);
-	if (entry->addr.proto == htons(ETH_P_IP))
+	switch (entry->addr.proto) {
+	case htons(ETH_P_IP):
 		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-	else
+	case htons(ETH_P_IPV6):
 		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
+		break;
 #endif
+	default:
+		ether_addr_copy(mdb.addr, entry->addr.u.mac);
+		break;
+	}
 
 	mdb.obj.orig_dev = port_dev;
 	if (p && port_dev && type == RTM_NEWMDB) {
@@ -425,6 +458,7 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 #if IS_ENABLED(CONFIG_IPV6)
 	entry.addr.u.ip6 = group->u.ip6;
 #endif
+	ether_addr_copy(group->u.mac, entry.addr.u.mac);
 	entry.vid = group->vid;
 	__mdb_entry_fill_flags(&entry, flags);
 	__br_mdb_notify(dev, port, &entry, type);
@@ -512,8 +546,12 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
 		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
 			return false;
 #endif
-	} else
+	} else if ((entry->flags & MDB_FLAGS_L2MCAST) &&
+		   !is_multicast_ether_addr(entry->addr.u.mac)) {
 		return false;
+	} else {
+		return false;
+	}
 	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY)
 		return false;
 	if (entry->vid >= VLAN_VID_MASK)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3d4b2817687f..43cfc8b18765 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -133,7 +133,9 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
 		break;
 #endif
 	default:
-		return NULL;
+		ip.proto = 0;
+		ether_addr_copy(ip.u.mac, eth_hdr(skb)->h_dest);
+		break;
 	}
 
 	return br_mdb_ip_get_rcu(br, &ip);
@@ -2233,7 +2235,7 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
 	memset(&eth, 0, sizeof(eth));
 	eth.h_proto = htons(proto);
 
-	ret = br_multicast_querier_exists(br, &eth);
+	ret = br_multicast_querier_exists(br, &eth, NULL);
 
 unlock:
 	rcu_read_unlock();
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c4fd307fbfdc..be9e5f327c86 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -200,6 +200,7 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
+#define MDB_PG_FLAGS_L2MCAST	BIT(3)
 
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
@@ -220,6 +221,7 @@ struct net_bridge_mdb_entry {
 	struct timer_list		timer;
 	struct br_ip			addr;
 	bool				host_joined;
+	bool				l2_mcast;
 	struct hlist_node		mdb_node;
 };
 
@@ -734,7 +736,8 @@ __br_multicast_querier_exists(struct net_bridge *br,
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
-					       struct ethhdr *eth)
+					       struct ethhdr *eth,
+					       struct net_bridge_mdb_entry *dst)
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
@@ -746,7 +749,7 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 			&br->ip6_other_query, true);
 #endif
 	default:
-		return false;
+		return !!(dst && dst->l2_mcast);
 	}
 }
 
@@ -814,7 +817,8 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
 }
 
 static inline bool br_multicast_querier_exists(struct net_bridge *br,
-					       struct ethhdr *eth)
+					       struct ethhdr *eth,
+					       struct net_bridge_mdb_entry *dst)
 {
 	return false;
 }
-- 
2.21.0


--------------D7A5C32EF7AAAB22C7D9BE02--
