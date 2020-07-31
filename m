Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7B6233CD9
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbgGaBZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:25:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36186 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgGaBZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:25:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1JnK-007dxY-Ay; Fri, 31 Jul 2020 03:25:10 +0200
Date:   Fri, 31 Jul 2020 03:25:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Message-ID: <20200731012510.GD1712415@lunn.ch>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200728160802.GI1705504@lunn.ch>
 <VI1PR0402MB38714D71435CC4DF99AE5A20E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <1c484c7b-1988-20dc-9433-3f322e81280c@gmail.com>
 <410daead-6956-bb9b-da35-53b93daa6c46@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <410daead-6956-bb9b-da35-53b93daa6c46@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 05:34:44PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/28/2020 5:28 PM, Doug Berger wrote:
> > On 7/28/2020 9:28 AM, Ioana Ciornei wrote:
> >>> Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
> >>>
> >>>> I think that the MAINTAINERS file should also be updated to mention
> >>>> the new path to the drivers. Just did a quick grep after 'drivers/net/phy':
> >>>> F:      drivers/net/phy/adin.c
> >>>> F:      drivers/net/phy/mdio-xgene.c
> >>>> F:      drivers/net/phy/
> >>>> F:      drivers/net/phy/marvell10g.c
> >>>> F:      drivers/net/phy/mdio-mvusb.c
> >>>> F:      drivers/net/phy/dp83640*
> >>>> F:      drivers/net/phy/phylink.c
> >>>> F:      drivers/net/phy/sfp*
> >>>> F:      drivers/net/phy/mdio-xpcs.c
> >>>
> >>> Hi Ioana
> >>>
> >>> Thanks, I will take care of that.
> >>>
> >>>> Other than that, the new 'drivers/net/phy/phy/' path is somewhat
> >>>> repetitive but unfortunately I do not have another better suggestion.
> >>>
> >>> Me neither.
> >>>
> >>> I wonder if we are looking at the wrong part of the patch.
> >>> drivers/net/X/phy/
> >>> drivers/net/X/mdio/
> >>> drivers/net/X/pcs/
> >>>
> >>> Question is, what would X be?
> >>>
> >>>    Andrew
> >>
> >> It may not be a popular suggestion but can't we take the drivers/net/phy,
> >> drivers/net/pcs and drivers/net/mdio route?
> 
> +1

O.K. Then let me see what happens to the core code. How easy it is to
split up, or if it all need to be together, probably still in phy.

      Andrew
