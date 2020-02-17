Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F334A160847
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgBQCn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:43:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32807 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgBQCnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:43:55 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so6115806plb.0
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 18:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sHy3BeMXVLFrJa4CmTnY222KKwHoAnv+b2JZGPX7Ekc=;
        b=dIbInro9Sm6CEjHlJS8ojrp+fupdbioSRKnpnZcQBy6K29jk92tsSyFOtg0Xc4/wgE
         rbUCYtQifN2bgGTYDgGZWsdNUCLTOFXJzDgNpLWuODJgRrXh0n5O7t/ybAYclHhW0Upm
         kH++EqJwO59t7wGoyJc+fbeUysVGH/zUlx1qZljMxu3me88MNdR76lAPXSbkmQZY2F0D
         cb+YfmZNFei9ZRxVf+dYLyGLyQpkYmYGf/olTUnZSt3mAeVMjWhLLGtvvptH447QhuIk
         U6dJBdrcJVCXiv/vnvf/NwJehjZa9zqamYJt5opaVcTjntgKbmq1Qpy990iVVVvtxAd1
         MOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sHy3BeMXVLFrJa4CmTnY222KKwHoAnv+b2JZGPX7Ekc=;
        b=QQ6qBt9a4A0kjVArbRJw87klRKLytmuSGauJsBLJ6a/wUIfJOAbJ5IF9maXGToLtv8
         c6H144xCHTgeDjnGBjT91c/QBdBLx3WHxJ6g1bXVqOG/iOjqQ3fMwmi1XtdAqGCpwCL5
         PW2jisXpwJyAVs5sx4/wO+qBl0w7Hi+uZQZPcwzlw9MOzz5vkqlhtCTM8qWUPkQJ6ehg
         kdbM+sQw1vQNmzcCGOdJgTzMqmLaQ8iSMjafyN1/6K54TVPuHdub8eFvJTMOec5hPE+A
         +vzla5FjfFd629DKFA1uJ/fSPrO+n6JMjLCp4a32ihy2Qkld4ngWc8ww4Q3DKtns5rpC
         ecVA==
X-Gm-Message-State: APjAAAVT3/L6wBFqXIHP/S2RqHVFG1JRqUehMk/G9EEacyHY4i2RVMxP
        y/gGynBUG+PQZH/krNJ1hds=
X-Google-Smtp-Source: APXvYqzh82J+YAld6bInNxKci7lPhbimGKJmJ0z+Yh1Y3NiDbW3yVSoQlfrQvWkawKp6ogGxp3jXGQ==
X-Received: by 2002:a17:90a:20c4:: with SMTP id f62mr18093137pjg.70.1581907435033;
        Sun, 16 Feb 2020 18:43:55 -0800 (PST)
Received: from martin-VirtualBox ([137.97.166.11])
        by smtp.gmail.com with ESMTPSA id 7sm14658659pfc.21.2020.02.16.18.43.53
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 16 Feb 2020 18:43:54 -0800 (PST)
Date:   Mon, 17 Feb 2020 08:13:51 +0530
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
Message-ID: <20200217024351.GA11681@martin-VirtualBox>
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 10:58:30AM -0600, Willem de Bruijn wrote:
> On Fri, Feb 14, 2020 at 11:20 PM Martin Varghese
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
> A few small points
> 
> >  net/ipv4/route.c                     |  48 +++
> >  net/ipv6/ip6_output.c                |  70 ++++
> 
> Both protocols have route.c and ip(6)_output.c files. For the sake of
> consistency, both should ideally be in route.c. Did you choose
> ip6_output.c for a reason?
> 
> There are also a couple of reverse christmas tree violations.
>
In Bareudp.c correct?
Wondering if there is any flag in checkpatch to catch them? 
> > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > +                                     struct net_device *dev,
> > +                                     struct net *net, __be32 *saddr,
> > +                                     const struct ip_tunnel_info *info,
> > +                                     u8 protocol, bool use_cache)
> > +{
> > +#ifdef CONFIG_DST_CACHE
> > +       struct dst_cache *dst_cache;
> > +#endif
> > +       struct rtable *rt = NULL;
> > +       struct flowi4 fl4;
> > +       __u8 tos;
> > +
> > +       memset(&fl4, 0, sizeof(fl4));
> > +       fl4.flowi4_mark = skb->mark;
> > +       fl4.flowi4_proto = protocol;
> > +       fl4.daddr = info->key.u.ipv4.dst;
> > +       fl4.saddr = info->key.u.ipv4.src;
> > +
> > +       tos = info->key.tos;
> > +       fl4.flowi4_tos = RT_TOS(tos);
> > +#ifdef CONFIG_DST_CACHE
> > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > +       if (use_cache) {
> > +               rt = dst_cache_get_ip4(dst_cache, saddr);
> > +               if (rt)
> > +                       return rt;
> > +       }
> > +#endif
> 
> This is the same in geneve, but no need to initialize fl4 on a cache
> hit. Then can also be restructured to only have a single #ifdef block.
Yes , We need not initialize fl4 when cache is used.
But i didnt get your point on restructuing to have a single #ifdef block
Could you please give more details
