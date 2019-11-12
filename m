Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE92F9371
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKLO5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:57:36 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:19548 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:57:36 -0500
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
IronPort-SDR: UEz06bpbq8Vgi4hFCMScPaFIhbiAfUI2vW4Tc9UysC3/2D/N1gr2fE48loH5SuwqwanaWX+cDU
 V4tBNVHZRNz6wAfaj/8L0KUP9J3dwICqE5QrxZo0Xm4hI1LOVVJ+PsttijHU9P6ddB9AfSKAcL
 R3cS6bQ/4HkKrVlCSBAWoahDP86bI4sGj0gwiVFP2uEdqu6Lkv9nj1FsZ6wzg98jqSDK5A+2I5
 7u06g0R1Mml39Dsah5wCD1s6QeZwI/RrWL1RJomwmMqR2BC19mfBSwaVj6hph9Ve+7oPpXFPor
 t5c=
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="56687008"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 07:57:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 07:57:33 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 07:57:33 -0700
Date:   Tue, 12 Nov 2019 15:57:32 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191112145054.GG10875@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/12/2019 15:50, Andrew Lunn wrote:
> External E-Mail
> 
> 
> > > > As there are no commonalities between the vsc73xx and felix drivers,
> > > > shouldn't you simply leave that one out and have felix in the existing
> > > > microchip folder?
> > > >
> > > 
> > > I don't have a strong preference, although where I come from, all new
> > > NXP networking drivers are still labeled as "freescale" even though
> > > there is no code reuse. There are even less commonalities with
> > > Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> > > old vsc73xx. I'll let the ex-Vitesse people decide.
> > I'm on the same page as Alexandre here.
> 
> Leaving them where they are makes maintenance easier. Fixes are easier
> to backport if things don't move around.
> 
> > I think we should leave vsc73xx where it is already, and put the felix driver in
> > the drivers/net/ethernet/mscc/ folder where ocelot is already.
> 
> Currently, all DSA drivers are in drivers/net/dsa. We do occasionally
> make changes over all DSA drivers at once, so it is nice they are all
> together. So i would prefer the DSA part of Felix is also there. But
> the core can be in drivers/net/ethernet/mscc/.
Ahh, my bad.

In that case I do not have any strong feelings on this either.

I should say that we are discussing to add support for a Ocelot VSC7511 as a DSA
driver. This one does not have an internal MIPS CPU.

The vsc73xx, felix and the drivers in dsa/microchip does not share any
functionallity. Not in SW and not in HW.

Maybe felix should just go directly into drivers/net/dsa/, and then if we add
support for VSC7511 then they can both live in drivers/net/dsa/ocelot/

/Allan
