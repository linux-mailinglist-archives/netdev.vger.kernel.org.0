Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204DD465EBF
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 08:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbhLBHhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 02:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhLBHhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 02:37:32 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003D1C061574;
        Wed,  1 Dec 2021 23:34:09 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id j9so24155549qvm.10;
        Wed, 01 Dec 2021 23:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Opto3wzHEqjYd8T7jPwjWOK/RPwqYNm/IybTcV27N+E=;
        b=j17TucoRjQ1GSoJfksT/OZw6ms3LET8kRFz2cf2wmIfBLUXR/fdODv6y5Ptx2C3v9k
         hSRvrTuXtXjpH+zEaqgDC0aIP1dYgxHh9Z3KuerZTvae2HbJIgJfmT+JNjrLt5Ad59mm
         kNBnOvNKxs/rbdtcBBebeugZMNwR88HaFz9LVx5cSXzQP7sc/jFklgE57a1JeYf+ggRX
         VHAAnaNCsGJxRaNKcjjpJZb/rT+Wj5nHwKxk+GFIhXO09sU1qUmFTQtXTDmd5an+FYpv
         P0TfPFYj+ChvMEeX6ijIL3UI0eAx1EeoUAX6N91xa1e7j0x9zc3vM03N0zSCMLlS1ulq
         WIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Opto3wzHEqjYd8T7jPwjWOK/RPwqYNm/IybTcV27N+E=;
        b=Css7G29YdNO5RmGI+XAWPWXmHjiCsmESpSf4JKjElVOT2UujRID4m8shGwD3S+qgiG
         Wd5mVnh8m2PCyd8JZp6HFNSRfaGjYyjTzzBtUo2Tre8DcCW8MGmNr2PXYwVf4VpSqnvI
         GIg+yf7BUGLdk6kkL7kUUOGfQWcgay6qiWpcvOssPHeX1wXuEly+3SuZ9JBtYJ18Pboc
         KaxHAWtDgbC8Ij1BEFCuk8Zmd+Q5Jkzp/IgSkZOWubVxm2AV8qHRIqCgAI8DGBgzYX1X
         7RJ9Wb3NGwfk7DYErrcWShISXBvfTTKNGDFpk1df2OV+9kS9x9Q5+KgaKrjUfls2EZja
         G3kw==
X-Gm-Message-State: AOAM532aCvs+3shCTtFF/g73qj2JgGCCBTsGj1crtgS4dBooG235/T9D
        8/8OwSc5IJ1+87cUJTKtuZIR3wnwSFbAZeU2uHY=
X-Google-Smtp-Source: ABdhPJy6OcNQxxq8vG1XlhscO3avBiMuaj9b8YJuz1edXhJg2DDbXUsaqDnO1aRgyBHWtx+r3S2a9AmyBesFlDIXeYk=
X-Received: by 2002:ad4:5b82:: with SMTP id 2mr10931268qvp.87.1638430449151;
 Wed, 01 Dec 2021 23:34:09 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com>
In-Reply-To: <20211124193327.2736-1-cpp.code.lv@gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Wed, 1 Dec 2021 23:33:58 -0800
Message-ID: <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Toms Atteka <cpp.code.lv@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
>
> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> packets can be filtered using ipv6_ext flag.
>
> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> ---
>  include/uapi/linux/openvswitch.h |   6 ++
>  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>  net/openvswitch/flow.h           |  14 ++++
>  net/openvswitch/flow_netlink.c   |  26 +++++-
>  4 files changed, 184 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index a87b44cd5590..43790f07e4a2 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -342,6 +342,7 @@ enum ovs_key_attr {
>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>
>  #ifdef __KERNEL__
>         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
>         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
>  };
>
> +/* separate structure to support backward compatibility with older user space */
> +struct ovs_key_ipv6_exthdrs {
> +       __u16  hdrs;
> +};
> +
>  struct ovs_key_tcp {
>         __be16 tcp_src;
>         __be16 tcp_dst;
> diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> index 9d375e74b607..28acb40437ca 100644
> --- a/net/openvswitch/flow.c
> +++ b/net/openvswitch/flow.c
> @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
>                                   sizeof(struct icmphdr));
>  }
>
> +/**
> + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> + *
> + * @skb: buffer where extension header data starts in packet
> + * @nh: ipv6 header
> + * @ext_hdrs: flags are stored here
> + *
> + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> + * is unexpectedly encountered. (Two destination options headers may be
> + * expected and would not cause this bit to be set.)
> + *
> + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> + * preferred (but not required) by RFC 2460:
> + *
> + * When more than one extension header is used in the same packet, it is
> + * recommended that those headers appear in the following order:
> + *      IPv6 header
> + *      Hop-by-Hop Options header
> + *      Destination Options header
> + *      Routing header
> + *      Fragment header
> + *      Authentication header
> + *      Encapsulating Security Payload header
> + *      Destination Options header
> + *      upper-layer header
> + */
> +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> +                             u16 *ext_hdrs)
> +{
> +       u8 next_type = nh->nexthdr;
> +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> +       int dest_options_header_count = 0;
> +
> +       *ext_hdrs = 0;
> +
> +       while (ipv6_ext_hdr(next_type)) {
> +               struct ipv6_opt_hdr _hdr, *hp;
> +
> +               switch (next_type) {
> +               case IPPROTO_NONE:
> +                       *ext_hdrs |= OFPIEH12_NONEXT;
> +                       /* stop parsing */
> +                       return;
> +
> +               case IPPROTO_ESP:
> +                       if (*ext_hdrs & OFPIEH12_ESP)
> +                               *ext_hdrs |= OFPIEH12_UNREP;
> +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> +                           dest_options_header_count >= 2) {
> +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> +                       }
> +                       *ext_hdrs |= OFPIEH12_ESP;
> +                       break;
you need to check_header() before looking into each extension header.
