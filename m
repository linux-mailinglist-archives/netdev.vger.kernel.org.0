Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446BC373376
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 03:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhEEBMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 21:12:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53534 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231805AbhEEBMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 21:12:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le64e-002ZFR-Sv; Wed, 05 May 2021 03:11:36 +0200
Date:   Wed, 5 May 2021 03:11:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 20/20] net: phy: add qca8k driver for
 qca8k switch internal PHY
Message-ID: <YJHwyPbklFgHVP3r@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-20-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-20-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* QCA specific MII registers access function */
> +static void qca8k_phy_dbg_write(struct mii_bus *bus, int phy_addr, u16 dbg_addr, u16 dbg_data)
> +{
> +	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	bus->write(bus, phy_addr, MII_ATH_DBG_ADDR, dbg_addr);
> +	bus->write(bus, phy_addr, MII_ATH_DBG_DATA, dbg_data);
> +	mutex_unlock(&bus->mdio_lock);
> +}

What are you locking against here?

     Andrew
