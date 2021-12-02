Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B364466AD7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348780AbhLBUX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348771AbhLBUXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:23:51 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F11C06174A;
        Thu,  2 Dec 2021 12:20:26 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id v15so2077118ljc.0;
        Thu, 02 Dec 2021 12:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fCzrqr37/Pa5nR8At64WlrHZN/bairxH2LuamcatVLw=;
        b=CUCBR/Ff7yjRk9IS8y2DBx2HmQPWsnyXqPWvLAfvwFZTAWH8l16MK5PJ3n0oDkX3di
         RN4SjcIISRc3g/84B8h4kiReDbDAkXIhiOGEeFzCR0d8Dj8oaYUhu4WuDDa4CdaA4mlI
         bj8LhXMcnyMUow8T17L+QndhrwI56Z0EwlDlU1W3QGOCTboUaLMT1v4+PakGfqwXXg4r
         Cr7LHqEF1BP9ro5FUzGBV/H/S8S0+JrEZc7+ZHPjynkGx4UB2Y2biNo0ses392sEokbi
         mya3W7EsD/1q9P6Al1qXAKQ66U+nwKJMg4UA0R++FqGjfYxxq0PzuRz27KEHj89TJXC9
         3ihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fCzrqr37/Pa5nR8At64WlrHZN/bairxH2LuamcatVLw=;
        b=R6xG4YogV0oGMebM5wc6xrxYVp85VC5pWMAsxb9o4FLj2XQSXEZXO6PduMuEY8dL7Q
         0TWdjKJv17baWdiEJZw5L2uEQNa9MmdJgmoxhLkCkStDUJbKltHFUt3b3K4SPZsz/az7
         rAI/ZTmgC21Kptpq/LHHHxkd4fntDObyyQqBfLNE0yEiSeuzR9Tbt2o0+RK8Am+PlUP5
         3udKMoT/7tq31g56mMDC40TId+eN2Iw4d9tFy8xR3gKhtUbGzWuC5O3ZMfl8IkqqH3na
         kZpo/FckJsEdsk8fKyP0IKfuoMCA+VoMbmcoicQu0KkD6rAioquuOIyI0vhjCJluumZQ
         yFGw==
X-Gm-Message-State: AOAM532i3/lCV2mkSZmVxp+uIKd6sUP36sPYCYCeSOh/XErp7eP4Y1eE
        hSe8aablMeHrH4EiSD32vGI9O4cqOF+vYcMhJrk=
X-Google-Smtp-Source: ABdhPJwRnG3pGN65CEPU0PxEFQ6Hhgtf6hLpY+v4ZNfIvtzJ3wYjDctmWxV2DJiX6mNGD/eMjZEpMcuqkEcRMEnGvfE=
X-Received: by 2002:a2e:a792:: with SMTP id c18mr14177493ljf.443.1638476425201;
 Thu, 02 Dec 2021 12:20:25 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com> <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
In-Reply-To: <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Thu, 2 Dec 2021 12:20:14 -0800
Message-ID: <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 11:34 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
> >
> > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > packets can be filtered using ipv6_ext flag.
> >
> > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > ---
> >  include/uapi/linux/openvswitch.h |   6 ++
> >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> >  net/openvswitch/flow.h           |  14 ++++
> >  net/openvswitch/flow_netlink.c   |  26 +++++-
> >  4 files changed, 184 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44cd5590..43790f07e4a2 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -342,6 +342,7 @@ enum ovs_key_attr {
> >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> >         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> > +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> >
> >  #ifdef __KERNEL__
> >         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
> >         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> >  };
> >
> > +/* separate structure to support backward compatibility with older user space */
> > +struct ovs_key_ipv6_exthdrs {
> > +       __u16  hdrs;
> > +};
> > +
> >  struct ovs_key_tcp {
> >         __be16 tcp_src;
> >         __be16 tcp_dst;
> > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > index 9d375e74b607..28acb40437ca 100644
> > --- a/net/openvswitch/flow.c
> > +++ b/net/openvswitch/flow.c
> > @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
> >                                   sizeof(struct icmphdr));
> >  }
> >
> > +/**
> > + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> > + *
> > + * @skb: buffer where extension header data starts in packet
> > + * @nh: ipv6 header
> > + * @ext_hdrs: flags are stored here
> > + *
> > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > + * is unexpectedly encountered. (Two destination options headers may be
> > + * expected and would not cause this bit to be set.)
> > + *
> > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > + * preferred (but not required) by RFC 2460:
> > + *
> > + * When more than one extension header is used in the same packet, it is
> > + * recommended that those headers appear in the following order:
> > + *      IPv6 header
> > + *      Hop-by-Hop Options header
> > + *      Destination Options header
> > + *      Routing header
> > + *      Fragment header
> > + *      Authentication header
> > + *      Encapsulating Security Payload header
> > + *      Destination Options header
> > + *      upper-layer header
> > + */
> > +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> > +                             u16 *ext_hdrs)
> > +{
> > +       u8 next_type = nh->nexthdr;
> > +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> > +       int dest_options_header_count = 0;
> > +
> > +       *ext_hdrs = 0;
> > +
> > +       while (ipv6_ext_hdr(next_type)) {
> > +               struct ipv6_opt_hdr _hdr, *hp;
> > +
> > +               switch (next_type) {
> > +               case IPPROTO_NONE:
> > +                       *ext_hdrs |= OFPIEH12_NONEXT;
> > +                       /* stop parsing */
> > +                       return;
> > +
> > +               case IPPROTO_ESP:
> > +                       if (*ext_hdrs & OFPIEH12_ESP)
> > +                               *ext_hdrs |= OFPIEH12_UNREP;
> > +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> > +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> > +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> > +                           dest_options_header_count >= 2) {
> > +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> > +                       }
> > +                       *ext_hdrs |= OFPIEH12_ESP;
> > +                       break;
> you need to check_header() before looking into each extension header.

Could you elaborate why I need to add check_header(),
skb_header_pointer() is doing sanitization.
