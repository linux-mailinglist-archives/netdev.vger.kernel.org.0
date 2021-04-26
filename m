Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D809436B007
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhDZIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:55:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28387 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhDZIzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 04:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619427282; x=1650963282;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AP8/vgZMLgLTPp4GWhqQOQD8yMyWeBlrSVvf3le8gkA=;
  b=QWv06zjcnKUmaP+DSGX0pHU6tE/eY7jj2aJKBrNngPoqzszPJTC6ANR5
   wXCskYPCZmCmutKgTRyCLPj0tFoLZ5gEi0YrBv7HjYZ7Y9QvFdkGfJJ/h
   DOr2ISUqeHHseiFqJQb5tHCeuJZBrsjUmjM2wSvtTtd83zcKkZzWyDLbf
   5eL+ekCNN6lIQukRSu6XS24ua82xaLJjDndmniKfGWVmhfXxQganfFfQV
   a4fkPqDQs8tV5RWGIHRGetOUJ3wWiPAc3JkWmwA19He/lAKAtC0uUirN+
   Jbzt0GAr7uaVVkmhiJGwf8d//OofJVWQT/wV8Nl8/lDPdTr/ykGWMFYGr
   g==;
IronPort-SDR: JQ55O2INFhmho3QO97hCvnd34s2JtzUVQRmYpgGVywThJiLibiI47yGkrUIDjgKKIaAlcRB9mo
 mHZuijgt0RCpsGfAn3M0VUeA59KGiOb1aRpSv21xut9hT2ybzlvnTHuG2un2TQgaDX/GI2Cqmv
 +aYnKN9GjXqtpW8RZfW0elnqkWmv85WcUXr4MdeqQnn5Gr/00nEHYQb201T5d2frahYX7/6enS
 cmDDQIwCyk5Xbp+gh+7gbgjduIWGsii/ZAAt9rrWG8xt/7L2smKOjPMOLBt1zebgl7gp/OabGT
 BOc=
X-IronPort-AV: E=Sophos;i="5.82,252,1613458800"; 
   d="scan'208";a="112169190"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2021 01:54:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 01:54:41 -0700
Received: from INB-LOAN0158.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 26 Apr 2021 01:54:37 -0700
Message-ID: <291ac605fe404b90c571f23f457f7f855eebf970.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 26 Apr 2021 14:24:35 +0530
In-Reply-To: <YIIGmpea6Mf0yzYS@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
         <20210422195921.utxdh5dn4ddltxkf@skbuf> <YIIGmpea6Mf0yzYS@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-23 at 01:28 +0200, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > > +
> > > +           lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > > +
> > > +           /* clear MII selection & set it based on interface later */
> > > +           data8 &= ~PORT_MII_SEL_M;
> > > +
> > > +           /* configure MAC based on p->interface */
> > > +           switch (p->interface) {
> > > +           case PHY_INTERFACE_MODE_MII:
> > > +                   lan937x_set_gbit(dev, false, &data8);
> > > +                   data8 |= PORT_MII_SEL;
> > > +                   break;
> > > +           case PHY_INTERFACE_MODE_RMII:
> > > +                   lan937x_set_gbit(dev, false, &data8);
> > > +                   data8 |= PORT_RMII_SEL;
> > > +                   break;
> > > +           default:
> > > +                   lan937x_set_gbit(dev, true, &data8);
> > > +                   data8 |= PORT_RGMII_SEL;
> > > +
> > > +                   data8 &= ~PORT_RGMII_ID_IG_ENABLE;
> > > +                   data8 &= ~PORT_RGMII_ID_EG_ENABLE;
> > > +
> > > +                   if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > > +                       p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> > > +                           data8 |= PORT_RGMII_ID_IG_ENABLE;
> > > +
> > > +                   if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> > > +                       p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> > > +                           data8 |= PORT_RGMII_ID_EG_ENABLE;
> > 
> > This is interesting. If you have an RGMII port connected to an external
> > PHY, how do you ensure that either the lan937x driver, or the PHY driver,
> > but not both, enable RGMII delays?
> 
> What generally happens is the MAC adds no delays, and the PHY acts
> upon the interface mode, inserting delays as requested.
> 
> There are a very small number of exceptions to this, for boards which
> have a PHY which cannot do delays, and the MAC can. If i remember
> correctly, this pretty much limited to one MAC vendor. In that case,
> the MAC adds delays, if the interface mode requests it, and it always
> passes PHY_INTERFACE_MODE_RGMII to the PHY so it does not add delays.
> 
> So what needs to be looked at here is what is passed to the phy
> connect call? passing p->interface is definitely wrong if the MAC is
> acting on it.
> 
> If even if the connect is correct, i would still prefer the MAC not do
> the delays, let the PHY do it, like nearly every other setup.
> 
>         Andrew
It comes here only if the port is not internal phy which means for MII
interface. As Andrew said, let the phy driver handles the delay if it has the
associated phy vendor driver, otherwise can still be added by MAC if required
(like for cpu port)?

What do you think on the following code?

	struct dsa_port *dp = dsa_to_port(dev->ds, port);
	struct phy_device *phy_dev = dp->slave->phydev;
	.
	.
	.

    	if (!phydev || phy_driver_is_genphy(phydev)) {
		/*Add RGMII internal delay*/
    	}


