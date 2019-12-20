Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E11279B3
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLTK7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:59:24 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37698 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfLTK7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:59:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id c23so3947672plz.4
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vgnQKYF899nQMAzN8HcPCMyDchQmFdO0b2CUdzgJd8E=;
        b=g3ZjaOpxKKq2ZjqHmJNEH0+GEQ9Ph5t+4NP/KotAwHCLuD+RrBUs8PUed2x/wVV0Zc
         DbSPObvvLs9bEFNVQ87WViHk7PKb6V4GbuEEHQzE9sy9/njKXCSHCCW3oRtA+dTFoRZ7
         LV+ZZ+/fJUecUd99iLy1iwM03B4l/p2yye6K9Hkf/r6X9qCGW4x4jpjY1fV1F++wPxDN
         oAxKdJ8rtFiFFOtMb2qSncn9otGfpnT5OZNFw8jxokFH55bB218X2yLwHCWcF7ZVSniD
         2fTaoMBf3Tzgtsd4jOIFkMXbjEeVng8mAb1KMmPDBZmz+Z0EVBggdyp0jczhYcLy9fNV
         n3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vgnQKYF899nQMAzN8HcPCMyDchQmFdO0b2CUdzgJd8E=;
        b=KmPg1dMkKWaWY6jcRcrkPTcbYJt2kUPnRlc/FI0GBR+zNyZsydoDdM94U4jIQRBuey
         r2B11Xsa6S5SyX7iDBJdl4OJw66TTh1ZBxvqSdLjWgtAwEAsDYbvTybcXo+9z5Ek7YYj
         ntBPIEeSqn1pnYafBIxnX9rZxBpyU5rPT0uF/hwIue/KQ8g3zWk2f+uE+hiwSlBxT03v
         EIEXvxAxI4tc7gb1YxW1VbVkXjBA+uoaEZ69gTBPoI+tFqRjshMmQ8w0YiLF7mGaW0vx
         5IGv0UkfZhWmPfqrzvA2HTFc+x/xaGjFN3lo1OYRnykNAAudDGLzw74EjmJ83egoIdeP
         QPHw==
X-Gm-Message-State: APjAAAWPbf/3GnVlsqf8UhfEVQEPxrJ5r8j6DVjUsYD6p8aw0zjR2lGd
        Li3AQZTYRJ91kNiD0L0zAnp2aC8v
X-Google-Smtp-Source: APXvYqz6U7bMm9INrsZC6fPvdg8ci/NFLVls7/rMukYHhftkIxeD3YI6PJ7g2OCg5iFXjolIvpZiwA==
X-Received: by 2002:a17:90a:778a:: with SMTP id v10mr14555284pjk.26.1576839563457;
        Fri, 20 Dec 2019 02:59:23 -0800 (PST)
Received: from martin-VirtualBox ([42.109.147.22])
        by smtp.gmail.com with ESMTPSA id g17sm13405881pfb.180.2019.12.20.02.59.21
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 02:59:22 -0800 (PST)
Date:   Fri, 20 Dec 2019 16:29:03 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next v4 3/3] openvswitch: New MPLS actions for layer
 2 tunnelling
Message-ID: <20191220105903.GA8821@martin-VirtualBox>
References: <cover.1576648350.git.martin.varghese@nokia.com>
 <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
 <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 07:50:52PM -0800, Pravin Shelar wrote:
> On Tue, Dec 17, 2019 at 10:56 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The existing PUSH MPLS action inserts MPLS header between ethernet header
> > and the IP header. Though this behaviour is fine for L3 VPN where an IP
> > packet is encapsulated inside a MPLS tunnel, it does not suffice the L2
> > VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
> > encapsulate the ethernet packet.
> >
> > The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start of the
> > packet or at the start of the l3 header depending on the value of l2 tunnel
> > flag in the PTAP_PUSH_MPLS arguments.
> >
> > POP_MPLS action is extended to support ethertype 0x6558.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> > Changes in v2:
> >    - PTAP_POP_MPLS action removed.
> >    - Special handling for ethertype 0 added in PUSH_MPLS.
> >    - Refactored push_mpls function to cater existing push_mpls and
> >      ptap_push_mpls actions.
> >    - mac len to specify the MPLS header location added in PTAP_PUSH_MPLS
> >      arguments.
> >
> > Changes in v3:
> >    - Special handling for ethertype 0 removed.
> >    - Added support for ether type 0x6558.
> >    - Removed mac len from PTAP_PUSH_MPLS argument list
> >    - used l2_tun flag to distinguish l2 and l3 tunnelling.
> >    - Extended PTAP_PUSH_MPLS handling to cater PUSH_MPLS action also.
> >
> > Changes in v4:
> >    - Removed extra blank lines.
> >    - Replaced bool l2_tun with u16 tun flags in
> >      struct ovs_action_ptap_push_mpls.
> >
> The patch looks almost ready. I have couple of comments.
> 
> >  include/uapi/linux/openvswitch.h | 31 +++++++++++++++++++++++++++++++
> >  net/openvswitch/actions.c        | 30 ++++++++++++++++++++++++------
> >  net/openvswitch/flow_netlink.c   | 34 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 89 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44c..d9461ce 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
> >  };
> >
> ...
> ...
> > diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> > index 65c2e34..85fe7df 100644
> > --- a/net/openvswitch/flow_netlink.c
> > +++ b/net/openvswitch/flow_netlink.c
> > @@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct nlattr *actions)
> >                 case OVS_ACTION_ATTR_SET_MASKED:
> >                 case OVS_ACTION_ATTR_METER:
> >                 case OVS_ACTION_ATTR_CHECK_PKT_LEN:
> > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
> >                 default:
> >                         return true;
> >                 }
> > @@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                         [OVS_ACTION_ATTR_METER] = sizeof(u32),
> >                         [OVS_ACTION_ATTR_CLONE] = (u32)-1,
> >                         [OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
> > +                       [OVS_ACTION_ATTR_PTAP_PUSH_MPLS] = sizeof(struct ovs_action_ptap_push_mpls),
> >                 };
> >                 const struct ovs_action_push_vlan *vlan;
> >                 int type = nla_type(a);
> > @@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
> >                 case OVS_ACTION_ATTR_RECIRC:
> >                         break;
> >
> > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
> Can you change name of this action given this can handle both L2 and
> L3 MPLS tunneling?
>
ADD_MPLS ?
PUSH_INSERT_MPLS ?
anything else?

I prefer ADD_MPLS  
> > +                       const struct ovs_action_ptap_push_mpls *mpls = nla_data(a);
> > +
> > +                       if (!eth_p_mpls(mpls->mpls_ethertype))
> > +                               return -EINVAL;
> > +
> > +                       if (!(mpls->tun_flags & OVS_MPLS_L2_TUNNEL_FLAG_MASK)) {
> > +                               if (vlan_tci & htons(VLAN_CFI_MASK) ||
> > +                                   (eth_type != htons(ETH_P_IP) &&
> > +                                    eth_type != htons(ETH_P_IPV6) &&
> > +                                    eth_type != htons(ETH_P_ARP) &&
> > +                                    eth_type != htons(ETH_P_RARP) &&
> > +                                    !eth_p_mpls(eth_type)))
> > +                                       return -EINVAL;
> > +                               mpls_label_count++;
> > +                       } else {
> > +                               if (mac_proto != MAC_PROTO_NONE) {
> It is better to check for 'MAC_PROTO_ETHERNET', rather than this negative test.
> 
> > +                                       mpls_label_count = 1;
> > +                                       mac_proto = MAC_PROTO_NONE;
> > +                               } else {
> > +                                       mpls_label_count++;
> > +                               }
> We need to either disallow combination of L3 and L2 MPLS_PUSH, POP
> actions in a action list or keep separate label count. Otherwise it is
> impossible to validate mpls labels stack depth in POP actions.
> 
> > +                       }
> > +                       eth_type = mpls->mpls_ethertype;
> > +                       break;
> > +               }
> > +
> >                 case OVS_ACTION_ATTR_PUSH_MPLS: {
> >                         const struct ovs_action_push_mpls *mpls = nla_data(a);
> >
