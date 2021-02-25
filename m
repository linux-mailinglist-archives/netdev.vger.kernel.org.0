Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96433259EA
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhBYWy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:54:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhBYWyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 17:54:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFPVY-008Tg0-Vw; Thu, 25 Feb 2021 23:53:20 +0100
Date:   Thu, 25 Feb 2021 23:53:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: make mdio_bus_phy_suspend/resume as
 __maybe_unused
Message-ID: <YDgqYBmLFVWvKLX2@lunn.ch>
References: <20210225145748.404410-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225145748.404410-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:57:27PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_PM_SLEEP is disabled, the compiler warns about unused
> functions:
> 
> drivers/net/phy/phy_device.c:273:12: error: unused function 'mdio_bus_phy_suspend' [-Werror,-Wunused-function]
> static int mdio_bus_phy_suspend(struct device *dev)
> drivers/net/phy/phy_device.c:293:12: error: unused function 'mdio_bus_phy_resume' [-Werror,-Wunused-function]
> static int mdio_bus_phy_resume(struct device *dev)
> 
> The logic is intentional, so just mark these two as __maybe_unused
> and remove the incorrect #ifdef.
> 
> Fixes: 4c0d2e96ba05 ("net: phy: consider that suspend2ram may cut off PHY power")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
