Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138601274BF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 05:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTEmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 23:42:49 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38679 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfLTEms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 23:42:48 -0500
Received: by mail-ot1-f68.google.com with SMTP id d7so5824713otf.5
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 20:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ppPHKVIbReBlAYvchDhXzs8zq87SnE7M6lPTPU03qTE=;
        b=hV9hwDjz5tel1ll9ed28iTO5Vgxz8j8db3fmclpKK3X7uDCvK1DBynpF3AHj5wEmpm
         5mueuh2WReAJKouhZ1vtbQP3GTmNhaRMt4dwHhS88Ui7UwBZ4cy97srgVO9DgHoRqF1M
         JYKYW4sGOScYVRynwPQGwwedxByl36Y+IcWJv8VQsq+GxJYvq2xYOUovx67DzI9hBzyp
         B+Wvm7GzpwmN1VC8TlUi67MXfGkoYE83UT4AYi5tqKTAnp/0ezo1TnKSUMnDyAVQVA5L
         2T4pr9EBzyqa6jy6aHGj11VUdOhQNyLe9nrAYWJYlay57h/lHnZjcvIzYZYWpO/X9y9c
         WhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ppPHKVIbReBlAYvchDhXzs8zq87SnE7M6lPTPU03qTE=;
        b=DLKAt2Mxadd4Lclhz2l6ihdiwg/cfYOmq2SfqssnlYEC4dNv8H+bj/K4wMY/d+yaYB
         NbrJ2Wk7SHiLZtVks2+VLA16yOvW06L3zcSECZZMNYCGz7FkJoG//I+FLiy9iWZWy/Jm
         D1o7gdUQFrtzhd/GsCnw5weewPSjfWyqg1LC2/GykiBbRsEW/XIiuCs3Ft4oYGAIxi+t
         QjcgGlT3LSUtDpZmYaJzuvB6QKUe6XF+oLHesQ/3QIi975lwiTQvQEYIZT1v3I8QobVc
         QBjX2x3Vb2gvtpLwLOQ9JfKzX9B7XDfuYIh8B0KRlBpub7GEM5NWxXsKVYyzD24k8+HB
         fPJQ==
X-Gm-Message-State: APjAAAWwFqdG7NF52iPPQXVicrLxwEd0tJTHkMOiVXapxR1vrOoEC6oj
        NrCkZIpngRSoYGYakY+cvDfpABkrRRoDyrFE3BJfOA==
X-Google-Smtp-Source: APXvYqxEBnjhhHA4oFQ0+p2BAs8dfWqKlcQ83C9PQ6iHX1R/1x735OeynGNhBtDLmr8raGsj6Pj4jGtrCfIEQT2PfTA=
X-Received: by 2002:a9d:10b:: with SMTP id 11mr5751663otu.222.1576816966932;
 Thu, 19 Dec 2019 20:42:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6830:1f10:0:0:0:0 with HTTP; Thu, 19 Dec 2019 20:42:46
 -0800 (PST)
In-Reply-To: <20191220030428.GA4534@martin-VirtualBox>
References: <cover.1576648350.git.martin.varghese@nokia.com>
 <f78a4e44caac82f0f1db5c89dfd30696c2cb192e.1576648350.git.martin.varghese@nokia.com>
 <CAOrHB_CTqSYc7TBuVqU64f7TjLQNmggWg69zYxrLwrC0Sgjf=A@mail.gmail.com>
 <20191219041234.GA2840@martin-VirtualBox> <CAOrHB_B88W_bnQGkE_=fML-6GyLUOzZ5FoL-WbvSCoU-D-d+fA@mail.gmail.com>
 <20191220030428.GA4534@martin-VirtualBox>
From:   Martin Varghese <martinvarghesenokia@gmail.com>
Date:   Fri, 20 Dec 2019 10:12:46 +0530
Message-ID: <CAF+XzbyJzwzUsLCsmzTjwOJ8sWkBPEtNaWYrDXvyLoxyPcFUfA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/20/19, Martin Varghese <martinvarghesenokia@gmail.com> wrote:
> On Thu, Dec 19, 2019 at 05:07:25PM -0800, Pravin Shelar wrote:
>> On Wed, Dec 18, 2019 at 8:12 PM Martin Varghese
>> <martinvarghesenokia@gmail.com> wrote:
>> >
>> > On Wed, Dec 18, 2019 at 07:50:52PM -0800, Pravin Shelar wrote:
>> > > On Tue, Dec 17, 2019 at 10:56 PM Martin Varghese
>> > > <martinvarghesenokia@gmail.com> wrote:
>> > > >
>> > > > From: Martin Varghese <martin.varghese@nokia.com>
>> > > >
>> > > > The existing PUSH MPLS action inserts MPLS header between ethernet
>> > > > header
>> > > > and the IP header. Though this behaviour is fine for L3 VPN where an
>> > > > IP
>> > > > packet is encapsulated inside a MPLS tunnel, it does not suffice the
>> > > > L2
>> > > > VPN (l2 tunnelling) requirements. In L2 VPN the MPLS header should
>> > > > encapsulate the ethernet packet.
>> > > >
>> > > > The new mpls action PTAP_PUSH_MPLS inserts MPLS header at the start
>> > > > of the
>> > > > packet or at the start of the l3 header depending on the value of l2
>> > > > tunnel
>> > > > flag in the PTAP_PUSH_MPLS arguments.
>> > > >
>> > > > POP_MPLS action is extended to support ethertype 0x6558.
>> > > >
>> > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
>> > > > ---
>> > > > Changes in v2:
>> > > >    - PTAP_POP_MPLS action removed.
>> > > >    - Special handling for ethertype 0 added in PUSH_MPLS.
>> > > >    - Refactored push_mpls function to cater existing push_mpls and
>> > > >      ptap_push_mpls actions.
>> > > >    - mac len to specify the MPLS header location added in
>> > > > PTAP_PUSH_MPLS
>> > > >      arguments.
>> > > >
>> > > > Changes in v3:
>> > > >    - Special handling for ethertype 0 removed.
>> > > >    - Added support for ether type 0x6558.
>> > > >    - Removed mac len from PTAP_PUSH_MPLS argument list
>> > > >    - used l2_tun flag to distinguish l2 and l3 tunnelling.
>> > > >    - Extended PTAP_PUSH_MPLS handling to cater PUSH_MPLS action
>> > > > also.
>> > > >
>> > > > Changes in v4:
>> > > >    - Removed extra blank lines.
>> > > >    - Replaced bool l2_tun with u16 tun flags in
>> > > >      struct ovs_action_ptap_push_mpls.
>> > > >
>> > > The patch looks almost ready. I have couple of comments.
>> > >
>> > > >  include/uapi/linux/openvswitch.h | 31
>> > > > +++++++++++++++++++++++++++++++
>> > > >  net/openvswitch/actions.c        | 30
>> > > > ++++++++++++++++++++++++------
>> > > >  net/openvswitch/flow_netlink.c   | 34
>> > > > ++++++++++++++++++++++++++++++++++
>> > > >  3 files changed, 89 insertions(+), 6 deletions(-)
>> > > >
>> > > > diff --git a/include/uapi/linux/openvswitch.h
>> > > > b/include/uapi/linux/openvswitch.h
>> > > > index a87b44c..d9461ce 100644
>> > > > --- a/include/uapi/linux/openvswitch.h
>> > > > +++ b/include/uapi/linux/openvswitch.h
>> > > > @@ -673,6 +673,32 @@ struct ovs_action_push_mpls {
>> > > >  };
>> > > >
>> > > ...
>> > > ...
>> > > > diff --git a/net/openvswitch/flow_netlink.c
>> > > > b/net/openvswitch/flow_netlink.c
>> > > > index 65c2e34..85fe7df 100644
>> > > > --- a/net/openvswitch/flow_netlink.c
>> > > > +++ b/net/openvswitch/flow_netlink.c
>> > > > @@ -79,6 +79,7 @@ static bool actions_may_change_flow(const struct
>> > > > nlattr *actions)
>> > > >                 case OVS_ACTION_ATTR_SET_MASKED:
>> > > >                 case OVS_ACTION_ATTR_METER:
>> > > >                 case OVS_ACTION_ATTR_CHECK_PKT_LEN:
>> > > > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS:
>> > > >                 default:
>> > > >                         return true;
>> > > >                 }
>> > > > @@ -3005,6 +3006,7 @@ static int __ovs_nla_copy_actions(struct net
>> > > > *net, const struct nlattr *attr,
>> > > >                         [OVS_ACTION_ATTR_METER] = sizeof(u32),
>> > > >                         [OVS_ACTION_ATTR_CLONE] = (u32)-1,
>> > > >                         [OVS_ACTION_ATTR_CHECK_PKT_LEN] = (u32)-1,
>> > > > +                       [OVS_ACTION_ATTR_PTAP_PUSH_MPLS] =
>> > > > sizeof(struct ovs_action_ptap_push_mpls),
>> > > >                 };
>> > > >                 const struct ovs_action_push_vlan *vlan;
>> > > >                 int type = nla_type(a);
>> > > > @@ -3072,6 +3074,33 @@ static int __ovs_nla_copy_actions(struct net
>> > > > *net, const struct nlattr *attr,
>> > > >                 case OVS_ACTION_ATTR_RECIRC:
>> > > >                         break;
>> > > >
>> > > > +               case OVS_ACTION_ATTR_PTAP_PUSH_MPLS: {
>> > > Can you change name of this action given this can handle both L2 and
>> > > L3 MPLS tunneling?
>> > >
>> > > > +                       const struct ovs_action_ptap_push_mpls *mpls
>> > > > = nla_data(a);
>> > > > +
>> > > > +                       if (!eth_p_mpls(mpls->mpls_ethertype))
>> > > > +                               return -EINVAL;
>> > > > +
>> > > > +                       if (!(mpls->tun_flags &
>> > > > OVS_MPLS_L2_TUNNEL_FLAG_MASK)) {
>> > > > +                               if (vlan_tci & htons(VLAN_CFI_MASK)
>> > > > ||
>> > > > +                                   (eth_type != htons(ETH_P_IP) &&
>> > > > +                                    eth_type != htons(ETH_P_IPV6)
>> > > > &&
>> > > > +                                    eth_type != htons(ETH_P_ARP)
>> > > > &&
>> > > > +                                    eth_type != htons(ETH_P_RARP)
>> > > > &&
>> > > > +                                    !eth_p_mpls(eth_type)))
>> > > > +                                       return -EINVAL;
>> > > > +                               mpls_label_count++;
>> > > > +                       } else {
>> > > > +                               if (mac_proto != MAC_PROTO_NONE) {
>> > > It is better to check for 'MAC_PROTO_ETHERNET', rather than this
>> > > negative test.
>> > >
>> > The idea is that if you have a l2 header you need to reset the mpls
>> > label count
>> > Either way fine for me.Let me know
>> Lets change it to  "if (mac_proto  == MAC_PROTO_ETHERNET)"
>>
> Yes, but it will not work for a hypothetical case where l2
> is no ethernet.
>> > > > +                                       mpls_label_count = 1;
>> > > > +                                       mac_proto = MAC_PROTO_NONE;
>> > > > +                               } else {
>> > > > +                                       mpls_label_count++;
>> > > > +                               }
>> > > We need to either disallow combination of L3 and L2 MPLS_PUSH, POP
>> > > actions in a action list or keep separate label count. Otherwise it
>> > > is
>> > > impossible to validate mpls labels stack depth in POP actions.
>> > >
>> >
>> > I assume it is taken in care in the above block
>> >
>> > let us consider the different cases
>> >
>> > 1.
>> >   Incoming Packet - ETH|IP|Payload
>> >   Actions = push_mpls(0x1),push_mpls(0x2),ptap_push_mpls(0x03)
>> >   Resulting packet - MPLS(3)|Eth|MPLS(2)|MPLS(1)|IP|Payload
>> >   Total Mpls count = 1
>> >
>> >   Since the total MPLS count = 1,ony one POP will be allowed and a
>> > recirc is need to
>> >   parse the inner packets
>> >
>> > 2. Incoming Packet - ETH|MPLS(1)|IP|Payload
>> >    Actions = ptap_push_mpls(0x03)
>> >    Resulting packet - MPLS(3)|Eth|MPLS(1)|IP|Payload
>> >    Total Mpls count = 1
>> >
>> >    Since the total MPLS count = 1,ony one POP will be allowed and a
>> > recirc is need to
>> >    parse the inner packets
>> >
>> > 3. Incoming Packet - MPLS(1)|IP|Payload
>> >    Actions = ptap_push_mpls(0x03)
>> >    Resulting packet - MPLS(3)|MPLS(1)|IP|Payload
>> >    Total Mpls count = 2
>> >
>> >    Since the total MPLS acount is 2 , 2 pops are allowd
>> >
>> >
>> > Is there any other case ?
>> >
>> I was think case of action list: PUSH_MPLS_L2, PUSH_MPLS_L3, ....,
>> POP_MPLS_L2, POP_MPLS_L2
>> This action will pass the validation. It would also work fine in
>> datapath since POP action can detect L2 and L3 packet dynamically. But
>> it is inconsistent with actions intention.
>
> I couldnt get the concern correctly.
> THere is no POPMPLS l2.There is only one type of MPLS POP
> the pop MPLS always removes MPLS header after mac header
>
> In the case of POP_MPLS:0x6558 the ethernet header should not be
> present as we dont support ethernet in ethernet.We have the validation
> in flow_netlink.c
> So for the POP_MPLS:0x6558 to work ,it should be preceeded by a pop_eth
> if is a ethernet packet.
>
> Considering the action above.
> Incomming packet - ETH|IP|Payload
> 1 Actions - push_mpls_l2
> outgoing packet -  l2 MPLS label|eth|IP - ( Packet is l3 now)
> 2 Actions  - Push_mpls_l2
> outgoing packet  | L3 MPLS Label| l2 MPLS label|eth|IP.
>
> 2 actions - POP_MPLS,POP_MPLS
> outgoing packet - ETH |IP|Payload  (Packet is l2 now)
>
>

The point here is there is no one to one mapping between
l2_tunnel_flag in push_mpls to
l2 VPN
As decsribed in the comments ,if the flag is set it inserts MPLS
header at the start of the packet.Hence if the packet is not having a
ethernet header start of the packet is start of l3 header as :well.

In that sense l2_tunnel_flag is bit ambiguous.
The better flag is l3_tunnel_flag.

The new action always insert MPLS header at the start of packet always
if not told otherwise
with l3_tunnel_flag.
I think what we have to keep in mind is the the new action has no
direct mapping to l3 or l2 VPN.It just says where to insert the MPLS
header.Similary for pop_mpls.0x6558  handling is just an extention to
existing action
