Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A7222C85
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgGPUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:12:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgGPUMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 16:12:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwAEk-005V6X-1F; Thu, 16 Jul 2020 22:12:10 +0200
Date:   Thu, 16 Jul 2020 22:12:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs even
 if first returned ffff:ffff
Message-ID: <20200716201210.GE1308244@lunn.ch>
References: <20200712164815.1763532-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200712164815.1763532-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Then the rest of the code just carried on thinking "ok, MMD 1 (PMA/PMD)
> says that there are 31 devices in that package, each having a device id
> of ffff:ffff, that's perfectly fine, let's go ahead and probe this PHY
> device".

With a device ID of ffff:ffff, what PHY driver was getting loaded?

> - MDIO_DEVS1=0x008a, MDIO_DEVS2=0x0000,
> - MDIO_DEVID1=0x0083, MDIO_DEVID2=0xe400

Now that we have valid IDs, is the same driver getting loaded? Do this
ID adding somewhere?

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
