Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0C1698A1
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgBWQO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 11:14:57 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34004 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWQO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 11:14:57 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so4000716pfc.1
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 08:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eVAmJrpS+Lnymsjz51Aqxn1/fwrijGMkFeEV5JcWOZ4=;
        b=gsInkGMKvQHEB/gWhfo380ItScSZQjK5rKh+z0frMJXsO8IpSYHO9b7AxE6Cdub9LQ
         ubNtPY0dbgMXgW694zoM0z2E6Zl2sUkFsEAwalkc3KUtvJlMNx27CpfecglKKrhIcvBH
         9xBYHV4gF+2KEj9ioLxkyEiuLo+UXsb299ah/oua1yd20U3sQe9KSJ/7zm7ENZMSiXrX
         rTswSwloOulAtvateGBZtUIgyHakLOJEGxIQAGOxCHIfGxaDK94CfQBp13x0AYacVLQ0
         4famdLkwbPcJarwSMy5lPtNwU7uc5qP1ssCwdKmf+45kwqxYR3ed1OuGxBlJk9Wi3CtW
         U6uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eVAmJrpS+Lnymsjz51Aqxn1/fwrijGMkFeEV5JcWOZ4=;
        b=OT96e9dvJUaNN+gaXhfDRQtf2bAeRHP8YXfu50BNHNB0wpy9ruvL3T0lO/BOKWj+dv
         BpqMN74Pp1wCb4Nd8QYG6q9yfJcibmzj5D3E80Atm1AWWHlYQJ7xqqE4b3gQYW+zccjC
         8KhuDNXG1FH3IJqkAonlAeFWwmtw8r8yU7LR+kedHyRAKpASqlKEG8CeuPsCJJERwaa/
         twcN8mgYlue5NdHauZxMKwELbsIi1n2zBM+7dV0AHru5ooV6btIBtZlbOnoKUXHfOKI7
         yAiKhocC/eI3rzP7zfP4BBE5yiVnIDeSKAQdUoPFO21PslQZ+OERbAuTsjv8MSelZcGR
         e7YQ==
X-Gm-Message-State: APjAAAVjSQio+RuflMHB6ThRbbX+fGd5ybtJmtM6sk46p0hg1aT1K/tV
        G79U+3d8cNqS9vWewX17g8U=
X-Google-Smtp-Source: APXvYqxJC3FLFyPQQpF+/19TWu7FFxUuBZevlTOWcmyjuLiWMdAcBFEXFJ7EDor4UKdfmCBOfzFjDQ==
X-Received: by 2002:a63:e30e:: with SMTP id f14mr47077746pgh.260.1582474496256;
        Sun, 23 Feb 2020 08:14:56 -0800 (PST)
Received: from martin-VirtualBox ([137.97.73.175])
        by smtp.gmail.com with ESMTPSA id v4sm9279226pff.174.2020.02.23.08.14.54
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 23 Feb 2020 08:14:55 -0800 (PST)
Date:   Sun, 23 Feb 2020 21:44:47 +0530
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
Message-ID: <20200223161447.GA2682@martin-VirtualBox>
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
 <20200217024351.GA11681@martin-VirtualBox>
 <CA+FuTSeMBFu44266y_JkkxduUcXVcbVctjaFCuFaCnEwS_LwEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeMBFu44266y_JkkxduUcXVcbVctjaFCuFaCnEwS_LwEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 09:16:34PM -0800, Willem de Bruijn wrote:
> > > There are also a couple of reverse christmas tree violations.
> > >
> > In Bareudp.c correct?
> 
> Right. Like bareudp_udp_encap_recv.
> 
> > Wondering if there is any flag in checkpatch to catch them?
> 
> It has come up, but I don't believe anything is merged.
> 
> > > > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > > > +                                     struct net_device *dev,
> > > > +                                     struct net *net, __be32 *saddr,
> > > > +                                     const struct ip_tunnel_info *info,
> > > > +                                     u8 protocol, bool use_cache)
> > > > +{
> > > > +#ifdef CONFIG_DST_CACHE
> > > > +       struct dst_cache *dst_cache;
> > > > +#endif
> > > > +       struct rtable *rt = NULL;
> > > > +       struct flowi4 fl4;
> > > > +       __u8 tos;
> > > > +
> > > > +       memset(&fl4, 0, sizeof(fl4));
> > > > +       fl4.flowi4_mark = skb->mark;
> > > > +       fl4.flowi4_proto = protocol;
> > > > +       fl4.daddr = info->key.u.ipv4.dst;
> > > > +       fl4.saddr = info->key.u.ipv4.src;
> > > > +
> > > > +       tos = info->key.tos;
> > > > +       fl4.flowi4_tos = RT_TOS(tos);
> > > > +#ifdef CONFIG_DST_CACHE
> > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > +       if (use_cache) {
> > > > +               rt = dst_cache_get_ip4(dst_cache, saddr);
> > > > +               if (rt)
> > > > +                       return rt;
> > > > +       }
> > > > +#endif
> > >
> > > This is the same in geneve, but no need to initialize fl4 on a cache
> > > hit. Then can also be restructured to only have a single #ifdef block.
> > Yes , We need not initialize fl4 when cache is used.
> > But i didnt get your point on restructuing to have a single #ifdef block
> > Could you please give more details
> 
> Actually, I was mistaken, missing the third #ifdef block that calls
> dst_cache_set_ip[46]. But the type of info->dst_cache is struct
> dst_cache, so I don't think the explicit cast or additional pointer
> variable (and with that the first #ifdef) is needed. But it's clearly
> not terribly important.
I tried to remove the additional pointer variable and the explicit cast.But Compiler warns as 
the info is a const variable (same for geneve)

So shall we keep as it is ?


