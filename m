Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC829A25
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404138AbfEXOgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:36:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56140 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403997AbfEXOgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 10:36:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3fJgvTqEhmBwQWcm4Ec4SKbVrWb5SDjuLaLyk06Zp2Y=; b=01B7wquOI6uQQAIirCyjpSwXbz
        nl6zSyrZOSxmzY/UUp4Q5FlKlIv5LTxypGJI/czt7WvtlUrQu1I8CdHNvaQMc+nOXoH+jO4ARLgAx
        QICRH/VVE/OJU/kGX3+TLA0AC2gM45XBWUEj1eNRgvhXlpgjtoMmQZ02Ue32Ew36Iivk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUBIk-0001fA-Rm; Fri, 24 May 2019 16:36:06 +0200
Date:   Fri, 24 May 2019 16:36:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V6] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190524143606.GN2979@lunn.ch>
References: <20190524142228.4003-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524142228.4003-1-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 04:22:28PM +0200, Marek Vasut wrote:
> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> BroadRReach 100BaseT1 PHYs used in automotive.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: linux-hwmon@vger.kernel.org
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> +static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
> +	{ "phy_symbol_error_count", 20, 0, GENMASK(15, 0) },
> +	{ "phy_polarity_detect", 25, 6, BIT(6) },
> +	{ "phy_open_detect", 25, 7, BIT(7) },
> +	{ "phy_short_detect", 25, 8, BIT(8) },
> +	{ "phy_rem_rcvr_count", 26, 0, GENMASK(7, 0) },
> +	{ "phy_loc_rcvr_count", 26, 8, GENMASK(15, 8) },
> +};

I don't like phy_polarity_detect, phy_open_detect and phy_short_detect
since they are not actually counters. But we don't have cable test
support yet. That is coming soon, but it is hard to say when, if it
will get merged this cycle. So lets keep them, but don't be too
surprised if they get removed later.

	Andrew
