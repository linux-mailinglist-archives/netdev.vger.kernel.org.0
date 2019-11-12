Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED340F9A03
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKLTsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:48:22 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52079 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726970AbfKLTsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:48:21 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: YlNcK9lCIKHws34cSle4hX9RaI2gt9ASRrHTBKacY6ykFYWC64KBVsErhWQS2sSQXa0ijBeFN/
 aaWuGdjoEPwGsXy7R82ftwYwzSC7Oir3eeG29hm3PdjnvEpa8Ytxea+qfqGvS/ZpZwVEP8Nq7g
 92qoKkIzXzTTy44UQKdYenkim5Rric6JlN9ZR3kvsnAenyPjJI3emZ6CgBUkzMKKx7PeBX6PDh
 EEI89OrgtkfRB857FhyqBRkrRP/5b4/Nj7uwfOU1NNpNF4skuwcIg8ECZ6gGY38hMCaxH7dUPy
 o8Y=
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="56734894"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 12:48:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 12:48:15 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 12:48:15 -0700
Date:   Tue, 12 Nov 2019 20:48:14 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
Message-ID: <20191112194814.gmenwbje3dg52s6l@lx-anielsen.microsemi.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch>
 <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
 <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
 <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/12/2019 21:26, Vladimir Oltean wrote:
> External E-Mail
> 
> 
> On Tue, 12 Nov 2019 at 21:10, Allan W. Nielsen
> <allan.nielsen@microchip.com> wrote:
> >
> > The 11/12/2019 17:26, Vladimir Oltean wrote:
> > > External E-Mail
> > >
> > >
> > > On Tue, 12 Nov 2019 at 16:57, Allan W. Nielsen
> > > <allan.nielsen@microchip.com> wrote:
> > > >
> > > > The 11/12/2019 15:50, Andrew Lunn wrote:
> > > > > External E-Mail
> > > > >
> > > > >
> > > > > > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > > > > > shouldn't you simply leave that one out and have felix in the existing
> > > > > > > > microchip folder?
> > > > > > > >
> > > > > > >
> > > > > > > I don't have a strong preference, although where I come from, all new
> > > > > > > NXP networking drivers are still labeled as "freescale" even though
> > > > > > > there is no code reuse. There are even less commonalities with
> > > > > > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > > > > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > > > > > I'm on the same page as Alexandre here.
> > > > >
> > > > > Leaving them where they are makes maintenance easier. Fixes are easier
> > > > > to backport if things don't move around.
> > > > >
> > > > > > I think we should leave vsc73xx where it is already, and put the felix driver in
> > > > > > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> > > > >
> > > > > Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> > > > > make changes over all DSA drivers at once, so it is nice they are all
> > > > > together. So i would prefer the DSA part of Felix is also there. But
> > > > > the core can be in drivers/net/ethernet/mscc/.
> > > > Ahh, my bad.
> > > >
> > > > In that case I do not have any strong feelings on this either.
> > > >
> > > > I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
> > > > driver. This one does not have an internal MIPS CPU.
> > > >
> > > > The vsc73xx, felix and the drivers in dsa/microchip does not share any
> > > > functionallity. Not in SW and not in HW.
> > > >
> > > > Maybe felix should just go directly into drivers/net/dsa/, and then if we add
> > > > support for VSC7511 then they can both live in drivers/net/dsa/ocelot/
> >
> >
> > A bit of background such that people outside NXP/MCHP has a better change to
> > follow and add to the discussion.
> >
> > Ocelot is a family name covering 4 VSC parts (VSC7511-14), and a IP used by NXP
> > (VSC9959).
> >
> > VSC7511-14 are all register compatible, it uses the same serdes etc.
> >
> > VSC7511/12 are "unmanaged" meaning that they do not have an embedded CPU.
> >
> > VSC7513/14 has an embedded MIPS CPU.
> >
> > VSC9959 not the same core as VSC7511-14, it is a newer generation with more
> > features, it is not register compatible, but all the basic functionallity is
> > very similar VSC7511-14 which is why it can call into the
> > drivers/net/ethernet/mscc/ocelot.c file.
> >
> > It is likely that NXP want to add more features in felix/VSC9959 which does not
> > exists in VSC7511-14.
> >
> > > When the felix driver is going to support the vsc7511 ocelot switch
> > > through the ocelot core, it will be naming chaos.
> > I do not think a VSC7511 will be based on Felix, but it will relay on the
> > refacturing/restructuring you have done in Ocelot.
> >
> > VSC7511 will use the same PCS and serdes settings as Ocelot (VSC7513/VSC7514)
> >
> > > Maybe we need to clarify what "felix" means (at the moment it means VSC9959).
> > Yes.
> >
> > > What if we just make it mean "DSA driver for Ocelot", and it supports both the
> > > VSC751x (Ocelot) and the VSC9959 (Felix) families?
> > I'm not too keen on using the felix name for that.
> >
> > Here is my suggestion:
> >
> > Drop the felix name and put it in drivers/net/dsa/ocelot_vsc9959* (this would be
> > my preference)
> >
> 
> This has one big issue: the name is very long! I can't see myself
> prefixing all function and structure names with ocelot_vsc9959_*.
> Felix is just 5 letters. And I can't use "ocelot" either, since that
> is taken :)
> So the DSA driver needs its own (short) name.
I certainly agree that ocelot_vsc9959_* is too long a prefix.

If you put it in drivers/net/dsa/ocelot_felix* or drivers/net/dsa/ocelot/felix*
then you can prefix with 'felix_'.

If you put it in drivers/net/dsa/ocelot_vsc9959* or drivers/net/dsa/ocelot/vsc9959*
then you can prefix with 'vsc9959_'.

The one thing all of this parts has in common is that they are all based on the
Ocelot family, which is why I suggest to include this into the path. It will
provide more information than putting it in the vitesse/microchip folders.

> > Or if you want the felix name put it in drivers/net/dsa/ocelot_felix*
> >
> > Or if we want folders put it in drivers/net/dsa/ocelot/vsc9959*
> >
> 
> The way I see an Ocelot DSA driver, it would be done a la mv88e6xxx,
> aka a single struct dsa_switch_ops registered for the entire family,
> and function pointers where the implementation differs. You're not
> proposing that here, but rather that each switch driver works in
> parallel with each other, and they all call into the Ocelot core. That
> would produce a lot more boilerplate, I think.
> And if the DSA driver for Ocelot ends up supporting more than 1
> device, its name should better not contain "vsc9959" since that's
> rather specific.
A vsc7511/12 will not share code with felix/vsc9959. I do not expect any other
IP/chip will be register compatible with vsc9959.

A vsc7511/12 will use the ocelot DSA tagger, but other from that it will call into the
ocelot driver (I think).

But to be honest, I do not think we should spend too much energy on vsc7511/12
now. When/if it comes, we will see how it fit best.

/Allan
