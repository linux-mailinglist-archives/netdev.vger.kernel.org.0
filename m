Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E501354722
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbhDET2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:28:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhDET2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 15:28:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTUsy-00Eyf2-TT; Mon, 05 Apr 2021 21:27:44 +0200
Date:   Mon, 5 Apr 2021 21:27:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGtksD5p5JVpnazu@lunn.ch>
References: <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
 <YGoSS7llrl5K6D+/@arch-linux>
 <YGsRwxwXILC1Tp2S@lunn.ch>
 <YGtdv++nv3H5K43E@arch-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGtdv++nv3H5K43E@arch-linux>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Now, instead of encoding this information of the bus' capabilities at both
> places, I'd propose just checking the mii_bus->capabilities field in the
> mdiobus_c45_*() functions. IMHO this would be a little cleaner, than having two
> places where this information is stored. What do you think about that?

You will need to review all the MDIO bus drivers to make sure they
correctly set the capabilities. There is something like 55 using
of_mdiobus_register() and 45 using mdiobus_register(). So you have 100
drivers to review.

	Andrew

