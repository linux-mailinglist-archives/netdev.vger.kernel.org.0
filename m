Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF88011D1BA
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfLLQCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:02:36 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42095 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbfLLQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:02:36 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so973501pfz.9
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Em3uFXGj/1Phk23lqTlgpC0pEcNBn01nCzW6AUq9Yj8=;
        b=s+jhposd7+sqX6/+TxStCtXFhFuL+RVLEeLPhz02NkD1utKKsbyQltuxUFKZ1ipWJf
         K/SJAlP764qFAzQc2S9QozXoVKmYTiFQeVOrxBU/ubILU4G7mMnb+SNhbanSG+eK6UM2
         sMONIOonh5YdnWUVdIqhbbHycsHTJYbC9uKYTVWa/gC++g6FyOWr5fKgUbLAOz0OWKqn
         0aAXyB3xXJoWvW6L8N6BltcnZX0vND+Rc/BfHltCAwbN+ObSdBmYVVC1TQDnPPKIh+uU
         gqLQACPrde+I5lGGkZYjIdtgSeQsgCQ/qFCNO2avSWsqDx5pW6GH18bS6in4Exn2yxBx
         5m5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Em3uFXGj/1Phk23lqTlgpC0pEcNBn01nCzW6AUq9Yj8=;
        b=WBjwKyiuHabdcN6zJ2t5KVThrcJl8dibWl4V1ogSMBkBBGvkrtUtKTXyaLRi0fiv8t
         iYgjqacyupiT0eBfPAaDBrT58kuHXkk0qAJEnRppYHI7va+e4ViGpTerlEnh+m/C/V8D
         hRJkHoqvlnQXv77dBJojHcOcbe/rGzltjxYylFJR86nYXjQys545nSaJ6dH36rhaPQX6
         sQfUV2GY20h344N/E4lt18d1yDJ47gmPYq91I26+PzjHDhK7A/a9cKBHfrboh35dQ7IR
         EAu0pI7kuI9ORJxB93U0rzU6H6mCc4xVwiwLMT5htrregIdT5Y00z4jbAqsCB8qOKSn/
         IkZw==
X-Gm-Message-State: APjAAAWFE50z8x4qBcy5vyOOs2DJ2ZoXUVim7sCrgr1MR3c0LLNbTcE/
        +BLiQ3qWTZdAoM2pmBFPI6g=
X-Google-Smtp-Source: APXvYqy0LzCQZ0Q6q/sYb5RHd6637bOC+QF6fORhPhnzCNOxducnQ/Corj0Dq1MhM96XzPsQGXrg+g==
X-Received: by 2002:a63:6b8a:: with SMTP id g132mr11106089pgc.127.1576166555060;
        Thu, 12 Dec 2019 08:02:35 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id o8sm6299548pjo.7.2019.12.12.08.02.33
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 08:02:34 -0800 (PST)
Date:   Thu, 12 Dec 2019 21:32:26 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191212160226.GA8105@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
 <20191211000245.GB2687@martin-VirtualBox>
 <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
 <20191211153900.GA5156@martin-VirtualBox>
 <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 08:19:08PM -0800, Pravin Shelar wrote:
> On Wed, Dec 11, 2019 at 7:39 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Tue, Dec 10, 2019 at 10:15:19PM -0800, Pravin Shelar wrote:
> > > On Tue, Dec 10, 2019 at 4:02 PM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
> > > > > On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > >
> > > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > > >
> > > > > > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > > > > > between ethernet header and the IP header. Though this behaviour is fine
> > > > > > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > > > > > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > > > > > the MPLS header should encapsulate the ethernet packet.
> > > > > >
> > > > > > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > > > > > MPLS header from start of the packet respectively.
> > > > > >
> > > > > > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > > > > > @ethertype - Ethertype of MPLS header.
> > > > > >
> > > > > > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > > > > > @ethertype - Ethertype of next header following the popped MPLS header.
> > > > > >              Value 0 in ethertype indicates the tunnelled packet is
> > > > > >              ethernet.
> > > > > >
> > > > > Did you considered using existing MPLS action to handle L2 tunneling
> > > > > packet ? It can be done by adding another parameter to the MPLS
> > > > > actions.
> > > >
> > >
> > > >
> > > >
> > > > Not really.
> > > >
> > > > Are you suggesting to extend the ovs_action_push_mpls and similarly for pop
> > > >
> > > > struct ovs_action_push_mpls {
> > > >         __be32 mpls_lse;
> > > >         __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > > > +        bool l2_tunnel;
> > > > };
> > > >
> > > > Does not that break the compatibilty with the existing userspace
> > > > OVS ?
> > > >
> > > Right, extending this would not look good. I am fine with new action.
> > > But we can design this new action as superset of existing and PTAP
> > > functionality, This way in future we can deprecate existing MPLS
> > > action in favor of new action.
> > > I think if you add mac_len parameter for the action it would take case
> > > of both cases.
> > Yes i guess so.
> > On the similar lines i guess we dont need a new PTAP_POP action as the existing
> > pop action pops mpls header from the start of the packet if the skb->mac_len=0
> > We just neeed a add a special handling for ethertype 0 is the existing pop
> > implementation
> 
> Passing next_proto as zero to skb_mpls_pop() would set skb->protocol
> to zero. That does not look good. Lets pass mac_len and next_proto for
> both Push and Pop action. I am also fine using using boolean to
> distinguish between L2 and L3 case. In that case we are dependent on
> skb->mac_len.

But setting to zero may be appropriate ? (a kind of reset of the protocol)
Normally skb->protocol holds the ethertype, but in this case we have a ethernet
header after the MPLS header and we need to read that ethernet header to 
find the ethertype.
Also if we decide the caller has to pass the ethertype as it is in normal pop
along with a l2 flag, which ethertype the skb_mpls_pop caller will pass.

Or should the caller pass the trans ether bridging ethertype 0x6558.In that 
case we may not need a flag, but i am not sure if using 0x6558 is correct here.


