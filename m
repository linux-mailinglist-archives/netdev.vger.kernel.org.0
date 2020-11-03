Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D812A4BD3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgKCQpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:45:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCQpC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 11:45:02 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZzQK-0053aE-FS; Tue, 03 Nov 2020 17:44:44 +0100
Date:   Tue, 3 Nov 2020 17:44:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next v2 00/19] net: phy: add support for shared
 interrupts (part 1)
Message-ID: <20201103164444.GL1042051@lunn.ch>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:50:55PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set aims to actually add support for shared interrupts in
> phylib and not only for multi-PHY devices. While we are at it,
> streamline the interrupt handling in phylib.

Hi Ioana

I did some quick testing with the Marvell PHY. This is one of the
drivers you have not changed. But it at least tests some of the core
changes.

Tested-by: Andrew Lunn <andrew@lunn.ch>

I will try to review the actual changes soon.

    Andrew
