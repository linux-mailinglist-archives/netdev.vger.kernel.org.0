Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8771CFAB19
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 08:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfKMHiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 02:38:25 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:50597 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfKMHiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 02:38:25 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: QYvUSvPoLLKEv3gD5yzbwI/5k7CIJzm8q4qRVVBIDzjPFn7hUjlgy/rCC74+Oo4r07A0j6RHaS
 lKq6CjVT33J7JkOL5hvXkphmOjhARJVdmVOJU4trBUt1PQynU7TRO/gGQvZwv5HRlLTIZ+su+1
 cW6hkj04gWExpCFepXF5k5EMc0crwayO8rSlXD0DrLeKLSuMIIaWmXS/me3PtU2jtGXHJf+iCt
 JfCRJXTOtBkUesmCVKEpnmAnRRfCksN7+EkiBQRvzqaZUWqSLU41yO/cGURkIQBLioKsipR8bt
 ICM=
X-IronPort-AV: E=Sophos;i="5.68,299,1569308400"; 
   d="scan'208";a="54094311"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 00:38:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 00:38:23 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 13 Nov 2019 00:38:22 -0700
Date:   Wed, 13 Nov 2019 08:38:22 +0100
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
Message-ID: <20191113073822.wlsgalzznlng2owt@lx-anielsen.microsemi.net>
References: <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch>
 <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
 <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
 <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com>
 <20191112194814.gmenwbje3dg52s6l@lx-anielsen.microsemi.net>
 <CA+h21hrh4oYs3j3cOz4Afe2GSbU9ME+nzoRaZ4D22mu9_jkO=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hrh4oYs3j3cOz4Afe2GSbU9ME+nzoRaZ4D22mu9_jkO=g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > The way I see an Ocelot DSA driver, it would be done a la mv88e6xxx,
> > > aka a single struct dsa_switch_ops registered for the entire family,
> > > and function pointers where the implementation differs. You're not
> > > proposing that here, but rather that each switch driver works in
> > > parallel with each other, and they all call into the Ocelot core. That
> > > would produce a lot more boilerplate, I think.
> > > And if the DSA driver for Ocelot ends up supporting more than 1
> > > device, its name should better not contain "vsc9959" since that's
> > > rather specific.
> > A vsc7511/12 will not share code with felix/vsc9959. I do not expect any other
> > IP/chip will be register compatible with vsc9959.
> I don't exactly understand this comment. Register-incompatible in a
> logical sense, or in a layout sense? Judging from the attachment in
> chapter 6 of the VSC7511 datasheet [1], at least the basic
> functionality appears to be almost the same. And for the rest, there's
> regmap magic.
My point is that vsc7511 has more in commen with vsc7514 than it has with
felix/vsc9959.

vsc7511 will use the same regmaps as those in vsc7514 (with different helper
functions as it will be accessing the reguster via SPI).

As far as I recall, felix/vsc9959 has slightly different (in-compatible) PTP
functionallity than vsc7511-14, which needs to be handled in the felix/vsc9959
driver. The same apply if you want to add support for TAS/taprio as this
featurte are not to be found in vsc7511-14.

> > A vsc7511/12 will use the ocelot DSA tagger, but other from that it will call into the
> > ocelot driver (I think).
> >
> > But to be honest, I do not think we should spend too much energy on vsc7511/12
> > now. When/if it comes, we will see how it fit best.
> 
> Ok. So the driver will still be called "felix", it will instantiate a
> struct felix_info_vsc9959 instead of the current felix_info_ls1028a,
> but will live in the root drivers/net/dsa folder. Then, when/if you
> add support for vsc7511, you'll move both into an "ocelot" folder and
> figure out how much of the driver minus the tagger is worth reusing
> (aka instantiate a struct felix_info_vsc7511). Agree?
Agree.

/Allan
