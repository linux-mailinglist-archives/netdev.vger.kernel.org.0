Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE01609CF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 06:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgBQFRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 00:17:17 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33299 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgBQFRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 00:17:16 -0500
Received: by mail-yb1-f196.google.com with SMTP id b6so8157443ybr.0
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 21:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qqEhJos7XwFWseneb5zXIELdslq+qUm6mgZUyVOeRDo=;
        b=QlMr7LHHjMIafjf3qJETNKkB3nze4sSQrJedFV2nN2HsanU+dNn8JRnj8oToGeSqF2
         PTbCI6D5LpHojTDE7ccScj2yyJtGFQeYDzzc49Msd5LnuqPxnmZt0ASLfEp7kl8X90J+
         PFJ8vk35ILkeb6RFLHA0GfZjTrnEszlgjUviUhr8VERAVFRmZUUzDk5M4wGLUtxo4DUz
         M2xmcczR3H7xu3yzYLoeQa8/FXLDx9xBsrTjk4I/11FDooYOrhx8EOF9oXIH/uzZP4wx
         g0pfK5KJgH3ChztszOOWQyVwwHP4RRKUe3s4ubwXMcVxU3hOsNVs96PjmbPSuIp880Qd
         /1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qqEhJos7XwFWseneb5zXIELdslq+qUm6mgZUyVOeRDo=;
        b=aAhB0yo/nhpocobYmYpxu/PiAabmeK3OXq59jO+m6thuATVxlSi7GHOsa00oHDERo3
         rjjc85pL30YUwv50UgXZOSJ7eyM2AgWx3fT7SE5EDyngeC/C/iVDmBjdFVNxBJgF1LvJ
         n/vkwSbkBVliny22DBVwdnuYMkzH+Ojwmcgl4+lV+q848RbWn04IwZ0fsnmYmfviSoys
         i0p7mux1a/lrwMvPzwzyiSgH751VggoqggGSX4BQyGhCRmH0zumkmCmFq+qUMYT9X/Wp
         vCtEQbylnWLgSSh2ewod8clqL6Lkim1vfK8+WAhp2pD4SFjOpaHFF1QYif3LE0UX6apO
         9HYA==
X-Gm-Message-State: APjAAAXY+jJjSjU1jHzF3etCaf/JWJxIH5E5IMvfa1STxiuLz1xiGQuT
        9ZYm4JcELR9OOKSBbVTlaQtddv5s
X-Google-Smtp-Source: APXvYqyN+fXUnexk/UGekQwbFcjSLPw5w5mJY+kjbEC/D+WaDjqcBwVSoO5IBd9SibvlFsRi1wX43A==
X-Received: by 2002:a25:cc95:: with SMTP id l143mr12756143ybf.367.1581916635124;
        Sun, 16 Feb 2020 21:17:15 -0800 (PST)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id i66sm6126716ywa.74.2020.02.16.21.17.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 21:17:14 -0800 (PST)
Received: by mail-yw1-f45.google.com with SMTP id b81so7353217ywe.9
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 21:17:13 -0800 (PST)
X-Received: by 2002:a81:517:: with SMTP id 23mr12175708ywf.104.1581916632927;
 Sun, 16 Feb 2020 21:17:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com> <20200217024351.GA11681@martin-VirtualBox>
In-Reply-To: <20200217024351.GA11681@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 16 Feb 2020 21:16:34 -0800
X-Gmail-Original-Message-ID: <CA+FuTSeMBFu44266y_JkkxduUcXVcbVctjaFCuFaCnEwS_LwEQ@mail.gmail.com>
Message-ID: <CA+FuTSeMBFu44266y_JkkxduUcXVcbVctjaFCuFaCnEwS_LwEQ@mail.gmail.com>
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

> > There are also a couple of reverse christmas tree violations.
> >
> In Bareudp.c correct?

Right. Like bareudp_udp_encap_recv.

> Wondering if there is any flag in checkpatch to catch them?

It has come up, but I don't believe anything is merged.

> > > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > > +                                     struct net_device *dev,
> > > +                                     struct net *net, __be32 *saddr,
> > > +                                     const struct ip_tunnel_info *info,
> > > +                                     u8 protocol, bool use_cache)
> > > +{
> > > +#ifdef CONFIG_DST_CACHE
> > > +       struct dst_cache *dst_cache;
> > > +#endif
> > > +       struct rtable *rt = NULL;
> > > +       struct flowi4 fl4;
> > > +       __u8 tos;
> > > +
> > > +       memset(&fl4, 0, sizeof(fl4));
> > > +       fl4.flowi4_mark = skb->mark;
> > > +       fl4.flowi4_proto = protocol;
> > > +       fl4.daddr = info->key.u.ipv4.dst;
> > > +       fl4.saddr = info->key.u.ipv4.src;
> > > +
> > > +       tos = info->key.tos;
> > > +       fl4.flowi4_tos = RT_TOS(tos);
> > > +#ifdef CONFIG_DST_CACHE
> > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > +       if (use_cache) {
> > > +               rt = dst_cache_get_ip4(dst_cache, saddr);
> > > +               if (rt)
> > > +                       return rt;
> > > +       }
> > > +#endif
> >
> > This is the same in geneve, but no need to initialize fl4 on a cache
> > hit. Then can also be restructured to only have a single #ifdef block.
> Yes , We need not initialize fl4 when cache is used.
> But i didnt get your point on restructuing to have a single #ifdef block
> Could you please give more details

Actually, I was mistaken, missing the third #ifdef block that calls
dst_cache_set_ip[46]. But the type of info->dst_cache is struct
dst_cache, so I don't think the explicit cast or additional pointer
variable (and with that the first #ifdef) is needed. But it's clearly
not terribly important.
