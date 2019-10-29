Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB52FE8613
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbfJ2Kuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:50:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44704 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfJ2Kuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 06:50:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id q26so5644781pfn.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 03:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I4ORYFOmwIlN8XKwaubVnBmsSAvActmgBjQA4brafZY=;
        b=h4uDBHOgbh2y/Kn/FL0sEAfBBqicrrzqgaeYjTJtBDxp8B/NjrvfO2vme9v3EDS+qA
         160SnKTIxlfbDl5Hux9Zy7Yc7yJj5uqCxnNornagTYQfuaPjOGVjAQMu4eWRzdJnBkm5
         FWOzbmlVGobqaRMz6Uf9Qwa1y0urs4lNpjZb6wdIH0xywJs8QcaeyJ290rjkmiMjoClB
         Cr4A9ulKCO2ekEI50+Tg0cw2nSZK6M0a6S7TX2HQTYOs/m3regd1EerrhhunwLghja/c
         GG6hYnCt2PApBxqx1Wzi9eTemST9YmSV0Qtr/B64quD9r9x913KpPaZA4Y0Va3IY2tfW
         whMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I4ORYFOmwIlN8XKwaubVnBmsSAvActmgBjQA4brafZY=;
        b=LJpiqRKTwDHIFaN0+Bruswjs7NWr8WglG6OFMvHFB8dUWZRUHosLf0lSvztNrYAQZR
         AZIYcjP/vbGH9pNj309NGH3NwOrFbouaZHOuCEBkkHhm88STxESw0oNX/wzMjRsWWLdU
         OZAkfIKMPzjl8ThXqQL6hZXoXshAs4yoD1v6/IaYGfERTFPUOirH6PyvfhDIKk74v5rs
         tUAK8AU+QgtUTQlKvq30V2V2mKna+c2Qawefamvf+mVJIxxWYcmUYFOboxwKUZ0OMnDM
         Sr53st3NToYT7JBcIUtl41MIauil29JvO0+D47wK8wduvi2IxBkYz7kul9VdE66vWXLm
         mbNA==
X-Gm-Message-State: APjAAAVPNguNa2nNxHStHU+VGM9IscBNRujxiJVFZXHM8uqic7G8CsXZ
        Ex8sPFPEvEOqDqS3QDrlV+Q=
X-Google-Smtp-Source: APXvYqz+sqTl0f8Q9K9spPKCjNpXkyyBCW7GvBqplmz1RXJnovx0fZbXMhR9nGnOJN7Hnwt5n+l8jQ==
X-Received: by 2002:a62:2686:: with SMTP id m128mr13052639pfm.143.1572346251015;
        Tue, 29 Oct 2019 03:50:51 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.251.227])
        by smtp.gmail.com with ESMTPSA id d5sm17874343pfa.180.2019.10.29.03.50.49
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 29 Oct 2019 03:50:50 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:20:37 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH v3 net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
Message-ID: <20191029105037.GA9566@martin-VirtualBox>
References: <1572242037-7041-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A2S-27P3xWFOKTCZ5rrjeubzAcbr+sChYQOES0ucC_iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_A2S-27P3xWFOKTCZ5rrjeubzAcbr+sChYQOES0ucC_iw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 12:37:45AM -0700, Pravin Shelar wrote:
> On Sun, Oct 27, 2019 at 10:54 PM Martin Varghese
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
> > Changes in v2:
> >     - Moved MPLS count validation from datapath to configuration.
> >     - Fixed set mpls function.
> >
> > Changes in v3:
> >     - Updated the comments section of POP_MPLS action configuration.
> >     - Moved mpls_label_count variable initialization to ovs_nla_copy_actions.
> >       The current value of the mpls_label_count variable in the function
> >       __ovs_nla_copy_actions  will be passed to the functions processing
> >       nested actions (Eg- validate_and_copy_clone) for validations of the
> >       nested actions on the cloned packet.
> >
> >  net/openvswitch/actions.c      |  2 +-
> >  net/openvswitch/flow.c         | 20 +++++++---
> >  net/openvswitch/flow.h         |  9 +++--
> >  net/openvswitch/flow_netlink.c | 87 +++++++++++++++++++++++++++++++-----------
> >  4 files changed, 85 insertions(+), 33 deletions(-)
> >
> ...
> > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > index d7559c6..65c2e34 100644
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
> ovs_key_attr_size() also needs update for MPLS labels.
> 
Do we need to ?
In the existing ovs_key_attr_size function i dont see MPLS header size taken into
account.I assume it is not needed as MPLS being a L3 protocol,either MPLS or IP/IPv6 
can be present.In the key size calculation we are including the 40 bytes of ipv6
which can accomodate 12 bytes of MPLS header.

Did i get your comment wrong?

> Otherwise looks good to me.
> 
> 
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
> > @@ -2406,13 +2426,14 @@ static inline void add_nested_action_end(struct sw_flow_actions *sfa,
> >  static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                                   const struct sw_flow_key *key,
> >                                   struct sw_flow_actions **sfa,
> > -                                 __be16 eth_type, __be16 vlan_tci, bool log);
> > +                                 __be16 eth_type, __be16 vlan_tci,
> > +                                 u32 mpls_label_count, bool log);
> >
> >  static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
> >                                     const struct sw_flow_key *key,
> >                                     struct sw_flow_actions **sfa,
> >                                     __be16 eth_type, __be16 vlan_tci,
> > -                                   bool log, bool last)
> > +                                   u32 mpls_label_count, bool log, bool last)
> >  {
> >         const struct nlattr *attrs[OVS_SAMPLE_ATTR_MAX + 1];
> >         const struct nlattr *probability, *actions;
> > @@ -2463,7 +2484,7 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
> >                 return err;
> >
> >         err = __ovs_nla_copy_actions(net, actions, key, sfa,
> > -                                    eth_type, vlan_tci, log);
> > +                                    eth_type, vlan_tci, mpls_label_count, log);
> >
> >         if (err)
> >                 return err;
> > @@ -2478,7 +2499,7 @@ static int validate_and_copy_clone(struct net *net,
> >                                    const struct sw_flow_key *key,
> >                                    struct sw_flow_actions **sfa,
> >                                    __be16 eth_type, __be16 vlan_tci,
> > -                                  bool log, bool last)
> > +                                  u32 mpls_label_count, bool log, bool last)
> >  {
> >         int start, err;
> >         u32 exec;
> > @@ -2498,7 +2519,7 @@ static int validate_and_copy_clone(struct net *net,
> >                 return err;
> >
> >         err = __ovs_nla_copy_actions(net, attr, key, sfa,
> > -                                    eth_type, vlan_tci, log);
> > +                                    eth_type, vlan_tci, mpls_label_count, log);
> >         if (err)
> >                 return err;
> >
> > @@ -2864,6 +2885,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
> >                                            const struct sw_flow_key *key,
> >                                            struct sw_flow_actions **sfa,
> >                                            __be16 eth_type, __be16 vlan_tci,
> > +                                          u32 mpls_label_count,
> >                                            bool log, bool last)
> >  {
> >         const struct nlattr *acts_if_greater, *acts_if_lesser_eq;
> > @@ -2912,7 +2934,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
> >                 return nested_acts_start;
> >
> >         err = __ovs_nla_copy_actions(net, acts_if_lesser_eq, key, sfa,
> > -                                    eth_type, vlan_tci, log);
> > +                                    eth_type, vlan_tci, mpls_label_count, log);
> >
> >         if (err)
> >                 return err;
> > @@ -2925,7 +2947,7 @@ static int validate_and_copy_check_pkt_len(struct net *net,
> >                 return nested_acts_start;
> >
> >         err = __ovs_nla_copy_actions(net, acts_if_greater, key, sfa,
> > -                                    eth_type, vlan_tci, log);
> > +                                    eth_type, vlan_tci, mpls_label_count, log);
> >
> >         if (err)
> >                 return err;
> > @@ -2952,7 +2974,8 @@ static int copy_action(const struct nlattr *from,
> >  static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                                   const struct sw_flow_key *key,
> >                                   struct sw_flow_actions **sfa,
> > -                                 __be16 eth_type, __be16 vlan_tci, bool log)
> > +                                 __be16 eth_type, __be16 vlan_tci,
> > +                                 u32 mpls_label_count, bool log)
> >  {
> >         u8 mac_proto = ovs_key_mac_proto(key);
> >         const struct nlattr *a;
> > @@ -3065,25 +3088,36 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
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
> > +                       /* Disallow subsequent L2.5+ set actions and mpls_pop
> > +                        * actions once the last MPLS label in the packet is
> > +                        * is popped as there is no check here to ensure that
> > +                        * the new eth type is valid and thus set actions could
> > +                        * write off the end of the packet or otherwise corrupt
> > +                        * it.
> >                          *
> >                          * Support for these actions is planned using packet
> >                          * recirculation.
> >                          */
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
> > @@ -3106,6 +3140,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >
> >                         err = validate_and_copy_sample(net, a, key, sfa,
> >                                                        eth_type, vlan_tci,
> > +                                                      mpls_label_count,
> >                                                        log, last);
> >                         if (err)
> >                                 return err;
> > @@ -3176,6 +3211,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >
> >                         err = validate_and_copy_clone(net, a, key, sfa,
> >                                                       eth_type, vlan_tci,
> > +                                                     mpls_label_count,
> >                                                       log, last);
> >                         if (err)
> >                                 return err;
> > @@ -3188,8 +3224,9 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >
> >                         err = validate_and_copy_check_pkt_len(net, a, key, sfa,
> >                                                               eth_type,
> > -                                                             vlan_tci, log,
> > -                                                             last);
> > +                                                             vlan_tci,
> > +                                                             mpls_label_count,
> > +                                                             log, last);
> >                         if (err)
> >                                 return err;
> >                         skip_copy = true;
> > @@ -3219,14 +3256,18 @@ int ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                          struct sw_flow_actions **sfa, bool log)
> >  {
> >         int err;
> > +       u32 mpls_label_count = 0;
> >
> >         *sfa = nla_alloc_flow_actions(min(nla_len(attr), MAX_ACTIONS_BUFSIZE));
> >         if (IS_ERR(*sfa))
> >                 return PTR_ERR(*sfa);
> >
> > +       if (eth_p_mpls(key->eth.type))
> > +               mpls_label_count = hweight_long(key->mpls.num_labels_mask);
> > +
> >         (*sfa)->orig_len = nla_len(attr);
> >         err = __ovs_nla_copy_actions(net, attr, key, sfa, key->eth.type,
> > -                                    key->eth.vlan.tci, log);
> > +                                    key->eth.vlan.tci, mpls_label_count, log);
> >         if (err)
> >                 ovs_nla_free_flow_actions(*sfa);
> >
> > --
> > 1.8.3.1
> >
