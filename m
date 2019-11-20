Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB76A1046EE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 00:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfKTXV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 18:21:57 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:55827 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTXV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 18:21:56 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: CWA8wLNhd8rKqvYtMgHLUbby0InRLkS1xvKnb+a5+yacHeJLsJTZIlUNRXITN6GpPTvH/uVqB9
 lgoHFdkGM9mxDhBPt246FgTGgebEG+ZhSCo8Eb6Vbx+0RRsFGwk+Ls+UpuQEongeLN0QD8uKsh
 LHpFSPt1xBNfNULR+dac8PsHDgvKpP9CPvvQshVeczLNUfk3u2gYqvwxp4tJoz9eTbNHLpPStV
 qJmqm0wVMZin/gZoskbRwWeBJbws3EnFgAI7M0cS66cPgz7EV2Qfl5T16Lcr84ibRXTA7keuYo
 0AU=
X-IronPort-AV: E=Sophos;i="5.69,223,1571727600"; 
   d="scan'208";a="57837839"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Nov 2019 16:21:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Nov 2019 16:21:55 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 20 Nov 2019 16:21:54 -0700
Date:   Thu, 21 Nov 2019 00:21:53 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
 <20191119214257.GB19542@lunn.ch>
 <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
 <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  };
> >
> >  &port0 {
> > +       phy-mode = "sgmii";
> >         phy-handle = <&phy0>;
> >  };
> >
> >  &port1 {
> > +       phy-mode = "sgmii";
> >         phy-handle = <&phy1>;
> >  };
> >
> >  &port2 {
> > +       phy-mode = "sgmii";
> >         phy-handle = <&phy2>;
> >  };
> >
> >  &port3 {
> > +       phy-mode = "sgmii";
> >         phy-handle = <&phy3>;
> >  };
> > diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
> > index aecaf4ef6ef4..9dad031900b5 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_board.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_board.c
> > @@ -513,6 +513,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >                 if (IS_ERR(regs))
> >                         continue;
> >
> > +               of_get_phy_mode(portnp, &phy_mode);
> > +               if (phy_mode == PHY_INTERFACE_MODE_NA)
> > +                       continue;
> > +
> 
> So this effectively reverts your own patch 4214fa1efffd ("net: mscc:
> ocelot: omit error check from of_get_phy_mode")?

Not really, at that point it was OK to have interface
PHY_INTERFACE_MODE_NA. There were few more checks before creating the
network device. Now with your changes you were creating
a network device for each port of the soc even if some ports
were not used on a board. Also with your changes you first create the
port and after that you create the phylink but between these two calls it
was the switch which continue for the interface PHY_INTERFACE_MODE_NA,
which is not correct. So these are the 2 reason why I have added the
property phy-mode to the ports and add back the check to see which ports
are used on each board.

> 
> >                 err = ocelot_probe_port(ocelot, port, regs);
> >                 if (err) {
> >                         of_node_put(portnp);
> > @@ -523,11 +527,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >                 priv = container_of(ocelot_port, struct ocelot_port_private,
> >                                     port);
> >
> > -               of_get_phy_mode(portnp, &phy_mode);
> > -
> >                 switch (phy_mode) {
> > -               case PHY_INTERFACE_MODE_NA:
> > -                       continue;
> >                 case PHY_INTERFACE_MODE_SGMII:
> >                         break;
> >                 case PHY_INTERFACE_MODE_QSGMII:
> > @@ -549,20 +549,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
> >                 }
> >
> >                 serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> > -               if (IS_ERR(serdes)) {
> > -                       err = PTR_ERR(serdes);
> > -                       if (err == -EPROBE_DEFER)
> > -                               dev_dbg(ocelot->dev, "deferring probe\n");
> 
> Why did you remove the probe deferral for the serdes phy?
Because not all the ports have the "phys" property.
> 
> > -                       else
> > -                               dev_err(ocelot->dev,
> > -                                       "missing SerDes phys for port%d\n",
> > -                                       port);
> > -
> > -                       of_node_put(portnp);
> > -                       goto out_put_ports;
> > -               }
> > -
> > -               if (serdes) {
> > +               if (!IS_ERR(serdes)) {
> >                         err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
> >                                                phy_mode);
> >                         if (err) {
> > --
> > 2.17.1
> >
> >
> > >
> > >    Andrew
> >
> > --
> > /Horatiu
> 
> Thanks,
> -Vladimir

-- 
/Horatiu
