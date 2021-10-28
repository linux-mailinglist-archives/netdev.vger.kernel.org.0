Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA0743E392
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhJ1O0E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Oct 2021 10:26:04 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:46711 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhJ1OZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:25:55 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 1D99B100006;
        Thu, 28 Oct 2021 14:23:20 +0000 (UTC)
Date:   Thu, 28 Oct 2021 16:23:20 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add FDMA support on ocelot switch driver
Message-ID: <20211028162320.7c07fdf3@xps-bootlin>
In-Reply-To: <20211028140738.4mozxpgltezu6zsm@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
        <20211028140738.4mozxpgltezu6zsm@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 28 Oct 2021 14:07:39 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Thu, Oct 28, 2021 at 03:49:29PM +0200, Clément Léger wrote:
> > This series adds support for the Frame DMA present on the VSC7514
> > switch. The FDMA is able to extract and inject packets on the
> > various ethernet interfaces present on the switch.
> > 
> > While adding FDMA support, bindings were switched from .txt to .yaml
> > and mac address read from device-tree was added to allow be set
> > instead of using random mac address.
> > 
> > Clément Léger (3):
> >   net: ocelot: add support to get mac from device-tree
> >   dt-bindings: net: convert mscc,vsc7514-switch bindings to yaml
> >   net: ocelot: add FDMA support
> > 
> >  .../bindings/net/mscc,vsc7514-switch.yaml     | 183 ++++
> >  .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
> >  drivers/net/ethernet/mscc/Makefile            |   1 +
> >  drivers/net/ethernet/mscc/ocelot.h            |   2 +
> >  drivers/net/ethernet/mscc/ocelot_fdma.c       | 811
> > ++++++++++++++++++ drivers/net/ethernet/mscc/ocelot_fdma.h       |
> > 60 ++ drivers/net/ethernet/mscc/ocelot_net.c        |  30 +-
> >  drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  20 +-
> >  include/linux/dsa/ocelot.h                    |  40 +-
> >  include/soc/mscc/ocelot.h                     |   2 +
> >  10 files changed, 1140 insertions(+), 92 deletions(-)
> >  create mode 100644
> > Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> > delete mode 100644
> > Documentation/devicetree/bindings/net/mscc-ocelot.txt create mode
> > 100644 drivers/net/ethernet/mscc/ocelot_fdma.c create mode 100644
> > drivers/net/ethernet/mscc/ocelot_fdma.h
> > 
> > -- 
> > 2.33.0
> >  
> 
> Oh yes, finally some care and attention for the ocelot switchdev
> driver. I'll review this soon, but I can't today.
> Will you be keeping the hardware for some extended period of time, and
> do you have some other changes planned as well?

Yes I'll keep the hardware for some time but I do not have other
changes planned yet. Maybe there will be additional changes later but
nothing sure.

Clément

