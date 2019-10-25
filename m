Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115B0E5008
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440676AbfJYPXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:23:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36234 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfJYPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:23:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so3823727qto.3
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DvzfwhnT9IaTjdbhIECvSA2O6h/kQqSoCdxHpSMfKL8=;
        b=b1ax0PypiHfa6GFOhzhWswUR1cZ9Qqm+5+rVHk7all6IqG8GOJIKVRgraEC1VheSNX
         okWQod43VDuV4qmflG4SzpFNgsuOLt56Syg7qdXAMkyCQTOj6XuwcOKnI0zcRpnfmu1G
         7PMhjVF0PbbMu8kFLXd6J8nCZ/g2eDSfuFICme+8l72pZPhwCMuwDga+DpSrn2Y2rvcs
         ThI6Pc2GsYxBw11HCf3kTLx8dhPcWkr0KML1KwhnS18Ex1sa6Suiv7ao6bnWj3tMFdZb
         jpBkJPZKQylf6JlpuHkvwVCBsUELjNrtq1ho5TV3fhRAAmLgMtNoGtmecyd4aHzXQXNA
         gAyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DvzfwhnT9IaTjdbhIECvSA2O6h/kQqSoCdxHpSMfKL8=;
        b=iyFrWX95pj321tVpumKr/v1poVIVnc60vPFPxnDCCxFeE12XDuHiR0WviYNgUiA5Yj
         8oHgAuA0+BPyII8tUTccNV78Xm1rgzluP8tc/ykBoJA5cmCl269n5ccgbQZzP97GCQyo
         uLcR6Tg1jWoXmeIH4HE/y0eIweRUhgH1mGh76jDslCkgM0qhSUhqc/ZxHCiVBPHHegCF
         a2O+Ft8ppD0odTdAtZdGlKxFIbXvPlAhBm+gKfj5pFOy6UEQF4BvOqJYOf/99Ad7Ivpl
         +iqSiJKAOwE3Wr2LyukalWGbGvtN10PRnowQ632ixRmv+qtpLiFqJ1iiyI3qM+e5TmNc
         rnVA==
X-Gm-Message-State: APjAAAUljADkEuRyhFwQNBZy0NkzKJ1aYVMEApJG4dZB0p8lcGYJo8+b
        29SgbYd2sNI3S5Fyx/FwPbLOwPU502oKc+eJN0Y=
X-Google-Smtp-Source: APXvYqyFbogcHLhZAT8V73SjVQ89to5YLztaNNqryqZAmO2HwZ4ypdjmrnL5SEEJeF0TKcuzUYNJhbgvR3FlzyS5Oyw=
X-Received: by 2002:a0c:abcc:: with SMTP id k12mr3785851qvb.101.1572017028266;
 Fri, 25 Oct 2019 08:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
 <20191024204740.GA74879@gmail.com> <20191025023400.GA2564@martin-VirtualBox>
In-Reply-To: <20191025023400.GA2564@martin-VirtualBox>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 25 Oct 2019 08:23:07 -0700
Message-ID: <CALDO+SbQiAU3VY3osJhXgOPGJYVXnTuHLONqZedcykEqEqwHUg@mail.gmail.com>
Subject: Re: [PATCH v2] Change in Openvswitch to support MPLS label depth of 3
 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pravin shelar <pshelar@ovn.org>,
        David Miller <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 7:34 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Oct 24, 2019 at 01:47:40PM -0700, William Tu wrote:
> > On Sun, Oct 20, 2019 at 07:41:42PM +0530, Martin Varghese wrote:
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > direction though the userspace OVS supports a max depth of 3 labels.
> > > This change enables openvswitch module to support a max depth of
> > > 3 labels in the ingress.
> > >
> >
> > Hi Martin,
> > Thanks for the patch. I have one comment below.
> >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > ---
> > > Changes in v2
> > >    - Moved MPLS count validation from datapath to configuration.
> > >    - Fixed set mpls function.
> > >
> > >  net/openvswitch/actions.c      |  2 +-
> > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > >  net/openvswitch/flow.h         |  9 ++++---
> > >  net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
> > >  4 files changed, 66 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > index 3572e11..f3125d7 100644
> > > --- a/net/openvswitch/actions.c
> > > +++ b/net/openvswitch/actions.c
> > > @@ -199,7 +199,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > >     if (err)
> > >             return err;
> > >
> > > -   flow_key->mpls.top_lse = lse;
> > > +   flow_key->mpls.lse[0] = lse;
> > >     return 0;
> > >  }
> > >
> > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > index dca3b1e..c101355 100644
> > > --- a/net/openvswitch/flow.c
> > > +++ b/net/openvswitch/flow.c
> > > @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
> > >                     memset(&key->ipv4, 0, sizeof(key->ipv4));
> > >             }
> > >     } else if (eth_p_mpls(key->eth.type)) {
> > > -           size_t stack_len = MPLS_HLEN;
> > > +           u8 label_count = 1;
> > >
> > > +           memset(&key->mpls, 0, sizeof(key->mpls));
> > >             skb_set_inner_network_header(skb, skb->mac_len);
> > >             while (1) {
> > >                     __be32 lse;
> > >
> > > -                   error = check_header(skb, skb->mac_len + stack_len);
> > > +                   error = check_header(skb, skb->mac_len +
> > > +                                        label_count * MPLS_HLEN);
> > >                     if (unlikely(error))
> > >                             return 0;
> > >
> > >                     memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
> > >
> > > -                   if (stack_len == MPLS_HLEN)
> > > -                           memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> > > +                   if (label_count <= MPLS_LABEL_DEPTH)
> > > +                           memcpy(&key->mpls.lse[label_count - 1], &lse,
> > > +                                  MPLS_HLEN);
> > >
> > > -                   skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> > > +                   skb_set_inner_network_header(skb, skb->mac_len +
> > > +                                                label_count * MPLS_HLEN);
> > >                     if (lse & htonl(MPLS_LS_S_MASK))
> > >                             break;
> > >
> > > -                   stack_len += MPLS_HLEN;
> > > +                   label_count++;
> > >             }
> > > +           if (label_count > MPLS_LABEL_DEPTH)
> > > +                   label_count = MPLS_LABEL_DEPTH;
> > > +
> > > +           key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
> >
> > >     } else if (key->eth.type == htons(ETH_P_IPV6)) {
> > >             int nh_len;             /* IPv6 Header + Extensions */
> > >
> > > diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
> > > index 3e2cc22..d9eccbe 100644
> > > --- a/net/openvswitch/flow.h
> > > +++ b/net/openvswitch/flow.h
> > > @@ -30,6 +30,7 @@ enum sw_flow_mac_proto {
> > >     MAC_PROTO_ETHERNET,
> > >  };
> > >  #define SW_FLOW_KEY_INVALID        0x80
> > > +#define MPLS_LABEL_DEPTH       3
> > >
> > >  /* Store options at the end of the array if they are less than the
> > >   * maximum size. This allows us to get the benefits of variable length
> > > @@ -85,9 +86,6 @@ struct sw_flow_key {
> > >                                      */
> > >     union {
> > >             struct {
> > > -                   __be32 top_lse; /* top label stack entry */
> > > -           } mpls;
> > > -           struct {
> > >                     u8     proto;   /* IP protocol or lower 8 bits of ARP opcode. */
> > >                     u8     tos;         /* IP ToS. */
> > >                     u8     ttl;         /* IP TTL/hop limit. */
> > > @@ -135,6 +133,11 @@ struct sw_flow_key {
> > >                             } nd;
> > >                     };
> > >             } ipv6;
> > > +           struct {
> > > +                   u32 num_labels_mask;    /* labels present bitmap of effective length MPLS_LABEL_DEPTH */
> >
> > Why using a bitmap here? why not just num_labels?
> > I saw that you have to convert it using hweight_long()
> > to num_labels a couple places below.
> >
>
> num_labels will not work when used in flow_key for flow match.
> Assume a case where a packet with 3 labels are received and the configured
> flow has a match condition for the top most label only.Num_labels cannot be
> used in that case
>
> My original patch was with num_labels.And we found that it will not work for
> the above case.
> Jbenc@redhat.com proposed the idea of num_labels_mask.
>

Thank you. Now I understand.
William
