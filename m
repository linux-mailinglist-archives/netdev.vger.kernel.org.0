Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7FAFAC6E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfKMI6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:58:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55685 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfKMI6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 03:58:03 -0500
X-Originating-IP: 92.137.17.54
Received: from localhost (alyon-657-1-975-54.w92-137.abo.wanadoo.fr [92.137.17.54])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B715760009;
        Wed, 13 Nov 2019 08:57:59 +0000 (UTC)
Date:   Wed, 13 Nov 2019 09:57:59 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 07/12] net: mscc: ocelot: separate the
 implementation of switch reset
Message-ID: <20191113085759.GJ3572@piout.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-8-olteanv@gmail.com>
 <20191112135559.GI5090@lunn.ch>
 <CA+h21hpH7O_O83KD-oEJ4c7iu2VsXJFQm2upNadD7xxOv7dvfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpH7O_O83KD-oEJ4c7iu2VsXJFQm2upNadD7xxOv7dvfw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 15:59:37+0200, Vladimir Oltean wrote:
> On Tue, 12 Nov 2019 at 15:56, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Tue, Nov 12, 2019 at 02:44:15PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > The Felix switch has a different reset procedure, so a function pointer
> > > needs to be created and added to the ocelot_ops structure.
> > >
> > > The reset procedure has been moved into ocelot_init.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot.c       |  3 ++
> > >  drivers/net/ethernet/mscc/ocelot.h       |  1 +
> > >  drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------
> >
> > I'm wondering about the name board. So far, the code you have moved
> > into ocelot_board has nothing to do with the board as such. This is
> > not a GPIO used to reset the switch, it is not a regulator, etc. It is
> > all internal to the device, but just differs per family. Maybe you can
> > think of a better name?
> >
> 
> Alexandre, what do you think? I agree "ocelot_board" is a bit strange.
> 

The name was coming from mscc, Allan agreed to rename it to
ocelot_vsc7514.c which would make sense.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
