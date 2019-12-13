Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF3211DCB0
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 04:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731512AbfLMDxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 22:53:49 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35604 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbfLMDxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 22:53:49 -0500
Received: by mail-pl1-f196.google.com with SMTP id s10so671982plp.2
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 19:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4I1z3Ne00Py5W4YSmz29sIMLxW4YtFIxs+J+S2uWxaI=;
        b=ur94E/C7XNkuiiAK2AD+ldeiIKpvcal6Dq/uUXLhNGKxQSwh6uasBx0pFXO2XS3J3C
         pVpIC5fa0XDDkn4y9fxxAxj+r6eBzlA+Qvdrvmmm913Uh1O3r4VtS4cNwqh2xEaMtvUt
         TLHtMf+vhm65llD43RRK+pcThrbD3XbmAyQ8MntKF3QRK8ne1gpBOdfOCYsPELjREOFQ
         zQuDYtEW95JNW8/2UBZO8NPfJbDl3zRg98ob2U7KKGk5ii09oZ843P8yfl2ASF2jp/T6
         m5hzYepfF0pcjgEscJwSSbPP7ezw6YaaD/MkBT71KjTfMsFK1j335G+2Fdjs7+n5OhOz
         voUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4I1z3Ne00Py5W4YSmz29sIMLxW4YtFIxs+J+S2uWxaI=;
        b=CyRcjJjf8lm4pFkWKfzm4+22GFKMnrvofhSPfKbYYCPGtUH48UMR8mbpo+Jl5Ryp0q
         OtD+LJEVmkWPLBmy+NZ7ysYYSELZFp8r1WhSH1WrvgAMgXCRdg/LyCgeyDw4Xts8jL/J
         /hiiRYq5MUoDZve6Sh6alROTPqnWtR/d0e/8oh/+9YD51mwWacbdYyAueokyfdmEL9yz
         vfm5kb95g8QRejcrukVSsDVNE77TUaLE1NZSHoaLuVp6PfBPOxa07HTLTVXoIhMNiVPh
         doECKLMDiCCl0HLlXKLzhSSWiTXCgbkouc/aL23SBv0u07cPKICByYetQTj3K4IMknPq
         yi9Q==
X-Gm-Message-State: APjAAAWW5c2ndtTII2sEgoJ3twBsW2Qw3MECK+xbChxT5MSuDsuwdqnu
        g+GNN3QSd5xezPYmeErG4as=
X-Google-Smtp-Source: APXvYqyAN6GZcd3cSJOsUmqL5yWQ6vH/GIGaIA3nc2AuOSMvkXzpZ9pTpWVro3iwTQC8PP+nqykrFw==
X-Received: by 2002:a17:902:8646:: with SMTP id y6mr13516692plt.191.1576209228417;
        Thu, 12 Dec 2019 19:53:48 -0800 (PST)
Received: from martin-VirtualBox ([112.79.80.231])
        by smtp.gmail.com with ESMTPSA id h26sm9508042pfr.9.2019.12.12.19.53.47
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 19:53:47 -0800 (PST)
Date:   Fri, 13 Dec 2019 09:23:40 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191213035242.GA8690@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
 <20191211000245.GB2687@martin-VirtualBox>
 <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
 <20191211153900.GA5156@martin-VirtualBox>
 <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
 <20191212160226.GA8105@martin-VirtualBox>
 <CAOrHB_AB+GrPxzgbKto9PZyoy7Yd9_EoHS5oVyNdNc75E0sAMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_AB+GrPxzgbKto9PZyoy7Yd9_EoHS5oVyNdNc75E0sAMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 07:15:47PM -0800, Pravin Shelar wrote:
> On Thu, Dec 12, 2019 at 8:02 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Wed, Dec 11, 2019 at 08:19:08PM -0800, Pravin Shelar wrote:
> > > On Wed, Dec 11, 2019 at 7:39 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > On Tue, Dec 10, 2019 at 10:15:19PM -0800, Pravin Shelar wrote:
> > > > > On Tue, Dec 10, 2019 at 4:02 PM Martin Varghese
> > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > >
> > > > > > On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
> > > > > > > On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> > > > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > > > >
> > > > > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > > > > >
> > > > > > > > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > > > > > > > between ethernet header and the IP header. Though this behaviour is fine
> > > > > > > > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > > > > > > > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > > > > > > > the MPLS header should encapsulate the ethernet packet.
> > > > > > > >
> > > > > > > > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > > > > > > > MPLS header from start of the packet respectively.
> > > > > > > >
> > > > > > > > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > > > > > > > @ethertype - Ethertype of MPLS header.
> > > > > > > >
> > > > > > > > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > > > > > > > @ethertype - Ethertype of next header following the popped MPLS header.
> > > > > > > >              Value 0 in ethertype indicates the tunnelled packet is
> > > > > > > >              ethernet.
> > > > > > > >
> > > > > > > Did you considered using existing MPLS action to handle L2 tunneling
> > > > > > > packet ? It can be done by adding another parameter to the MPLS
> > > > > > > actions.
> > > > > >
> > > > >
> > > > > >
> > > > > >
> > > > > > Not really.
> > > > > >
> > > > > > Are you suggesting to extend the ovs_action_push_mpls and similarly for pop
> > > > > >
> > > > > > struct ovs_action_push_mpls {
> > > > > >         __be32 mpls_lse;
> > > > > >         __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > > > > > +        bool l2_tunnel;
> > > > > > };
> > > > > >
> > > > > > Does not that break the compatibilty with the existing userspace
> > > > > > OVS ?
> > > > > >
> > > > > Right, extending this would not look good. I am fine with new action.
> > > > > But we can design this new action as superset of existing and PTAP
> > > > > functionality, This way in future we can deprecate existing MPLS
> > > > > action in favor of new action.
> > > > > I think if you add mac_len parameter for the action it would take case
> > > > > of both cases.
> > > > Yes i guess so.
> > > > On the similar lines i guess we dont need a new PTAP_POP action as the existing
> > > > pop action pops mpls header from the start of the packet if the skb->mac_len=0
> > > > We just neeed a add a special handling for ethertype 0 is the existing pop
> > > > implementation
> > >
> > > Passing next_proto as zero to skb_mpls_pop() would set skb->protocol
> > > to zero. That does not look good. Lets pass mac_len and next_proto for
> > > both Push and Pop action. I am also fine using using boolean to
> > > distinguish between L2 and L3 case. In that case we are dependent on
> > > skb->mac_len.
> >
> > But setting to zero may be appropriate ? (a kind of reset of the protocol)
> > Normally skb->protocol holds the ethertype, but in this case we have a ethernet
> > header after the MPLS header and we need to read that ethernet header to
> > find the ethertype.
> > Also if we decide the caller has to pass the ethertype as it is in normal pop
> > along with a l2 flag, which ethertype the skb_mpls_pop caller will pass.
> >
> > Or should the caller pass the trans ether bridging ethertype 0x6558.In that
> > case we may not need a flag, but i am not sure if using 0x6558 is correct here.
> >
> The inner packet type needs to be part of MPLS pop action. We can not
> assume it would be ethernet packet. Otherwise OVS will not be able to
> support multiple tagged packets for L2 MPLS tunneling.

I am not sure if i got you comment correctly ?

We are not assuming the inner packet is ethernet always.We are just retriggring the
parsing with ethernet header if ethertype is 0

By multiple tagged packets you mean below

MPLS 1|MPLS 2| ethernet--|

But in this case ethertype passed to pop action will be 0x8847 or 0x8848 and not 0.


My other doubt is If we use a flag to say it is a l2 tunnel.
what the caller  will pass in ethertype.and subsequently what we will set in openvswitch.
