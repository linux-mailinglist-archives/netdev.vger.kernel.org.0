Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D895A100D22
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfKRUaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:30:06 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45150 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfKRUaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 15:30:06 -0500
Received: by mail-yb1-f193.google.com with SMTP id i3so2782655ybe.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 12:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pviaXpKwfpJXUurmgWdhZSfSQcuQ0KIX8RAbLV7xR4o=;
        b=B1oX67iyqyIavERHfAF+8ATTkmTjqjGtTrr0MtUCZ/Rqe97v+6sSwp/LE+8VDL9X2f
         3X5hua2tC4TOe4Rb+pDFwktDdgu7UB2mffOD/+1KpnyFjGzWyxbEkGsus3u6rY48XSB7
         NiamXbgYrC0Hr3bp/HrcXjc/OQkpyrCQOEbOVr/LsmhpuGUKPZckzsnxgum9Pr5wheqH
         ioA9dgzjndzJ7TIiSgywkL+SOiChZr52UOqVRp2+wAjs0M08+mhbZwZIxUhkTXsjJPHm
         vjE5Ttj/F2B3hG+v+EXsORpRfTWgQixz6MsMqTV8IVY9KDiKZ2cUE1nAxIG+CAGy/Ntz
         r8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pviaXpKwfpJXUurmgWdhZSfSQcuQ0KIX8RAbLV7xR4o=;
        b=qmWCIMpXvKYbRTwZO8BBPoXYsHPzAHYGUmNN2pnuoqyn6u8YxBExjoNI6NSP8GruXf
         YD5HsG9exu8io3dfAPycVFYpTO32ZZFwgfILIilG6anj7RxSjP23OKpHgIdDzY3+IRaW
         161us3tQUJQO6iRaUbFJue0yVWADEg8TL581zDV/il3STH0SFBCCTTFuz2auxfQoWvZx
         hiYQ4mVHJdPwkcQQdQQ+cOtNrpzA30X0UZPtrllTYO4AeKDnvMw/u3INfhugMA8lJVja
         l5QmLtcunpqd9XihMWvXjE/7apv6EoZ4aEzO3CrtvlUPEefjTH18Z0PMllGywOCq7Gbv
         uq2g==
X-Gm-Message-State: APjAAAWtX86Ql9LZT0joKH00tSRwzYv+1WxkADsNWNwrzV4ASZGYMC/t
        SLxOL/Z9ATpVq/t5795FYmq6f6FX
X-Google-Smtp-Source: APXvYqwbFw4zpEq5+VGQtvYYhJ5Rr2YDTmoAMr5XQSggbBGp6e6FlHIzeZJSt0dBR34FlV95o/8RrQ==
X-Received: by 2002:a25:c584:: with SMTP id v126mr25696762ybe.386.1574109003731;
        Mon, 18 Nov 2019 12:30:03 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id 64sm8712182ywg.103.2019.11.18.12.30.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 12:30:02 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id n82so6388512ywc.7
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 12:30:02 -0800 (PST)
X-Received: by 2002:a0d:c942:: with SMTP id l63mr21810263ywd.269.1574109001749;
 Mon, 18 Nov 2019 12:30:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1574071944.git.pabeni@redhat.com> <643f2b258e275e915fa96ef0c635f9c5ff804c9d.1574071944.git.pabeni@redhat.com>
In-Reply-To: <643f2b258e275e915fa96ef0c635f9c5ff804c9d.1574071944.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Nov 2019 15:29:25 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf_GL2gfGnDnZiVzHpjbV6+bw25Pi-FMNdUGH4np9=N3Q@mail.gmail.com>
Message-ID: <CA+FuTSf_GL2gfGnDnZiVzHpjbV6+bw25Pi-FMNdUGH4np9=N3Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] ipv6: introduce and uses route look hints
 for list input
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 6:03 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When doing RX batch packet processing, we currently always repeat
> the route lookup for each ingress packet. If policy routing is
> configured, and IPV6_SUBTREES is disabled at build time, we
> know that packets with the same destination address will use
> the same dst.
>
> This change tries to avoid per packet route lookup caching
> the destination address of the latest successful lookup, and
> reusing it for the next packet when the above conditions are
> in place. Ingress traffic for most servers should fit.
>
> The measured performance delta under UDP flood vs a recvmmsg
> receiver is as follow:
>
> vanilla         patched         delta
> Kpps            Kpps            %
> 1431            1664            +14

Since IPv4 speed-up is almost half and code considerably more complex,
maybe only do IPv6?

>
> In the worst-case scenario - each packet has a different
> destination address - the performance delta is within noise
> range.
>
> v1 -> v2:
>  - fix build issue with !CONFIG_IPV6_MULTIPLE_TABLES
>  - fix potential race when fib6_has_custom_rules is set
>    while processing a packet batch
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv6/ip6_input.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index ef7f707d9ae3..f559ad6b09ef 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -44,10 +44,16 @@
>  #include <net/inet_ecn.h>
>  #include <net/dst_metadata.h>
>
> +struct ip6_route_input_hint {
> +       unsigned long   refdst;
> +       struct in6_addr daddr;
> +};
> +
>  INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
>  INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *));
>  static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
> -                               struct sk_buff *skb)
> +                               struct sk_buff *skb,
> +                               struct ip6_route_input_hint *hint)
>  {
>         void (*edemux)(struct sk_buff *skb);
>
> @@ -59,7 +65,13 @@ static void ip6_rcv_finish_core(struct net *net, struct sock *sk,
>                         INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
>                                         udp_v6_early_demux, skb);
>         }
> -       if (!skb_valid_dst(skb))
> +
> +       if (skb_valid_dst(skb))
> +               return;
> +
> +       if (hint && ipv6_addr_equal(&hint->daddr, &ipv6_hdr(skb)->daddr))
> +               __skb_dst_copy(skb, hint->refdst);
> +       else
>                 ip6_route_input(skb);

Is it possible to do the address comparison in ip6_list_rcv_finish
itself and pass a pointer to refdst if safe? To avoid new struct
definition, memcpy and to have all logic in one place. Need to
keep a pointer to the prev skb, then, instead.

>  static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
>                                 struct list_head *head)
>  {
> +       struct ip6_route_input_hint _hint, *hint = NULL;
>         struct dst_entry *curr_dst = NULL;
>         struct sk_buff *skb, *next;
>         struct list_head sublist;
> @@ -104,9 +127,18 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
>                 skb = l3mdev_ip6_rcv(skb);
>                 if (!skb)
>                         continue;
> -               ip6_rcv_finish_core(net, sk, skb);
> +               ip6_rcv_finish_core(net, sk, skb, hint);
>                 dst = skb_dst(skb);
>                 if (curr_dst != dst) {
> +                       if (ip6_can_cache_route_hint(net)) {
> +                               _hint.refdst = skb->_skb_refdst;
> +                               memcpy(&_hint.daddr, &ipv6_hdr(skb)->daddr,
> +                                      sizeof(_hint.daddr));
> +                               hint = &_hint;
> +                       } else {
> +                               hint = NULL;
> +                       }

not needed. ip6_can_cache_route_hit is the same for all iterations of
the loop (indeed, compile time static), so if false, hint is never
set.




> +
>                         /* dispatch old sublist */
>                         if (!list_empty(&sublist))
>                                 ip6_sublist_rcv_finish(&sublist);
> --
> 2.21.0
>
