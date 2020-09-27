Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C3279D3E
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 03:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgI0BDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 21:03:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgI0BDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 21:03:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kML5g-00GKvL-5k; Sun, 27 Sep 2020 03:03:00 +0200
Date:   Sun, 27 Sep 2020 03:03:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: Add per port
 devlink regions
Message-ID: <20200927010300.GD3889809@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-8-andrew@lunn.ch>
 <20200926235246.sk6jmeqdrd5oivj4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926235246.sk6jmeqdrd5oivj4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I was meaning to ask this since the global regions patchset, but I
> forgot.
> 
> Do we not expect to see, under the same circumstances, the same region
> snapshot on a big endian and on a little endian system?

We have never had any issues with endinness with MDIO. PHY/DSA drivers
work with host endian. The MDIO bus controller does what it needs to
do when shifting the bits out, as required by class 22 or 45.

netlink in general assume host endian, as far as i know. So a big
endian and a little endian snapshot are going to be different.

Arnd did an interesting presentation for LPC. He basically shows that
big endian is going away, with the exception of IBM big iron. I don't
expect an IBM Z to have a DSA switch!

       Andrew
