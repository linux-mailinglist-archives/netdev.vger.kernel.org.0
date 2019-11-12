Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E11F9963
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfKLTKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:10:02 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5909 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfKLTKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:10:02 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: hmzTPo4x6ASnctdl+tNQxVylNmMGpAwJ7ZRH+08lUPmSaWmgGcspxxPQzR1zgCf83Xwvjcc6bO
 nF7t1VX4zw9IGkmsmzyBd5Hi2xF4ywew1WeqpLZPTt/96PkwlNKMFJnhuPsGC+7BnCy7PHOOvu
 VshMwlIb2JtztAEFOSV3/oe59hdBeHKzbDDDvuTkX2ciAICb3WXAEW6bmijg6jgTriOEs7/54e
 pYttoUz3MyTEM2oLkeDak7wjb0kXn2CeG/xo9GTfHoSTMrl7BVwpBzMTEJKPRjCL6l2fWY0ueB
 w2g=
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="58083372"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 12:09:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 12:09:58 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 12:09:58 -0700
Date:   Tue, 12 Nov 2019 20:09:57 +0100
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
Message-ID: <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch>
 <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/12/2019 17:26, Vladimir Oltean wrote:
> External E-Mail
> 
> 
> On Tue, 12 Nov 2019 at 16:57, Allan W. Nielsen
> <allan.nielsen@microchip.com> wrote:
> >
> > The 11/12/2019 15:50, Andrew Lunn wrote:
> > > External E-Mail
> > >
> > >
> > > > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > > > shouldn't you simply leave that one out and have felix in the existing
> > > > > > microchip folder?
> > > > > >
> > > > >
> > > > > I don't have a strong preference, although where I come from, all new
> > > > > NXP networking drivers are still labeled as "freescale" even though
> > > > > there is no code reuse. There are even less commonalities with
> > > > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > > > I'm on the same page as Alexandre here.
> > >
> > > Leaving them where they are makes maintenance easier. Fixes are easier
> > > to backport if things don't move around.
> > >
> > > > I think we should leave vsc73xx where it is already, and put the felix driver in
> > > > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> > >
> > > Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> > > make changes over all DSA drivers at once, so it is nice they are all
> > > together. So i would prefer the DSA part of Felix is also there. But
> > > the core can be in drivers/net/ethernet/mscc/.
> > Ahh, my bad.
> >
> > In that case I do not have any strong feelings on this either.
> >
> > I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
> > driver. This one does not have an internal MIPS CPU.
> >
> > The vsc73xx, felix and the drivers in dsa/microchip does not share any
> > functionallity. Not in SW and not in HW.
> >
> > Maybe felix should just go directly into drivers/net/dsa/, and then if we add
> > support for VSC7511 then they can both live in drivers/net/dsa/ocelot/


A bit of background such that people outside NXP/MCHP has a better change to
follow and add to the discussion.

Ocelot is a family name covering 4 VSC parts (VSC7511-14), and a IP used by NXP
(VSC9959).

VSC7511-14 are all register compatible, it uses the same serdes etc.

VSC7511/12 are "unmanaged" meaning that they do not have an embedded CPU.

VSC7513/14 has an embedded MIPS CPU.

VSC9959 not the same core as VSC7511-14, it is a newer generation with more
features, it is not register compatible, but all the basic functionallity is
very similar VSC7511-14 which is why it can call into the
drivers/net/ethernet/mscc/ocelot.c file.

It is likely that NXP want to add more features in felix/VSC9959 which does not
exists in VSC7511-14.

> When the felix driver is going to support the vsc7511 ocelot switch
> through the ocelot core, it will be naming chaos.
I do not think a VSC7511 will be based on Felix, but it will relay on the
refacturing/restructuring you have done in Ocelot.

VSC7511 will use the same PCS and serdes settings as Ocelot (VSC7513/VSC7514)

> Maybe we need to clarify what "felix" means (at the moment it means VSC9959).
Yes.

> What if we just make it mean "DSA driver for Ocelot", and it supports both the
> VSC751x (Ocelot) and the VSC9959 (Felix) families?
I'm not too keen on using the felix name for that.

Here is my suggestion:

Drop the felix name and put it in drivers/net/dsa/ocelot_vsc9959* (this would be
my preference)

Or if you want the felix name put it in drivers/net/dsa/ocelot_felix*

Or if we want folders put it in drivers/net/dsa/ocelot/vsc9959*

When we get to it, we can add vsc7511/12 in drivers/net/dsa/ocelot_vsc7512*

To be consisten and clean up (my) earlier mistake we should rename the
drivers/net/ethernet/mscc/ocelot_board.c to
drivers/net/ethernet/mscc/ocelot_vsc7514.c (as it is really not board stuff, but
ocelot internal cpu stuff).

Andrew also pointed out that the stuff put into this file did not seem very
board related.

> Is anybody else instantiating the VSC9959 core, or close derivatives, except
> NXP LS1028A? If the answer is yes, are those other instantiations PCI devices,
> or something else?
Not what I'm aware of.

> I would appreciate if you could take a
> look through the probing part of patch 11/12 (the "felix_instance_tbl"
> part and felix-regs.c) and see if there are any naming changes I can
> make that would make it easier for you to fit in one more device.
Will do.

> Of course, I don't expect to make radical changes, you'd still need to do some
> refactoring if you decide to add your vsc7511, I just care that the
> refactoring doesn't change any current semantics.
The majority of the needed changes to add vsc7511 has been done by now ;-)

/Allan

