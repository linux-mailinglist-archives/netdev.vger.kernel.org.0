Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0A33263EF
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhBZORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:17:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60430 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhBZORC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 09:17:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFdue-008c0w-ES; Fri, 26 Feb 2021 15:16:12 +0100
Date:   Fri, 26 Feb 2021 15:16:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <YDkCrCIwtCOmOBAX@lunn.ch>
References: <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
 <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
 <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com>
 <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
 <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com>
 <CABwr4_vpmgxyGAGYjM_C5TvdROT+pV738YBv=KnSKEO-ibUMxQ@mail.gmail.com>
 <286fb043-b812-a5ba-c66e-eef63fe5cc98@gmail.com>
 <CABwr4_tJqFiS-XtFitXGn=bjYzdv=YwqSSUaAvh1U-iHsbTZXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABwr4_tJqFiS-XtFitXGn=bjYzdv=YwqSSUaAvh1U-iHsbTZXQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > OK, I see. Then there's no reason to complain upstream.
> > Either use the mainline B53 DSA driver of fix interrupt mode
> > downstream.
> 
> I agree.
> 
> This b53 driver has one PHY with the same BCM63XX phy_id, causing a
> double probe. I'll send the original patch to the OpenWrt project.

Hi Daniel

There is a bit of a disconnect between OpenWRT and Mainline. They have
a lot of fixes that don't make it upstream. So it is good to see
somebody trying to fix mainline first, and then backport to
OpenWRT. But please do test mainline and confirm it is actually broken
before submitting patches.

When you do submit to OpenWRT, please make it clear this is an OpenWRT
problem so somebody does not try to push it to mainline again....

And if you have an itch to scratch, try adding mainline support for
this board. We can guide you.

	Andrew
