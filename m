Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEE4107806
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfKVTaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:30:19 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37033 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfKVTaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 14:30:18 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: bxFAU/KywwCcd2H8Wp4lJ8iowKZppKGXPqD1P+0mzpYO6VXrWtfQUCHGKQ1IiO4JA4Jb1MERLh
 tuuC5mMi0vZWWCnYS+3hEnnYOXxF7ds1LE//FC6/V8DEQ7MQcjRFYmYEYYlzP2e8UV1kMLOxdR
 uVR3t8I/sxlrnAcZ8Wk1JoOAQC/iYqzg1PXDMvnYZlSf89+wfQatIxs5X68gePNmrr5GBRfdog
 b/t4WEm3VS5CGEREllSvQphF8Or26wvnMdtlr+38N1eQvAwQ+iUawg78wYDTi5cmfWWwIvECb3
 dio=
X-IronPort-AV: E=Sophos;i="5.69,230,1571727600"; 
   d="scan'208";a="56600415"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2019 12:30:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 22 Nov 2019 12:30:17 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 22 Nov 2019 12:30:17 -0700
Date:   Fri, 22 Nov 2019 20:30:16 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20191122193015.zooiv6px4e6uf2my@soft-dev3.microsemi.net>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
 <20191119214257.GB19542@lunn.ch>
 <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
 <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
 <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
 <20191121001855.GC18325@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191121001855.GC18325@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/21/2019 01:18, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > Not really, at that point it was OK to have interface
> > PHY_INTERFACE_MODE_NA. There were few more checks before creating the
> > network device. Now with your changes you were creating
> > a network device for each port of the soc even if some ports
> > were not used on a board.
> 
> That does not sound right. If the port is not used, the DSA core will
> call port_disable() to allow the driver to power off the port. It will
> not create a network device for it.
> 
> Or is this just an issue with the switchdev driver, not the DSA
> driver?
In my case I just use the switchdev driver. I don't have the DSA driver.

> 
>         Andrew
> > > >                 serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> > > > -               if (IS_ERR(serdes)) {
> > > > -                       err = PTR_ERR(serdes);
> > > > -                       if (err == -EPROBE_DEFER)
> > > > -                               dev_dbg(ocelot->dev, "deferring probe\n");
> > >
> > > Why did you remove the probe deferral for the serdes phy?
> > Because not all the ports have the "phys" property.
> 
> You probably need to differentiate between ENODEV and EPROBE_DEFER.
> You definitely do need to return EPROBE_DEFER if you get that.
Thanks, I will keep it in mind.

> Shame you cannot use devm_phy_optional_get().
> 
>     Andrew

-- 
/Horatiu
