Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DEC119FBC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 01:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLKAC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 19:02:56 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45033 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfLKACz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 19:02:55 -0500
Received: by mail-pf1-f193.google.com with SMTP id d199so753835pfd.11
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 16:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ddjwTqwv1qgzHOtf+IYcUF7b27uC9sv723y13ATTZvI=;
        b=crbpQYR6RCN6uq/oQTbMUGi62eMxzCkQj3hcYmE68cUssYiVHRLxlQR7Q7c+Bd+ZpE
         DvFmAM5LiYwnmAhcRBViC1QAF4MIH55k+qLqGM9GuP28zuQ/ZcycWqQiADMQPoensWnm
         Qz0rl0UTIjimkLmeTQ10eMy6j9mYUdLsEdPBwgRa1tx6hZRTscBkV+WmYkXfR5QmWkx0
         6WzSMmUoFhUSQ2alLgHr5B3czXLg0F3Nhn6ly52pjgB2Hcr2jj49UPPULyfrsELD3GzI
         JEWurBMWDhloRppjz5SUk0OjUPEvqmLuHE4/ZPpOUfLGDkC43+lPFFx9gYiBQDGT2Pxf
         pk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ddjwTqwv1qgzHOtf+IYcUF7b27uC9sv723y13ATTZvI=;
        b=khi9y8LOE0CKq4YFEg4FXZZEHp0IN1qF4TtaPLytsy4EeiMdaQbWh5cPGhD0J7FFUW
         bz0E7HF+pH5769m3XjP05bpG6L0iGtwBWsmAz9CKY9+L+/5wb/3shqNO8ISMm+hY5G33
         raWKxDUFvam7zA15ahEsyqm2PaDA1/Uwri5KAo5HJ4F0lo/LSkwfmywmqrjdtS2t7O/0
         EYBoGBRfF37ouv1zKAugLeqFfBvMZwu7lE0g6HWwxYMPQS4cRxtgC39KavIcDG2S8p4C
         KcFIBZ5C39rczyc44PaSsT2+J0dJh/XeplrQqx4FzaA+7/LUbt3Kf8xWiOgiDCKKUFPZ
         yAtw==
X-Gm-Message-State: APjAAAXVYYfycuXasEv9IZmlHERzfy5pxymCrJUnd3WWQtnAvB2gfWgN
        ErcuhsELrLdC8ranokgUhKPKTBP0
X-Google-Smtp-Source: APXvYqyHGCpjdwsFr5E9E3o+iRMvUkMRW3pPymCwo5DM5HHcwbHo/Ju/vKkiXB7E11/lTKLbUg+9vg==
X-Received: by 2002:a63:e14a:: with SMTP id h10mr874850pgk.74.1576022575016;
        Tue, 10 Dec 2019 16:02:55 -0800 (PST)
Received: from martin-VirtualBox ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id y22sm164366pfn.122.2019.12.10.16.02.53
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 16:02:54 -0800 (PST)
Date:   Wed, 11 Dec 2019 05:32:45 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2
 tunnelling
Message-ID: <20191211000245.GB2687@martin-VirtualBox>
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
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
> Did you considered using existing MPLS action to handle L2 tunneling
> packet ? It can be done by adding another parameter to the MPLS
> actions.



Not really.

Are you suggesting to extend the ovs_action_push_mpls and similarly for pop

struct ovs_action_push_mpls {
        __be32 mpls_lse;
        __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
+        bool l2_tunnel;
};

Does not that break the compatibilty with the existing userspace
OVS ?

Will not push_mpls and pop_mpls called from existing OVS fail in action_lens check
in __ovs_nla_copy_actions ?


