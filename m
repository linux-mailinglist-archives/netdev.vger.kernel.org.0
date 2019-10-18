Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486C7DC7F9
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 17:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505104AbfJRPA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 11:00:28 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36007 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392463AbfJRPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 11:00:28 -0400
Received: by mail-yw1-f67.google.com with SMTP id x64so2275612ywg.3
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 08:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4nELmVlmtLOUgWPCJRXpZideUdtQN+t6dEJbBPJKwv0=;
        b=cHssbYZbyQu7TEwwkGJPWe2mbdilo8h9Ex3WHWzmelV2OzYzBN2u4hGeedxb1GlKzP
         Ce6jobcE9w18sUChUNkh8pt0xBAnc1oF6NWuyuro75YNjs1pz2XQCAsVRQkpFQBVDD/K
         oi+firuaVQ/F098e2ZnRxhqGnTdAwlt3i+jDYTCEfafdpuwZW6Ivr4ml5pZEYwJsYOC4
         qXpUGiG4JGWklYg9uKpQh4/ITW4LT33A3G5ZtXzeA7uNm6LaruLmyJXiGsC17BioWNjJ
         tOXDCKZ5M4uAicitKK64sj7r49WG71jFpDOADO4olSnW+JkVTYwbd3cPfQIHiY8u/I6N
         DP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4nELmVlmtLOUgWPCJRXpZideUdtQN+t6dEJbBPJKwv0=;
        b=onADVUUUIDk5KvYn0fmcJ4qyYj8rAAkV7dWE7AVC/0SePzzb77HIdhK3PPraRCWrX8
         Z9IdeGk6kpc7zRJLuS1jEjLP3cDYU3XSRzO6PJJhWcPyLPU0Msei6ToD8x3gtD9LWu/6
         8Fdc/NGWob13YEOtqlnDM377SiHrW7IO/nCDybgl4K0ZF6VJW+hJm3Cn8qRNIyZagrOY
         I8b54kDVdwvvmU8gcMlwuOsKEukBelCPlkKikEmUKLdnzCUE+vcn4LjyRk1bkULzr1S9
         UvyPmN6StanwHkLXxE8e/pF56EF6deG84sgqpJtpk0pfB5NcoEYRHkIK347SjVCubzEl
         TJIw==
X-Gm-Message-State: APjAAAVD/4RUjn3elW1OTLwHW8v63G7C+zK7QFyCw3JovzfFJx1xTi5W
        WkNAXgYjPLlpvRZ0BjJJ9xJL/En8
X-Google-Smtp-Source: APXvYqwasXkq5bYbnbegvpqIaWUxCpG9ApTTxsoghmcTsOKyWYccFHzRvY36+n1fq0NGcitZTJjW1w==
X-Received: by 2002:a81:70c2:: with SMTP id l185mr7060691ywc.347.1571410826308;
        Fri, 18 Oct 2019 08:00:26 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id f127sm1363482ywe.89.2019.10.18.08.00.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2019 08:00:24 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id d192so2279309ywa.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 08:00:24 -0700 (PDT)
X-Received: by 2002:a81:6f8a:: with SMTP id k132mr7033014ywc.275.1571410823598;
 Fri, 18 Oct 2019 08:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox>
In-Reply-To: <20191018082029.GA11876@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 18 Oct 2019 10:59:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
Message-ID: <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 4:20 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Oct 17, 2019 at 04:48:26PM -0400, Willem de Bruijn wrote:
> > On Thu, Oct 17, 2019 at 9:20 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Tue, Oct 08, 2019 at 12:28:23PM -0400, Willem de Bruijn wrote:
> > > > On Tue, Oct 8, 2019 at 5:51 AM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > From: Martin <martin.varghese@nokia.com>
> > > > >
> > > > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > > > tunnelling module for tunnelling different protocols like MPLS,
> > > > > IP,NSH etc inside a UDP tunnel.
> > > > >
> > > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > > > ---
> >
> > > > > +static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> > > > > +{
> > > >
> > > >
> > > > > +       skb_push(skb, sizeof(struct ethhdr));
> > > > > +       eh = (struct ethhdr *)skb->data;
> > > > > +       eh->h_proto = proto;
> > > > > +
> > > > > +       skb_reset_mac_header(skb);
> > > > > +       skb->protocol = eth_type_trans(skb, bareudp->dev);
> > > > > +       skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > > > > +       oiph = skb_network_header(skb);
> > > > > +       skb_reset_network_header(skb);
> > > > > +
> > > > > +       if (bareudp_get_sk_family(bs) == AF_INET)
> > > >
> > > > This should be derived from packet contents, not socket state.
> > > > Although the one implies the other, I imagine.
> > > >
> > >
> > > The IP Stack check IP headers & puts the packet in the correct socket, hence checking the ip headers again is reduntant correct?
> >
> > This parses the inner packet after decapsulation. The protocol stack
> > has selected the socket based on the outer packet, right?
> >
>
> The check on socket  " if (bareudp_get_sk_family(bs) == AF_INET)"  was to find out the outer header was ipv4 and v6.
> Based on that TOS/ECN of outer header is derived from oiph->tos for ipv4 and using ipv6_get_dsfield(oipv6h) for ipv6.
> The TOS/ECN  of inner header are derived in funtions IP_ECN_decapsulate  & IP6_ECN_decapsulate.And they are derived from packet.
> > I guess the correctness comes from the administrator having configured
> > the bareudp for this protocol type, so implicitly guarantees that no
> > other inner packets will appear.
> >
> Yes that is correct.
>
> > Also, the oiph pointer is a bit fragile now that a new mac header is
> > constructed in the space that used to hold the encapsulation headers.
> > I suppose it only updates eth->h_proto, which lies in the former udp
> > header. More fundamentally, is moving the mac header needed at all, if
> > the stack correctly uses skb_mac_header whenever it accesses also
> > after decapsulation?
> >
>
> We need to move ethernet header. As there could be cases where the packet from a bareudp device is redirected via
> other physical interface to a different network node for further processing.
> I agree that oiph pointer is fragile, but since we are updating only proto field we are not corrupting the oiph.
> But we can do ethernet header update once the oiph is no more used.It would entail setting the skb->protocol before calling IP_ECN_decapsulate
>
>
>
> > > In geneve & vxlan it is done the same way.

I see, yes, geneve does the same thing.

> > >
> > >
> > > > > +static struct rtable *bareudp_get_v4_rt(struct sk_buff *skb,
> > > > > +                                       struct net_device *dev,
> > > > > +                                       struct bareudp_sock *bs4,
> > > > > +                                       struct flowi4 *fl4,
> > > > > +                                       const struct ip_tunnel_info *info)
> > > > > +{
> > > > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > > > +       struct dst_cache *dst_cache;
> > > > > +       struct rtable *rt = NULL;
> > > > > +       __u8 tos;
> > > > > +
> > > > > +       if (!bs4)
> > > > > +               return ERR_PTR(-EIO);
> > > > > +
> > > > > +       memset(fl4, 0, sizeof(*fl4));
> > > > > +       fl4->flowi4_mark = skb->mark;
> > > > > +       fl4->flowi4_proto = IPPROTO_UDP;
> > > > > +       fl4->daddr = info->key.u.ipv4.dst;
> > > > > +       fl4->saddr = info->key.u.ipv4.src;
> > > > > +
> > > > > +       tos = info->key.tos;
> > > > > +       fl4->flowi4_tos = RT_TOS(tos);
> > > > > +
> > > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > > +       if (use_cache) {
> > > > > +               rt = dst_cache_get_ip4(dst_cache, &fl4->saddr);
> > > > > +               if (rt)
> > > > > +                       return rt;
> > > > > +       }
> > > > > +       rt = ip_route_output_key(bareudp->net, fl4);
> > > > > +       if (IS_ERR(rt)) {
> > > > > +               netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
> > > > > +               return ERR_PTR(-ENETUNREACH);
> > > > > +       }
> > > > > +       if (rt->dst.dev == dev) { /* is this necessary? */
> > > > > +               netdev_dbg(dev, "circular route to %pI4\n", &fl4->daddr);
> > > > > +               ip_rt_put(rt);
> > > > > +               return ERR_PTR(-ELOOP);
> > > > > +       }
> > > > > +       if (use_cache)
> > > > > +               dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
> > > > > +       return rt;
> > > > > +}
> > > > > +
> > > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > > +static struct dst_entry *bareudp_get_v6_dst(struct sk_buff *skb,
> > > > > +                                           struct net_device *dev,
> > > > > +                                           struct bareudp_sock *bs6,
> > > > > +                                           struct flowi6 *fl6,
> > > > > +                                           const struct ip_tunnel_info *info)
> > > > > +{
> > > > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > > > +       struct dst_entry *dst = NULL;
> > > > > +       struct dst_cache *dst_cache;
> > > > > +       __u8 prio;
> > > > > +
> > > > > +       if (!bs6)
> > > > > +               return ERR_PTR(-EIO);
> > > > > +
> > > > > +       memset(fl6, 0, sizeof(*fl6));
> > > > > +       fl6->flowi6_mark = skb->mark;
> > > > > +       fl6->flowi6_proto = IPPROTO_UDP;
> > > > > +       fl6->daddr = info->key.u.ipv6.dst;
> > > > > +       fl6->saddr = info->key.u.ipv6.src;
> > > > > +       prio = info->key.tos;
> > > > > +
> > > > > +       fl6->flowlabel = ip6_make_flowinfo(RT_TOS(prio),
> > > > > +                                          info->key.label);
> > > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > > +       if (use_cache) {
> > > > > +               dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
> > > > > +               if (dst)
> > > > > +                       return dst;
> > > > > +       }
> > > > > +       if (ipv6_stub->ipv6_dst_lookup(bareudp->net, bs6->sock->sk, &dst,
> > > > > +                                      fl6)) {
> > > > > +               netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
> > > > > +               return ERR_PTR(-ENETUNREACH);
> > > > > +       }
> > > > > +       if (dst->dev == dev) { /* is this necessary? */
> > > > > +               netdev_dbg(dev, "circular route to %pI6\n", &fl6->daddr);
> > > > > +               dst_release(dst);
> > > > > +               return ERR_PTR(-ELOOP);
> > > > > +       }
> > > > > +
> > > > > +       if (use_cache)
> > > > > +               dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
> > > > > +       return dst;
> > > > > +}
> > > > > +#endif
> > > >
> > > > The route lookup logic is very similar to vxlan_get_route and
> > > > vxlan6_get_route. Can be reused?
> > >
> > > I had a look at the vxlan & geneve and it seems the corresponding functions  in those modules are tightly coupled  to the rest of the module design.
> > > More specifically wrt the ttl inheritance & the caching behaviour. It may not be possible for those modules to use a new generic API unless without a change in those module design.
> >
> > bareudp_get_v4_rt is identical to geneve_get_v4_rt down to the comment
> > aside from
> >
> >         if ((tos == 1) && !geneve->collect_md) {
> >                 tos = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
> >                 use_cache = false;
> >         }
> >
> > Same for bareudp_get_v6_dst and geneve_get_v6_dst.
> >
> > Worst case that one branch could be made conditional on a boolean
> > argument? Maybe this collect_md part (eventually) makes sense to
> > bareudp, as well.
> >
> >
> Unlike Geneve, bareudp module is  a generic L3 encapsulation module and it could be used to tunnel different L3 protocols.
> TTL inheritance requirements for these protocols will be different when tunnelled. For Example - TTL inheritance for MPLS & IP are different.
> And moving this function to a common place will make it tough for Geneve & bareudp if a new L3 protocol with new TTL inheritance requirements shows up

But that is not in geneve_get_v4_rt and its bareudp/v6_dst variants.

I do think that with close scrutiny there is a lot more room for code
deduplication. Just look at the lower half of geneve_rx and
bareudp_udp_encap_recv, for instance. This, too, is identical down to
the comments. Indeed, is it fair to say that geneve was taken as the
basis for this device?

That said, even just avoiding duplicating those routing functions
would be a good start.

I'm harping on this because in other examples in the past where a new
device was created by duplicating instead of factoring out code
implementations diverge over time in bad ways due to optimizations,
features and most importantly bugfixes being applied only to one
instance or the other. See for instance tun.c and tap.c.

Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
not setting the v6only bit, so does the device need to have separate
sock4 and sock6 members? Both sockets currently lead to the same
bareudp_udp_encap_recv callback function.
