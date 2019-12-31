Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E57112D9DA
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 16:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfLaPdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 10:33:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37622 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaPdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 10:33:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so16004579plz.4
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 07:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BfWsa3LscQQJPLxmg4FcwO6qVaRkl5vLi5pGPKGNPD8=;
        b=DmxQHG0xvFR5FSNm0pGfLNsupPawAub/T6FzqgC8vNqeHd1Zg71ImcEhJy+U5gYhhQ
         lWN1R2kKWlexXJMjOlvl3mJZLbiiYyhkoHCmjQbzTe+u1bHi76ZqmlWvf7FlKj8wSq3x
         m+hXGeIkeQQzWvAKemkKyOZqyiapCoiIDyof5xm4fARlMpEtPiMndf7LV5BL9u8Vyap3
         Guig00C5dt33NE3T4KpQVoZ4a5bLR2G13VB3EpvhKBHimrDLZXiYshz+WsT1zUpRdyS1
         /LuSFX8sY9boTFRDNY648Zq98PRBiiNVO8+/u2zToLzQpMb9+3lnd4eOWitemS9v6I1c
         rZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BfWsa3LscQQJPLxmg4FcwO6qVaRkl5vLi5pGPKGNPD8=;
        b=UZUU7D6EoyqCNrPhFB0eYeecuA53+Do3In1eVUMFeIi2Sj2ocLG6FSjmy5fh4vVFXo
         5zCbG/jEZA9Q4OB0wG0Hs2P4LpLP337F93bqHasnXrXgWV+ZAAslXOhcOkT5g829RWr1
         KN+zMPIhGhFC0dcX/vL+vkx/HRl11HKHQW/hU46YwOBm3IJCRJsjJeQYqrF44/0cTK4H
         CtC7BErLsHBUYAJHZZhb2wOwzHpw2BhuzPBh85rK0LU1L85VFyQi0zF5xBH81cnJGg87
         TcDOr/UIsDAcLCFCfV5QYGLBwqdFT4BTCt0/7EcoGCqwmPNhf9Z60KD6sP7qsi1WZFgw
         cxdw==
X-Gm-Message-State: APjAAAWFgb0cfxV1WO0dC6D4AsOIamKcYnZ381z3PJyKeGOX/RKkeyZo
        GPuWSyk8My4YzxiEqRK/gqA=
X-Google-Smtp-Source: APXvYqyFeIKYe8hDmBquaRj1JkMVLh6r6FrKPMT5hmw5zKdlNIRzu1QY4R95vaNnZmy0kL4tUAjCGA==
X-Received: by 2002:a17:902:9f91:: with SMTP id g17mr73584843plq.179.1577806383328;
        Tue, 31 Dec 2019 07:33:03 -0800 (PST)
Received: from martin-VirtualBox ([42.109.146.152])
        by smtp.gmail.com with ESMTPSA id j9sm50747902pfn.152.2019.12.31.07.33.02
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 31 Dec 2019 07:33:02 -0800 (PST)
Date:   Tue, 31 Dec 2019 21:02:55 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH v3 net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191231153255.GA2327@martin-VirtualBox>
References: <cover.1573872263.git.martin.varghese@nokia.com>
 <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
 <CA+FuTSeUGsWH-GR7N_N7PChaW4S6Hucmvo_1s_9bbisxz1eOAA@mail.gmail.com>
 <20191128162427.GB2633@martin-VirtualBox>
 <CA+FuTSc1GBxnWgMSVPNxx1wndFmauvTd7r54dDV92PeNprouWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSc1GBxnWgMSVPNxx1wndFmauvTd7r54dDV92PeNprouWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 29, 2019 at 01:18:36PM -0500, Willem de Bruijn wrote:
> On Thu, Nov 28, 2019 at 11:25 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Mon, Nov 18, 2019 at 12:23:09PM -0500, Willem de Bruijn wrote:
> > > On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > >
> > > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > > tunnelling module for tunnelling different protocols like MPLS,
> > > > IP,NSH etc inside a UDP tunnel.
> > > >
> > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> > > > +static int bareudp_fill_metadata_dst(struct net_device *dev,
> > > > +                                    struct sk_buff *skb)
> > > > +{
> > > > +       struct ip_tunnel_info *info = skb_tunnel_info(skb);
> > > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > > +
> > > > +       if (ip_tunnel_info_af(info) == AF_INET) {
> > > > +               struct rtable *rt;
> > > > +               struct flowi4 fl4;
> > > > +
> > > > +               rt = iptunnel_get_v4_rt(skb, dev, bareudp->net, &fl4, info,
> > > > +                                       use_cache);
> > > > +               if (IS_ERR(rt))
> > > > +                       return PTR_ERR(rt);
> > > > +
> > > > +               ip_rt_put(rt);
> > > > +               info->key.u.ipv4.src = fl4.saddr;
> > > > +#if IS_ENABLED(CONFIG_IPV6)
> > > > +       } else if (ip_tunnel_info_af(info) == AF_INET6) {
> > > > +               struct dst_entry *dst;
> > > > +               struct flowi6 fl6;
> > > > +               struct bareudp_sock *bs6 = rcu_dereference(bareudp->sock);
> > > > +
> > > > +               dst = ip6tunnel_get_dst(skb, dev, bareudp->net, bs6->sock, &fl6,
> > > > +                                       info, use_cache);
> > > > +               if (IS_ERR(dst))
> > > > +                       return PTR_ERR(dst);
> > > > +
> > > > +               dst_release(dst);
> > > > +               info->key.u.ipv6.src = fl6.saddr;
> > > > +#endif
> > > > +       } else {
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       info->key.tp_src = udp_flow_src_port(bareudp->net, skb,
> > > > +                                            bareudp->sport_min,
> > > > +                                            USHRT_MAX, true);
> > > > +       info->key.tp_dst = bareudp->conf.port;
> > > > +       return 0;
> > > > +}
> > >
> > > This can probably all be deduplicated with geneve_fill_metadata_dst
> > > once both use iptunnel_get_v4_rt.
> > >
> >
> > Do you have any preference of file to keep the common function
> 
> Perhaps net/ipv4/udp_tunnel.c

I was trying this change and i found i dont have a lot of generic code here.

Populating L4 ports is function of the protocol implementation
and it is differnt for geneve and for bareudp

The one thing we could do is to write a generic API to derive the 
tunnel src address.

But since it is a very small piece i dont see much value add by making it 
generic and i prefer to keep the way as it is now

But i am open for both the option. What you think ? 



