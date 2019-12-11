Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A33B11B36F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbfLKPmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:42:33 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:42081 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388409AbfLKPmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:42:31 -0500
Received: by mail-pj1-f68.google.com with SMTP id o11so9071368pjp.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P3O85PPAf4aOPOG1Emdp4kKhp8CGCd0/wtlttwR9NVY=;
        b=HB76zFUK8ZW5gSbHn+YAZOqCYKzXQguHz96ikmOPpZ0rdIqExfvl0385SjnzMlnyN7
         lhb30uBL/Kr2sLzFdDDBzOlXPjEadz5zWFJTcevBK2hshG5GzhJWMy7KW/giDyqsWulO
         wI67QLx9KKEi52++KAh+YWe0FDJKSa1rAq3Sqej52eZH3hxn06CX/G2FnEZ0SrKrsSKk
         3Z8pOygEw7qQrjTW0F7Or/1DHLBc+zwVUVHwmt4q2XjGElRmDrpi1Ecvj6uuRgsiE1pL
         95+gTNtqXZJcU/jpxVMzrHpIyH3vc0agZ99aiWVzk01zoxxLtBXgDyMn0iEQK+bL9dfi
         6avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P3O85PPAf4aOPOG1Emdp4kKhp8CGCd0/wtlttwR9NVY=;
        b=t7N+VzIuCRc7C+qusbMT0EASMuod/aD9ZNYPkgoWtIZkeBheivxBeivDreLQ8asNeW
         IcZgXgEksS8o7R8fIDMbWutBlNd4BqsaXiQG9suPb/o7Qd1g0b+Md54BGq72d623rFap
         Byv4EFDqAfWIqUl7cxVqU0rPrDwqpHNr6O2RynzBZoKYlFDdUNLV2SJCZjOUfLVgvXFo
         m2xcsTtgDC7vd0CWWYAPGxfnq+FKcZBSaQJWHWNW+gWa2cD6oaok20JUdfq7J/fJQ+DG
         6fQIR0HhNb2oXXUQq98T/USodR/V7CwxFEqk9HyOGiI68213dYUooBlOm6kpHOmZUWpQ
         Sr8w==
X-Gm-Message-State: APjAAAWn+qPn00SAlopI75S7+d2+nEFlFI30SyA4h6wCBwUvqTYmXBYU
        2csm+HLF7ym2Lr/9Ha0PYuI=
X-Google-Smtp-Source: APXvYqzU52+0L/8u80LgIeeoN99UP5r1pafh1rMuVSGFSuo98Uf2R0oeI1HoN0xLwhDwgHcxJt7XVA==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr3894725pls.126.1576078950943;
        Wed, 11 Dec 2019 07:42:30 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id d38sm3040683pgd.59.2019.12.11.07.42.29
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2019 07:42:30 -0800 (PST)
Date:   Wed, 11 Dec 2019 21:12:24 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191211154224.GB5156@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BKv3EvdoNc6HxN6a5cMAhmrSOa57MeaF1kCWss_NTZHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_BKv3EvdoNc6HxN6a5cMAhmrSOa57MeaF1kCWss_NTZHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:15:57PM -0800, Pravin Shelar wrote:
> On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > between ethernet header and the IP header. Though this behaviour is fine
> > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > the MPLS header should encapsulate the ethernet packet.
> >
> > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > MPLS header from start of the packet respectively.
> >
> > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > @ethertype - Ethertype of MPLS header.
> >
> > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > @ethertype - Ethertype of next header following the popped MPLS header.
> >              Value 0 in ethertype indicates the tunnelled packet is
> >              ethernet.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> >  include/uapi/linux/openvswitch.h |  2 ++
> >  net/openvswitch/actions.c        | 40 ++++++++++++++++++++++++++++++++++++++++
> >  net/openvswitch/flow_netlink.c   | 21 +++++++++++++++++++++
> >  3 files changed, 63 insertions(+)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44c..af05062 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -927,6 +927,8 @@ enum ovs_action_attr {
> >         OVS_ACTION_ATTR_METER,        /* u32 meter ID. */
> >         OVS_ACTION_ATTR_CLONE,        /* Nested OVS_CLONE_ATTR_*.  */
> >         OVS_ACTION_ATTR_CHECK_PKT_LEN, /* Nested OVS_CHECK_PKT_LEN_ATTR_*. */
> > +       OVS_ACTION_ATTR_PTAP_PUSH_MPLS,    /* struct ovs_action_push_mpls. */
> > +       OVS_ACTION_ATTR_PTAP_POP_MPLS,     /* __be16 ethertype. */
> >
> >         __OVS_ACTION_ATTR_MAX,        /* Nothing past this will be accepted
> >                                        * from userspace. */
> What about MPLS set action? does existing action works with PTAP MPLS?
>
It should work as skb->network header is used to locate MPLS header
but skb_mpls_push is not calling skb_reset_mac_len to set mac len to 0
We need to add that. 
> 
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index 4c83954..d43c37e 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -160,6 +160,38 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
> >                               struct sw_flow_key *key,
> >                               const struct nlattr *attr, int len);
> >
> > +static int push_ptap_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > +                         const struct ovs_action_push_mpls *mpls)
> > +{
> > +       int err;
> > +
> > +       err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
> > +                           0, false);
> > +       if (err)
> > +               return err;
> > +
> > +       key->mac_proto = MAC_PROTO_NONE;
> > +       invalidate_flow_key(key);
> > +       return 0;
> > +}
> > +
> Can you factor out code from existing MPLS action to avoid code duplication.
> 
yes

> > +static int ptap_pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > +                        const __be16 ethertype)
> > +{
> > +       int err;
> > +
> > +       err = skb_mpls_pop(skb, ethertype, skb->mac_len,
> > +                          ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
> > +       if (err)
> > +               return err;
> > +
> Why is mac_len passed here? given MPLS is topmost header I do not see
> any need to move headers during pop operation.
skb->mac_len will be 0 here.
