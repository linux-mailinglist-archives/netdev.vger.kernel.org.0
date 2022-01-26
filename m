Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5287649D117
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 18:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243901AbiAZRoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 12:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbiAZRoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 12:44:08 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC33C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 09:44:07 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id e17so675992ljk.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 09:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=klAqn1xLqtZoojfb1Qegc6zQK1oGL4d9QTe7/dZRi7o=;
        b=NuYakNQJ7MSq2gaO5AaCSz8EqyNAYKVjMFCblt9F1yw93jEFLUN0JbxKw6w6blYCUE
         SnXf8xRYLOpR85buv32UvVcKP8U0b2yiBRHVNmwqRC9nU+YtJGw9W6U7LXnDFpoCbR++
         pafYxoPtMieS9xxMfQlFFIT1TlOKQc1qVlUNxT86EiSDqJgV5DApSs2CpYBZU76vMhCR
         AmtgJ1++wbfEZW2jgpnPkTw1jUgiNkVCJJrcwTXMm2HkSTPfN6SS87NlJ91I4leeyEv7
         AX1FoALxKOCRYo/4no1LktugEYKfu8oTez8AcWi27sfrnLd8RqU0BUxwVe1i7qslh1Vv
         +vVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=klAqn1xLqtZoojfb1Qegc6zQK1oGL4d9QTe7/dZRi7o=;
        b=WYXh6egjefuMqlX/M9KAQSQdjrt1h0qSS0W0vBVbfQaRx9hxoIvbgm/Z03YofDDsv0
         coIj+0+XtsbhbudZRU0zUFRUpmRVsqpZUSkXPotgG16xnyGLaQtFjkC/lpIp0LMb0tY8
         6+K5d82XW5TioLY9vZOd94Rs+BH1JRPz+e+JWc37Ga1SKiZhRYfekCHzbjcqPbHGjPv1
         QrIlmj0yCz1mKwNXB/VW1swznoJdB9mVxHl11YMMT5uWR1rJ2sf1d39VmMLrMkuAycYc
         BLmp/3qOnAw+g7NlWj88YAXbkWj2e4uoNID78a+bADES1IJLstTuAk8+kKMpOwQ0qLxp
         VCqw==
X-Gm-Message-State: AOAM532IHyb/tgX4zZH6HOdnbLUT3yODY99mE09CtTVzhDP5jSSPbhIE
        F+sSDri9RUfP/lcTbvP7GTBbwMyP4Xr/u979y6wIfQ==
X-Google-Smtp-Source: ABdhPJyDm+DZhYLnJD3FRKFC7QIqAVSaSVmbBAZC9/SpvXEp+d4OzJEBsbFnCtG4G5j1UMq+oFuJMRuktO1C3+AnJxk=
X-Received: by 2002:a2e:a7c4:: with SMTP id x4mr97620ljp.133.1643219045720;
 Wed, 26 Jan 2022 09:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20220125232424.2487391-1-jeffreyji@google.com>
In-Reply-To: <20220125232424.2487391-1-jeffreyji@google.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Wed, 26 Jan 2022 09:43:54 -0800
Message-ID: <CAMzD94QFnN013ePHb+yGYGFrFSWBDG-aLF8v=A2+kvj00YStmA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net-core: add InMacErrors counter
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Brian Vazquez <brianvv@google.com>

On Tue, Jan 25, 2022 at 3:24 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
>
> From: jeffreyji <jeffreyji@google.com>
>
> Increment InMacErrors counter when packet dropped due to incorrect dest
> MAC addr.
>
> An example when this drop can occur is when manually crafting raw
> packets that will be consumed by a user space application via a tap
> device. For testing purposes local traffic was generated using trafgen
> for the client and netcat to start a server
>
> example output from nstat:
> \~# nstat -a | grep InMac
> Ip6InMacErrors                  0                  0.0
> IpExtInMacErrors                1                  0.0
>
> Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> counter was incremented.
>
> Changelog:
>
> v3-4:
> Remove Change-Id
>
> v2:
> Use skb_free_reason() for tracing
> Add real-life example in patch msg
>
> Signed-off-by: jeffreyji <jeffreyji@google.com>
> ---
>  include/linux/skbuff.h    |  1 +
>  include/uapi/linux/snmp.h |  1 +
>  net/ipv4/ip_input.c       |  7 +++++--
>  net/ipv4/proc.c           |  1 +
>  net/ipv6/ip6_input.c      | 12 +++++++-----
>  net/ipv6/proc.c           |  1 +
>  6 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index bf11e1fbd69b..04a36352f677 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -320,6 +320,7 @@ enum skb_drop_reason {
>         SKB_DROP_REASON_TCP_CSUM,
>         SKB_DROP_REASON_TCP_FILTER,
>         SKB_DROP_REASON_UDP_CSUM,
> +       SKB_DROP_REASON_BAD_DEST_MAC,
>         SKB_DROP_REASON_MAX,
>  };
>
> diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
> index 904909d020e2..ac2fac12dd7d 100644
> --- a/include/uapi/linux/snmp.h
> +++ b/include/uapi/linux/snmp.h
> @@ -57,6 +57,7 @@ enum
>         IPSTATS_MIB_ECT0PKTS,                   /* InECT0Pkts */
>         IPSTATS_MIB_CEPKTS,                     /* InCEPkts */
>         IPSTATS_MIB_REASM_OVERLAPS,             /* ReasmOverlaps */
> +       IPSTATS_MIB_INMACERRORS,                /* InMacErrors */
>         __IPSTATS_MIB_MAX
>  };
>
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 3a025c011971..379ef6b46920 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -441,8 +441,11 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>         /* When the interface is in promisc. mode, drop all the crap
>          * that it receives, do not try to analyse it.
>          */
> -       if (skb->pkt_type == PACKET_OTHERHOST)
> -               goto drop;
> +       if (skb->pkt_type == PACKET_OTHERHOST) {
> +               __IP_INC_STATS(net, IPSTATS_MIB_INMACERRORS);
> +               kfree_skb_reason(skb, SKB_DROP_REASON_BAD_DEST_MAC);
> +               return NULL;
> +       }
>
>         __IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
>
> diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
> index f30273afb539..dfe0a1dbf8e9 100644
> --- a/net/ipv4/proc.c
> +++ b/net/ipv4/proc.c
> @@ -117,6 +117,7 @@ static const struct snmp_mib snmp4_ipextstats_list[] = {
>         SNMP_MIB_ITEM("InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
>         SNMP_MIB_ITEM("InCEPkts", IPSTATS_MIB_CEPKTS),
>         SNMP_MIB_ITEM("ReasmOverlaps", IPSTATS_MIB_REASM_OVERLAPS),
> +       SNMP_MIB_ITEM("InMacErrors", IPSTATS_MIB_INMACERRORS),
>         SNMP_MIB_SENTINEL
>  };
>
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 80256717868e..f6245fba7699 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -149,15 +149,17 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>         u32 pkt_len;
>         struct inet6_dev *idev;
>
> -       if (skb->pkt_type == PACKET_OTHERHOST) {
> -               kfree_skb(skb);
> -               return NULL;
> -       }
> -
>         rcu_read_lock();
>
>         idev = __in6_dev_get(skb->dev);
>
> +       if (skb->pkt_type == PACKET_OTHERHOST) {
> +               __IP6_INC_STATS(net, idev, IPSTATS_MIB_INMACERRORS);
> +               rcu_read_unlock();
> +               kfree_skb_reason(skb, SKB_DROP_REASON_BAD_DEST_MAC);
> +               return NULL;
> +       }
> +
>         __IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
>
>         if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
> diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
> index d6306aa46bb1..76e6119ba558 100644
> --- a/net/ipv6/proc.c
> +++ b/net/ipv6/proc.c
> @@ -84,6 +84,7 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
>         SNMP_MIB_ITEM("Ip6InECT1Pkts", IPSTATS_MIB_ECT1PKTS),
>         SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
>         SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
> +       SNMP_MIB_ITEM("Ip6InMacErrors", IPSTATS_MIB_INMACERRORS),
>         SNMP_MIB_SENTINEL
>  };
>
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>
