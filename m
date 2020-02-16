Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6126C1604E8
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgBPQ7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 11:59:11 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43388 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728386AbgBPQ7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 11:59:11 -0500
Received: by mail-yw1-f66.google.com with SMTP id f204so6797664ywc.10
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 08:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+AKNIAXYxKoBaAJPGdS3BRIcV/MOGV1i/wZ5L4HRaJ0=;
        b=RiwUpFjtVFaKNMvxes5Yfm9WwtW0TaFduO7axpGzz2enkGffQFjYcnqENM7C6hLnEg
         XvFOKkoXxDstEPYg5x1Glqe3YSy4CBUV3SViTLX5CmNq8p/qFrRnnVYOGnwNfrkhsFmf
         /k/eMS4W70m9rZztD10X6oNXBOb8cmbJWpo0tEq5F7XGAoZapBriKoN0mdtna8lxeOT4
         22MRdmfXQ1+HvYiWyimsqg+aTjEZaGs1ivcEDuTTdxMPWrcaBrqtddC5V3hlHKYUo85a
         tYmyK/U0qEaiCdy123oiFxxC7JIW1atbrLNJr7UKi8Nbq6qFwTy+etV/L7slLauymedq
         whug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+AKNIAXYxKoBaAJPGdS3BRIcV/MOGV1i/wZ5L4HRaJ0=;
        b=tIBoEkR90e8fCsDQR1iw5YyXhnbdnLvz4LGNpBxoOlSCFKQtQ/VIuNn+mYaxeSFlo7
         Mz2LPOsg3T93RZcRrrg5wxYo/0jAON7K+zMueUxjF56MUvZ6+W2BFlqZn/cVmX/mgJ17
         mAF+UR6J5iGsZVeClzvU18PJn4htrmdb6d9W/x3ymoONOjnNbwGkfE/YcbnQK+IPKpJ/
         IaDgtgpgVzwSpjdvWWFObsnyzzu6ogD06agtNwNevX3mbx0Xgfjpc9F8XnRlo30FvDmC
         ePg/PWJYG7KKLVrEUjBfXeegJ4Xx9y98qsEKOKzAAXZVvj0z4V1mEChh7kuQHDtObemG
         FDEQ==
X-Gm-Message-State: APjAAAV5O49MskLCFZVwsWrPGks/OBLEfBUTn/xxHMakTEutJhAvj2LM
        GNJHFiwICHoLrGoQOTQkfeFOlcUi
X-Google-Smtp-Source: APXvYqyDSRbq49rqLSlCmfk3QyO22SBuceoK/3tApHDaflp4Ee777Qa0BSvWJLBWFL1bqJC11t0HGw==
X-Received: by 2002:a81:9bc2:: with SMTP id s185mr9740384ywg.55.1581872350116;
        Sun, 16 Feb 2020 08:59:10 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id l37sm5334885ywa.103.2020.02.16.08.59.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 08:59:09 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id f21so7513515ybg.11
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 08:59:08 -0800 (PST)
X-Received: by 2002:a25:7c5:: with SMTP id 188mr11222041ybh.178.1581872347936;
 Sun, 16 Feb 2020 08:59:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581745878.git.martin.varghese@nokia.com> <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
In-Reply-To: <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 16 Feb 2020 10:58:30 -0600
X-Gmail-Original-Message-ID: <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
Message-ID: <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/2] net: UDP tunnel encapsulation module for
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

On Fri, Feb 14, 2020 at 11:20 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

A few small points

>  net/ipv4/route.c                     |  48 +++
>  net/ipv6/ip6_output.c                |  70 ++++

Both protocols have route.c and ip(6)_output.c files. For the sake of
consistency, both should ideally be in route.c. Did you choose
ip6_output.c for a reason?

There are also a couple of reverse christmas tree violations.

> +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> +                                     struct net_device *dev,
> +                                     struct net *net, __be32 *saddr,
> +                                     const struct ip_tunnel_info *info,
> +                                     u8 protocol, bool use_cache)
> +{
> +#ifdef CONFIG_DST_CACHE
> +       struct dst_cache *dst_cache;
> +#endif
> +       struct rtable *rt = NULL;
> +       struct flowi4 fl4;
> +       __u8 tos;
> +
> +       memset(&fl4, 0, sizeof(fl4));
> +       fl4.flowi4_mark = skb->mark;
> +       fl4.flowi4_proto = protocol;
> +       fl4.daddr = info->key.u.ipv4.dst;
> +       fl4.saddr = info->key.u.ipv4.src;
> +
> +       tos = info->key.tos;
> +       fl4.flowi4_tos = RT_TOS(tos);
> +#ifdef CONFIG_DST_CACHE
> +       dst_cache = (struct dst_cache *)&info->dst_cache;
> +       if (use_cache) {
> +               rt = dst_cache_get_ip4(dst_cache, saddr);
> +               if (rt)
> +                       return rt;
> +       }
> +#endif

This is the same in geneve, but no need to initialize fl4 on a cache
hit. Then can also be restructured to only have a single #ifdef block.
