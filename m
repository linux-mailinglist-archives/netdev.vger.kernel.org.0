Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00E7DD6A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfHAOHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 10:07:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46094 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731504AbfHAOHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 10:07:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so73725031wru.13
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=XoMikWCt2BvkT6bPfOK2U8c/fCL/4NTf2rKAmIgSuMw=;
        b=MUQmZ8ra3678e0GFkUDOz9SXjHdhyvyHUNoLY1GJd1aXafm4Z/KsTGc36hk5kvVwrn
         gKjszIaAaJ/Wct6In5htTNAVIY4cGmvKKXFnYa7kWNzpXVSLQONwuiXUVDlHYrFY0KMQ
         jkg3dSC3b8G0wvKoOULGZGBM+10wvpsMqgKPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=XoMikWCt2BvkT6bPfOK2U8c/fCL/4NTf2rKAmIgSuMw=;
        b=D9AeaI6rsnBoRQNJZQyzRS/7sARsbRk8TvW9PF+xwko4wheFgaYD5gk3wArDWGH7Ud
         /H9zSsvCE9A8d9Z/jARp/w0qgDi66a3MK8l9yxj0iESqri+sqpNM7D6H7TCTI55RkNxW
         uOVWB6Q+vNQCvm2xTqHe+dUEugS6CSbXNVhPZlk4RQFwR9aMViAL1E/nCHZd2Su2WMwz
         k59dviEBP+wnKTAOg6augWefIBVl1tC9uV5jINfbqKhmmj4gVKdRw/BEGAqoM6O7NgfM
         h2Ki7PydhcELvo/9TcYSCcZkNUeGDk35mBf0gnHDNrewBTf+3cWE5dRxfE+CDsj8ZtiW
         SZhg==
X-Gm-Message-State: APjAAAWbFiMVqbQgdBu8FtFd6rjgTLawXZGl4wdHll2gUXjtjUfiUvts
        Wra3SICbz6tESUXqFLA3Z/6200qYdO9afQ==
X-Google-Smtp-Source: APXvYqyZfNYyDv6YNSOWVxezJ2sIvOMgfWBIjpa67rrpFSpiecq0Fto5l23AEUTaYX063jXD6ph16A==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr132471179wra.328.1564668449271;
        Thu, 01 Aug 2019 07:07:29 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v12sm61655413wrr.87.2019.08.01.07.07.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 07:07:28 -0700 (PDT)
Subject: Re: [net-next,rfc] net: bridge: mdb: Extend with multicast LLADDR
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, idosch@mellanox.com,
        andrew@lunn.ch, allan.nielsen@microchip.com
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com, petrm@mellanox.com,
        tglx@linutronix.de, fw@strlen.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1564663840-27721-1-git-send-email-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <f758fdbf-4e0a-57b3-f13d-23e893ba7458@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 17:07:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1564663840-27721-1-git-send-email-horatiu.vultur@microchip.com>
Content-Type: multipart/mixed;
 boundary="------------F92E64033FFB71AE03742F84"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------F92E64033FFB71AE03742F84
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Horatiu,
Overall I think MDB is the right way, we'd like to contain the multicast code.
A few comments below.

On 01/08/2019 15:50, Horatiu Vultur wrote:
> Based on the discussion on the topic[1], we extend the functionality of
> the 'bridge mdb' command to accept link layer multicast address. This
> required only few changes and it fits nicely with the current
> implementation and also the old implementation was not changed.
> 
> In this patch, we have added a MAC address to the union in 'struct br_ip'.
> If we want to continue like this we should properly rename the structure as
> it is not an IP any more.
> 
> To create a group for two of the front ports the following entries can
> be added:
> bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
> bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
> 
> Now the entries will be display as following:
> dev br0 port eth0 grp 01:00:00:00:00:04 permanent offload vid 1
> dev br0 port eth1 grp 01:00:00:00:00:04 permanent offload vid 1
> 
> This requires changes to iproute2 as well, see the follogin patch for that.
> 
> Now if frame with dmac '01:00:00:00:00:04' will arrive at one of the front
> ports. If we have HW offload support, then the frame will be forwarded by
> the switch, and need not to go to the CPU. In a pure SW world, the frame is
> forwarded by the SW bridge, which will flooded it only the ports which are
> part of the group.
> 
> So far so good. This is an important part of the problem we wanted to solve.
> 
> But, there is one drawback of this approach. If you want to add two of the
> front ports and br0 to receive the frame then I can't see a way of doing it
> with the bridge mdb command. To do that it requireds many more changes to
> the existing code.
> 
> Example:
> bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
> bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
> bridge mdb add dev br0 port br0 grp 01:00:00:00:00:04 permanent vid 1 // This looks wrong.
> 
> We believe we come a long way by re-using the facilities in MDB (thanks for
> convincing us in doing this), but we are still not completely happy with
> the result.
> 

Just add self argument for the bridge mdb command, no need to specify it twice.

> If I only look at the user-interface (iproute2), and completely ignore all
> the implementation details, then I still think that the FDB sub command is
> more suitable for this. Today, FDB is for unicast, and MDB is for multicast.
> We could change this such that MDB is for IP-multicast, and FDB is
> forwarding in general (we should prevent FDB in install IP-multicast rules,
> but we suggest to allow it to install MAC-Multicast rules).
> 
> The example from above would now look like this:
> bridge fdb add 01:00:00:00:00:04 dev eth0 static self master
> bridge fdb add 01:00:00:00:00:04 dev eth1 static self master
> bridge fdb add 01:00:00:00:00:04 dev br0 static self master
> 
> It would be very similar to the "bridge vlan" command which also allow to
> specify groups with and without br0.
> 
> Next observation is on the hashing data structure. In 'net_bridge_mdb_entry'
> we only use/need the net_bridge_port_group/ports member (and the MAC
> address, which we hacked into the br_ip struct) when we are a L2-multicast
> entry. This type allow use to re-use the br_multicast_flood function
> which does a lot of the work for us.
> 
> Also, the key used to do the lookup in the FDB is already a MAC address
> (no need to hack the br_ip).
> 

Look at it as extending br_ip, it's not a hack but a valid mcast use-case.
In fact br_ip is an internal structure which can easily be renamed.

> Regarding the events generated by switchdev: In the current proposal this
> is a SWITCHDEV_OBJ_ID_PORT_MDB which refer to the switchdev_obj_port_mdb
> type. If we changed to use the SWITCHDEV_FDB_ADD_TO_BRIDGE event, then
> the associated data type would be switchdev_notifier_fdb_info - which also
> has the information we need.
> 
> Using the FDB database, can still reuse the net_bridge_port_group type (and
> associated functions), and I other parts from the MDB call graph as well.
> 

We don't want to mix these.

> If this sounds appealing, then we can do a proposal based on the idea.
> 
> If the MDB patch is what we can agree on, then we will continue polish this
> and look for a solution to control the inclusion/exclusion of the br0
> device (hints will be most appreciated).
> 

Yes, please. Let's work on this implementation. Some code comments below.

> [1] https://patchwork.ozlabs.org/patch/1136878/
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> Co-developed-by: Allan W. Nielsen <allan.nielsen@microchip.com>
> Signed-off-by: Allan W. Nielsen <allan.nielsen@microchip.com>
> ---
>  include/linux/if_bridge.h      |  1 +
>  include/uapi/linux/if_bridge.h |  1 +
>  net/bridge/br_device.c         |  7 +++++--
>  net/bridge/br_forward.c        |  3 ++-
>  net/bridge/br_input.c          | 13 ++++++++++--
>  net/bridge/br_mdb.c            | 47 +++++++++++++++++++++++++++++++++++-------
>  net/bridge/br_multicast.c      |  4 +++-
>  net/bridge/br_private.h        |  3 ++-
>  8 files changed, 64 insertions(+), 15 deletions(-)
> 

Overall I don't think we need this BR_PKT_MULTICAST_L2, we could do the below much
easier and without the checks if you use a per-mdb flag that says it's to be treated
as a MULTICAST_L2 entry. Then you remove all of the BR_PKT_MULTICAST_L2 code (see the
attached patch based on this one for example). and continue processing it as it is processed today.
We'll keep the fast-path with minimal number of new conditionals.

Something like the patch I've attached to this reply, note that it is not complete
just to show the intent, you'll have to re-work br_mdb_notify() to make it proper
and there're most probably other details I've missed. If you find even better/less
complex way to do it then please do.

Cheers,
 Nik

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index f3fab5d..07b092a 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -16,6 +16,7 @@
>  struct br_ip {
>  	union {
>  		__be32	ip4;
> +		__u8	mac[ETH_ALEN];
>  #if IS_ENABLED(CONFIG_IPV6)
>  		struct in6_addr ip6;
>  #endif
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 773e476..e535a81 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -243,6 +243,7 @@ struct br_mdb_entry {
>  		union {
>  			__be32	ip4;
>  			struct in6_addr ip6;
> +			__u8	mac[ETH_ALEN];
>  		} u;
>  		__be16		proto;
>  	} addr;
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index c05def8..b2d9041 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -83,7 +83,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  		br_flood(br, skb, BR_PKT_BROADCAST, false, true);
>  	} else if (is_multicast_ether_addr(dest)) {
>  		if (unlikely(netpoll_tx_running(dev))) {
> -			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
> +			br_flood(br, skb, BR_PKT_MULTICAST_IP, false, true);
>  			goto out;
>  		}
>  		if (br_multicast_rcv(br, NULL, skb, vid)) {
> @@ -95,8 +95,11 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
>  		    br_multicast_querier_exists(br, eth_hdr(skb)))
>  			br_multicast_flood(mdst, skb, false, true);
> +		else if (mdst && skb->protocol != htons(ETH_P_IP) &&
> +			 skb->protocol != htons(ETH_P_IPV6))
> +			br_multicast_flood(mdst, skb, false, true);
>  		else
> -			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
> +			br_flood(br, skb, BR_PKT_MULTICAST_IP, false, true);
>  	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
>  		br_forward(dst->dst, skb, false, true);
>  	} else {
> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
> index 8663700..36b58e8 100644
> --- a/net/bridge/br_forward.c
> +++ b/net/bridge/br_forward.c
> @@ -203,7 +203,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
>  			if (!(p->flags & BR_FLOOD))
>  				continue;
>  			break;
> -		case BR_PKT_MULTICAST:
> +		case BR_PKT_MULTICAST_IP:
> +		case BR_PKT_MULTICAST_L2:
>  			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
>  				continue;
>  			break;
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 21b74e7..a7db0c5 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -99,9 +99,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			pkt_type = BR_PKT_BROADCAST;
>  			local_rcv = true;
>  		} else {
> -			pkt_type = BR_PKT_MULTICAST;
> +			pkt_type = BR_PKT_MULTICAST_IP;
>  			if (br_multicast_rcv(br, p, skb, vid))
>  				goto drop;
> +
> +			if (skb->protocol != htons(ETH_P_IP) &&
> +			    skb->protocol != htons(ETH_P_IPV6))
> +				pkt_type = BR_PKT_MULTICAST_L2;
>  		}
>  	}
>  
> @@ -129,7 +133,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	}
>  
>  	switch (pkt_type) {
> -	case BR_PKT_MULTICAST:
> +	case BR_PKT_MULTICAST_L2:
> +		mdst = br_mdb_get(br, skb, vid);
> +		if (mdst)
> +			mcast_hit = true;
> +		break;
> +	case BR_PKT_MULTICAST_IP:
>  		mdst = br_mdb_get(br, skb, vid);
>  		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
>  		    br_multicast_querier_exists(br, eth_hdr(skb))) {
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index bf6acd3..b337a30 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -67,12 +67,19 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
>  	memset(ip, 0, sizeof(struct br_ip));
>  	ip->vid = entry->vid;
>  	ip->proto = entry->addr.proto;
> -	if (ip->proto == htons(ETH_P_IP))
> +	switch (ip->proto) {
> +	case htons(ETH_P_IP):
>  		ip->u.ip4 = entry->addr.u.ip4;
> +		break;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	else
> +	case htons(ETH_P_IPV6):
>  		ip->u.ip6 = entry->addr.u.ip6;
> +		break;
>  #endif
> +	default:
> +		ether_addr_copy(ip->u.mac, entry->addr.u.mac);
> +		break;
> +	}
>  }
>  
>  static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
> @@ -117,12 +124,19 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
>  			e.ifindex = port->dev->ifindex;
>  			e.vid = p->addr.vid;
>  			__mdb_entry_fill_flags(&e, p->flags);
> -			if (p->addr.proto == htons(ETH_P_IP))
> +			switch (p->addr.proto) {
> +			case htons(ETH_P_IP):
>  				e.addr.u.ip4 = p->addr.u.ip4;
> +				break;
>  #if IS_ENABLED(CONFIG_IPV6)
> -			if (p->addr.proto == htons(ETH_P_IPV6))
> +			case htons(ETH_P_IPV6):
>  				e.addr.u.ip6 = p->addr.u.ip6;
> +				break;
>  #endif
> +			default:
> +				ether_addr_copy(e.addr.u.mac, p->addr.u.mac);
> +				break;
> +			}
>  			e.addr.proto = p->addr.proto;
>  			nest_ent = nla_nest_start_noflag(skb,
>  							 MDBA_MDB_ENTRY_INFO);
> @@ -322,12 +336,19 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
>  		.vid = entry->vid,
>  	};
>  
> -	if (entry->addr.proto == htons(ETH_P_IP))
> +	switch (entry->addr.proto) {
> +	case htons(ETH_P_IP):
>  		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
> +		break;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	else
> +	case htons(ETH_P_IPV6):
>  		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
> +		break;
>  #endif
> +	default:
> +		ether_addr_copy(mdb.addr, entry->addr.u.mac);
> +		break;
> +	}
>  
>  	mdb.obj.orig_dev = dev;
>  	switch (type) {
> @@ -367,12 +388,19 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
>  	int err = -ENOBUFS;
>  
>  	port_dev = __dev_get_by_index(net, entry->ifindex);
> -	if (entry->addr.proto == htons(ETH_P_IP))
> +	switch (entry->addr.proto) {
> +	case htons(ETH_P_IP):
>  		ip_eth_mc_map(entry->addr.u.ip4, mdb.addr);
> +		break;
>  #if IS_ENABLED(CONFIG_IPV6)
> -	else
> +	case htons(ETH_P_IPV6):
>  		ipv6_eth_mc_map(&entry->addr.u.ip6, mdb.addr);
> +		break;
>  #endif
> +	default:
> +		ether_addr_copy(mdb.addr, entry->addr.u.mac);
> +		break;
> +	}
>  
>  	mdb.obj.orig_dev = port_dev;
>  	if (p && port_dev && type == RTM_NEWMDB) {
> @@ -423,6 +451,7 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
>  #if IS_ENABLED(CONFIG_IPV6)
>  	entry.addr.u.ip6 = group->u.ip6;
>  #endif
> +	ether_addr_copy(group->u.mac, entry.addr.u.mac);
>  	entry.vid = group->vid;
>  	__mdb_entry_fill_flags(&entry, flags);
>  	__br_mdb_notify(dev, port, &entry, type);
> @@ -510,6 +539,8 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
>  		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
>  			return false;
>  #endif
> +	} else if (is_multicast_ether_addr(entry->addr.u.mac)) {
> +		;
>  	} else
>  		return false;
>  	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY)
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index de22c8f..01250c1 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -133,7 +133,9 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge *br,
>  		break;
>  #endif
>  	default:
> -		return NULL;
> +		ip.proto = 0;
> +		ether_addr_copy(ip.u.mac, eth_hdr(skb)->h_dest);
> +		break;
>  	}
>  
>  	return br_mdb_ip_get_rcu(br, &ip);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 159a0e2..60e2430d 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -590,7 +590,8 @@ void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
>  /* br_forward.c */
>  enum br_pkt_type {
>  	BR_PKT_UNICAST,
> -	BR_PKT_MULTICAST,
> +	BR_PKT_MULTICAST_IP,
> +	BR_PKT_MULTICAST_L2,
>  	BR_PKT_BROADCAST
>  };
>  int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb);
> 


--------------F92E64033FFB71AE03742F84
Content-Type: text/x-patch;
 name="0001-net-bridge-mdb-Extend-with-multicast-LLADDR.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-net-bridge-mdb-Extend-with-multicast-LLADDR.patch"

From 611cb2250c06a22d08819bc2d3d67bb7a2867cc4 Mon Sep 17 00:00:00 2001
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
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_device.c         |  7 +++--
 net/bridge/br_forward.c        |  3 ++-
 net/bridge/br_input.c          | 13 ++++++++--
 net/bridge/br_mdb.c            | 47 ++++++++++++++++++++++++++++------
 net/bridge/br_multicast.c      |  4 ++-
 net/bridge/br_private.h        |  3 ++-
 8 files changed, 64 insertions(+), 15 deletions(-)

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
index 1b3c2b643a02..49a2de0b7420 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -244,6 +244,7 @@ struct br_mdb_entry {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			__u8	mac[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 681b72862c16..581d6875cdb2 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -84,7 +84,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		br_flood(br, skb, BR_PKT_BROADCAST, false, true);
 	} else if (is_multicast_ether_addr(dest)) {
 		if (unlikely(netpoll_tx_running(dev))) {
-			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
+			br_flood(br, skb, BR_PKT_MULTICAST_IP, false, true);
 			goto out;
 		}
 		if (br_multicast_rcv(br, NULL, skb, vid)) {
@@ -96,8 +96,11 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
 		    br_multicast_querier_exists(br, eth_hdr(skb)))
 			br_multicast_flood(mdst, skb, false, true);
+		else if (mdst && skb->protocol != htons(ETH_P_IP) &&
+			 skb->protocol != htons(ETH_P_IPV6))
+			br_multicast_flood(mdst, skb, false, true);
 		else
-			br_flood(br, skb, BR_PKT_MULTICAST, false, true);
+			br_flood(br, skb, BR_PKT_MULTICAST_IP, false, true);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
 		br_forward(dst->dst, skb, false, true);
 	} else {
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 86637000f275..36b58e86d719 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -203,7 +203,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 			if (!(p->flags & BR_FLOOD))
 				continue;
 			break;
-		case BR_PKT_MULTICAST:
+		case BR_PKT_MULTICAST_IP:
+		case BR_PKT_MULTICAST_L2:
 			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
 				continue;
 			break;
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 09b1dd8cd853..f69e710a7f55 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -97,9 +97,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			pkt_type = BR_PKT_BROADCAST;
 			local_rcv = true;
 		} else {
-			pkt_type = BR_PKT_MULTICAST;
+			pkt_type = BR_PKT_MULTICAST_IP;
 			if (br_multicast_rcv(br, p, skb, vid))
 				goto drop;
+
+			if (skb->protocol != htons(ETH_P_IP) &&
+			    skb->protocol != htons(ETH_P_IPV6))
+				pkt_type = BR_PKT_MULTICAST_L2;
 		}
 	}
 
@@ -127,7 +131,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	}
 
 	switch (pkt_type) {
-	case BR_PKT_MULTICAST:
+	case BR_PKT_MULTICAST_L2:
+		mdst = br_mdb_get(br, skb, vid);
+		if (mdst)
+			mcast_hit = true;
+		break;
+	case BR_PKT_MULTICAST_IP:
 		mdst = br_mdb_get(br, skb, vid);
 		if ((mdst || BR_INPUT_SKB_CB_MROUTERS_ONLY(skb)) &&
 		    br_multicast_querier_exists(br, eth_hdr(skb))) {
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 428af1abf8cc..25d182f45fde 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -69,12 +69,19 @@ static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip)
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
@@ -119,12 +126,19 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			e.ifindex = port->dev->ifindex;
 			e.vid = p->addr.vid;
 			__mdb_entry_fill_flags(&e, p->flags);
-			if (p->addr.proto == htons(ETH_P_IP))
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
@@ -324,12 +338,19 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
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
@@ -369,12 +390,19 @@ static void __br_mdb_notify(struct net_device *dev, struct net_bridge_port *p,
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
@@ -425,6 +453,7 @@ void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 #if IS_ENABLED(CONFIG_IPV6)
 	entry.addr.u.ip6 = group->u.ip6;
 #endif
+	ether_addr_copy(group->u.mac, entry.addr.u.mac);
 	entry.vid = group->vid;
 	__mdb_entry_fill_flags(&entry, flags);
 	__br_mdb_notify(dev, port, &entry, type);
@@ -512,6 +541,8 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
 		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
 			return false;
 #endif
+	} else if (is_multicast_ether_addr(entry->addr.u.mac)) {
+		;
 	} else
 		return false;
 	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3d4b2817687f..aa28a322ce9d 100644
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
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c4fd307fbfdc..1f2a880a9d17 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -592,7 +592,8 @@ void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
 /* br_forward.c */
 enum br_pkt_type {
 	BR_PKT_UNICAST,
-	BR_PKT_MULTICAST,
+	BR_PKT_MULTICAST_IP,
+	BR_PKT_MULTICAST_L2,
 	BR_PKT_BROADCAST
 };
 int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb);
-- 
2.21.0


--------------F92E64033FFB71AE03742F84--
