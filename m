Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E435621D05
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 20:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfEQSDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 14:03:35 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfEQSDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 14:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8rCx7aNMQgaaE3OVRIh3C6VMVTS2Gt7pMDRdweY6XAM=; b=XQgnUr8hCgnJ0R9prdh5dsb1A
        7XKlsWIiPt0ndUiAPagrcVgPUyDAE6M3+2I1a2SYzLGcaf8HP9++h1GjYEZoY0PeQ5q8ZqJI8ESCZ
        8eOjtjI1Qpr7+s/FE4AHKBb4bUYY1JkReFNNbB/UpXaYtwBflpnFh0w75lDZk6sCf2w0sKyLz8NbI
        vvkVlRlb14tQWWkRu14/mZGsFy3F4y8WcTLIuuMyR9D5U1yFRcVefzUAxEOlVp5EuK9FcdHA35m72
        V2jjoafC79Jl4drrr8te9tZLY+8eH4fG/kRDI+YL64CyIXSwU5tAh4dQ4u+iCmjEwrOxTTOKjw6q2
        bL3cwV1Ww==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:55842)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hRhCW-0001po-Hl; Fri, 17 May 2019 19:03:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hRhCU-0002QK-NF; Fri, 17 May 2019 19:03:22 +0100
Date:   Fri, 17 May 2019 19:03:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190517180322.wwjthwdyiyrgpbxg@shell.armlinux.org.uk>
References: <20190515143936.524acd4e@bootlin.com>
 <20190515132701.GD23276@lunn.ch>
 <20190515160214.1aa5c7d9@bootlin.com>
 <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
 <20190517171038.36d921a5@bootlin.com>
 <VI1PR0402MB2800630F0E9CCBE6A3FBCFBEE00B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <VI1PR0402MB2800630F0E9CCBE6A3FBCFBEE00B0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 05:37:00PM +0000, Ioana Ciornei wrote:
> > Subject: Re: dsa: using multi-gbps speeds on CPU port
> >=20
> > Hi everyone,
> >=20
> > On Wed, 15 May 2019 09:09:26 -0700
> > Florian Fainelli <f.fainelli@gmail.com> wrote:
> >=20
> > >On 5/15/19 7:02 AM, Maxime Chevallier wrote:
> > >> Hi Andrew,
> > >>
> > >> On Wed, 15 May 2019 15:27:01 +0200
> > >> Andrew Lunn <andrew@lunn.ch> wrote:
> > >>
> > >>> I think you are getting your terminology wrong. 'master' is eth0 in
> > >>> the example you gave above. CPU and DSA ports don't have netdev
> > >>> structures, and so any PHY used with them is not corrected to a
> > >>> netdev.
> > >>
> > >> Ah yes sorry, I'm still in the process of getting familiar with the
> > >> internals of DSA :/
> > >>
> > >>>> I'll be happy to help on that, but before prototyping anything, I =
wanted
> > >>>> to have your thougts on this, and see if you had any plans.
> > >>>
> > >>> There are two different issues here.
> > >>>
> > >>> 1) Is using a fixed-link on a CPU or DSA port the right way to do t=
his?
> > >>> 2) Making fixed-link support > 1G.
> > >>>
> > >>> The reason i decided to use fixed-link on CPU and DSA ports is that
> > >>> we already have all the code needed to configure a port, and an API
> > >>> to do it, the adjust_link() callback. Things have moved on since
> > >>> then, and we now have an additional API, .phylink_mac_config(). It
> > >>> might be better to directly use that. If there is a max-speed
> > >>> property, create a phylink_link_state structure, which has no
> > >>> reference to a netdev, and pass it to .phylink_mac_config().
> > >>>
> > >>> It is just an idea, but maybe you could investigate if that would
> > >>> work.
> >=20
> > I've quickly prototyped and tested this solution, and besides a few twe=
aks that
> > are needed on the mv88e6xxx driver side, it works fine.
> >=20
> > I'll post an RFC with this shortly, so that you can see what it looks l=
ike.
> >=20
> > As Russell said, there wasn't anything needed on the master interface s=
ide.
> >=20
> > >
> > >Vladimir mentioned a few weeks ago that he is considering adding
> > >support for PHYLIB and PHYLINK to run without a net_device instance,
> > >you two should probably coordinate with each other and make sure both
> > >of your requirements (which are likely the same) get addressed.
> >=20
> > That would help a lot solving this issue indeed, I'll be happy to help =
on that,
> > thanks for the tip !
> >=20
> > Maxime
> >=20
>=20
> Hi Maxime,
>=20
> I am currently maintaining some drivers for Freescale/NXP DPAA2 Ethernet.=
 This architecture has a management firmware that abstracts and simplifies =
the hardware configuration into a so called object model. DPAA2 is a little=
 too modular and you have the concept of a network interface object (DPNI) =
which is completely self-contained and separate from the hardware port itse=
lf (DPMAC). You can connect DPNIs to DPMACs but also DPNIs to one another. =
The dpaa2-eth driver conceptually handles a DPNI object. Among other things=
, the management firmware presents the link state information to the DPNI o=
bject as abstract as possible (speed, duplex, up/down etc.). The firmware g=
athers this information from whomever the DPNI is connected to. Since the f=
irmware can't reuse Linux PHY drivers due to incompatible licensing, we nee=
d another driver which acts as glue logic between the PHY drivers and the f=
irmware. This is the out-of-tree dpmac driver that notifies the firmware of=
 any external PHY events. At the end of the day, the dpaa2-eth driver gets =
notified of these external PHY events after the firmware itself is notified=
 and raises an interrupt line.=20
>=20
> To start the PHY state machine for a port, the dpmac driver must fabricat=
e a netdevice which it does not register with the stack. One would, of cour=
se, suggest to move the PHY management directly into the dpaa2-eth driver. =
But the firmware's ABI is already stable and besides, it is not desirable t=
o grant MDIO access to users of the DPNI object.
>=20
> Obviously, that fake netdevice has to go before the dpmac driver sees mai=
nline. What you guys are proposing (the phylink/netdev decoupling) would al=
so benefit our scenario. I talked to Vladimir and we'll make sure that what=
ever works for us is also benefiting the DSA cpu/cascade port. Hopefully we=
'll have some patches early next week.

For SFP, I've already removed much of the netdev bits from that layer,
but I don't see any way to really get rid of it from phylink - we need
access to the netdev state there to know what the carrier state is for
the netdev (phylink tracks that state and manages the carrier state on
behalf of the MAC driver.)

--=20
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps =
up
According to speedtest.net: 11.9Mbps down 500kbps up
