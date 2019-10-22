Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A196CE0762
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfJVP3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:29:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36534 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbfJVP3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:29:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so10879255pfr.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 08:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nGvY2xZBxotQRJ7nSdXjhM0X54veEDhy7QMpdOv3qWk=;
        b=jlxWEeEgbslL2YfzYroZKhm3/w7r4yu3HCglq4VxpS3PX1pWj1vkMZkwz7oIfDxC4h
         NpbIA0qEf51jiQT/ayF8KIdcccFSU/C/fg146cTfYnG0u10lqRXaLIIHMI90SO/Poukm
         pqcXL0SnNSsW2DYTLi7yl3P6JbyX/+NHo+2HW8jg+4CKun5WjmIyScAQT51T8ih30lGT
         e0RDY1CFWkifds0JoHOSdaNOD0oC0NzGixwkE2SwHHFRO6oFlpRHjqwzAEJ5TKhOoUEY
         f4R0TlMDeIgGhfkXX0VkuBRls1W5+J9Oa7oQHT4J8dKOvCteNOQhUMJTOKNbcWQMdJZq
         lNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nGvY2xZBxotQRJ7nSdXjhM0X54veEDhy7QMpdOv3qWk=;
        b=tv+3gZIpu5i7pEaDA5Ti/s9dME9+haE0Ny4NVwYS+DEmm0f07PC6VX5Qb9lT/FrF0T
         YTVA96e+sHuuLdbL6Noy1bzCwuTKy+HxNOGvZvWrodM7Ji+RvWpig++1HvXqbs8tly0z
         WirWA9BKZQGiQYT6Lmm0JffOQoZXkbgqxf9AEBXrRdsUx+sOanEXC4EFrChfEJQB2Vui
         qqPRvuhrm6qaJPWMSRP4E//zsJcT32SbLAWkDWPnwseWYEzXrC7VkQpn62nr2K21GjFn
         uj9IjCejs2lxqThs4twZ9qMXp/L5U4PRHQIi0c27m+a2GthBBiU9MSEYze4briIhEZ6Q
         zgqQ==
X-Gm-Message-State: APjAAAVlkalgl0WgZEq9ZE4bAa/Y0ieU3hKEnUhmHL+4CX/BIFqoEHcp
        0ZIyeY2jmq1TN3bR11r5p8o=
X-Google-Smtp-Source: APXvYqxn1keM1GNlzGuGnAo9+Pfa2abnfPVl164eAg/Ol9r8OAlnyp4/nzVNvXnVwBEJU9Fp8vLRug==
X-Received: by 2002:a63:67c3:: with SMTP id b186mr4484486pgc.152.1571758190292;
        Tue, 22 Oct 2019 08:29:50 -0700 (PDT)
Received: from martin-VirtualBox ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id 6sm4478136pfy.43.2019.10.22.08.29.48
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 08:29:49 -0700 (PDT)
Date:   Tue, 22 Oct 2019 20:59:40 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH v2] Change in Openvswitch to support MPLS label depth of
 3 in ingress direction
Message-ID: <20191022152940.GB23540@martin-VirtualBox>
References: <1571580702-18476-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_B=1RR+qqx938=O32iTH1yQ+S_gLAXS-aA1PLYYtgu6VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_B=1RR+qqx938=O32iTH1yQ+S_gLAXS-aA1PLYYtgu6VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 12:03:49AM -0700, Pravin Shelar wrote:
> On Sun, Oct 20, 2019 at 7:12 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > direction though the userspace OVS supports a max depth of 3 labels.
> > This change enables openvswitch module to support a max depth of
> > 3 labels in the ingress.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> > Changes in v2
> >    - Moved MPLS count validation from datapath to configuration.
> >    - Fixed set mpls function.
> >
> This patch looks pretty close now.
> 
> >  net/openvswitch/actions.c      |  2 +-
> >  net/openvswitch/flow.c         | 20 ++++++++++-----
> >  net/openvswitch/flow.h         |  9 ++++---
> >  net/openvswitch/flow_netlink.c | 57 +++++++++++++++++++++++++++++++++---------
> >  4 files changed, 66 insertions(+), 22 deletions(-)
> >
> ...
> > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > index d7559c6..21de061 100644
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
> > @@ -1628,10 +1628,25 @@ static int ovs_key_from_nlattrs(struct net *net, struct sw_flow_match *match,
> >
> >         if (attrs & (1 << OVS_KEY_ATTR_MPLS)) {
> >                 const struct ovs_key_mpls *mpls_key;
> > +               u32 hdr_len;
> > +               u32 label_count, label_count_mask, i;
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
> > @@ -2114,13 +2129,18 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
> >                 ether_addr_copy(arp_key->arp_sha, output->ipv4.arp.sha);
> >                 ether_addr_copy(arp_key->arp_tha, output->ipv4.arp.tha);
> >         } else if (eth_p_mpls(swkey->eth.type)) {
> > +               u8 i, num_labels;
> >                 struct ovs_key_mpls *mpls_key;
> >
> > -               nla = nla_reserve(skb, OVS_KEY_ATTR_MPLS, sizeof(*mpls_key));
> > +               num_labels = hweight_long(output->mpls.num_labels_mask);
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
> > @@ -2957,6 +2977,10 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >         u8 mac_proto = ovs_key_mac_proto(key);
> >         const struct nlattr *a;
> >         int rem, err;
> > +       u32 mpls_label_count = 0;
> > +
> > +       if (eth_p_mpls(eth_type))
> > +               mpls_label_count = hweight_long(key->mpls.num_labels_mask);
> >
> The MPLS push and pop action could be part of nested actions in
> sample, so the count needs to be global count across such nested
> actions. have a look at validate_and_copy_sample().
>
Embedding mpls_label_count in struct sw_flow_actions will not work for clone

I guess we need to move the below code to ovs_nla_copy_actions and extend the  arguments of __ovs_nla_copy_actions to take mpls_label_count also
if (eth_p_mpls(eth_type))
                mpls_label_count = hweight_long(key->mpls.num_labels_mask)

 
> >         nla_for_each_nested(a, attr, rem) {
> >                 /* Expected argument lengths, (u32)-1 for variable length. */
> > @@ -3065,25 +3089,34 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                              !eth_p_mpls(eth_type)))
> >                                 return -EINVAL;
> >                         eth_type = mpls->mpls_ethertype;
> > +                       mpls_label_count++;
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
> This comment needs updated.
> 
> 
> > -                       eth_type = htons(0);
> > +                       proto = nla_get_be16(a);
> > +                       mpls_label_count--;
> > +
> > +                       if (!eth_p_mpls(proto) || !mpls_label_count)
> > +                               eth_type = htons(0);
> > +                       else
> > +                               eth_type =  proto;
> > +
> >                         break;
> > +               }
> >
> >                 case OVS_ACTION_ATTR_SET:
> >                         err = validate_set(a, key, sfa,
> > --
> > 1.8.3.1
> >
