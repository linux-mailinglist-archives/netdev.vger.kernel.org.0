Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEA7D0F22
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbfJIMsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:48:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45671 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfJIMsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:48:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id r1so159654pgj.12
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZmS1qLsW9r+mq90LuJUsYsZhzFQZM9y2CCctJeUbc5w=;
        b=tA6xoy43i5FgK/3jC1a3MQz8O6YO5IFca3MZMwMXCc4i0oLd+VxJZYR+oH6ysouyU6
         X9yK1N5kkorFs1VDq0g54aGlVd6rkA+p/4pA037sQTJBqfhZmFWdUQPl8GMH2Bh9dY2M
         fHAWPLmvthPr00lGwGz7eqvMK6NtP5kS8ASdnCHK+Mw9KiM4nzrTqHOTIrmDQFvR4xhU
         ZbobmipIQatt/0d+ZWEgkakGfPnC3C92DWo0iYdZQbGSstArw5AAaJF8is1BEPVmtH7S
         zMVxI8E7tEOxxnPOW/PJb61FDvJAiyp5EZeHhJz0EfMKHXauwWb8AjcbrCTHDE6fq+eC
         jBHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZmS1qLsW9r+mq90LuJUsYsZhzFQZM9y2CCctJeUbc5w=;
        b=HolX5VLPf+P01mYYqpEJw6D1ZDT0dtt1XtbEMzRMI5jHUSVM1U7cPVKqMaSo4uzgdE
         q2+5AsVfrq2e4GrLF6+WAug1O+4p9Y6cAck5+WPRzHQO5+yxBPtRL+nbnPJd9HjOv5PJ
         t/KEITvOE6qrEFMdPi/Ifq8D9DoM8Rv1v+cn8GQlCOk9y6dkg1f3/frRE244fRWTFaQj
         7/ZO4/5Ss4Sq1PHBf6FIi+GPrYlSwQ7dy8oQwtC/viqzbmULe4zLGO72lD82TpmDO+HT
         jNf4PGtDeKrZIWgXUGXRfJ4qw8gLDW7jDQ5IYU5urG8cOexq9TizsHVPwUr4OC+X1Eqp
         +sbA==
X-Gm-Message-State: APjAAAUyo1SvG0caLqal4GpQEhsIATCAsTxlj17Nq2HCt+3KDpgrM3O/
        XX3+SeuUCWhtZ9SMbIElNpY=
X-Google-Smtp-Source: APXvYqy3MQakkdviSFOuxuYpiLMz7S0mIzRE8rKRj+D6qtMQhj4bPmg7DvZ3pU90H/7kKo2n2oDQQA==
X-Received: by 2002:a17:90a:9f42:: with SMTP id q2mr3907284pjv.95.1570625315463;
        Wed, 09 Oct 2019 05:48:35 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id w27sm5249423pfq.32.2019.10.09.05.48.34
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 09 Oct 2019 05:48:34 -0700 (PDT)
Date:   Wed, 9 Oct 2019 18:18:14 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191009124814.GB17712@martin-VirtualBox>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
unlike FOU which does l4 encapsulation, here we are trying to acheive l3 encapsulation.
For Example,  What is needed for MPLSoUDP is to take packets such as:

eth header | mpls header | payload

and encapsulate them to:

eth header | ip header | udp header | mpls header | payload
<--------- outer ------------------> <---- inner --------->

which is later decapsulated back to:

eth header | mpls header | payload

Note that in the decapsulated case, the ethertype in the eth header is ETH_P_MPLS_UC, while in the encapsulated case, the ethertype in the eth header is ETH_P_IP. When decapsulating, ETH_P_MPLS_UC is
restored based on the configured tunnel parameters.

This cannot be done with FOU. FOU needs an ipproto, not ethertype.

During receive FOU dispatches packet to l4 handlers which makes it impossible to patch it to get it working for l3 protocols like MPLS.

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
Yes it is. 
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

Yes  we could. We can move these to a common place. include/net/ip_tunnels.h ? 
