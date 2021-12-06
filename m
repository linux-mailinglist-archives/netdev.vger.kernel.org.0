Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F0D46AE1B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358056AbhLFXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353673AbhLFXEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:04:22 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBB2C061746;
        Mon,  6 Dec 2021 15:00:53 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id t26so28997156lfk.9;
        Mon, 06 Dec 2021 15:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FjV+wowl7VCTIjvAdT0VMUIUtDoK4pYPTWQSgnrh1wQ=;
        b=Fp5gSPfq6p0nw1xVnNxSi9x503RCL8YgyfLGb5LXL/4yWa6VTOYZVW5BB10G81NTAn
         2nM9HPHL+1yH7tXp2QMamUZ9hNqMe/3Y7qG4fPBrchgioxpT0+sUcT2qqiH1QkaD+CT+
         7rwqNlJiu3fmI0L3DbRKmVbPadybOMaTc9h3nJ0woLIWTS5T5o2+TtzS3aMVfuLZqQ4f
         SNJJUt15NbV57OuWM0QwexX82fe1USFIiT4QZoeOIJ2TBWYBh1kep0iwefhZ7IrAhxpB
         H+HsR4DPoht/iFuF5zqzPXsSC7kbrPHJOG1DtU6OjomIzmzUNQfCA1xXp4JkbNUKCr1t
         nlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FjV+wowl7VCTIjvAdT0VMUIUtDoK4pYPTWQSgnrh1wQ=;
        b=RZNnqvV6jGtJnAqKuzm5ZxCnl04GUwMnj0jGqzj8kJaRJjGS1n0Zb4k0ydhG+xMFMB
         MS9eNhZMmzmsqyMG2HmbtEhzE4HaFjzOJ3hUPZb36IFwcni3ZJeOZJosYJcwKqryttXT
         nQreg+IJSDYNvc9j914do5jImMQleFwum10/tUaFDTcUDxmKpM9vSvap3fKXuZrxblPf
         xuKuxjynMabvHy4Dm219XZsd3xdY+1yIGL/ck886tfjBTZAiQ3WMYsKGTVE9iQaofNNH
         4rydvqVKXs0FZo6J34Ow1J358Q7mcCvPIA6kEfYuYziF3vSqsxNbz/qv8yLzzrpNXK6w
         tOqw==
X-Gm-Message-State: AOAM531sWK9pxzj6ShsMicnDARHq8Ne24681Y0bAyPpVkPa4ddxxuay3
        vHg7N0mB4jj9/33XQka/nb1GYxazDVB/Vu2NRVk=
X-Google-Smtp-Source: ABdhPJwr+QnW9Cs3/TvtkNCsWHvSjpQgN79RW+JGUZYVPRGTp2rLJl7TZJ1jFqE4f/WgVgBAYl27GajJaVy6ieituDY=
X-Received: by 2002:a05:6512:33a5:: with SMTP id i5mr37810841lfg.324.1638831651315;
 Mon, 06 Dec 2021 15:00:51 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com> <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
 <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com> <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com>
In-Reply-To: <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Mon, 6 Dec 2021 15:00:40 -0800
Message-ID: <CAASuNyUKj+dsf++7mhdkjm2mabQggYW4x42_BV=y+VPPSBFqfA@mail.gmail.com>
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

On Thu, Dec 2, 2021 at 9:28 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> On Thu, Dec 2, 2021 at 12:20 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
> >
> > On Wed, Dec 1, 2021 at 11:34 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> > >
> > > On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
> > > >
> > > > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > > > packets can be filtered using ipv6_ext flag.
> > > >
> > > > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > > > ---
> > > >  include/uapi/linux/openvswitch.h |   6 ++
> > > >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> > > >  net/openvswitch/flow.h           |  14 ++++
> > > >  net/openvswitch/flow_netlink.c   |  26 +++++-
> > > >  4 files changed, 184 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > > index a87b44cd5590..43790f07e4a2 100644
> > > > --- a/include/uapi/linux/openvswitch.h
> > > > +++ b/include/uapi/linux/openvswitch.h
> > > > @@ -342,6 +342,7 @@ enum ovs_key_attr {
> > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> > > >         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> > > > +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> > > >
> > > >  #ifdef __KERNEL__
> > > >         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > > > @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
> > > >         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> > > >  };
> > > >
> > > > +/* separate structure to support backward compatibility with older user space */
> > > > +struct ovs_key_ipv6_exthdrs {
> > > > +       __u16  hdrs;
> > > > +};
> > > > +
> > > >  struct ovs_key_tcp {
> > > >         __be16 tcp_src;
> > > >         __be16 tcp_dst;
> > > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > > index 9d375e74b607..28acb40437ca 100644
> > > > --- a/net/openvswitch/flow.c
> > > > +++ b/net/openvswitch/flow.c
> > > > @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
> > > >                                   sizeof(struct icmphdr));
> > > >  }
> > > >
> > > > +/**
> > > > + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> > > > + *
> > > > + * @skb: buffer where extension header data starts in packet
> > > > + * @nh: ipv6 header
> > > > + * @ext_hdrs: flags are stored here
> > > > + *
> > > > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > > > + * is unexpectedly encountered. (Two destination options headers may be
> > > > + * expected and would not cause this bit to be set.)
> > > > + *
> > > > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > > > + * preferred (but not required) by RFC 2460:
> > > > + *
> > > > + * When more than one extension header is used in the same packet, it is
> > > > + * recommended that those headers appear in the following order:
> > > > + *      IPv6 header
> > > > + *      Hop-by-Hop Options header
> > > > + *      Destination Options header
> > > > + *      Routing header
> > > > + *      Fragment header
> > > > + *      Authentication header
> > > > + *      Encapsulating Security Payload header
> > > > + *      Destination Options header
> > > > + *      upper-layer header
> > > > + */
> > > > +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> > > > +                             u16 *ext_hdrs)
> > > > +{
> > > > +       u8 next_type = nh->nexthdr;
> > > > +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> > > > +       int dest_options_header_count = 0;
> > > > +
> > > > +       *ext_hdrs = 0;
> > > > +
> > > > +       while (ipv6_ext_hdr(next_type)) {
> > > > +               struct ipv6_opt_hdr _hdr, *hp;
> > > > +
> > > > +               switch (next_type) {
> > > > +               case IPPROTO_NONE:
> > > > +                       *ext_hdrs |= OFPIEH12_NONEXT;
> > > > +                       /* stop parsing */
> > > > +                       return;
> > > > +
> > > > +               case IPPROTO_ESP:
> > > > +                       if (*ext_hdrs & OFPIEH12_ESP)
> > > > +                               *ext_hdrs |= OFPIEH12_UNREP;
> > > > +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> > > > +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> > > > +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> > > > +                           dest_options_header_count >= 2) {
> > > > +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> > > > +                       }
> > > > +                       *ext_hdrs |= OFPIEH12_ESP;
> > > > +                       break;
> > > you need to check_header() before looking into each extension header.
> >
> > Could you elaborate why I need to add check_header(),
> > skb_header_pointer() is doing sanitization.
>
> I mean check_header() would allow you to read the header without
> copying the bits, it is used in ovs flow extraction so its usual
> check.

But check_header() will call *__pskb_pull_tail which in turn will copy
bits if data will be fragmented.

/* Moves tail of skb head forward, copying data from fragmented part,
 * when it is necessary.
 * 1. It may fail due to malloc failure.
 * 2. It may change skb pointers.
 *
 * It is pretty complicated. Luckily, it is called only in exceptional cases.
 */
void *__pskb_pull_tail(struct sk_buff *skb, int delta)

as well I noticed that for example commit
4a06fa67c4da20148803525151845276cdb995c1 is moving from
pskb_may_pull() to skb_header_pointer()
