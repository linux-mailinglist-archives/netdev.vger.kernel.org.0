Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDDD25DB7B
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730526AbgIDOYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:24:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730483AbgIDOXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:23:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kECd1-00DCyV-9k; Fri, 04 Sep 2020 16:23:47 +0200
Date:   Fri, 4 Sep 2020 16:23:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Adam =?utf-8?Q?Rudzi=C5=84ski?= <adam.rudzinski@arf.net.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
Message-ID: <20200904142347.GP3112546@lunn.ch>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
 <307b343b-2e8d-cb20-c22f-0e80acdf1dc9@arf.net.pl>
 <20200904134558.GL3112546@lunn.ch>
 <ed801431-2b46-5d6d-0cfd-a4b043702f9f@arf.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed801431-2b46-5d6d-0cfd-a4b043702f9f@arf.net.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 04:00:55PM +0200, Adam Rudziński wrote:
> W dniu 2020-09-04 o 15:45, Andrew Lunn pisze:
> > > Just a bunch of questions.
> > > 
> > > Actually, why is it necessary to have a full MDIO bus scan already during
> > > probing peripherals?
> > That is the Linux bus model. It does not matter what sort of bus it
> > is, PCI, USB, MDIO, etc. When the bus driver is loaded, the bus is
> > enumerated and drivers probe for each device found on the bus.
> 
> OK. But is it always expected to find all the devices on the bus in the
> first run?

Yes. Cold plug expects to find all the device while scanning the bus.

> Does the bus model ever allow to just add any more devices? Kind of,
> "hotplug". :)

Hotplug is triggered by hardware saying a new device has been
added/removed after cold plug.

This is not a hotplug case. The hardware has not suddenly appeared, it
has always been there.

   Andrew
