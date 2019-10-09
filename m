Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8E1D1053
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbfJINjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:39:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40361 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731083AbfJINjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:39:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so1653251pfb.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 06:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w3L2NbJDsbnRxMMsFLwuwViQ6t0iOFxRUmbLzWPe3IY=;
        b=jAMZrqLQfxHhrhbiCIHbeiYX1urfK854868AaVI6WBzIXgXTNTQCmumC+Zb3pBCEGq
         b7BzqWzwC/yxuPcxlsR2NIeYKtvgMtYTfwgdGMDZkbPnfzwXOwHUaUh78M0o9YZQsKp6
         kG37WT/RlXDhD2PvEJqpeHB1NiaSqsTCRh6ce/aHrgjGNA2mNPAsWu+Bqn904HjEA9X/
         h6d0NVgUg9j6afqNxxEWsAEe1/uiYYP3KlTNiV/jXzxqF6J126TS37Dn/fPlBw2Ca/T/
         dCQCpWVIk32Ac3xfgy2D2Qg8SNiGdr+A2MK9mwyvnPAEutW49U5a89gBdB7Gj2UgchNN
         CQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w3L2NbJDsbnRxMMsFLwuwViQ6t0iOFxRUmbLzWPe3IY=;
        b=DCCRy9kb6XQqpLANWd2yhBOQwAG8QfGig4us9jDB+n1dB67tjtUYtTcM4N32mPjpDO
         sR32qLDBlqmSybLGMOdKRle3QOHVawndi+eAWBI4+Qv6KfjASdWYOMBUL0yXFvYI7OCd
         nNbWcbAj0GOB3P6i2Unsxk7pFhzJeumd//ypnTflOcyOckL/mWn82CCg0zdVvTXu2oTE
         UWSu/MFgi6cK7OigdColR3yzEU/rvVGhkvZNOu98xcuxZeqYHd/GHVkYOpGjzOAPGbQS
         3MqRTCLQJVwqDklWLYl/D8T6xerlO+ZAh6D5QM32Ba0FkWPRPT4oEi3ljtBEU15s70qX
         BOBA==
X-Gm-Message-State: APjAAAUM2gObW6jWAfDvGhppuYHrPhpc73W15lvJsf7Q4vTssGgirHAV
        KA9QAUwUZDx8bF+YEBwCOdXpqpl5
X-Google-Smtp-Source: APXvYqxplwitOpu2BN0MPtrz9UjPBPCTx5v14YdKQ5VrMdQGAcGQ0vGg921vrVdjrZE5kS2+yLzc5A==
X-Received: by 2002:a63:5fd0:: with SMTP id t199mr4277210pgb.369.1570628361443;
        Wed, 09 Oct 2019 06:39:21 -0700 (PDT)
Received: from martin-VirtualBox ([122.178.241.240])
        by smtp.gmail.com with ESMTPSA id q88sm5769585pjq.9.2019.10.09.06.39.20
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 09 Oct 2019 06:39:20 -0700 (PDT)
Date:   Wed, 9 Oct 2019 19:08:40 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 2/2] Special handling for IP & MPLS.
Message-ID: <20191009133840.GC17712@martin-VirtualBox>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSc_L_2sGSvSOtF2t6rKFenNp+L-0YBjqhTT6_NZBS9XJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 12:09:49PM -0400, Willem de Bruijn wrote:
> On Tue, Oct 8, 2019 at 5:52 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin <martin.varghese@nokia.com>
> >
> 
> This commit would need a commit message.
> 
> > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> >
> > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > ---
> >  Documentation/networking/bareudp.txt | 18 ++++++++
> >  drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
> >  include/net/bareudp.h                |  1 +
> >  include/uapi/linux/if_link.h         |  1 +
> >  4 files changed, 95 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> > index d2530e2..4de1022 100644
> > --- a/Documentation/networking/bareudp.txt
> > +++ b/Documentation/networking/bareudp.txt
> > @@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> >  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> >  a UDP tunnel.
> >
> > +Special Handling
> > +----------------
> > +The bareudp device supports special handling for MPLS & IP as they can have
> > +multiple ethertypes.
> 
> Special in what way?
> 
The bareudp device associates a L3 protocol (ethertype) with a UDP port.
For some protocols like MPLS,IP there exists multiplle ethertypes.
IPV6 and IPV4 ethertypes for IP and MPLS unicast & Multicast ethertypes for
MPLS. There coud be use cases where both MPLS unicast and multicast traffic
need to be tunnelled using the same bareudp device.Similarly for ipv4 and ipv6.

This problem is solved by introducing a flag called extended mode which should be used 
be with IPv4 and MPLS unicast ethertypes.

The extended mode flag when used with IPV4 ethertype enables the bareudp device to
recognize & support IPV4 & v6.

The extended mode flag when used with MPLS unicast ethertype enables bareudp device
to recognize & support MPLS unicast & multicast.

> > +MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8847 (multicast).
> 
> 0x8848. Use ETH_P_MPLS_UC and ETH_P_MPLS_MC instead of hard coding constants.
> 
> > +IP proctocol can have ethertypes 0x0800 (v4) & 0x866 (v6).
> > +This special handling can be enabled only for ethertype 0x0800 & 0x88847 with a
> 
> Again typo.
> 
> > +flag called extended mode.
> > +
> >  Usage
> >  ------
> >
> > @@ -21,3 +30,12 @@ This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
> >  The device will listen on UDP port 6635 to receive traffic.
> >
> >  b. ip link delete bareudp0
> > +
> > +2. Device creation with extended mode enabled
> > +
> > +There are two ways to create a bareudp device for MPLS & IP with extended mode
> > +enabled
> > +
> > +a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1
> > +
> > +b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index 7e6813a..2a688da 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -48,6 +48,7 @@ struct bareudp_dev {
> >         struct net_device  *dev;        /* netdev for bareudp tunnel */
> >         __be16             ethertype;
> >         u16                sport_min;
> > +       bool               ext_mode;
> >         struct bareudp_conf conf;
> >         struct bareudp_sock __rcu *sock4; /* IPv4 socket for bareudp tunnel */
> >  #if IS_ENABLED(CONFIG_IPV6)
> > @@ -82,15 +83,64 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >                 goto drop;
> >
> >         bareudp = bs->bareudp;
> > -       proto = bareudp->ethertype;
> > +       if (!bareudp)
> > +               goto drop;
> > +
> > +       if (bareudp->ethertype == htons(ETH_P_IP)) {
> > +               struct iphdr *iphdr;
> > +
> > +               iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> > +               if (iphdr->version == 4) {
> > +                       proto = bareudp->ethertype;
> > +               } else if (bareudp->ext_mode && (iphdr->version == 6)) {
> > +                       proto = htons(ETH_P_IPV6);
> 
> Verified packet length before reading at offset? Why does v6 needs
> extended mode, while v4 does not?
>
Explained above.
 
> For any packet encapsulated in UDP, the inner packet type will be
> unknown, so needs to be configured on the device. That is not a
> special feature. FOU gives an example. My main concern is that this
> introduces a lot of code that nearly duplicates existing tunneling
> support. It is not clear to me that existing logic cannot be
> reused/extended.
