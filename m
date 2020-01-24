Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D44148FAC
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388496AbgAXUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:48:15 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39677 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388286AbgAXUsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 15:48:14 -0500
Received: by mail-ed1-f68.google.com with SMTP id m13so3951483edb.6
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 12:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSJvkVhtf7uxQYh6FJbUSVgLsP58YqWcIsCWxqBi1DU=;
        b=c9JubSl/ECFKsedkD6HfCppTxDF7/TXeQVxPW+26qTuMqIKRGDi52F6to2BHGNTf3U
         86/MUHlz4tNiqgaVQtB+0gncbUzGs4tuvyRgJkv6Akauep7rxkdL0J0ZbuX/BlGtMIHC
         hWFFwMtSHAsi/3Z9mkpTMIYFrIGJrtHjihxtFm1hSgIuuWaW1qx4ASHMi7GgE979NDPy
         /jWXLbk47YdcdmE7eq47U72v5QQmDDl9VxGO4krFhlGSKeDCl+tDgdbv5YDge0wzKc9P
         rO1Sn7TGE44uieAPPh+N/6oWwsxhmcrSFqH1qFGLlMwRVlaxtRwtXlAWLHcO14FIAwTV
         L02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSJvkVhtf7uxQYh6FJbUSVgLsP58YqWcIsCWxqBi1DU=;
        b=F+vogCFqtGd9MEAJpvcXF5+ptyRGGH/lo3Dyl4PMOtrvpvOCe1RCh76H+scS99laAM
         sVpojOtHXR7bd6qzuz8qZGmgijFkupA9IooYkWO5hI49aUreEh6Ha0/NLsvuR4gSDRXz
         hs33mna65Qz0SgB14oFQL6kW2sqxC2ET+nX9rg7GBLhGuCP4oIQK3krLSl/gGGN7Vkya
         2Z/Uf2SJZTdidM1QU0A0qp50CwWa/V4rZcEe2Uetbgyk9rJoT14LyhLtCsrucifa9+ne
         CVn6MaRcph7rcEqGYoOy5F+9YbCiW0cqUmL+E7S0WnZyOVFi6EXbHX0fFLi4aHPLbOPz
         af8Q==
X-Gm-Message-State: APjAAAXiIT/pcNvcp4Y1oXeaNVFqyJfK70Gi0IHZwIeBNqrj39pfpcGj
        EOkrTnGoONhDEhsjS2mXmOzqojCZZcpYM8zqfpI=
X-Google-Smtp-Source: APXvYqz9RkHVtxbeq8CjlbPYy3hmZVc7deKcamfQGCaDynQz0XHAYPsGUjXq7tO4ezcQJ6nKJ7xklFVLXyhRnWyz0j4=
X-Received: by 2002:a17:906:b88c:: with SMTP id hb12mr4446705ejb.150.1579898893148;
 Fri, 24 Jan 2020 12:48:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579798999.git.martin.varghese@nokia.com>
 <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
 <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com> <20200124144711.GA8532@martin-VirtualBox>
In-Reply-To: <20200124144711.GA8532@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jan 2020 15:47:37 -0500
Message-ID: <CAF=yD-J7C-g_L8p2N+h4OS2q2nEOOmJqKvnTw5tP4wtm6WuqKA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
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

On Fri, Jan 24, 2020 at 9:47 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Jan 23, 2020 at 05:42:25PM -0500, Willem de Bruijn wrote:
> > On Thu, Jan 23, 2020 at 1:04 PM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > tunnelling module for tunnelling different protocols like MPLS,
> > > IP,NSH etc inside a UDP tunnel.
> > >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> >
> > > diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
> > > index 028eaea..8215d1b 100644
> > > --- a/include/net/ip6_tunnel.h
> > > +++ b/include/net/ip6_tunnel.h
> > > @@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
> > >                 iptunnel_xmit_stats(dev, pkt_len);
> > >         }
> > >  }
> > > +
> > > +static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
> > > +                                                 struct net_device *dev,
> > > +                                                 struct net *net,
> > > +                                                 struct socket *sock,
> > > +                                                 struct flowi6 *fl6,
> > > +                                                 const struct ip_tunnel_info *info,
> > > +                                                 bool use_cache)
> > > +{
> > > +       struct dst_entry *dst = NULL;
> > > +#ifdef CONFIG_DST_CACHE
> > > +       struct dst_cache *dst_cache;
> > > +#endif
> >
> > I just noticed these ifdefs are absent in Geneve. On closer look,
> > CONFIG_NET_UDP_TUNNEL selects CONFIG_NET_IP_TUNNEL selects
> > CONFIG_DST_CACHE. So they are indeed not needed.
> >
> > Sorry, should have noticed that in v4. It could conceivably be fixed
> > up later, but seems worth one more round to get it right from the
> > start.
> >
> But unlike geneve i have placed this definition in ip_tunnels.h &
> ip6_tunnels.h which doesnt come under NET_IP_TUNNEL.Hence build
> will fail in cases where NET_UDP_TUNNEL is disabled
> Kbuild robot has shown that in v3.
>
> Even with  #ifdef CONFIG_DST_CACHE Kbuild robot reported another issue.
> when ip6_tunnel.h included in ip4_tunnel_core.c.
> dst_cache_get_ipv6 comes under ipv6 flag  and hence the compilation of
> ip4_tunnel_core.c fails when IPV6 is disabled.
>
> Ideally this functions should be defined in ip_tunnel.c & ip6_tunnel.c
> as these function has no significance if IP Tunnel is disabled.

Sounds great. Yes, these functions are better in a .c file.
