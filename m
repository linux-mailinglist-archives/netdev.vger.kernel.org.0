Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181CF2B6455
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 14:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgKQNp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 08:45:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732499AbgKQNp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 08:45:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kf1Ip-007XoC-07; Tue, 17 Nov 2020 14:45:47 +0100
Date:   Tue, 17 Nov 2020 14:45:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
Message-ID: <20201117134546.GA1797886@lunn.ch>
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com>
 <20201110102552.GZ1551@shell.armlinux.org.uk>
 <87blg5qou5.fsf@microchip.com>
 <20201110151248.GA1551@shell.armlinux.org.uk>
 <87a6voqntq.fsf@microchip.com>
 <20201115121921.GI1551@shell.armlinux.org.uk>
 <877dqkqly5.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dqkqly5.fsf@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you have the Marvell PHY driver either built-in or available as a
> > module? I suspect the problem is you don't. You will need the Marvell
> > PHY driver to correctly drive the PHY, you can't rely on the fallback
> > driver for SFPs.
> Correct.  I was using the generic driver and that does clearly not
> work.  After including the Marvell driver the callback to the validate
> function happens as expected.  Thanks for the support.

Hi Russell

Maybe we should have MDIO_I2C driver select the Marvell PHY driver?

      Andrew
