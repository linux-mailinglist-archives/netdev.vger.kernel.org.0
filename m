Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C842B3943
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 21:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKOU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 15:56:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgKOU4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 15:56:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keP4c-007EDm-OK; Sun, 15 Nov 2020 21:56:34 +0100
Date:   Sun, 15 Nov 2020 21:56:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Robert Hancock <robert.hancock@calian.com>
Subject: Re: [PATCH RESEND net-next 06/18] net: phy: marvell: remove the use
 of .ack_interrupt()
Message-ID: <20201115205634.GH1701029@lunn.ch>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
 <20201113165226.561153-7-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113165226.561153-7-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 06:52:14PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> In preparation of removing the .ack_interrupt() callback, we must replace
> its occurrences (aka phy_clear_interrupt), from the 2 places where it is
> called from (phy_enable_interrupts and phy_disable_interrupts), with
> equivalent functionality.
> 
> This means that clearing interrupts now becomes something that the PHY
> driver is responsible of doing, before enabling interrupts and after
> clearing them. Make this driver follow the new contract.
> 
> Cc: Maxim Kochetkov <fido_max@inbox.ru>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Robert Hancock <robert.hancock@calian.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Hi Ioana

I tested this series on a couple of Marvell Ethernet switches with
integrated PHYs using interrupts. Please feel free to add

Tested-by: Andrew Lunn <andrew@lunn.ch>

to this and the previous patch.

    Andrew
