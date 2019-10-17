Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD66DDB8A5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 22:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395184AbfJQUtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 16:49:08 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:36580 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728420AbfJQUtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 16:49:07 -0400
Received: by mail-yw1-f67.google.com with SMTP id x64so1369363ywg.3
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 13:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pBNYdqc2YSvIj6dkxfx1AnclyKc/vSMiI0PdnPlJZq0=;
        b=dnexs5LJk4TIauQA3Id2FrpuUAv9LAbyzqQAuGxvFhq5YRDKzFskDWaWxzeK/PAMRM
         ODoKPwYVpFOpnQvk0JtbzF1u92TA1qCOxdnX1ASjfqRRCz/uN9mk7mW1068ja/1F1as3
         13cvYjgWaJBuLPIwaTlNqqwjKvOyadyNi3oaR70PQXZjU2uJ9v9XVajCBdLoIq4slTH3
         gT9E3tDieZ5PXeJcyfCDpq4NQZmw/BKxnDolKFk/yBJ2bg310qI21YESh4KRcAU1fGkZ
         EB7bDnCVIHcGG615jcCcaWflapu5ofoqew/MF9idcFCQ+AcsNMkg2XfWf4E3Gww11Vpe
         j5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pBNYdqc2YSvIj6dkxfx1AnclyKc/vSMiI0PdnPlJZq0=;
        b=kYatpCK40/BrWsgzT6jWf2KqUXp1viyriw5y2uonXXa9/kLhSS1js8evFuI80KX0qK
         EYuIiMSdz8ybdDIbE1/V4lCxS3ZZK20LU3OTDqe9f6D3AgR/nRKY5XBeoF1gO9UQYBP2
         GXAG1c/IhmT/pKXXuVfdzZCxbOlpIYISUNZ4q6Ni0xTRUxdjcnVjET7wZKbvFizt41//
         R9GLL9i4N71epiEQ3ms0Lh4Tqtw3Z/veYUUi7i+Ab1HyyxG5Wi+AV9uhPZZLsSFxo7xH
         1N6ndkkuebSk+vgo9PMyb7/ltlCSjU6RhvfESExG7r1s30xdjf9eU4icdPqPgR78mj1G
         6Cew==
X-Gm-Message-State: APjAAAUls2G6CT5UPkiVSFIYqp26AmZkQTeyD6GWH/mSmOGbhGxbRBRY
        x7VcAQu6vm9WgxFs+zRt7PrWj8oo
X-Google-Smtp-Source: APXvYqwy7Blb7xosaDksZKrUX7ie/YmWcnm+OaliDUOcTzFygm32gfN8fOXu097MVDXzKRuCTIUFMQ==
X-Received: by 2002:a81:1a85:: with SMTP id a127mr4639279ywa.53.1571345345948;
        Thu, 17 Oct 2019 13:49:05 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id z66sm280869ywz.78.2019.10.17.13.49.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 13:49:04 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id s7so1140225ybq.7
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 13:49:03 -0700 (PDT)
X-Received: by 2002:a25:3753:: with SMTP id e80mr3842771yba.203.1571345342876;
 Thu, 17 Oct 2019 13:49:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com> <20191017132029.GA9982@martin-VirtualBox>
In-Reply-To: <20191017132029.GA9982@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 17 Oct 2019 16:48:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
Message-ID: <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 9:20 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 08, 2019 at 12:28:23PM -0400, Willem de Bruijn wrote:
> > On Tue, Oct 8, 2019 at 5:51 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin <martin.varghese@nokia.com>
> > >
> > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > tunnelling module for tunnelling different protocols like MPLS,
> > > IP,NSH etc inside a UDP tunnel.
> > >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > ---

> > > +static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *s=
kb)
> > > +{
> >
> >
> > > +       skb_push(skb, sizeof(struct ethhdr));
> > > +       eh =3D (struct ethhdr *)skb->data;
> > > +       eh->h_proto =3D proto;
> > > +
> > > +       skb_reset_mac_header(skb);
> > > +       skb->protocol =3D eth_type_trans(skb, bareudp->dev);
> > > +       skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > > +       oiph =3D skb_network_header(skb);
> > > +       skb_reset_network_header(skb);
> > > +
> > > +       if (bareudp_get_sk_family(bs) =3D=3D AF_INET)
> >
> > This should be derived from packet contents, not socket state.
> > Although the one implies the other, I imagine.
> >
>
> The IP Stack check IP headers & puts the packet in the correct socket, he=
nce checking the ip headers again is reduntant correct?

This parses the inner packet after decapsulation. The protocol stack
has selected the socket based on the outer packet, right?

I guess the correctness comes from the administrator having configured
the bareudp for this protocol type, so implicitly guarantees that no
other inner packets will appear.

Also, the oiph pointer is a bit fragile now that a new mac header is
constructed in the space that used to hold the encapsulation headers.
I suppose it only updates eth->h_proto, which lies in the former udp
header. More fundamentally, is moving the mac header needed at all, if
the stack correctly uses skb_mac_header whenever it accesses also
after decapsulation?

> In geneve & vxlan it is done the same way.
>
>
> > > +static struct rtable *bareudp_get_v4_rt(struct sk_buff *skb,
> > > +                                       struct net_device *dev,
> > > +                                       struct bareudp_sock *bs4,
> > > +                                       struct flowi4 *fl4,
> > > +                                       const struct ip_tunnel_info *=
info)
> > > +{
> > > +       bool use_cache =3D ip_tunnel_dst_cache_usable(skb, info);
> > > +       struct bareudp_dev *bareudp =3D netdev_priv(dev);
> > > +       struct dst_cache *dst_cache;
> > > +       struct rtable *rt =3D NULL;
> > > +       __u8 tos;
> > > +
> > > +       if (!bs4)
> > > +               return ERR_PTR(-EIO);
> > > +
> > > +       memset(fl4, 0, sizeof(*fl4));
> > > +       fl4->flowi4_mark =3D skb->mark;
> > > +       fl4->flowi4_proto =3D IPPROTO_UDP;
> > > +       fl4->daddr =3D info->key.u.ipv4.dst;
> > > +       fl4->saddr =3D info->key.u.ipv4.src;
> > > +
> > > +       tos =3D info->key.tos;
> > > +       fl4->flowi4_tos =3D RT_TOS(tos);
> > > +
> > > +       dst_cache =3D (struct dst_cache *)&info->dst_cache;
> > > +       if (use_cache) {
> > > +               rt =3D dst_cache_get_ip4(dst_cache, &fl4->saddr);
> > > +               if (rt)
> > > +                       return rt;
> > > +       }
> > > +       rt =3D ip_route_output_key(bareudp->net, fl4);
> > > +       if (IS_ERR(rt)) {
> > > +               netdev_dbg(dev, "no route to %pI4\n", &fl4->daddr);
> > > +               return ERR_PTR(-ENETUNREACH);
> > > +       }
> > > +       if (rt->dst.dev =3D=3D dev) { /* is this necessary? */
> > > +               netdev_dbg(dev, "circular route to %pI4\n", &fl4->dad=
dr);
> > > +               ip_rt_put(rt);
> > > +               return ERR_PTR(-ELOOP);
> > > +       }
> > > +       if (use_cache)
> > > +               dst_cache_set_ip4(dst_cache, &rt->dst, fl4->saddr);
> > > +       return rt;
> > > +}
> > > +
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +static struct dst_entry *bareudp_get_v6_dst(struct sk_buff *skb,
> > > +                                           struct net_device *dev,
> > > +                                           struct bareudp_sock *bs6,
> > > +                                           struct flowi6 *fl6,
> > > +                                           const struct ip_tunnel_in=
fo *info)
> > > +{
> > > +       bool use_cache =3D ip_tunnel_dst_cache_usable(skb, info);
> > > +       struct bareudp_dev *bareudp =3D netdev_priv(dev);
> > > +       struct dst_entry *dst =3D NULL;
> > > +       struct dst_cache *dst_cache;
> > > +       __u8 prio;
> > > +
> > > +       if (!bs6)
> > > +               return ERR_PTR(-EIO);
> > > +
> > > +       memset(fl6, 0, sizeof(*fl6));
> > > +       fl6->flowi6_mark =3D skb->mark;
> > > +       fl6->flowi6_proto =3D IPPROTO_UDP;
> > > +       fl6->daddr =3D info->key.u.ipv6.dst;
> > > +       fl6->saddr =3D info->key.u.ipv6.src;
> > > +       prio =3D info->key.tos;
> > > +
> > > +       fl6->flowlabel =3D ip6_make_flowinfo(RT_TOS(prio),
> > > +                                          info->key.label);
> > > +       dst_cache =3D (struct dst_cache *)&info->dst_cache;
> > > +       if (use_cache) {
> > > +               dst =3D dst_cache_get_ip6(dst_cache, &fl6->saddr);
> > > +               if (dst)
> > > +                       return dst;
> > > +       }
> > > +       if (ipv6_stub->ipv6_dst_lookup(bareudp->net, bs6->sock->sk, &=
dst,
> > > +                                      fl6)) {
> > > +               netdev_dbg(dev, "no route to %pI6\n", &fl6->daddr);
> > > +               return ERR_PTR(-ENETUNREACH);
> > > +       }
> > > +       if (dst->dev =3D=3D dev) { /* is this necessary? */
> > > +               netdev_dbg(dev, "circular route to %pI6\n", &fl6->dad=
dr);
> > > +               dst_release(dst);
> > > +               return ERR_PTR(-ELOOP);
> > > +       }
> > > +
> > > +       if (use_cache)
> > > +               dst_cache_set_ip6(dst_cache, dst, &fl6->saddr);
> > > +       return dst;
> > > +}
> > > +#endif
> >
> > The route lookup logic is very similar to vxlan_get_route and
> > vxlan6_get_route. Can be reused?
>
> I had a look at the vxlan & geneve and it seems the corresponding functio=
ns  in those modules are tightly coupled  to the rest of the module design.
> More specifically wrt the ttl inheritance & the caching behaviour. It may=
 not be possible for those modules to use a new generic API unless without =
a change in those module design.

bareudp_get_v4_rt is identical to geneve_get_v4_rt down to the comment
aside from

        if ((tos =3D=3D 1) && !geneve->collect_md) {
                tos =3D ip_tunnel_get_dsfield(ip_hdr(skb), skb);
                use_cache =3D false;
        }

Same for bareudp_get_v6_dst and geneve_get_v6_dst.

Worst case that one branch could be made conditional on a boolean
argument? Maybe this collect_md part (eventually) makes sense to
bareudp, as well.



> The bareudp module is a generic L3 encapsulation module. It could be used=
 to tunnel different l3 protocols. TTL Inheritance behaviour when tunnelled
> could be different for these inner protocols. Hence moving  this function=
 to a common place will make it tough to change it later when a need arises=
 for a new protocol
>
> Otherwise we should have more generic function which takes the  generic I=
P header params as arguments. Then the point is we don=E2=80=99t need a fun=
ction like that
> We can just fill up "struct flowi4" and call ip_route_output_key or dst_c=
ache_get_ip4 to get the route table entry
>
>
> Thanks
> Martin
