Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A60D37E7
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfJKDeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:34:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42463 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfJKDeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:34:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so5204616pff.9
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5Zl953Bky3v9zI8rB5m1x2ekZg793nQIL/SyBzSPVFE=;
        b=RbsnpHKZAT8uHSnyLwgZG3o4HknlPpPA5X8tIolHFt2iJT+ZA8zovMusuFvrX8JyBy
         bfFrwJedoMe9Jn9UqwhUyTVv2Du92l6OpXwpcdyXNO/yAAEFDE52auwmG3T7htv9Ojam
         qydx4Ua5rWrwiZDbI9UiAs81hJQGDOBq620xxjYb1x8joXE6EPYCOhX0mhY5e1cHwEWu
         SP1K8dVS4XC0MAfThXqtmA/Gt827VACT7KHHMzzQ8y9MsxarT7Nfv+SoKOW2GNgqDCP2
         iVW+ArpCZpdN0P3ig5dHsizL+fdbNpJQhvr6o7sbCDN0E1cZQw6G/xb3nJFy536WrXj1
         F2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5Zl953Bky3v9zI8rB5m1x2ekZg793nQIL/SyBzSPVFE=;
        b=ZmtWeSvX30zr5oCR8eJV++kooQiRNmoaGcG1IkdKF7ikbwIJORAspEEilEh+s/PLtm
         kDbrwaLF0iqQldITQUaXam88RRbqVqX8/stfqIMjy6p3s9Pe19YiNeXdTqPKkv2UsAHW
         /MZmis6+PuKQ3SavRa1ElAyPVWZxQ4fH1zSHL5S44TBeLube/Uj6WmygJhI7CXBO/TWv
         jYnDx5eiYLnUMPeL7gjFgBnTGvBfl1RudbhZcZHWaygcClXv+7r0EMaNK1779D05U9kS
         i7YVSCff3Sj48/b7r7PVOmRK1OVN2u1jd/r6bKFhiizQ6Nqe6hGeW3uVWn9clsPdqcY2
         MKYg==
X-Gm-Message-State: APjAAAVbagtgRjoB6+bjwjcDe5Cd8+AKrXp9QqinKbj6ZF+WXb3bBHOX
        ag3tGo8lhwD9tshv/zRJfWo=
X-Google-Smtp-Source: APXvYqxJEsp1LvelF8t+74gahz50cqaeKWQKKeDJfa/J9L6dGheK62YKpJhDBwTBJBy+xEegOeq/LA==
X-Received: by 2002:a17:90a:3428:: with SMTP id o37mr15311484pjb.17.1570764869818;
        Thu, 10 Oct 2019 20:34:29 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id m5sm7335967pgt.15.2019.10.10.20.34.28
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 10 Oct 2019 20:34:29 -0700 (PDT)
Date:   Fri, 11 Oct 2019 09:03:57 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
Message-ID: <20191011033357.GA22105@martin-VirtualBox>
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 08:29:51AM -0700, Pravin Shelar wrote:
> On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > direction though the userspace OVS supports a max depth of 3 labels.
> > This change enables openvswitch module to support a max depth of
> > 3 labels in the ingress.
> >
> > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > ---
> >  net/openvswitch/actions.c      | 10 +++++++-
> >  net/openvswitch/flow.c         | 20 ++++++++++-----
> >  net/openvswitch/flow.h         |  9 ++++---
> >  net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
> >  4 files changed, 72 insertions(+), 22 deletions(-)
> >
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index 3572e11..eb5bed5 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> >  {
> >         int err;
> >
> > +       if (!key->mpls.num_labels_mask)
> > +               return -EINVAL;
> > +
> >         err = skb_mpls_pop(skb, ethertype);
> >         if (err)
> >                 return err;
> >
> > +       key->mpls.num_labels_mask >>= 1;
> >         invalidate_flow_key(key);
> Since this key is immediately invalidated, what is point of updating
> the label count?
> 
> >         return 0;
> >  }
> What about checks in OVS_ACTION_ATTR_PUSH_MPLS?
> 
> > @@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> >         struct mpls_shim_hdr *stack;
> >         __be32 lse;
> >         int err;
> > +       u32 i = 0;
> >
> >         stack = mpls_hdr(skb);
> >         lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
> > @@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> >         if (err)
> >                 return err;
> >
> > -       flow_key->mpls.top_lse = lse;
> > +       for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
> > +               flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
> > +
> > +       flow_key->mpls.lse[i] = *mpls_lse;
> This is changing semantic of mpls-set action. It is looking like
> mpls-push. Lets keep the MPLS set that sets one or more MPLS lebels.
> 
> >         return 0;
> >  }
> >
> > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > index dca3b1e..c101355 100644
> > --- a/net/openvswitch/flow.c
> > +++ b/net/openvswitch/flow.c
> > @@ -699,27 +699,35 @@ static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
> >                         memset(&key->ipv4, 0, sizeof(key->ipv4));
> >                 }
> >         } else if (eth_p_mpls(key->eth.type)) {
> > -               size_t stack_len = MPLS_HLEN;
> > +               u8 label_count = 1;
> >
> > +               memset(&key->mpls, 0, sizeof(key->mpls));
> >                 skb_set_inner_network_header(skb, skb->mac_len);
> >                 while (1) {
> >                         __be32 lse;
> >
> > -                       error = check_header(skb, skb->mac_len + stack_len);
> > +                       error = check_header(skb, skb->mac_len +
> > +                                            label_count * MPLS_HLEN);
> I do not think this is right. This way OVS can copy into MPLS labels
> from next header beyond MPLS. You need parse MPLS header and determine
> end of MPLS labels.
> 
> >                         if (unlikely(error))
> >                                 return 0;
> >
> >                         memcpy(&lse, skb_inner_network_header(skb), MPLS_HLEN);
> >
> > -                       if (stack_len == MPLS_HLEN)
> > -                               memcpy(&key->mpls.top_lse, &lse, MPLS_HLEN);
> > +                       if (label_count <= MPLS_LABEL_DEPTH)
> > +                               memcpy(&key->mpls.lse[label_count - 1], &lse,
> > +                                      MPLS_HLEN);
> >
> > -                       skb_set_inner_network_header(skb, skb->mac_len + stack_len);
> > +                       skb_set_inner_network_header(skb, skb->mac_len +
> > +                                                    label_count * MPLS_HLEN);
> >                         if (lse & htonl(MPLS_LS_S_MASK))
> >                                 break;
> >
> > -                       stack_len += MPLS_HLEN;
> > +                       label_count++;
> >                 }
> > +               if (label_count > MPLS_LABEL_DEPTH)
> > +                       label_count = MPLS_LABEL_DEPTH;
> > +
> > +               key->mpls.num_labels_mask = GENMASK(label_count - 1, 0);
> >         } else if (key->eth.type == htons(ETH_P_IPV6)) {
> >                 int nh_len;             /* IPv6 Header + Extensions */
> >
> ...
> ...
> > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > index d7559c6..4eb04e9 100644
> > --- a/net/openvswitch/flow_netlink.c
> > +++ b/net/openvswitch/flow_netlink.c
> > @@ -424,7 +424,7 @@ size_t ovs_key_attr_size(void)
> >         [OVS_KEY_ATTR_DP_HASH]   = { .len = sizeof(u32) },
> >         [OVS_KEY_ATTR_TUNNEL]    = { .len = OVS_ATTR_NESTED,
> >                                      .next = ovs_tunnel_key_lens, },
> > -       [OVS_KEY_ATTR_MPLS]      = { .len = sizeof(struct ovs_key_mpls) },
> > +       [OVS_KEY_ATTR_MPLS]      = { .len = OVS_ATTR_VARIABLE },
> >         [OVS_KEY_ATTR_CT_STATE]  = { .len = sizeof(u32) },
> >         [OVS_KEY_ATTR_CT_ZONE]   = { .len = sizeof(u16) },
> >         [OVS_KEY_ATTR_CT_MARK]   = { .len = sizeof(u32) },
> > @@ -1628,10 +1628,26 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> >
> >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> >                 const struct ovs_key_mpls *mpls_key;
> > +               u32 hdr_len = 0;
> > +               u32 label_count = 0, i = 0;
> > +               u32 label_count_mask = 0;
> No need to initialize these values.
> >
> >                 mpls_key = nla_data(a[OVS_KEY_ATTR_MPLS]);
> > -               SW_FLOW_KEY_PUT(match, mpls.top_lse,
> > -                               mpls_key->mpls_lse, is_mask);
> > +               hdr_len = nla_len(a[OVS_KEY_ATTR_MPLS]);
> > +               label_count = hdr_len / sizeof(struct ovs_key_mpls);
> > +
> > +               if (label_count == 0 || label_count > MPLS_LABEL_DEPTH ||
> > +                   hdr_len % sizeof(struct ovs_key_mpls))
> > +                       return -EINVAL;
> > +
> > +               label_count_mask =  GENMASK(label_count - 1, 0);
> > +
> > +               for (i = 0 ; i < label_count; i++)
> > +                       SW_FLOW_KEY_PUT(match, mpls.lse[i],
> > +                                       mpls_key[i].mpls_lse, is_mask);
> > +
> > +               SW_FLOW_KEY_PUT(match, mpls.num_labels_mask,
> > +                               label_count_mask, is_mask);
> >
> >                 attrs &= ~(1 << OVS_KEY_ATTR_MPLS);
> >          }
> > @@ -2114,13 +2130,22 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> >         } else if (eth_p_mpls(swkey->eth.type)) {
> > +               u8 i = 0;
> > +               u8 num_labels;
> >                 struct ovs_key_mpls *mpls_key;
> >
> > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > +               num_labels = hweight_long(output->mpls.num_labels_mask);
> > +               if (num_labels >= MPLS_LABEL_DEPTH)
> > +                       num_labels = MPLS_LABEL_DEPTH;
> I do not see need for this check. We can copy the value directly from key.
> 
> > +
> > +               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS,
> > +                                 num_labels * sizeof(*mpls_key));
> >                 if (!nla)
> >                         goto nla_put_failure;
> > +
> >                 mpls_key = nla_data(nla);
> > -               mpls_key->mpls_lse = output->mpls.top_lse;
> > +               for (i = 0; i < num_labels; i++)
> > +                       mpls_key[i].mpls_lse = output->mpls.lse[i];
> >         }
> >
> >         if ((swkey->eth.type == htons(ETH_P_IP) ||
> > @@ -3068,22 +3093,28 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                         break;
> >                 }
> >
> > -               case OVS_ACTION_ATTR_POP_MPLS:
> > +               case OVS_ACTION_ATTR_POP_MPLS: {
> > +                       __be16  proto;
> >                         if (vlan_tci & htons(VLAN_CFI_MASK) ||
> >                             !eth_p_mpls(eth_type))
> >                                 return -EINVAL;
> >
> Since this patch is adding support for multiple labels, we need to
> track depth of the MPLS label stack in MPLS push and pop actions
> validation to avoid checks in fastpath.
> 
> > -                       /* Disallow subsequent L2.5+ set and mpls_pop actions
> > -                        * as there is no check here to ensure that the new
> > -                        * eth_type is valid and thus set actions could
> > -                        * write off the end of the packet or otherwise
> > -                        * corrupt it.
> > +                       /* Disallow subsequent L2.5+ set actions as there is
> > +                        * no check here to ensure that the new eth type is
> > +                        * valid and thus set actions could write off the
> > +                        * end of the packet or otherwise corrupt it.
> >                          *
> >                          * Support for these actions is planned using packet
> >                          * recirculation.
> >                          */
> > -                       eth_type = htons(0);
> > +
> > +                       proto = nla_get_be16(a);
> > +                       if (!eth_p_mpls(proto))
> > +                               eth_type = htons(0);
> > +                       else
> > +                               eth_type =  proto;
> 
> I do not see any point of changing this validation logic. OVS can not
> parse beyond MPLS, so lets keep this as it it.
> 
> 
> >                         break;
> > +               }
> >
> >                 case OVS_ACTION_ATTR_SET:
> >                         err = validate_set(a, key, sfa,
> 
> I would also like to see patch that adds multi label MPLS unit test in
> system-traffic.at along with this patch.

the same patch to dev@openvswitch.org along with the changes in sytem-traffic.at  ?
