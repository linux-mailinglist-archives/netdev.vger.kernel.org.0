Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA27F92B4
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKLOdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:33:49 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:12607 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLOdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:33:49 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: vyflLMw4yvZBuu1vZSAjpz23pAj03nCpVYSiRxD783dgmViXcF+msHkzoLb/JWbLXvqt3VGAD0
 qdCjbtWP976ld9l+ujqfHrDbxBy7K2hoscBWgTeyH4qJu3LprIpS1GqndK8a3RNIFSEPQjvIgx
 NtXd+p7RjHT/8ZT0VBN345Mm5VNdCCFPXiNG80Ae+nN4xuoGQsAHAXdu0WAlTbIXl1EA0DTF0E
 6QaalO1w8XmFtSUa74VYsLpk9Z6FX0j+R6zzLC7puynuWIBOg9qBFcaWNICBBVVyLqdzf++P89
 /RA=
X-IronPort-AV: E=Sophos;i="5.68,296,1569308400"; 
   d="scan'208";a="55166426"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2019 07:33:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 07:33:47 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 12 Nov 2019 07:33:48 -0700
Date:   Tue, 12 Nov 2019 15:33:46 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
Message-ID: <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-11-olteanv@gmail.com>
 <20191112130947.GE3572@piout.net>
 <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/12/2019 15:40, Vladimir Oltean wrote:
> External E-Mail
> 
> 
> On Tue, 12 Nov 2019 at 15:09, Alexandre Belloni
> <alexandre.belloni@bootlin.com> wrote:
> >
> > Hi,
> >
> > On 12/11/2019 14:44:18+0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > The vitesse/ folder will contain drivers for switching chips derived
> > > from legacy Vitesse IPs (VSC family), including those produced by
> > > Microsemi and Microchip (acquirers of Vitesse).
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/dsa/Kconfig                       | 31 +------------------
> > >  drivers/net/dsa/Makefile                      |  4 +--
> > >  drivers/net/dsa/vitesse/Kconfig               | 31 +++++++++++++++++++
> > >  drivers/net/dsa/vitesse/Makefile              |  3 ++
> > >  .../vsc73xx-core.c}                           |  2 +-
> > >  .../vsc73xx-platform.c}                       |  2 +-
> > >  .../vsc73xx-spi.c}                            |  2 +-
> > >  .../{vitesse-vsc73xx.h => vitesse/vsc73xx.h}  |  0
> > >  8 files changed, 39 insertions(+), 36 deletions(-)
> > >  create mode 100644 drivers/net/dsa/vitesse/Kconfig
> > >  create mode 100644 drivers/net/dsa/vitesse/Makefile
> > >  rename drivers/net/dsa/{vitesse-vsc73xx-core.c => vitesse/vsc73xx-core.c} (99%)
> > >  rename drivers/net/dsa/{vitesse-vsc73xx-platform.c => vitesse/vsc73xx-platform.c} (99%)
> > >  rename drivers/net/dsa/{vitesse-vsc73xx-spi.c => vitesse/vsc73xx-spi.c} (99%)
> > >  rename drivers/net/dsa/{vitesse-vsc73xx.h => vitesse/vsc73xx.h} (100%)
> > >
> >
> > As there are no commonalities between the vsc73xx and felix drivers,
> > shouldn't you simply leave that one out and have felix in the existing
> > microchip folder?
> >
> 
> I don't have a strong preference, although where I come from, all new
> NXP networking drivers are still labeled as "freescale" even though
> there is no code reuse. There are even less commonalities with
> Microchip (ex-Micrel, if I am not mistaken) KSZ switches than with the
> old vsc73xx. I'll let the ex-Vitesse people decide.
I'm on the same page as Alexandre here.

I think we should leave vsc73xx where it is already, and put the felix driver in
the drivers/net/ethernet/mscc/ folder where ocelot is already.

/Allan

