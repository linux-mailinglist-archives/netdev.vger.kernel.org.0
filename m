Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECD2297DF0
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 20:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1763678AbgJXSK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 14:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763671AbgJXSKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 14:10:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22262C0613CE;
        Sat, 24 Oct 2020 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q2qXgGdzj4L8j+jXytIL6k3GCXZEZ2jHlP9NdG+kfiE=; b=v6P6XV8JYqUM6/zC/DDUpY1DU
        4PHk9E5aL7cwy6rKP5XYKCneMBaeH/bRzTFlBU+AGj5UBEFqvixuHwmEzhGGM9uclyHqTOP9wxKMM
        3zEDdo+7/E2GA8czNSzZ0/dYOl0NUeDGnb9TameVLMeYKGszVH6pUuAIBNHjOpcqeMoZuZ9WQFitG
        rtrHfEKq27ZZzCnzEt/QgGz49qtkc01RR5AzOrfp2NePO7g1bcND9W9a1AtAvyqyAemws4+yJd2d9
        dOINIn7OemizW22oPhf9ZRpym3naGc7prKhkChWNBWbQ7c9jbZonFsavDX0pbC0l0z19veLnuk7dG
        2BN/C1u+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50478)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kWNzR-0004wn-5p; Sat, 24 Oct 2020 19:10:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kWNzF-0001EU-BE; Sat, 24 Oct 2020 19:09:53 +0100
Date:   Sat, 24 Oct 2020 19:09:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
Message-ID: <20201024180952.GG1551@shell.armlinux.org.uk>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
 <20201024171705.GK745568@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201024171705.GK745568@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 07:17:05PM +0200, Andrew Lunn wrote:
> > - Every PHY driver gains a .handle_interrupt() implementation that, for
> >   the most part, would look like below:
> > 
> > 	irq_status = phy_read(phydev, INTR_STATUS);
> > 	if (irq_status < 0) {
> > 		phy_error(phydev);
> > 		return IRQ_NONE;
> > 	}
> > 
> > 	if (irq_status == 0)
> > 		return IRQ_NONE;
> > 
> > 	phy_trigger_machine(phydev);
> > 
> > 	return IRQ_HANDLED;
> 
> Hi Ioana
> 
> It looks like phy_trigger_machine(phydev) could be left in the core,
> phy_interrupt(). It just needs to look at the return code, IRQ_HANDLED
> means trigger the state machine.

Is this appropriate for things such as the existing user of
handle_interrupt - vsc8584_handle_interrupt() ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
