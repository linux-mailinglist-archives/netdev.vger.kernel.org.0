Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6797835CFA2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244303AbhDLRpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:45:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243722AbhDLRpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 13:45:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW0cI-00GJfe-8V; Mon, 12 Apr 2021 19:44:54 +0200
Date:   Mon, 12 Apr 2021 19:44:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: fix detection of PHY on Topaz
 switches
Message-ID: <YHSHFjcxDauzOP1v@lunn.ch>
References: <20210412121430.20898-1-pali@kernel.org>
 <20210412165739.27277-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210412165739.27277-1-pali@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 06:57:39PM +0200, Pali Rohár wrote:
> Since commit fee2d546414d ("net: phy: marvell: mv88e6390 temperature
> sensor reading"), Linux reports the temperature of Topaz hwmon as
> constant -75°C.
> 
> This is because switches from the Topaz family (88E6141 / 88E6341) have
> the address of the temperature sensor register different from Peridot.
> 
> This address is instead compatible with 88E1510 PHYs, as was used for
> Topaz before the above mentioned commit.
> 
> Create a new mapping table between switch family and PHY ID for families
> which don't have a model number. And define PHY IDs for Topaz and Peridot
> families.
> 
> Create a new PHY ID and a new PHY driver for Topaz's internal PHY.
> The only difference from Peridot's PHY driver is the HWMON probing
> method.
> 
> Prior this change Topaz's internal PHY is detected by kernel as:
> 
>   PHY [...] driver [Marvell 88E6390] (irq=63)
> 
> And afterwards as:
> 
>   PHY [...] driver [Marvell 88E6341 Family] (irq=63)
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> BugLink: https://github.com/globalscaletechnologies/linux/issues/1
> Fixes: fee2d546414d ("net: phy: marvell: mv88e6390 temperature sensor reading")
> Reviewed-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
