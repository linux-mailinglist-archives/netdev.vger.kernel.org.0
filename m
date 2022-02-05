Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4352B4AACD3
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 23:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbiBEWCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 17:02:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbiBEWCZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 17:02:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fj6soXATaJNNoX9QBPtiuZ3HdCimHzkDVsFl35DUbMg=; b=YkCSXdLjcZv8vWvDA/hr+bg+2q
        HSMYwfFAkAmfKIZlT48sVCAdGYGjXA9HSQ6FI1/H978OGTAfPBy3/Q+/QHr7IQ7bP8bILAEPlazJ/
        o+NKODcEYn1qL2aARqoaeyaStOYZCZHguJts/1Cu9PdUMHQNHTTiHmSnt5N2XHtCpm4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGT8B-004RBJ-V7; Sat, 05 Feb 2022 23:02:07 +0100
Date:   Sat, 5 Feb 2022 23:02:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ron Madrid <ron_madrid@sbcglobal.net>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: marvell: Fix MDI-x polarity setting in
 88e1118-compatible PHYs
Message-ID: <Yf7z33SdwW9dwTdD@lunn.ch>
References: <20220205214951.60371-1-Pavel.Parkhomenko@baikalelectronics.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205214951.60371-1-Pavel.Parkhomenko@baikalelectronics.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 12:49:51AM +0300, Pavel Parkhomenko wrote:
> When setting up autonegotiation for 88E1118R and compatible PHYs,
> a software reset of PHY is issued before setting up polarity.
> This is incorrect as changes of MDI Crossover Mode bits are
> disruptive to the normal operation and must be followed by a
> software reset to take effect. Let's patch m88e1118_config_aneg()
> to fix the issue mentioned before by invoking software reset
> of the PHY just after setting up MDI-x polarity.
> 
> Fixes: 605f196efbf8 ("phy: Add support for Marvell 88E1118 PHY")
> Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Cc: stable@vger.kernel.org

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
