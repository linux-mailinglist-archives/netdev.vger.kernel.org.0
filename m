Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213546EC10
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240197AbhLIPsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:48:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:12979 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240158AbhLIPsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:48:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639064714; x=1670600714;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DKnB0fVSUxTvsZxpzsFNlUGooXd/ZY3HpAGAz8EIxNw=;
  b=royqvuq+ZzRBjbnxkctjXLNmn1Bjs2p7+ndyAo/jeSLk/Pe0nHgjA193
   n0rWZnHowiGR3O5z0Y7fgBKG0LzNFyPIbKf0CIctjy8NTU70LeDz3g/Gg
   F3GCNtWG81UTGk/2ZWAumOChXuH+I7UkL5dpm+RJE5iTzR2pVJRyjzKs/
   B9K1JEiXTN7m7RYw/0gj50jEim670A4kDwpo/4a21LqnQ2qw10Pxin5fI
   5Z+1p1RMQF7CilQgktbnvbE9YTZTcrorCnm0kYc5myP+CJp3pgVD7xJ5V
   nixaiHc2wJrgtYkKDFOrMZLf3W0TDTikqLG6ViOh6/cTODWq2QR+b3b3B
   Q==;
IronPort-SDR: qjX5i9owNzNmWTfAJ52bzCNypao1pQ9pMJ9XqxA8mG9lbBT9f3w5pK2MXisbB8L4tB718dJTNo
 sd4Mqt6TWmbwW90jvraL3Y8F/HZEkj/QeG4G87ZDaiMJ+X+r8l/rg22yMR1Cg6Ys6DimjctjgN
 BmF+jjQoPkFXr5joJvL37HuYt5/NdgvTIAy0yYuSCNvVCHPuAmCoewM5CAFvjtcYj4z/HSI3lA
 iAiG+uSZfo34TaxmlwjS0HJBzge/+pzPzViCBGx6IRNqBmefAp7z+rz0VL8DgTIT9CemmLeOFm
 QVI8QDD6AnpSU/toO15/fXTA
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="146103217"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 08:45:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Dec 2021 08:45:10 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 9 Dec 2021 08:45:10 -0700
Date:   Thu, 9 Dec 2021 16:47:09 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 5/6] net: lan966x: Add vlan support
Message-ID: <20211209154709.huq27gxgaqxgixku@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-6-horatiu.vultur@microchip.com>
 <20211209135928.25myffd3xzcnmndl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211209135928.25myffd3xzcnmndl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2021 13:59, Vladimir Oltean wrote:
> 
> On Thu, Dec 09, 2021 at 10:46:14AM +0100, Horatiu Vultur wrote:
> > +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> > +                           bool pvid, bool untagged)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +
> > +     /* Egress vlan classification */
> > +     if (untagged && port->vid != vid) {
> > +             if (port->vid) {
> > +                     dev_err(lan966x->dev,
> > +                             "Port already has a native VLAN: %d\n",
> > +                             port->vid);
> > +                     return -EBUSY;
> 
> Are you interested in supporting the use case from 0da1a1c48911 ("net:
> mscc: ocelot: allow a config where all bridge VLANs are egress-untagged")?
> Because it would be good if the driver was structured that way from the
> get-go instead of patching it later.

Currently not, but I don't know what will happen in 1 month or 6
months.

> 
> > +             }
> > +             port->vid = vid;
> > +     }
> > +
> > +     /* Default ingress vlan classification */
> > +     if (pvid)
> > +             port->pvid = vid;
> > +
> > +     return 0;
> > +}

-- 
/Horatiu
