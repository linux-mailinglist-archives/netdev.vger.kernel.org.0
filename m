Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66128DBFC0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406746AbfJRIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 04:20:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33377 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395519AbfJRIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 04:20:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so2503590pls.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 01:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=riDVkEhpVRQWbrB7JStgGbHiqZwnP3ZTmnM42mY7YnM=;
        b=XC1yrAlh0k9uqB+iBQDWTStCQN12PP+lwP1ZRE58P1flolUzVsbnRUoaA9iw+5l74k
         JTDolCB9jS9N8dUBUjyV4alCr4W+xEnU7AQMmGMHyLA47lnYZdZPPZlxq8u1/DWuEL+v
         RWBK4SYxqpH98TmS1rIfYAFLib9i5Bt1dW2pI72tyl80TwMqGEAgrnfVO1SFWv8N6N1G
         /ubfv4ivvt0gpGssm0v/jZq4Pi6ZbWNXYUJ+z+VNn5hE1piwRR92sffrLjSasGFheRmW
         uhsRHf7Wt7FGiHIuhDWvVJFk4UES//0MuW+GZTFr2NoEwip/2VHBthnwmBWOb57WJPtV
         77ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=riDVkEhpVRQWbrB7JStgGbHiqZwnP3ZTmnM42mY7YnM=;
        b=OdgslESEPh/mhLfqK+PH3bbLUJYn6HiZHLbWRYZRbvoGtI1URrE46oRv8uIzv3jRrA
         h54XataSki/8zEF+3MI1jDse3LtMtfCOLgr1CELMRKkGpIs29cHmbYnNK5//x9LC/uTQ
         J/tBQjtz581+byTRsxz8VABWozzTSg0Pq5ep+yRluB2EEmyxdDfGNocVCo0Ncix/twb7
         3W4I9Aq4SBQnZCZNvMga+vWM7id5+bHnuY6g4tPM6n8p9viAqZ2Dw6+r3wLgn80O6bDp
         akxvxhetAD3+Tz2WuhgOPnIk6zdyBm8q1fJv6RVK91ubDTNxV0wczyKrWf4jidq9pWp4
         pM4w==
X-Gm-Message-State: APjAAAUlHJG2Tx3Lvomdpy5ZzpHVYyg6sNw1mTiJYHrbJhdqeD3E9Ok5
        6jNxTJhebCWGB+uqe7ImRhA=
X-Google-Smtp-Source: APXvYqx7bbu/ig1DiBW08F1spq4/+dS31bTPWPQhqES9OWNTN3C9NUf0AHk179aXUkbzTPzKh/PafA==
X-Received: by 2002:a17:902:8505:: with SMTP id bj5mr8189090plb.296.1571386838588;
        Fri, 18 Oct 2019 01:20:38 -0700 (PDT)
Received: from martin-VirtualBox ([1.39.146.157])
        by smtp.gmail.com with ESMTPSA id z4sm7082181pfn.45.2019.10.18.01.20.37
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 01:20:37 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:50:29 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191018082029.GA11876@martin-VirtualBox>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox>
 <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 04:48:26PM -0400, Willem de Bruijn wrote:
> On Thu, Oct 17, 2019 at 9:20 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Tue, Oct 08, 2019 at 12:28:23PM -0400, Willem de Bruijn wrote:
> > > On Tue, Oct 8, 2019 at 5:51 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > From: Martin <martin.varghese@nokia.com>
> > > >
> > > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > > tunnelling module for tunnelling different protocols like MPLS,
> > > > IP,NSH etc inside a UDP tunnel.
> > > >
> > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > > ---
> 
> > > > +static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> > > > +{
> > >
> > >
> > > > +       skb_push(skb, sizeof(struct ethhdr));
> > > > +       eh = (struct ethhdr *)skb->data;
> > > > +       eh->h_proto = proto;
> > > > +
> > > > +       skb_reset_mac_header(skb);
> > > > +       skb->protocol = eth_type_trans(skb, bareudp->dev);
> > > > +       skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > > > +       oiph = skb_network_header(skb);
> > > > +       skb_reset_network_header(skb);
> > > > +
> > > > +       if (bareudp_get_sk_family(bs) == AF_INET)
> > >
> > > This should be derived from packet contents, not socket state.
> > > Although the one implies the other, I imagine.
> > >
> >
> > The IP Stack check IP headers & puts the packet in the correct socket, hence checking the ip headers again is reduntant correct?
> 
> This parses the inner packet after decapsulation. The protocol stack
> has selected the socket based on the outer packet, right?
> 

The check on socket  " if (bareudp_get_sk_family(bs) == AF_INET)"  was to find out the outer header was ipv4 and v6.
Based on that TOS/ECN of outer header is derived from oiph->tos for ipv4 and using ipv6_get_dsfield(oipv6h) for ipv6.
The TOS/ECN  of inner header are derived in funtions IP_ECN_decapsulate  & IP6_ECN_decapsulate.And they are derived from packet.
> I guess the correctness comes from the administrator having configured
> the bareudp for this protocol type, so implicitly guarantees that no
> other inner packets will appear.
> 
Yes that is correct.

> Also, the oiph pointer is a bit fragile now that a new mac header is
> constructed in the space that used to hold the encapsulation headers.
> I suppose it only updates eth->h_proto, which lies in the former udp
> header. More fundamentally, is moving the mac header needed at all, if
> the stack correctly uses skb_mac_header whenever it accesses also
> after decapsulation?
>

We need to move ethernet header. As there could be cases where the packet from a bareudp device is redirected via
other physical interface to a different network node for further processing.
I agree that oiph pointer is fragile, but since we are updating only proto field we are not corrupting the oiph.
But we can do ethernet header update once the oiph is no more used.It would entail setting the skb->protocol before calling IP_ECN_decapsulate 


 
> > In geneve & vxlan it is done the same way.
> >
> >
> > > > +static struct rtable *bareudp_get_v4_rt(struct sk_buff *skb,
> > > > +                                       struct net_device *dev,
> > > > +                                       struct bareudp_sock *bs4,
> > > > +                                       struct flowi4 *fl4,
> > > > +                                       const struct ip_tunnel_info *info)
> > > > +{
> > > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > > +       struct dst_cache *dst_cache;
> > > > +       struct rtable *rt = NULL;
> > > > +       __u8 tos;
> > > > +
> > > > +       if (!bs4)
> > > > +               return ERR_PTR(-EIO);
> > > > +
> > > > +       memset(fl4, 0, sizeof(*fl4));
> > > > +       fl4->flowi4_mark = skb->mark;
> > > > +       fl4->flowi4_proto = IPPROTO_UDP;
> > > > +       fl4->daddr = info->key.u.ipv4.dst;
> > > > +       fl4->saddr = info->key.u.ipv4.src;
> > > > +
> > > > +       tos = info->key.tos;
> > > > +       fl4->flowi4_tos = RT_TOS(tos);
> > > > +
> > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > +       if (use_cache) {
> > > > +               rt = dst_cache_get_ip4(dst_cache, &fl4->saddr);
> > > > +               if (rt)
> > > > +                       return rt;
> > > > +       }
> > > > +       rt = ip_route_output_key(bareudp->net, fl4);
> > > > +       if (IS_ERR(rt)) {
> > > > +               netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
> > > > +               return ERR_PTR(-ENETUNREACH);
> > > > +       }
> > > > +       if (rt->dst.dev == dev) { /* is this necessary? */
> > > > +               netdev_dbg(dev, "circular route to %pI4\n", &fl4->daddr);
> > > > +               ip_rt_put(rt);
> > > > +               return ERR_PTR(-ELOOP);
> > > > +       }
> > > > +       if (use_cache)
> > > > +               dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
> > > > +       return rt;
> > > > +}
> > > > +
> > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > +static struct dst_entry *bareudp_get_v6_dst(struct sk_buff *skb,
> > > > +                                           struct net_device *dev,
> > > > +                                           struct bareudp_sock *bs6,
> > > > +                                           struct flowi6 *fl6,
> > > > +                                           const struct ip_tunnel_info *info)
> > > > +{
> > > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > > +       struct dst_entry *dst = NULL;
> > > > +       struct dst_cache *dst_cache;
> > > > +       __u8 prio;
> > > > +
> > > > +       if (!bs6)
> > > > +               return ERR_PTR(-EIO);
> > > > +
> > > > +       memset(fl6, 0, sizeof(*fl6));
> > > > +       fl6->flowi6_mark = skb->mark;
> > > > +       fl6->flowi6_proto = IPPROTO_UDP;
> > > > +       fl6->daddr = info->key.u.ipv6.dst;
> > > > +       fl6->saddr = info->key.u.ipv6.src;
> > > > +       prio = info->key.tos;
> > > > +
> > > > +       fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
> > > > +                                          info->key.label);
> > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > +       if (use_cache) {
> > > > +               dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
> > > > +               if (dst)
> > > > +                       return dst;
> > > > +       }
> > > > +       if (ipv6_stub->ipv6_dst_lookup(bareudp->net, bs6->sock->sk, &dst,
> > > > +                                      fl6)) {
> > > > +               netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
> > > > +               return ERR_PTR(-ENETUNREACH);
> > > > +       }
> > > > +       if (dst->dev == dev) { /* is this necessary? */
> > > > +               netdev_dbg(dev, "circular route to %pI6\n", &fl6->daddr);
> > > > +               dst_release(dst);
> > > > +               return ERR_PTR(-ELOOP);
> > > > +       }
> > > > +
> > > > +       if (use_cache)
> > > > +               dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
> > > > +       return dst;
> > > > +}
> > > > +#endif
> > >
> > > The route lookup logic is very similar to vxlan_get_route and
> > > vxlan6_get_route. Can be reused?
> >
> > I had a look at the vxlan & geneve and it seems the corresponding functions  in those modules are tightly coupled  to the rest of the module design.
> > More specifically wrt the ttl inheritance & the caching behaviour. It may not be possible for those modules to use a new generic API unless without a change in those module design.
> 
> bareudp_get_v4_rt is identical to geneve_get_v4_rt down to the comment
> aside from
> 
>         if ((tos == 1) && !geneve->collect_md) {
>                 tos = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
>                 use_cache = false;
>         }
> 
> Same for bareudp_get_v6_dst and geneve_get_v6_dst.
> 
> Worst case that one branch could be made conditional on a boolean
> argument? Maybe this collect_md part (eventually) makes sense to
> bareudp, as well.
> 
> 
Unlike Geneve, bareudp module is  a generic L3 encapsulation module and it could be used to tunnel different L3 protocols.
TTL inheritance requirements for these protocols will be different when tunnelled. For Example - TTL inheritance for MPLS & IP are different.
And moving this function to a common place will make it tough for Geneve & bareudp if a new L3 protocol with new TTL inheritance requirements shows up


> 
> > The bareudp module is a generic L3 encapsulation module. It could be used to tunnel different l3 protocols. TTL Inheritance behaviour when tunnelled
> > could be different for these inner protocols. Hence moving  this function to a common place will make it tough to change it later when a need arises for a new protocol
> >
> > Otherwise we should have more generic function which takes the  generic IP header params as arguments. Then the point is we don’t need a function like that
> > We can just fill up "struct flowi4" and call ip_route_output_key or dst_cache_get_ip4 to get the route table entry
> >
> >
> > Thanks
> > Martin
