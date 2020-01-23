Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD61473F7
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 23:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAWWnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 17:43:05 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43645 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgAWWnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 17:43:05 -0500
Received: by mail-yb1-f195.google.com with SMTP id k15so2512360ybd.10
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 14:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxbb2KzwjQg7wgfCBjufG7WQ1UHS5fl8tjSKK6EGv38=;
        b=UXb5yfhbH6gyDox+vUldA89biDHQlQfPzcJ8QMs8wXBt6GQ0mvdSqWKUJ/xq8LtL3l
         x2t3fibrGxCSFZHl3XjGyMS67/4yrUadfcfLeVaE1OozaeFef5vIX5Uh1KlY9Rz0jyBc
         mXUUdTFExtisUupvw24Rn9OgPAH7epJTNRfgB6Q7aFNQqzOuIoKvUYqVtq3NFLhvVIH5
         hOfAldBFAOsBU1cTbp3fITJKJE1uFPBq4GiULNKrCJqYPKCI7a6EThg1OAwzgGeQxaFE
         7qM8ytZE1Io7VPx/mtQ/yWQKZuPENGUFTU0KkGyiVwwbDm/BUXePmlKHT5Pwujjjo7f6
         olpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxbb2KzwjQg7wgfCBjufG7WQ1UHS5fl8tjSKK6EGv38=;
        b=SedCDskx5A+jSpC+Wxi2N4p4pdqQ8wHDUTdgb+ohPhaIGJ3T+GJr1zhRhANzyLAJb5
         bEJ83EQLYT3aR6+EHnoH8FicuFnP4zdVMoAbiq2wHR3zSU1k4Q4WZY1rLycbPIT1vIjq
         0Akk+pgp63+JF8mvyXFMliPx1ymIyxwHJVxEm1hacCqo93D+Ovfye4nqv4BfKzXGaSDt
         G/bZbCrIhyA/FuSURIwM/FuCgVKnzhV2HD/Ty0Ok5CDnRTTvfcCt2Bndkj8NSDjjkTX+
         5FMPvGw1//el2FGIh5QcxsrhugsRQCQuDQ+gidcR1JsdvtYQbXwcF4RCu+JVqHlQoZGH
         mKCQ==
X-Gm-Message-State: APjAAAUaB9SkE+ER4XyAIoYz/QSjntD2CLuzs5VJqAjpSD5yTFwV44ip
        kL1VwyE0erBkfERxF4auDk2AxTUT
X-Google-Smtp-Source: APXvYqzDF2D7VsK29b7fJRDz9XA/KYWEcoPSFsxKr765ugDG1i67H3ET/IxekqQc4+93IgZpG5FVTQ==
X-Received: by 2002:a25:cc83:: with SMTP id l125mr88023ybf.107.1579819383509;
        Thu, 23 Jan 2020 14:43:03 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id q130sm1443043ywg.52.2020.01.23.14.43.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 14:43:02 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id c8so2504779ybk.9
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 14:43:02 -0800 (PST)
X-Received: by 2002:a25:41c7:: with SMTP id o190mr85837yba.139.1579819381544;
 Thu, 23 Jan 2020 14:43:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579798999.git.martin.varghese@nokia.com> <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
In-Reply-To: <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 23 Jan 2020 17:42:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
Message-ID: <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 1:04 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

> diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
> index 028eaea..8215d1b 100644
> --- a/include/net/ip6_tunnel.h
> +++ b/include/net/ip6_tunnel.h
> @@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
>                 iptunnel_xmit_stats(dev, pkt_len);
>         }
>  }
> +
> +static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
> +                                                 struct net_device *dev,
> +                                                 struct net *net,
> +                                                 struct socket *sock,
> +                                                 struct flowi6 *fl6,
> +                                                 const struct ip_tunnel_info *info,
> +                                                 bool use_cache)
> +{
> +       struct dst_entry *dst = NULL;
> +#ifdef CONFIG_DST_CACHE
> +       struct dst_cache *dst_cache;
> +#endif

I just noticed these ifdefs are absent in Geneve. On closer look,
CONFIG_NET_UDP_TUNNEL selects CONFIG_NET_IP_TUNNEL selects
CONFIG_DST_CACHE. So they are indeed not needed.

Sorry, should have noticed that in v4. It could conceivably be fixed
up later, but seems worth one more round to get it right from the
start.

Glad you found the previous reviews helpful. I will also miss a lot.
For more assurance and also as regression test, it might be
worth looking into adding a bareudp mode to
tools/testing/selftests/net/pmtu.sh. That looks like it exercises a
variety of tunnel types already. Extending it might be little work
(once ip supports bareudp).

To be clear, not for this patch set. Let's not delay that further.
Just a thought.
