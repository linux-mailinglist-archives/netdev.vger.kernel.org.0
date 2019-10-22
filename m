Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC06E0448
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389193AbfJVMzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:55:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39061 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388182AbfJVMzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 08:55:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so9903794pgn.6
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 05:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZQJv1CEz1FKlo9XHC9ZfvO5ZQ+/BW9njwPlm7yq2Y6M=;
        b=MxK2TOc5qrTVzP9QHxwlfMsKMU1W80N6Xco1P7nOGFAZTn1f2L/otW/aElZHsPkoIE
         0DIZaSguUlHXfs9Z5I4UpVHtT+AuPfVO61CcCZK/DTsNGUOVJ5jbv8F1ytCr1HAJOTTl
         H3/eDDyoZdT+LTLh1EO+9nNCww8RXlgzvVW7u/ibFTFxYbNJPNPdpn86FP1rG7fW/Y9L
         4kY6gJ5VBYJLaCHAfyCCSrDUKdfEJ54IIuDD6Rg99qSiETq7urWUDK4E9g9BKXCoG+iz
         SQBfHYy0F6amvb6kyceQ0gVBGCv/2dZSd9uDtToH9liHy5EBocIdUPp2ka5suaVL7DFx
         yYTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZQJv1CEz1FKlo9XHC9ZfvO5ZQ+/BW9njwPlm7yq2Y6M=;
        b=VEX1etTzYaza37BxlNAMmaNjxqYWt3SZK39QlFpRRTze/wg3tHvjVTZvfElbgv7SxI
         EVks4pqwe3XsAIwSGQCaIfMA1enGRzfxhO7kBckPhjQptIWq5xt5mATycfWabo8ABpMn
         jN5HBh0t9ezUkBz80/kfzbPBSAsDkRVvsWjIyaYNa3RJu5u7sKsogZTl0mkI825ndSBe
         Uw0d2AR7gFQUGMwyjwnpeSffma/gUUmrzeYE5C0CLYhIM/W0JaLIkak2+d+yusCzCbFF
         LfOkVRgqCobIhaeXXcwYN/dVItTXj41q/sm4inf2mIkzr90PrFMAAH7DUTSBAKS4smvM
         RzTQ==
X-Gm-Message-State: APjAAAWEJDBdNXMwJKe9Vv19tYZdaW/GcZzzAr6DUg4xzbmUwSl1CAlK
        exR6iqwHk2xMDfwBlNAlUVY=
X-Google-Smtp-Source: APXvYqy5YdDppFXnd+Q+unum/D+7Xb1ebDj1+Bt60UbUH0iKoxzhmtPQdALOr8mvIrqLbzImvt3wCw==
X-Received: by 2002:a62:7a8a:: with SMTP id v132mr1322681pfc.228.1571748952579;
        Tue, 22 Oct 2019 05:55:52 -0700 (PDT)
Received: from martin-VirtualBox ([223.226.47.180])
        by smtp.gmail.com with ESMTPSA id t141sm22953731pfc.65.2019.10.22.05.55.51
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 05:55:52 -0700 (PDT)
Date:   Tue, 22 Oct 2019 18:21:30 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH v2] Change in Openvswitch to support MPLS label depth of
 3 in ingress direction
Message-ID: <20191022125130.GA22846@martin-VirtualBox>
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

can we embed the mpls_label_count in struct sw_flow_actions? 

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

Disallow subsequent L2.5+ set and mpls_pop actions
once the last MPLS label in the packet is popped
as there is no check here to ensure that the new
eth_type is valid and thus set actions could
write off the end of the packet or otherwise
corrupt it.
 
Support for these actions is planned using packet
recirculation.
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
