Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22472D7760
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 15:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405105AbgLKODb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:03:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395187AbgLKOCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 09:02:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knizX-00BP2e-BZ; Fri, 11 Dec 2020 15:01:51 +0100
Date:   Fri, 11 Dec 2020 15:01:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jon Nettleton <jon@solid-run.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Andrew Elwell <andrew.elwell@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201211140151.GJ2638572@lunn.ch>
References: <20201208133532.GH643756@sasha-vm>
 <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com>
 <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk>
 <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
 <20201210175619.GW1551@shell.armlinux.org.uk>
 <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
 <20201210202650.GA2654274@lunn.ch>
 <CABdtJHuuRY-Oimx6DbEW4pLYdbBKKwV+1r3OpfS62skCJYWLkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABdtJHuuRY-Oimx6DbEW4pLYdbBKKwV+1r3OpfS62skCJYWLkQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 06:03:57AM +0100, Jon Nettleton wrote:
> On Thu, Dec 10, 2020 at 9:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > +1. As soon as the MDIO+ACPI lands, I plan to do the rework.
> >
> > Don't hold you breath. It has gone very quiet about ACPI in net
> > devices.
> 
> NXP resources were re-allocated for their next internal BSP release.
> I have been working with Calvin over the past week and a half and the new
> patchset will be submitted early next week most likely.

Hi Jon

Cool, i just hope you get buy in from the ACPI maintainers this time.

      Andrew
