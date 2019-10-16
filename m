Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2074AD8630
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389203AbfJPDF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:05:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46637 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfJPDF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:05:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id e15so5353399pgu.13
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t+xaEoOIMyfczg4iHhS+UdrNANRll+o2qEqih7Wk8PQ=;
        b=LzFzLL5ioynahzpoyXSu7YhAmMWgJTLiKyuMM77/EFbcsQKb66dVCfwiqX/qP0hJ5P
         AmEL1oqw4mZDijwJt76g7q4JapoRTb9LQaV3kq/vjnmTodj0d/BIdLlb7MZA/DzsP1Ty
         Xsww6uKIPyVObzSnfJdyKa9tVXdzHzAwb5AO+ZXLwA5sQlQedUAV3ji/FRVqOd0tpwqj
         nompUXZoXuHMZemDsS7MhItY7gaaMA6Pq6N1MRRJJj5UerCrKRR/hE5ln7PSsGYPhU8X
         /Ae21IcuoXgTR2VSpaQgMp4lz7guO7pp7+jlxStRas7vs+scDZFDSrQV+wG5NClSSmpV
         TYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t+xaEoOIMyfczg4iHhS+UdrNANRll+o2qEqih7Wk8PQ=;
        b=cKq1DhP9ak5HjkM03jemUZc6xugam9VgYxD6hBqW2Y7u2HYYxytLpvKXnmlZMS6Gew
         zkP9E0bUDyPBWqYack0eCRLbow+Y7jJwC8FsP/jh6Arkj4N0b+QM7C9oPVjpm4QNJnvu
         a/NeZh4HFYkIRnLx9hZxGntVBtEhI6kAv14hJbvG12E4oD7RLhdaz34nO9Ghhs+kZ17q
         KjCjtRnQjAxHGrLL84r17nMWXPuAk9mHJnjLIV3QCIBwrvqX6KMY+grf3r2Du/M7i5gQ
         mpZCvB1IzYjm5TgNNTC4nF45HwItDrpo1P1tMFnbeiOXmDK+Rvig1BzoWrsvJ4RaZNaz
         DlFg==
X-Gm-Message-State: APjAAAVPbc3ZcHW5EgDsGD2I74Wej1Zt3bXkmmybVnPqrkIQsYEKk3n9
        5a1BrcoZlSjkO5ByiWA2GZhA9eVp
X-Google-Smtp-Source: APXvYqw6CF6fkckBQxvMzYGJSVITwavMyL28ToBV/n6DbBS2UrzARAmEf3cPRPySzs8Xe7Zzk1N6cw==
X-Received: by 2002:a63:160a:: with SMTP id w10mr43296325pgl.212.1571195124555;
        Tue, 15 Oct 2019 20:05:24 -0700 (PDT)
Received: from martin-VirtualBox ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id a11sm20270439pfo.165.2019.10.15.20.05.23
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Oct 2019 20:05:23 -0700 (PDT)
Date:   Wed, 16 Oct 2019 08:35:16 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
Message-ID: <20191016030516.GA2700@martin-VirtualBox>
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
 <20191010043101.GA19339@martin-VirtualBox>
 <CAOrHB_CSwAPW7XwyaFV_hxQADmh25a8JMJa0tRXZbnu-2R60Kw@mail.gmail.com>
 <20191014160444.GA29007@martin-VirtualBox>
 <CAOrHB_CXu-WGPB-7+K8hA=ZubgcMWAERVYbMhKVuSK5z1Sz7tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_CXu-WGPB-7+K8hA=ZubgcMWAERVYbMhKVuSK5z1Sz7tQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 12:03:35AM -0700, Pravin Shelar wrote:
> On Mon, Oct 14, 2019 at 9:06 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Sat, Oct 12, 2019 at 01:08:26PM -0700, Pravin Shelar wrote:
> > > On Wed, Oct 9, 2019 at 9:31 PM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 09, 2019 at 08:29:51AM -0700, Pravin Shelar wrote:
> > > > > On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
> > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > >
> > > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > > >
> > > > > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > > > > direction though the userspace OVS supports a max depth of 3 labels.
> > > > > > This change enables openvswitch module to support a max depth of
> > > > > > 3 labels in the ingress.
> > > > > >
> > > > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > > > > ---
> > > > > >  net/openvswitch/actions.c      | 10 +++++++-
> > > > > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > > > > >  net/openvswitch/flow.h         |  9 ++++---
> > > > > >  net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
> > > > > >  4 files changed, 72 insertions(+), 22 deletions(-)
> > > > > >
> > > > > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > > > > index 3572e11..eb5bed5 100644
> > > > > > --- a/net/openvswitch/actions.c
> > > > > > +++ b/net/openvswitch/actions.c
> > > > > > @@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > > > > >  {
> > > > > >         int err;
> > > > > >
> > > > > > +       if (!key->mpls.num_labels_mask)
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > > >         err = skb_mpls_pop(skb, ethertype);
> > > > > >         if (err)
> > > > > >                 return err;
> > > > > >
> > > > > > +       key->mpls.num_labels_mask >>= 1;
> > > > > >         invalidate_flow_key(key);
> > > > > Since this key is immediately invalidated, what is point of updating
> > > > > the label count?
> > > > >
> > > >
> > > > The num_labels_mask is being checked in the pop_mpls action to see if anymore
> > > > label present to pop.
> > > >
> > > > if (!key->mpls.num_labels_mask)
> > > >         return -EINVAL:
> > > >
> > > > > >         return 0;
> > > > > >  }
> > > > > What about checks in OVS_ACTION_ATTR_PUSH_MPLS?
> > > > >
> > > > The change does not have any impact to the PUSH_MPLS actions.
> > > > It should work as before.
> > > >
> > > Since the MPLS label count is checked in POP, the PUSH action needs to
> > > update the count.
> > >
> > Ok, that would be to support a rule like this
> > eth_type(0x0800),actions: push_mpls(label=7,tc=0,ttl=64,bos=1,eth_type=0x8847), pop_mpls(eth_type=0x800)
> >
> > Though this rule has no effect we can support it for the completeness.
> > It would entail a code like this
> >
> >  if (eth_p_mpls(proto))
> >         key->mpls.num_labels_mask = (key->mpls.num_labels_mask << 1 &
> >                                      GENMASK(MPLS_LABEL_DEPTH -1, 0))| 0x1;  else
> >         key->mpls.num_labels_mask = (key->mpls.num_labels_mask & 0x0)|0x01;
> Yes, but as mentioned below, it can be moved to flow install time.
> 
> > > > > > @@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > > > > >         struct mpls_shim_hdr *stack;
> > > > > >         __be32 lse;
> > > > > >         int err;
> > > > > > +       u32 i = 0;
> > > > > >
> > > > > >         stack = mpls_hdr(skb);
> > > > > >         lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
> > > > > > @@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > > > > >         if (err)
> > > > > >                 return err;
> > > > > >
> > > > > > -       flow_key->mpls.top_lse = lse;
> > > > > > +       for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
> > > > > > +               flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
> > > > > > +
> > > > > > +       flow_key->mpls.lse[i] = *mpls_lse;
> > > > > This is changing semantic of mpls-set action. It is looking like
> > > > > mpls-push. Lets keep the MPLS set that sets one or more MPLS lebels.
> > > > >
> > > > > >         return 0;
> > > > > >  }
> > > >
> > > > Not sure if I got your comment correct.
> > > > Just as before, the new code updates the top most label in the flow_key.
> > > I am referring to the for loop which shifts labels to make room new
> > > label been set. I think the set action should over-write labels
> > > specified in set action.
> > >
> > Correct. Then this would suffice " flow_key->mpls.lse[0] = lse"
> >
> Yes, with this change this action need to support one more labels in set action.
> 
shouldn't we be consistent with the existing behaviour in current kernel module, Dpif-netdev & ovs userspace, where the set_mpls action  sets the top most MPLS label params ?
> > > > > >
> > > > > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > > > > index dca3b1e..c101355 100644
> > > > > > --- a/net/openvswitch/flow.c
> > > > > > +++ b/net/openvswitch/flow.c
> > > > > > @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
> > > > > >                         memset(&key->ipv4, 0, sizeof(key->ipv4));
> > > > > >                 }
> > > > > >         } else if (eth_p_mpls(key->eth.type)) {
> > > > > > -               size_t stack_len = MPLS_HLEN;
> > > > > > +               u8 label_count = 1;
> > > > > >
> > > > > > +               memset(&key->mpls, 0, sizeof(key->mpls));
> > > > > >                 skb_set_inner_network_header(skb, skb->mac_len);
> > > > > >                 while (1) {
> > > > > >                         __be32 lse;
> > > > > >
> > > > > > -                       error = check_header(skb, skb->mac_len + stack_len);
> > > > > > +                       error = check_header(skb, skb->mac_len +
> > > > > > +                                            label_count * MPLS_HLEN);
> > > > > I do not think this is right. This way OVS can copy into MPLS labels
> > > > > from next header beyond MPLS. You need parse MPLS header and determine
> > > > > end of MPLS labels.
> > > > >
> > > > The MPLS labels are parsed and then the label count is updated.
> > > > Did i miss anything ?
> > > ok, That is not issue, but I see other difference compared to current
> > > MPLS flow parsing. Currently OVS is keeping top most label in flow.
> > > with this change it will keep bottom three MPLS labels in flows. I
> > > think we need to keep the parsing same as before.
> >
> > It is keeping the top 3 labels.The loop parses the MPLS labels till it finds the BOS bit or when the label count reaches MPLS_LABEL_DEPTH.
> 
> ok.
> 
> > >
> > >
> > > > > >                         if (unlikely(error))
> > > > > >                                 return 0;
> > > > > >
> > > > > >                         memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
> > > > > >
> > > > > > -                       if (stack_len == MPLS_HLEN)
> > > > > > -                               memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> > > > > > +                       if (label_count <= MPLS_LABEL_DEPTH)
> > > > > > +                               memcpy(&key->mpls.lse[label_count - 1], &lse,
> > > > > > +                                      MPLS_HLEN);
> > > > > >
> > > > > > -                       skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> > > > > > +                       skb_set_inner_network_header(skb, skb->mac_len +
> > > > > > +                                                    label_count * MPLS_HLEN);
> > > > > >                         if (lse & htonl(MPLS_LS_S_MASK))
> > > > > >                                 break;
> > > > > >
> > > > > > -                       stack_len += MPLS_HLEN;
> > > > > > +                       label_count++;
> > > > > >                 }
> > > > > > +               if (label_count > MPLS_LABEL_DEPTH)
> > > > > > +                       label_count = MPLS_LABEL_DEPTH;
> > > > > > +
> > > > > > +               key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
> > > > > >         } else if (key->eth.type == htons(ETH_P_IPV6)) {
> > > > > >                 int nh_len;             /* IPv6 Header + Extensions */
> > > > > >
> > > > > ...
> > > > > ...
> > > > > > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > > > > > index d7559c6..4eb04e9 100644
> > > > > > --- a/net/openvswitch/flow_netlink.c
> > > > > > +++ b/net/openvswitch/flow_netlink.c
> > > > > > @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
> > > > > >         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
> > > > > >         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
> > > > > >                                      .next = ovs_tunnel_key_lens, },
> > > > > > -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> > > > > > +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
> > > > > >         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
> > > > > >         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
> > > > > >         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> > > > > > @@ -1628,10 +1628,26 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> > > > > >
> > > > > >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> > > > > >                 const struct ovs_key_mpls *mpls_key;
> > > > > > +               u32 hdr_len = 0;
> > > > > > +               u32 label_count = 0, i = 0;
> > > > > > +               u32 label_count_mask = 0;
> > > > > No need to initialize these values.
> > > >
> > > > > >
> > > > > >                 mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> > > > > > -               SW_FLOW_KEY_PUT(match, mpls.top_lse,
> > > > > > -                               mpls_key->mpls_lse, is_mask);
> > > > > > +               hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> > > > > > +               label_count = hdr_len / sizeof(struct ovs_key_mpls);
> > > > > > +
> > > > > > +               if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> > > > > > +                   hdr_len % sizeof(struct ovs_key_mpls))
> > > > > > +                       return -EINVAL;
> > > > > > +
> > > > > > +               label_count_mask =  GENMASK(label_count - 1, 0);
> > > > > > +
> > > > > > +               for (i = 0 ; i < label_count; i++)
> > > > > > +                       SW_FLOW_KEY_PUT(match, mpls.lse[i],
> > > > > > +                                       mpls_key[i].mpls_lse, is_mask);
> > > > > > +
> > > > > > +               SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> > > > > > +                               label_count_mask, is_mask);
> > > > > >
> > > > > >                 attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
> > > > > >          }
> > > > > > @@ -2114,13 +2130,22 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> > > > > >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> > > > > >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> > > > > >         } else if (eth_p_mpls(swkey->eth.type)) {
> > > > > > +               u8 i = 0;
> > > > > > +               u8 num_labels;
> > > > > >                 struct ovs_key_mpls *mpls_key;
> > > > > >
> > > > > > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > > > > > +               num_labels = hweight_long(output->mpls.num_labels_mask);
> > > > > > +               if (num_labels >= MPLS_LABEL_DEPTH)
> > > > > > +                       num_labels = MPLS_LABEL_DEPTH;
> > > > > I do not see need for this check. We can copy the value directly from key.
> > > > >
> > > >
> > > > > > +
> > > > > > +               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> > > > > > +                                 num_labels * sizeof(*mpls_key));
> > > > > >                 if (!nla)
> > > > > >                         goto nla_put_failure;
> > > > > > +
> > > > > >                 mpls_key = nla_data(nla);
> > > > > > -               mpls_key->mpls_lse = output->mpls.top_lse;
> > > > > > +               for (i = 0; i < num_labels; i++)
> > > > > > +                       mpls_key[i].mpls_lse = output->mpls.lse[i];
> > > > > >         }
> > > > > >
> > > > > >         if ((swkey->eth.type == htons(ETH_P_IP) ||
> > > > > > @@ -3068,22 +3093,28 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> > > > > >                         break;
> > > > > >                 }
> > > > > >
> > > > > > -               case OVS_ACTION_ATTR_POP_MPLS:
> > > > > > +               case OVS_ACTION_ATTR_POP_MPLS: {
> > > > > > +                       __be16  proto;
> > > > > >                         if (vlan_tci & htons(VLAN_CFI_MASK) ||
> > > > > >                             !eth_p_mpls(eth_type))
> > > > > >                                 return -EINVAL;
> > > > > >
> > > > > Since this patch is adding support for multiple labels, we need to
> > > > > track depth of the MPLS label stack in MPLS push and pop actions
> > > > > validation to avoid checks in fastpath.
> > > > >
> > > > As mentioned before this change has no impact to the push.
> > > > As before, there is no restriction on the number of pushes we can make.
> > > >
> > > > For the pop_mpls, we coud add a local variable to count the number of pops
> > > > and validate that against MPLS_LABEL_DEPTH ?
> > >
> > > Right. lets keep local variable here in flow validation that way we
> > > can avoid the checks in fastpath.
> > >
> >
> > We still needs the check in fast path as we need to validate the number of labels actually present in the packet.
> > We could have a wrong rule where the number of pop_mpls actions is 3 and the number of MPLS labels in the incoming packet is just 2.
> >
> > For that matter having a validation in the pop_mpls action configuration against MPLS_LABEL_DEPTH is redundant.
> > We may not need it.
> >
> > > > > > -                       /* Disallow subsequent L2.5+ set and mpls_pop actions
> > > > > > -                        * as there is no check here to ensure that the new
> > > > > > -                        * eth_type is valid and thus set actions could
> > > > > > -                        * write off the end of the packet or otherwise
> > > > > > -                        * corrupt it.
> > > > > > +                       /* Disallow subsequent L2.5+ set actions as there is
> > > > > > +                        * no check here to ensure that the new eth type is
> > > > > > +                        * valid and thus set actions could write off the
> > > > > > +                        * end of the packet or otherwise corrupt it.
> > > > > >                          *
> > > > > >                          * Support for these actions is planned using packet
> > > > > >                          * recirculation.
> > > > > >                          */
> > > > > > -                       eth_type = htons(0);
> > > > > > +
> > > > > > +                       proto = nla_get_be16(a);
> > > > > > +                       if (!eth_p_mpls(proto))
> > > > > > +                               eth_type = htons(0);
> > > > > > +                       else
> > > > > > +                               eth_type =  proto;
> > > > >
> > > > > I do not see any point of changing this validation logic. OVS can not
> > > > > parse beyond MPLS, so lets keep this as it it.
> > > > >
> > > > >
> > > > unlike before, we can have multiple pop actions now.so we need to update
> > > > the eth_type properly if the proto is MPLS.
> > >
> > > ok, so as mentioned above we need to keep MPLS label stack depth and
> > > keep track of labels added by PUSH actions and removed by POP. That
> > > was we can validate it better and set eth_type to zero when MPLS label
> > > count reaches to zero.
> > >
> >
> > In the configuration flow, how do we keep track of the MPLS labels present in the packet?
> It is in flow key, your patch is adding this field, mpls.num_labels_mask. :-)
> 
> > We cannot find that out from the PUSH & POP MPLS actions as the incoming packet might be already a MPLS packet
> >
> > We could add a count variable for pop_mpls actions for a flow and check that against MPLS_LABEL_DEPTH to make sure we don't configure more than "MPLS_LABEL_DEPTH" pop actions.
> > But as I mentioned above ,that would be redundant as we are anyways doing a check for this in datapath.
> 
> So by looking at flow key mpls struct and current depth of the MPLS
> label stack, we can perform MPLS stack depth validation checks in pop
> and push action at flow install time, rather than fast path. This
> would allow us to validate MPLS labels stack upto MPLS_LABEL_DEPTH. I
> think that is good enough for now.
> 

Ok. will do that
> > > > > >                         break;
> > > > > > +               }
> > > > > >
> > > > > >                 case OVS_ACTION_ATTR_SET:
> > > > > >                         err = validate_set(a, key, sfa,
> > > > >
> > > > > I would also like to see patch that adds multi label MPLS unit test in
> > > > > system-traffic.at along with this patch.
