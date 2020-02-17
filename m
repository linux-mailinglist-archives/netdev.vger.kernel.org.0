Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCE1160853
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBQCtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:49:49 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37964 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgBQCts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:49:48 -0500
Received: by mail-pg1-f193.google.com with SMTP id d6so8262106pgn.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 18:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ywJwOOxzyEYrZwSjpCFVqCUvNC6Gsi/zYbh8rasTSZ4=;
        b=abUGd6GggKVwz2RVaXo17AHvz9uy7QtWVqx1bPlP6L7ZVu+g22vghxLTOsppX26AMu
         qn4yfTVpm1Q2CENUwQPWOfspJ1gyGQuBRi3xrZPiaAuoIhodM/Z3c1H5/7PTcIEoYmHH
         SYPEsFL7ajR4hutQmDOdcoOscXhbBUtqmTgX9V6y+EZl1ESEFVSK+D0k5rJdnnGO5del
         08AL8wtxWMnXg3c8D8KxnnPK6P0bfUDvRVjC97PEgAY2RYxDJ3wRqDO9nar1qfQJR3hJ
         BpDIRgLBfJvEEyeyNlZiHm5nNdjxS3mcN+KjP8ByEW3O+ZE+z7/akTmoMfkKFHdGK3SD
         kBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ywJwOOxzyEYrZwSjpCFVqCUvNC6Gsi/zYbh8rasTSZ4=;
        b=F8BRce3oggIoWqgoVRUdxp6S9Mei+QS8rByeuXzlrFS/8y8iTunZ3fIRIH7q5NP+iD
         GQ8KZLwM2sbp+L6Hlc4A816Mkjx1WSTjU5hhDAJLm8tbp2lGopDPjtY0mQ3w4GkAgRq/
         R0DS28Ap2I5EQrPxtS2tHiu9TyeQ+4BLUFOobr4c8h938ecqO8tDai3Mj2Xs1WONsG5Z
         4Y7OWgM+w0DnsBynS2Rj5Ycshi6q+N9lwDXp4+gDKfjXzWxvqmT7q9MZqFGkAxOc25rw
         78iWZHMgsO4msQD5wK+NdrJ3Ljz3b5Gt7Q+hDJTs9XUJxcxsRC6sr3vsQfSrlweznccK
         X1Bg==
X-Gm-Message-State: APjAAAWz6z9tdspQQs6EDEindQoW/7+c/5ciANtUaqUgAMR5lvsq8RgX
        rC/F7ArUP9xJd8pTEPA7Guc=
X-Google-Smtp-Source: APXvYqz+mpa33Bcw1s/9blStN2CLS9OeHHqXu3oxBi1Iha7B+Q0N7aWC8ZPYN88S6ScN4LnI24Ywcw==
X-Received: by 2002:a63:d441:: with SMTP id i1mr16256387pgj.426.1581907787521;
        Sun, 16 Feb 2020 18:49:47 -0800 (PST)
Received: from martin-VirtualBox ([137.97.166.11])
        by smtp.gmail.com with ESMTPSA id r6sm14415228pfh.91.2020.02.16.18.49.46
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 16 Feb 2020 18:49:47 -0800 (PST)
Date:   Mon, 17 Feb 2020 08:19:43 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v7 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20200217024943.GA11700@martin-VirtualBox>
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfdBm4z4dTT3dHB=Fe7GTwrjJkHRw-5W3cSHbAWa1T_eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfdBm4z4dTT3dHB=Fe7GTwrjJkHRw-5W3cSHbAWa1T_eQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 12:26:18PM -0600, Willem de Bruijn wrote:
> On Sat, Feb 15, 2020 at 12:20 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The Bareudp tunnel module provides a generic L3 encapsulation
> > tunnelling module for tunnelling different protocols like MPLS,
> > IP,NSH etc inside a UDP tunnel.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> > +struct net_device *bareudp_dev_create(struct net *net, const char *name,
> > +                                     u8 name_assign_type,
> > +                                     struct bareudp_conf *conf)
> > +{
> > +       struct nlattr *tb[IFLA_MAX + 1];
> > +       struct net_device *dev;
> > +       LIST_HEAD(list_kill);
> > +       int err;
> > +
> > +       memset(tb, 0, sizeof(tb));
> > +       dev = rtnl_create_link(net, name, name_assign_type,
> > +                              &bareudp_link_ops, tb, NULL);
> > +       if (IS_ERR(dev))
> > +               return dev;
> > +
> > +       err = bareudp_configure(net, dev, conf);
> > +       if (err) {
> > +               free_netdev(dev);
> > +               return ERR_PTR(err);
> > +       }
> > +       err = dev_set_mtu(dev, IP_MAX_MTU);
> 
> does this not exceed dev->max_mtu?
> 
Noted.Must consider BAREUDP Overhead.
> > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > index cec1a54..1bf8065 100644
> > --- a/include/net/ipv6.h
> > +++ b/include/net/ipv6.h
> > @@ -1027,6 +1027,12 @@ struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, st
> >  struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
> >                                          const struct in6_addr *final_dst,
> >                                          bool connected);
> > +struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
> > +                                       struct net_device *dev,
> > +                                       struct net *net, struct socket *sock,
> > +                                       struct in6_addr *saddr,
> > +                                       const struct ip_tunnel_info *info,
> > +                                       u8 protocol, bool use_cache);
> >  struct dst_entry *ip6_blackhole_route(struct net *net,
> >                                       struct dst_entry *orig_dst);
> >
> > diff --git a/include/net/route.h b/include/net/route.h
> > index a9c60fc..81750ae 100644
> > --- a/include/net/route.h
> > +++ b/include/net/route.h
> > @@ -128,6 +128,12 @@ static inline struct rtable *__ip_route_output_key(struct net *net,
> >
> >  struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
> >                                     const struct sock *sk);
> > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > +                                     struct net_device *dev,
> > +                                     struct net *net, __be32 *saddr,
> > +                                     const struct ip_tunnel_info *info,
> > +                                     u8 protocol, bool use_cache);
> > +
> >  struct dst_entry *ipv4_blackhole_route(struct net *net,
> >                                        struct dst_entry *dst_orig);
> >
> 
> Ah, I now see where the difference between net/ipv4/route.c and
> net/ipv6/ip6_output.c come from. It follows from existing locations of
>  ip6_sk_dst_lookup_flow and ip_route_output_flow.
> 
> Looking for the ipv6 analog of ip_route_output_flow, I see that, e.g.,
> ipvlan uses ip6_route_output from net/ipv6/route.c without a NULL sk.
> But ping calls ip6_sk_dst_lookup_flow.
> 
> It might be a better fit behind ip6_route_output_flags, but it's
> probably moot, really.

Actually i considered both the files but i felt this function 
should naturally sit with ip6_sk_dst_lookup_flow.
If you dont have strong objection i would like to keep the
function in ip6_output.c
