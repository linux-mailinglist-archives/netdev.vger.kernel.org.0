Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EAE2A8B7D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 01:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbgKFAgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 19:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732696AbgKFAgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 19:36:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB1F120759;
        Fri,  6 Nov 2020 00:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604622977;
        bh=tRqgcsdimRuU943pgSMhYm9axOpsG9cRtfmZCIbi+1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TxV5HNRjkNFmHVKKGj0rmhIUMfRKEeZf+PgQV540q4bZ3VVN7FGK9h9OdyAjmdmUj
         GxQM97Bai13yrh3l8oAKqoOzVAt88locMy3uaoLSEzExxzi8RhQwJdjJGgU2owPjYd
         nQzP5fB2SPZYsTKvVhmcKIrysUPYh4ttJ0XXmYBw=
Date:   Thu, 5 Nov 2020 16:36:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20201105163614.647d47c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 Nov 2020 14:50:55 +0200 Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set aims to actually add support for shared interrupts in
> phylib and not only for multi-PHY devices. While we are at it,
> streamline the interrupt handling in phylib.

Applied, thank you!
