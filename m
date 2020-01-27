Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E072414A77C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgA0PtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:49:02 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42205 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgA0PtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 10:49:02 -0500
Received: by mail-pl1-f195.google.com with SMTP id p9so3885840plk.9
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 07:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=djy3Kh44k9yBgyb1jaNJvgO0D/LWjxaViOmFKiUUKKw=;
        b=KUsIaCIKYLRFkAb48YEpM0QnR/B+KGY1b+4UjGt84nvLx6QjFE4Q8NoHiB6BoCkbdr
         jTZ/aAaGG2AtQztNfC79il30+cPXUqDB7JS2tBZAdNrXnyVJs1ZSZzoeGzhGDP2pEwnY
         21ioRVC6HDlBK+Ub/nXm+xRZullgFW+SXVbxA9r/3VU+EgzqHp0Q61yzabSBeztZTBMS
         JL2QkYIPEbGACC5s2s75q5VIB1uwM8p1ZgOOnhNuQCRGSqlJIW062G18o0sY+C9tjzQt
         uhwgEwIl8Cy8AMZlSp6QVDp7YcTRHY/LGgG/tlp0d0wTWRZxsFTuBVcxYV2ic0k5v0Mo
         54DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=djy3Kh44k9yBgyb1jaNJvgO0D/LWjxaViOmFKiUUKKw=;
        b=BSzXSh88NvzjUkhHKw55RV7calG5KosH6aiNRqiPgONxO6OTMxwYyMuozisrgHqHhH
         gaSfOFPH8Vn7vMJp8tRAj79Zk0l+u+busvvLjXwQzW9UiTbDoYVUJWXeugJrkc9zUbMD
         EtpAApO7cSRka7wvLjtBkq0hHHM4Ee+WUiUcd1x7zzV30zwmrdeFF+u38HGJxc6ibpp6
         spM4NQkr8iS3wXLWQFzeF5TdUYdE8T2RlSIhmyMCQN/KokzOLdFYTkPj/0Jkeq8QGshd
         Lh9rFWY1EMYyQ+s276lllMp0dHhUT0Zn7QEf3IIdX1Gm1qf22NWPUCRhfKTfRRRBKPoq
         OEaw==
X-Gm-Message-State: APjAAAU4/IrC5PrZf/6y7VdbRqTSNwau9iZUZxbxWJ31/33ZmsXtWqw4
        rYMXdze5Mz+BD/iByfdWQEI=
X-Google-Smtp-Source: APXvYqwQnA/FSfz3aEQ0jC/Q69+F7A8IbFAYOubRMhZkJbcZdkUJ2to+jL9FipADjeMamez8DwIRHQ==
X-Received: by 2002:a17:902:b401:: with SMTP id x1mr18447150plr.326.1580140140974;
        Mon, 27 Jan 2020 07:49:00 -0800 (PST)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id b185sm16860863pfa.102.2020.01.27.07.48.59
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 07:49:00 -0800 (PST)
Date:   Mon, 27 Jan 2020 21:18:55 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20200127154855.GA2512@martin-VirtualBox>
References: <cover.1579798999.git.martin.varghese@nokia.com>
 <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
 <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
 <20200124144711.GA8532@martin-VirtualBox>
 <CAF=yD-J7C-g_L8p2N+h4OS2q2nEOOmJqKvnTw5tP4wtm6WuqKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-J7C-g_L8p2N+h4OS2q2nEOOmJqKvnTw5tP4wtm6WuqKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 03:47:37PM -0500, Willem de Bruijn wrote:
> On Fri, Jan 24, 2020 at 9:47 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Thu, Jan 23, 2020 at 05:42:25PM -0500, Willem de Bruijn wrote:
> > > On Thu, Jan 23, 2020 at 1:04 PM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > >
> > > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > > tunnelling module for tunnelling different protocols like MPLS,
> > > > IP,NSH etc inside a UDP tunnel.
> > > >
> > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > > diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
> > > > index 028eaea..8215d1b 100644
> > > > --- a/include/net/ip6_tunnel.h
> > > > +++ b/include/net/ip6_tunnel.h
> > > > @@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
> > > >                 iptunnel_xmit_stats(dev, pkt_len);
> > > >         }
> > > >  }
> > > > +
> > > > +static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
> > > > +                                                 struct net_device *dev,
> > > > +                                                 struct net *net,
> > > > +                                                 struct socket *sock,
> > > > +                                                 struct flowi6 *fl6,
> > > > +                                                 const struct ip_tunnel_info *info,
> > > > +                                                 bool use_cache)
> > > > +{
> > > > +       struct dst_entry *dst = NULL;
> > > > +#ifdef CONFIG_DST_CACHE
> > > > +       struct dst_cache *dst_cache;
> > > > +#endif
> > >
> > > I just noticed these ifdefs are absent in Geneve. On closer look,
> > > CONFIG_NET_UDP_TUNNEL selects CONFIG_NET_IP_TUNNEL selects
> > > CONFIG_DST_CACHE. So they are indeed not needed.
> > >
> > > Sorry, should have noticed that in v4. It could conceivably be fixed
> > > up later, but seems worth one more round to get it right from the
> > > start.
> > >
> > But unlike geneve i have placed this definition in ip_tunnels.h &
> > ip6_tunnels.h which doesnt come under NET_IP_TUNNEL.Hence build
> > will fail in cases where NET_UDP_TUNNEL is disabled
> > Kbuild robot has shown that in v3.
> >
> > Even with  #ifdef CONFIG_DST_CACHE Kbuild robot reported another issue.
> > when ip6_tunnel.h included in ip4_tunnel_core.c.
> > dst_cache_get_ipv6 comes under ipv6 flag  and hence the compilation of
> > ip4_tunnel_core.c fails when IPV6 is disabled.
> >
> > Ideally this functions should be defined in ip_tunnel.c & ip6_tunnel.c
> > as these function has no significance if IP Tunnel is disabled.
> 
> Sounds great. Yes, these functions are better in a .c file.

Keeping these functions in ipv4/route.c and ipv6/ip6_output.c along with ip_route_output_flow & ip6_dst_lookup_flow
These functions will be named ip_route_output_tunnel & ip6_dst_lookup_tunnel
 

Keeping these functions in ip_tunnels.c & ip6_tunnels.c is a bad idea as the bareudp module has no
Dependency with ipv4 & ipv6 tunnel module as of now and there is no need to create one.


Do you see any issues
If the above approach is not feasible we should fall back to ip_tunnel.h ip6_tunnel.h with proper #ifdef protection

