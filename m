Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E112031CAE2
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 14:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBPNJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 08:09:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhBPNJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 08:09:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lC05Q-006h2F-Qs; Tue, 16 Feb 2021 14:08:16 +0100
Date:   Tue, 16 Feb 2021 14:08:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Re: [EXT] Re: Phylink flow control support on ports with
 MLO_AN_FIXED auto negotiation
Message-ID: <YCvDwMiOL2H+nv7S@lunn.ch>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131103549.GA1463@shell.armlinux.org.uk>
 <CO6PR18MB3873D6F519D1B4112AA77671B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20210131111214.GB1463@shell.armlinux.org.uk>
 <20210131121950.GA1477@shell.armlinux.org.uk>
 <20210213113947.GD1477@shell.armlinux.org.uk>
 <CO6PR18MB38732FD9F40B8956B019F719B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
 <YCq65/83SnpgyA86@lunn.ch>
 <CO6PR18MB3873A73FCB7DD1233249B314B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO6PR18MB3873A73FCB7DD1233249B314B0889@CO6PR18MB3873.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 08:33:19PM +0000, Stefan Chulski wrote:
> > > > > > I discussed it with Andrew earlier last year, and his response was:
> > > > > >
> > > > > >  DT configuration of pause for fixed link probably is
> > > > > > sufficient. I don't  remember it ever been really discussed for
> > > > > > DSA. It was a Melanox  discussion about limiting pause for the
> > > > > > CPU. So I think it is safe to  not implement ethtool -A, at
> > > > > > least until somebody has a real use case  for it.
> > > > > >
> > > > > > So I chose not to support it - no point supporting features that
> > > > > > people aren't using. If you have a "real use case" then it can be added.
> > > > >
> > > > > This patch may be sufficient - I haven't fully considered all the
> > > > > implications of changing this though.
> > > >
> > > > Did you try this patch? What's the outcome?
> > >
> > > For me patch worked as expected.
> > 
> > Hi Stefan
> > 
> > Russell's patch allows it, but i would be interested in knows why you actually
> > need it. What is your use case for changing this on the fly?
> > 
> > 	 Andrew
> 
> Usually, user prefer have the capability disable/enable flow control on the fly.
> For example:
> Armada connected by 10G fixed link to SOHO switch and SOHO has 10 external 1G LAN interfaces.
> When we have 2 flows (from Armada to LAN) from two different ports, we have an obvious congestion issue.
> Bursts on 10G interface would cause FC frames on Armada<->SOHO 10G port and one flow would affect another.
> In some use cases, the user would prefer lossless traffic and keep FC, for another use case (probably UDP streaming) disable FC.

O.K, so you have reasonable uses cases for it. I'm O.K. with this.

     Andrew
