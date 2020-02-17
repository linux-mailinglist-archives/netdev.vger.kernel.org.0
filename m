Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078671609D0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 06:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgBQFUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 00:20:06 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43799 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgBQFUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 00:20:05 -0500
Received: by mail-yb1-f196.google.com with SMTP id b141so8133453ybg.10
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 21:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Klaqi42nk+dQlmzrH/S5DstKEezF5OIZyqttsOA2p4=;
        b=NuTL2mrjsDSxS3elOIJtaz2TafLRu7vGAdbVocZSgICi13MwyDYWr5/lrdg9Y3Pnsx
         Y+OMQ6Ip5t7y5fTSzzvicXK7WXFaeB6cglMyBn+hEXt8M9aG/Wyu/I/phKev3A1J6mPP
         jGuoJ9PrNfS3UliY6GR2mhkwCfkv/cEBv4dLPr6d7NUolYE6Aoui6j2nZFXcGhGzHyzb
         bd5xUvC4wpcInaaZ3PKMVErn6btIuDlWngNBsPIuPADBNQQshdZs8P76mVY3eMXOytVv
         nGLVR8GbKy/GVKwqRW3Fetw4+T+ulPv0heMyDE54BL57cY/rbEwGp9mNXMrh+ZCRYkFG
         kkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Klaqi42nk+dQlmzrH/S5DstKEezF5OIZyqttsOA2p4=;
        b=iLBl+gXr9OSUDM6u1zlUlz5eq6Sjfimy4WUiqJ5/84xGNNaZK4x1KwOo1NARbXmS3S
         3GRY3JszUkKjkmMqIORjSCZg+C5voHTZiegjoxEMTmKHXqqv2w2szWAuAeBs8iSZ96tU
         WRZBQRKBTMY8q0abYsfblGiofB+JdW0QUiZFe6Brl0J96zzkL8b7fbqHqNzlg95qylYN
         BHVhGD/89dqBBIuVlPPOywmJvvbxuWIkQQbc/1vNo9mn0a7OY0q6ScMPaSFR03XNqV3H
         9T3E5VSHQtQ3qd+5iM0spsVGeEkX7thHj9FcI787isUea/91dzJzHtGGqHWTjqrJznXw
         pQ6Q==
X-Gm-Message-State: APjAAAW/ZPQTV5Jc6WgV4nMr9wOqCWParJtZJMuTkS7/OLQSn5dHaPTt
        BgqUJ6JvD1wviBKUqpylIN72E9n7
X-Google-Smtp-Source: APXvYqz5UA9nXKRexavkreEojpVaKJKr3XtAIPfik6sao4Yrvg9F2eEeoxOh5vXHFD9Koxby+bqBjg==
X-Received: by 2002:a25:be91:: with SMTP id i17mr13180865ybk.452.1581916804218;
        Sun, 16 Feb 2020 21:20:04 -0800 (PST)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id b195sm6153062ywh.80.2020.02.16.21.20.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 21:20:03 -0800 (PST)
Received: by mail-yb1-f180.google.com with SMTP id v12so8139806ybi.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 21:20:03 -0800 (PST)
X-Received: by 2002:a25:6906:: with SMTP id e6mr12753364ybc.441.1581916802871;
 Sun, 16 Feb 2020 21:20:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfdBm4z4dTT3dHB=Fe7GTwrjJkHRw-5W3cSHbAWa1T_eQ@mail.gmail.com> <20200217024943.GA11700@martin-VirtualBox>
In-Reply-To: <20200217024943.GA11700@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 16 Feb 2020 21:19:24 -0800
X-Gmail-Original-Message-ID: <CA+FuTSd=x3TDKjmtZZv3Hv1L=zMKSoSc4nt3wgcFhvJc-KB+tA@mail.gmail.com>
Message-ID: <CA+FuTSd=x3TDKjmtZZv3Hv1L=zMKSoSc4nt3wgcFhvJc-KB+tA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> > > index cec1a54..1bf8065 100644
> > > --- a/include/net/ipv6.h
> > > +++ b/include/net/ipv6.h
> > > @@ -1027,6 +1027,12 @@ struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, st
> > >  struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
> > >                                          const struct in6_addr *final_dst,
> > >                                          bool connected);
> > > +struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
> > > +                                       struct net_device *dev,
> > > +                                       struct net *net, struct socket *sock,
> > > +                                       struct in6_addr *saddr,
> > > +                                       const struct ip_tunnel_info *info,
> > > +                                       u8 protocol, bool use_cache);
> > >  struct dst_entry *ip6_blackhole_route(struct net *net,
> > >                                       struct dst_entry *orig_dst);
> > >
> > > diff --git a/include/net/route.h b/include/net/route.h
> > > index a9c60fc..81750ae 100644
> > > --- a/include/net/route.h
> > > +++ b/include/net/route.h
> > > @@ -128,6 +128,12 @@ static inline struct rtable *__ip_route_output_key(struct net *net,
> > >
> > >  struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
> > >                                     const struct sock *sk);
> > > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > > +                                     struct net_device *dev,
> > > +                                     struct net *net, __be32 *saddr,
> > > +                                     const struct ip_tunnel_info *info,
> > > +                                     u8 protocol, bool use_cache);
> > > +
> > >  struct dst_entry *ipv4_blackhole_route(struct net *net,
> > >                                        struct dst_entry *dst_orig);
> > >
> >
> > Ah, I now see where the difference between net/ipv4/route.c and
> > net/ipv6/ip6_output.c come from. It follows from existing locations of
> >  ip6_sk_dst_lookup_flow and ip_route_output_flow.
> >
> > Looking for the ipv6 analog of ip_route_output_flow, I see that, e.g.,
> > ipvlan uses ip6_route_output from net/ipv6/route.c without a NULL sk.
> > But ping calls ip6_sk_dst_lookup_flow.
> >
> > It might be a better fit behind ip6_route_output_flags, but it's
> > probably moot, really.
>
> Actually i considered both the files but i felt this function
> should naturally sit with ip6_sk_dst_lookup_flow.
> If you dont have strong objection i would like to keep the
> function in ip6_output.c

Yes, sounds good, thanks. The difference stood out to me in an initial
git show --stat, but on closer reading both choices can be argued for.
