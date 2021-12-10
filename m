Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E945046FBA4
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbhLJHkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbhLJHj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:39:56 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C07AC0617A1;
        Thu,  9 Dec 2021 23:36:21 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id g28so6989250qkk.9;
        Thu, 09 Dec 2021 23:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HUTwS7xM+YcEvJ79qh9Q5lIy9ARorMvWQSRogohGLCs=;
        b=TAleqTPVjeXyH067cJPzHDNf8lHlWKSqC+fOmbtTqF70LiN4oDRNA6mpDrRiZf1fva
         H903BoBdaXwn2yXpdXmmunJQ5YWKLslIUCQPPR1ZVRPBTE5ilecMO//QrIleN+cokpKv
         N9eGjHgWpawenAumJ+Q3Xa5uU+y67MLxH+GwMXMCte5qgBCXa3/lTtGShkcZMeJLzKLt
         S/Tp8oRRLoPNfHbhiOL067n+DRqFmlAKjspCx16yc4YpxyvogyGNnXFgHuemfemD3TXw
         1kx3SO43s8XG2HNqT5LcahLhekGahLRH5ckGSWEo7zExuT3C3/4uwds4VFs7tDSc0k7I
         aA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HUTwS7xM+YcEvJ79qh9Q5lIy9ARorMvWQSRogohGLCs=;
        b=0K4htbxBXfq23JwSCdHlV4NmRgfTuTza+JothcZnmv4Yk4Z4frXWmWTPbQtmMl7k1j
         g9XYGZPIsa3dFU2p6MpOnJFKs++cmT4a6cxsdONW3Tcqly29uNazt6jc3I37VteqcsSS
         156LOH5dEzS2pGaUOVqJd+iyYgRJ/ThhdkORlJvE8lBvTm2bVNUFq+XBNGxUo8ZjHKWW
         VSN8GMaNecx5FdrJZqOUKKx1tQS7cRvrvrKa+tVw/1JEaEejz0dd/9j09jF+niyIQsRO
         toI6NR+023Hu6a8No5Q4Sd+kcB0Da1Rywb+9vn9Slx/qmXX3P5wsPYfx54C4xE7DqkpI
         DR4g==
X-Gm-Message-State: AOAM5321mB12HrIeB0nmEuIPKdPVSkqtLoomOi3uohbrqW6gJ3iZxHGj
        6W76bBSwomEicq7FNJcQQTZIXAIYjOY98isDuXY=
X-Google-Smtp-Source: ABdhPJwYHbxLow1IU041nfozRSJCzMxLTXgGvgqkCNZKDv1hk/hlD0U5+MJQ0Lat29M4BS8/zSOmk5N299fREPLQdkg=
X-Received: by 2002:a37:654e:: with SMTP id z75mr18522006qkb.732.1639121780720;
 Thu, 09 Dec 2021 23:36:20 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com> <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
 <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
 <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com> <CAASuNyUKj+dsf++7mhdkjm2mabQggYW4x42_BV=y+VPPSBFqfA@mail.gmail.com>
In-Reply-To: <CAASuNyUKj+dsf++7mhdkjm2mabQggYW4x42_BV=y+VPPSBFqfA@mail.gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Thu, 9 Dec 2021 23:36:09 -0800
Message-ID: <CAOrHB_CyBoTYO8Qn-qtcfrbqfVc9TjaU6ib_2ZSQx-R9ns-bUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Cpp Code <cpp.code.lv@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

()

On Mon, Dec 6, 2021 at 3:00 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
>
> On Thu, Dec 2, 2021 at 9:28 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> >
> > On Thu, Dec 2, 2021 at 12:20 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
> > >
> > > On Wed, Dec 1, 2021 at 11:34 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> > > >
> > > > On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
> > > > >
> > > > > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > > > > packets can be filtered using ipv6_ext flag.
> > > > >
> > > > > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > > > > ---
> > > > >  include/uapi/linux/openvswitch.h |   6 ++
> > > > >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> > > > >  net/openvswitch/flow.h           |  14 ++++
> > > > >  net/openvswitch/flow_netlink.c   |  26 +++++-
> > > > >  4 files changed, 184 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > > > index a87b44cd5590..43790f07e4a2 100644
> > > > > --- a/include/uapi/linux/openvswitch.h
> > > > > +++ b/include/uapi/linux/openvswitch.h
> > > > > @@ -342,6 +342,7 @@ enum ovs_key_attr {
> > > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> > > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> > > > >         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> > > > > +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> > > > >
> > > > >  #ifdef __KERNEL__
> > > > >         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > > > > @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
> > > > >         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> > > > >  };
> > > > >
> > > > > +/* separate structure to support backward compatibility with older user space */
> > > > > +struct ovs_key_ipv6_exthdrs {
> > > > > +       __u16  hdrs;
> > > > > +};
> > > > > +
> > > > >  struct ovs_key_tcp {
> > > > >         __be16 tcp_src;
> > > > >         __be16 tcp_dst;
> > > > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > > > index 9d375e74b607..28acb40437ca 100644
> > > > > --- a/net/openvswitch/flow.c
> > > > > +++ b/net/openvswitch/flow.c
> > > > > @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
> > > > >                                   sizeof(struct icmphdr));
> > > > >  }
> > > > >
> > > > > +/**
> > > > > + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> > > > > + *
> > > > > + * @skb: buffer where extension header data starts in packet
> > > > > + * @nh: ipv6 header
> > > > > + * @ext_hdrs: flags are stored here
> > > > > + *
> > > > > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > > > > + * is unexpectedly encountered. (Two destination options headers may be
> > > > > + * expected and would not cause this bit to be set.)
> > > > > + *
> > > > > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > > > > + * preferred (but not required) by RFC 2460:
> > > > > + *
> > > > > + * When more than one extension header is used in the same packet, it is
> > > > > + * recommended that those headers appear in the following order:
> > > > > + *      IPv6 header
> > > > > + *      Hop-by-Hop Options header
> > > > > + *      Destination Options header
> > > > > + *      Routing header
> > > > > + *      Fragment header
> > > > > + *      Authentication header
> > > > > + *      Encapsulating Security Payload header
> > > > > + *      Destination Options header
> > > > > + *      upper-layer header
> > > > > + */
> > > > > +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> > > > > +                             u16 *ext_hdrs)
> > > > > +{
> > > > > +       u8 next_type = nh->nexthdr;
> > > > > +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> > > > > +       int dest_options_header_count = 0;
> > > > > +
> > > > > +       *ext_hdrs = 0;
> > > > > +
> > > > > +       while (ipv6_ext_hdr(next_type)) {
> > > > > +               struct ipv6_opt_hdr _hdr, *hp;
> > > > > +
> > > > > +               switch (next_type) {
> > > > > +               case IPPROTO_NONE:
> > > > > +                       *ext_hdrs |= OFPIEH12_NONEXT;
> > > > > +                       /* stop parsing */
> > > > > +                       return;
> > > > > +
> > > > > +               case IPPROTO_ESP:
> > > > > +                       if (*ext_hdrs & OFPIEH12_ESP)
> > > > > +                               *ext_hdrs |= OFPIEH12_UNREP;
> > > > > +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> > > > > +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> > > > > +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> > > > > +                           dest_options_header_count >= 2) {
> > > > > +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> > > > > +                       }
> > > > > +                       *ext_hdrs |= OFPIEH12_ESP;
> > > > > +                       break;
> > > > you need to check_header() before looking into each extension header.
> > >
> > > Could you elaborate why I need to add check_header(),
> > > skb_header_pointer() is doing sanitization.
> >
> > I mean check_header() would allow you to read the header without
> > copying the bits, it is used in ovs flow extraction so its usual
> > check.
>
> But check_header() will call *__pskb_pull_tail which in turn will copy
> bits if data will be fragmented.
>
OVS flow extract uses this function to extract flow upto L4, so
skb_header_pointer() is not saving any copy operation.

> /* Moves tail of skb head forward, copying data from fragmented part,
>  * when it is necessary.
>  * 1. It may fail due to malloc failure.
>  * 2. It may change skb pointers.
>  *
>  * It is pretty complicated. Luckily, it is called only in exceptional cases.
>  */
> void *__pskb_pull_tail(struct sk_buff *skb, int delta)
>
> as well I noticed that for example commit
> 4a06fa67c4da20148803525151845276cdb995c1 is moving from
> pskb_may_pull() to skb_header_pointer()
ok, I see advantage of using skb_header_pointer() in this case, but
replacing all check_header() with skb_header_pointer() would add lot
of copy operation in flow extract. Anyways for this use case
skb_header_pointer() is fine.

Acked-by: Pravin B Shelar <pshelar@ovn.org>
