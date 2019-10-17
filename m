Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72FEDAE1B
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 15:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394462AbfJQNUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 09:20:38 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33388 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394421AbfJQNUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 09:20:38 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so1674194pfl.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 06:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=212cj+hV0AaL26+YhnhfrBQjwvM6MXgU9v5ve6d+wy0=;
        b=Dp1UWDevDfGYNSfV+aYYEN5WnrlMXhndEvwxa0q67CtyIAjvNIjifiJp6Ya56FwDua
         z11errElMGY4onDWXOxlo8NXZ85DfJEbbWuF4nN5mqXSs+5+PXB+W0RKIbD7IFZuRVBs
         yL5bkVXfMyLv4HYtJkYrJAHa+2b5/WUwqs6GYoXDcbSYaj2zgO8eWm3m75JPw6VxC4PA
         NLdOHpi1fJVdixbA+EUR1w7E/jV43EPFCAlaGY9MYKMIHZSzB7gfrA0CcFt0kCkP3nxr
         oHi+fOkS2+s4pVO3LxqKzgQMd6s6Asm6/hxYH//+N49xMMJCTyUDordrbxYJQ7G0oZOj
         D0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=212cj+hV0AaL26+YhnhfrBQjwvM6MXgU9v5ve6d+wy0=;
        b=ZXpLaFXnuXZhcjvFDxa+10Hiu9+pkvqFdASbRYYmPzDFIgDlsjnQmjHK6wNMv84OR3
         2QFvVbGzYt5yYPWmEYbp7LV85KCZEyzqqfzWUsBKP77a0lrfoOe63y7JuWtdBlAg1/x4
         sMjrjtun56iSFBHFoA4zf4aqWhAvYzTBtIbN3T44B6njiyGbcbwAWdMhMnJHx9PL1p3R
         GY/2aQ+ZiPu9mcuunRhfjxgPQvmqTDCK8bTbPEONyx/H1vqHWd8zxcKsTdzGaKZvqI54
         U9Cvw2klPgTKR/zqNRR1uljBak45HNkM0hurJ6rnNPE+6sA/vq8ybCeg9XQY4pyMTk6g
         zSVA==
X-Gm-Message-State: APjAAAUDvYMp+FFQqNsPqzscLXilPj/8UrCfmsI5PazOfLtNcXo07Ht2
        5kr556DvQk3kspXyQO2tarA=
X-Google-Smtp-Source: APXvYqw8H0tEaFvYIHMkF+SGvXun5VpY6IeQlwYW8OxBQ+B+fWTatWxJYOYbD0yI1sXWnwOG4Hwa4Q==
X-Received: by 2002:a63:352:: with SMTP id 79mr4180606pgd.232.1571318437434;
        Thu, 17 Oct 2019 06:20:37 -0700 (PDT)
Received: from martin-VirtualBox ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id m13sm3055428pgi.22.2019.10.17.06.20.36
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 17 Oct 2019 06:20:36 -0700 (PDT)
Date:   Thu, 17 Oct 2019 18:50:29 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191017132029.GA9982@martin-VirtualBox>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 12:28:23PM -0400, Willem de Bruijn wrote:
> On Tue, Oct 8, 2019 at 5:51 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin <martin.varghese@nokia.com>
> >
> > The Bareudp tunnel module provides a generic L3 encapsulation
> > tunnelling module for tunnelling different protocols like MPLS,
> > IP,NSH etc inside a UDP tunnel.
> >
> > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > ---
> >  Documentation/networking/bareudp.txt |  23 +
> >  drivers/net/Kconfig                  |  13 +
> >  drivers/net/Makefile                 |   1 +
> >  drivers/net/bareudp.c                | 930 +++++++++++++++++++++++++++++++++++
> >  include/net/bareudp.h                |  19 +
> >  include/uapi/linux/if_link.h         |  12 +
> >  6 files changed, 998 insertions(+)
> >  create mode 100644 Documentation/networking/bareudp.txt
> >  create mode 100644 drivers/net/bareudp.c
> >  create mode 100644 include/net/bareudp.h
> >
> > diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> > new file mode 100644
> > index 0000000..d2530e2
> > --- /dev/null
> > +++ b/Documentation/networking/bareudp.txt
> > @@ -0,0 +1,23 @@
> > +Bare UDP Tunnelling Module Documentation
> > +========================================
> > +
> > +There are various L3 encapsulation standards using UDP being discussed to
> > +leverage the UDP based load balancing capability of different networks.
> > +MPLSoUDP (https://tools.ietf.org/html/rfc7510)is one among them.
> > +
> > +The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> > +support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> > +a UDP tunnel.
> 
> This patch set introduces a lot of code, much of which duplicates
> existing tunnel devices, whether FOU using ipip tunnels and
> fou_build_header or separate devices like vxlan and geneve. Let's try
> to reuse what's there (and tested).
> 
> How does this differ from foo-over-udp (FOU). In supporting MPLS
> alongside IP? If so, can it reuse the existing code, possibly with
> patches to that existing tunnel logic?
> 
> I happened to have been playing around with MPLS in GRE recently. Have
> not tried the same over UDP tunnels, but most of it should apply?
> 
>   ip tunnel add gre1 mode gre local 192.168.1.1 remote 192.168.1.2 dev eth0
>   ip addr add 192.168.101.1 peer 192.168.101.2 dev gre1
>   ip link set dev gre1 up
> 
>   sysctl net.mpls.conf.gre1.input=1
>   sysctl net.mpls.platform_labels=17
>   ip addr add 192.168.201.1/24 dev gre1
>   ip route add 192.168.202.0/24 encap mpls 17 dev gre1
>   ip -f mpls route add 16 dev lo
> 
> 
> > +static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> > +{
> > +       struct bareudp_sock *bs;
> > +       struct ethhdr *eh;
> > +       struct bareudp_dev *bareudp;
> > +       struct metadata_dst *tun_dst = NULL;
> > +       struct pcpu_sw_netstats *stats;
> > +       unsigned int len;
> > +       int err = 0;
> > +       void *oiph;
> > +       u16 proto;
> > +
> > +       if (unlikely(!pskb_may_pull(skb, BAREUDP_BASE_HLEN)))
> > +               goto drop;
> > +
> > +       bs = rcu_dereference_sk_user_data(sk);
> > +       if (!bs)
> > +               goto drop;
> > +
> > +       bareudp = bs->bareudp;
> > +       proto = bareudp->ethertype;
> > +
> > +       if (iptunnel_pull_header(skb, BAREUDP_BASE_HLEN,
> > +                                proto,
> > +                                !net_eq(bareudp->net,
> > +                                        dev_net(bareudp->dev)))) {
> > +               bareudp->dev->stats.rx_dropped++;
> > +               goto drop;
> > +       }
> > +       tun_dst = udp_tun_rx_dst(skb, bareudp_get_sk_family(bs), TUNNEL_KEY,
> > +                                0, 0);
> > +       if (!tun_dst) {
> > +               bareudp->dev->stats.rx_dropped++;
> > +               goto drop;
> > +       }
> > +       skb_dst_set(skb, &tun_dst->dst);
> 
> Is this dst metadata a firm requirement? It is optional in vxlan, say.
> If here, too, please split such parts off into separate follow-on
> patches.
> 
> 
> > +       skb_push(skb, sizeof(struct ethhdr));
> > +       eh = (struct ethhdr *)skb->data;
> > +       eh->h_proto = proto;
> > +
> > +       skb_reset_mac_header(skb);
> > +       skb->protocol = eth_type_trans(skb, bareudp->dev);
> > +       skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > +       oiph = skb_network_header(skb);
> > +       skb_reset_network_header(skb);
> > +
> > +       if (bareudp_get_sk_family(bs) == AF_INET)
> 
> This should be derived from packet contents, not socket state.
> Although the one implies the other, I imagine.
>

The IP Stack check IP headers & puts the packet in the correct socket, hence checking the ip headers again is reduntant correct?
In geneve & vxlan it is done the same way.

 
> > +static struct rtable *bareudp_get_v4_rt(struct sk_buff *skb,
> > +                                       struct net_device *dev,
> > +                                       struct bareudp_sock *bs4,
> > +                                       struct flowi4 *fl4,
> > +                                       const struct ip_tunnel_info *info)
> > +{
> > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > +       struct dst_cache *dst_cache;
> > +       struct rtable *rt = NULL;
> > +       __u8 tos;
> > +
> > +       if (!bs4)
> > +               return ERR_PTR(-EIO);
> > +
> > +       memset(fl4, 0, sizeof(*fl4));
> > +       fl4->flowi4_mark = skb->mark;
> > +       fl4->flowi4_proto = IPPROTO_UDP;
> > +       fl4->daddr = info->key.u.ipv4.dst;
> > +       fl4->saddr = info->key.u.ipv4.src;
> > +
> > +       tos = info->key.tos;
> > +       fl4->flowi4_tos = RT_TOS(tos);
> > +
> > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > +       if (use_cache) {
> > +               rt = dst_cache_get_ip4(dst_cache, &fl4->saddr);
> > +               if (rt)
> > +                       return rt;
> > +       }
> > +       rt = ip_route_output_key(bareudp->net, fl4);
> > +       if (IS_ERR(rt)) {
> > +               netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
> > +               return ERR_PTR(-ENETUNREACH);
> > +       }
> > +       if (rt->dst.dev == dev) { /* is this necessary? */
> > +               netdev_dbg(dev, "circular route to %pI4\n", &fl4->daddr);
> > +               ip_rt_put(rt);
> > +               return ERR_PTR(-ELOOP);
> > +       }
> > +       if (use_cache)
> > +               dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
> > +       return rt;
> > +}
> > +
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +static struct dst_entry *bareudp_get_v6_dst(struct sk_buff *skb,
> > +                                           struct net_device *dev,
> > +                                           struct bareudp_sock *bs6,
> > +                                           struct flowi6 *fl6,
> > +                                           const struct ip_tunnel_info *info)
> > +{
> > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > +       struct dst_entry *dst = NULL;
> > +       struct dst_cache *dst_cache;
> > +       __u8 prio;
> > +
> > +       if (!bs6)
> > +               return ERR_PTR(-EIO);
> > +
> > +       memset(fl6, 0, sizeof(*fl6));
> > +       fl6->flowi6_mark = skb->mark;
> > +       fl6->flowi6_proto = IPPROTO_UDP;
> > +       fl6->daddr = info->key.u.ipv6.dst;
> > +       fl6->saddr = info->key.u.ipv6.src;
> > +       prio = info->key.tos;
> > +
> > +       fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
> > +                                          info->key.label);
> > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > +       if (use_cache) {
> > +               dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
> > +               if (dst)
> > +                       return dst;
> > +       }
> > +       if (ipv6_stub->ipv6_dst_lookup(bareudp->net, bs6->sock->sk, &dst,
> > +                                      fl6)) {
> > +               netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
> > +               return ERR_PTR(-ENETUNREACH);
> > +       }
> > +       if (dst->dev == dev) { /* is this necessary? */
> > +               netdev_dbg(dev, "circular route to %pI6\n", &fl6->daddr);
> > +               dst_release(dst);
> > +               return ERR_PTR(-ELOOP);
> > +       }
> > +
> > +       if (use_cache)
> > +               dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
> > +       return dst;
> > +}
> > +#endif
> 
> The route lookup logic is very similar to vxlan_get_route and
> vxlan6_get_route. Can be reused?

I had a look at the vxlan & geneve and it seems the corresponding functions  in those modules are tightly coupled  to the rest of the module design.
More specifically wrt the ttl inheritance & the caching behaviour. It may not be possible for those modules to use a new generic API unless without a change in those module design.

The bareudp module is a generic L3 encapsulation module. It could be used to tunnel different l3 protocols. TTL Inheritance behaviour when tunnelled
could be different for these inner protocols. Hence moving  this function to a common place will make it tough to change it later when a need arises for a new protocol

Otherwise we should have more generic function which takes the  generic IP header params as arguments. Then the point is we don’t need a function like that
We can just fill up "struct flowi4" and call ip_route_output_key or dst_cache_get_ip4 to get the route table entry


Thanks
Martin
