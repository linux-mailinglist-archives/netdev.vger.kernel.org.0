Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C819111B2E1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfLKPjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:39:17 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44972 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387618AbfLKPjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:39:16 -0500
Received: by mail-pl1-f195.google.com with SMTP id bh2so1549927plb.11
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q8ruk00WfBGKL8eojBCBhUKmckcGonvYNXEiF1DhlpE=;
        b=rIveDBGTBnPNmAaeG0p29qGWRIHfDOjsCX38aMgq4URKTI/b/FsRv8A9lLt4wX61it
         qh7Hp11WUfUbQAawN8OBensqnh2y+IQ0eYNGhr6IP9uAUUBIqguPKaereokHyPqtEDI5
         2omsMrwOxJEN1WJCWLoAX0GTcZSPk5GwSlV5VJ5OZoe2dPN0K+GltmR2R/uI9a5v4OI4
         7Ck6vWe09ixcjuzVrgRPHJxINnYPKJ9jszIBuHzmibNjcSeqDmRvab6EbUuJLMsqM5r7
         iGSSbmhNqrDAaGHvOl5K5pZvtet/qwAiW84PwgexZ171dRrR+IM7Il90RVRI3RCRfOdo
         bRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q8ruk00WfBGKL8eojBCBhUKmckcGonvYNXEiF1DhlpE=;
        b=SlW0H2JHwyOe9kg5YsyfHgjq1R1p/oJ67cJ4kb1M8d12DU2QrtJO8DBeYrGTipKoLr
         TcqHIFt7nKXDwrqEHnXNbMIFIZoE9I9Kqec01ufCzS9KrpC9CvXwqckLor9ATZWdRt+p
         bJklG0FK4mJQ1ZlzbuPiWlmV96BcJBvjq/HmXmzaacwr3qTqo9TF5RDiZ+IqJZTOTheh
         dFmQcn9W9dRqOcDktv8DQOhpGFieOrVk3yOdlbq9CqJAzHW3riKHNzRWZ0QzFI/nAYhn
         ulQPlA2+AjoAfLWbc4xn6UMcT5/9rQ9lFDX3M8DbwKn3dupDFnCCBHzWwYW/bpEqaqBO
         R4FA==
X-Gm-Message-State: APjAAAW5fiLfWi92jH5J/QL7UVoqluupo8rBqRlACJ4FzIEmwoB6hU/h
        2m49EGH+c52FUrRWnMiGfso=
X-Google-Smtp-Source: APXvYqwoWYeHg6vJYLvKwaDry7AfRHqiFetSj9FzgdvW8HqFIj0QxER9mJRpEJ3u5RA40ZqNCXqipQ==
X-Received: by 2002:a17:902:7586:: with SMTP id j6mr3638980pll.299.1576078755468;
        Wed, 11 Dec 2019 07:39:15 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id w3sm3499423pfd.161.2019.12.11.07.39.12
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2019 07:39:13 -0800 (PST)
Date:   Wed, 11 Dec 2019 21:09:00 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191211153900.GA5156@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
 <20191211000245.GB2687@martin-VirtualBox>
 <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:15:19PM -0800, Pravin Shelar wrote:
> On Tue, Dec 10, 2019 at 4:02 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
> > > On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > >
> > > > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > > > between ethernet header and the IP header. Though this behaviour is fine
> > > > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > > > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > > > the MPLS header should encapsulate the ethernet packet.
> > > >
> > > > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > > > MPLS header from start of the packet respectively.
> > > >
> > > > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > > > @ethertype - Ethertype of MPLS header.
> > > >
> > > > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > > > @ethertype - Ethertype of next header following the popped MPLS header.
> > > >              Value 0 in ethertype indicates the tunnelled packet is
> > > >              ethernet.
> > > >
> > > Did you considered using existing MPLS action to handle L2 tunneling
> > > packet ? It can be done by adding another parameter to the MPLS
> > > actions.
> >
> 
> >
> >
> > Not really.
> >
> > Are you suggesting to extend the ovs_action_push_mpls and similarly for pop
> >
> > struct ovs_action_push_mpls {
> >         __be32 mpls_lse;
> >         __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > +        bool l2_tunnel;
> > };
> >
> > Does not that break the compatibilty with the existing userspace
> > OVS ?
> >
> Right, extending this would not look good. I am fine with new action.
> But we can design this new action as superset of existing and PTAP
> functionality, This way in future we can deprecate existing MPLS
> action in favor of new action.
> I think if you add mac_len parameter for the action it would take case
> of both cases.
Yes i guess so.
On the similar lines i guess we dont need a new PTAP_POP action as the existing
pop action pops mpls header from the start of the packet if the skb->mac_len=0
We just neeed a add a special handling for ethertype 0 is the existing pop 
implementation
