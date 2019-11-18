Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26913100A2A
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfKRRXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:23:53 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35062 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfKRRXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:23:52 -0500
Received: by mail-yb1-f196.google.com with SMTP id h23so7492410ybg.2
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CVoVYjQc9txYW0vhwUDLk2dGiXDOJoyuDgUi7qqCHKM=;
        b=X2U9k2OT7VC2mwJYytV+sbmyceaMrjv95jljdAhAEgNtwt9QFejHljgmSZwnF7I+8g
         y8vN0qeygFxXTu4srx/yFXF0vIVNWrJA6hmz9d7FNeMGnsWUfvPDeC/17VkFBce2vaxZ
         0N9/VvDpnkNBp8fhMcvj7bCI+X2FoeTEpAHG4cmi47g7zsJK8xiIqB5Uril8Y2j0Dwk7
         SXFDfWJP+D9mXLP4cC1g4+GVz+Ug07R2nPL+qoqtZug/bkv01CGkqRSNEW9eevqK+Xnu
         ZUdZVQ3wVqBC9zGVJ+QoIb2ptjCw6iqBt6k9QOdWh6jp90CLs4uL3mjZOHgdFsAhAlrR
         rt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CVoVYjQc9txYW0vhwUDLk2dGiXDOJoyuDgUi7qqCHKM=;
        b=k1u1W0LuU6OniSj/d5vcBKitIbP4JaAfRzHqo4zJHFV20iONpuyGMHRo201oDf9bXK
         F9GVs/G8e797sv+pmhTlmZtxckPwIKoF/bRaqwp47Icuvc5ObTSwVqLdfNqmii6qVazi
         6LE2jTxwGUmuITM8wqcd2FS0c43ruQjKXCikMDNRp1nRBzQ95+s6tXi8e9me6udpOjUa
         KntKRRiVLqAy5E+HJ1OPa3EkOCi6rVvineMmwXL2yGo/JhrVzMG8JJkwVc23ub6xLHRN
         9S+ZVi4VvcTJDVnaOIH7wGN5xWsIXzAq9t4xRALpKCtYeGp97OF47L18IRHofgK+tpv7
         hBJQ==
X-Gm-Message-State: APjAAAW1q+JCH9Zp0Mpd1kxKKfLp4q9LJy/3EUObmjBMG0KYd+o25wTE
        O9fRtVdFK/QBvF/5HSaaTgT4qcPs
X-Google-Smtp-Source: APXvYqwsAYCJfBFlS27CVt01MMVF7C/APAcmafGWBHnZS7l0slpV7c22S+ai7UqgVtkZx6SFMgIrHQ==
X-Received: by 2002:a25:100a:: with SMTP id 10mr6380391ybq.444.1574097828648;
        Mon, 18 Nov 2019 09:23:48 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id r196sm8793142ywg.102.2019.11.18.09.23.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 09:23:47 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id r201so7474733ybc.10
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 09:23:46 -0800 (PST)
X-Received: by 2002:a25:dd04:: with SMTP id u4mr24257595ybg.419.1574097826164;
 Mon, 18 Nov 2019 09:23:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573872263.git.martin.varghese@nokia.com> <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
In-Reply-To: <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Nov 2019 12:23:09 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeUGsWH-GR7N_N7PChaW4S6Hucmvo_1s_9bbisxz1eOAA@mail.gmail.com>
Message-ID: <CA+FuTSeUGsWH-GR7N_N7PChaW4S6Hucmvo_1s_9bbisxz1eOAA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
> Changes in v2:
>      - Fixed documentation errors.
>      - Converted documentation to rst format.
>      - Moved ip tunnel rt lookup code to a common location.

This does not actually deduplicate with the existing code in geneve
(and vxlan, maybe others).

Mentioned a few more obvious examples inline. I won't keep harping on
this point, as I have no real stake in this.

But if you don't deduplicate from the start, I'm skeptical that it
will happen later. And then fixes to one driver are likely to be
missed for the other, slowly drifting the code further apart.

> +1) Device creation & deletion
> +
> +    a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.
> +
> +       This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
> +       0x8847 (MPLS traffic). The destination port of the UDP header will be set to
> +       6635.The device will listen on UDP port 6635 to receive traffic.
> +

Might be useful to also document how to use this on transmission.

> +struct bareudp_sock {
> +       struct socket           *sock;
> +       struct rcu_head         rcu;
> +       struct bareudp_dev      *bareudp;
> +};

Is this intermediate struct needed, or could struct bareudp_dev
directly hang off of sk_user_data if it gains a struct rcu_head?
Especially now that there is a 1:1 relationship between socket and
device.

> +       skb_push(skb, sizeof(struct ethhdr));
> +       skb_reset_mac_header(skb);
> +
> +       err = skb_ensure_writable(skb, sizeof(struct ethhdr));
> +       if (unlikely(err))
> +               goto drop;
> +
> +       eh = (struct ethhdr *)skb->data;
> +       eh->h_proto = proto;
> +       skb->protocol = eth_type_trans(skb, bareudp->dev);
> +       oiph = skb_network_header(skb);
> +       skb_reset_network_header(skb);

After decapsulation packets now have a fake ethernet header with
garbage in the src and dst address. Tcpdump will show that.

Instead of pseudo Ethernet, should this device be of link layer type
ARPHRD_NONE. Or alternatively a new type analogous to ARPHRD_TUNNEL
that includes the udp header?

The same can probably be said about geneve, so no strong objection to
what is here. Just a point for thought.

> +       if (bareudp_get_sk_family(bs) == AF_INET)
> +               err = IP_ECN_decapsulate(oiph, skb);
> +#if IS_ENABLED(CONFIG_IPV6)
> +       else
> +               err = IP6_ECN_decapsulate(oiph, skb);
> +#endif

with dual stack sockets, should this check now be based on packet
header instead of bareudp_get_sk_family?

> +       if (unlikely(err)) {
> +               if (log_ecn_error) {
> +                       if (bareudp_get_sk_family(bs) == AF_INET)
> +                               net_info_ratelimited("non-ECT from %pI4 "
> +                                                    "with TOS=%#x\n",
> +                                                    &((struct iphdr *)oiph)->saddr,
> +                                                    ((struct iphdr *)oiph)->tos);
> +#if IS_ENABLED(CONFIG_IPV6)
> +                       else
> +                               net_info_ratelimited("non-ECT from %pI6\n",
> +                                                    &((struct ipv6hdr *)oiph)->saddr);
> +#endif
> +               }
> +               if (err > 1) {
> +                       ++bareudp->dev->stats.rx_frame_errors;
> +                       ++bareudp->dev->stats.rx_errors;
> +                       goto drop;
> +               }
> +       }
> +
> +       len = skb->len;
> +       err = gro_cells_receive(&bareudp->gro_cells, skb);
> +       if (likely(err == NET_RX_SUCCESS)) {
> +               stats = this_cpu_ptr(bareudp->dev->tstats);
> +               u64_stats_update_begin(&stats->syncp);
> +               stats->rx_packets++;
> +               stats->rx_bytes += len;
> +               u64_stats_update_end(&stats->syncp);
> +       }
> +       return 0;
> +drop:
> +       /* Consume bad packet */
> +       kfree_skb(skb);
> +
> +       return 0;
> +}

All of this can pretty easily be shared with geneve.

> +static struct socket *bareudp_create_sock(struct net *net, bool ipv6,
> +                                         __be16 port)
> +{
> +       struct socket *sock;
> +       struct udp_port_cfg udp_conf;
> +       int err;
> +
> +       memset(&udp_conf, 0, sizeof(udp_conf));
> +#if IS_ENABLED(CONFIG_IPV6)
> +       udp_conf.family = AF_INET6;
> +#else
> +       udp_conf.family = AF_INET;
> +#endif

Still need to take bool ipv6 in account when creating the socket?

> +static int bareudp_sock_add(struct bareudp_dev *bareudp, bool ipv6)
> +{
> +       struct net *net = bareudp->net;
> +       struct bareudp_sock *bs;
> +
> +       bs = bareudp_socket_create(net, bareudp->conf.port, ipv6);
> +       if (IS_ERR(bs))
> +               return PTR_ERR(bs);
> +
> +       rcu_assign_pointer(bareudp->sock, bs);
> +       bs->bareudp = bareudp;
> +
> +       return 0;

Especially now that the device only has one socket, probably no need
to have a separate bareudp_socket_create from bareudp_sock_add.  Same
for __bareudp_sock_release and bareudp_sock_release.

> +}
> +
> +static void __bareudp_sock_release(struct bareudp_sock *bs)
> +{
> +       if (!bs)
> +               return;
> +
> +       udp_tunnel_sock_release(bs->sock);
> +       kfree_rcu(bs, rcu);
> +}
> +
> +static void bareudp_sock_release(struct bareudp_dev *bareudp)
> +{
> +       struct bareudp_sock *bs = rtnl_dereference(bareudp->sock);
> +
> +       rcu_assign_pointer(bareudp->sock, NULL);
> +       synchronize_net();
> +       __bareudp_sock_release(bs);
> +}
> +
> +static int bareudp_fill_metadata_dst(struct net_device *dev,
> +                                    struct sk_buff *skb)
> +{
> +       struct ip_tunnel_info *info = skb_tunnel_info(skb);
> +       struct bareudp_dev *bareudp = netdev_priv(dev);
> +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> +
> +       if (ip_tunnel_info_af(info) == AF_INET) {
> +               struct rtable *rt;
> +               struct flowi4 fl4;
> +
> +               rt = iptunnel_get_v4_rt(skb, dev, bareudp->net, &fl4, info,
> +                                       use_cache);
> +               if (IS_ERR(rt))
> +                       return PTR_ERR(rt);
> +
> +               ip_rt_put(rt);
> +               info->key.u.ipv4.src = fl4.saddr;
> +#if IS_ENABLED(CONFIG_IPV6)
> +       } else if (ip_tunnel_info_af(info) == AF_INET6) {
> +               struct dst_entry *dst;
> +               struct flowi6 fl6;
> +               struct bareudp_sock *bs6 = rcu_dereference(bareudp->sock);
> +
> +               dst = ip6tunnel_get_dst(skb, dev, bareudp->net, bs6->sock, &fl6,
> +                                       info, use_cache);
> +               if (IS_ERR(dst))
> +                       return PTR_ERR(dst);
> +
> +               dst_release(dst);
> +               info->key.u.ipv6.src = fl6.saddr;
> +#endif
> +       } else {
> +               return -EINVAL;
> +       }
> +
> +       info->key.tp_src = udp_flow_src_port(bareudp->net, skb,
> +                                            bareudp->sport_min,
> +                                            USHRT_MAX, true);
> +       info->key.tp_dst = bareudp->conf.port;
> +       return 0;
> +}

This can probably all be deduplicated with geneve_fill_metadata_dst
once both use iptunnel_get_v4_rt.


> +static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +       struct bareudp_dev *bareudp = netdev_priv(dev);
> +       struct ip_tunnel_info *info = NULL;
> +       int err;
> +
> +       if (skb->protocol != bareudp->ethertype) {
> +               err = -EINVAL;
> +               goto tx_error;
> +       }
> +
> +       info = skb_tunnel_info(skb);

Like geneve, should this have two modes, either associated with LWT if
geneve->collect_md, else static for the device (geneve->info)? As
opposed to requiring collect_md mode.

> +/* Initialize the device structure. */
> +static void bareudp_setup(struct net_device *dev)
> +{
> +       ether_setup(dev);
> +
> +       dev->netdev_ops = &bareudp_netdev_ops;
> +       dev->ethtool_ops = &bareudp_ethtool_ops;
> +       dev->needs_free_netdev = true;
> +
> +       SET_NETDEV_DEVTYPE(dev, &bareudp_type);
> +
> +       dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
> +       dev->features    |= NETIF_F_RXCSUM;
> +       dev->features    |= NETIF_F_GSO_SOFTWARE;
> +
> +       dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
> +       dev->hw_features |= NETIF_F_GSO_SOFTWARE;
> +
> +       /* MTU range: 68 - (something less than 65535) */
> +       dev->min_mtu = ETH_MIN_MTU;
> +       dev->max_mtu = IP_MAX_MTU - BAREUDP_BASE_HLEN - dev->hard_header_len;

For IPv6, MSS is 64 kB without headers, so dev->max_mtu could perhaps
be IP_MAX_MTU. Also, why is hard_header_len subtracted? Again, same
for geneve, so if it works there, fine to leave here. Just something
that surprised me and might be worth giving another thought.
