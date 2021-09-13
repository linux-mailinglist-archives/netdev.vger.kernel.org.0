Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC172408C1C
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbhIMNMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:12:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhIMNMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:12:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lhuklNqPbPBlUpzBlVfCCXYDNgKobxlQ6GFS6KR2OQ8=; b=VFE3T67fTCAfX+NiJZ6mngYyhG
        dgz/2pCeI3+dhERc0MFab+ofX3E9hBzzSbq7oI5hciXQ5+0Qih5eN/Q+TRDAzaP7FMGgtFLWStLQ8
        pVrXAPEfwoyDDps6r/XhkAHRDr9f3gIIPe0HOhKOJqVyuEDPFGPIrNwMuXK3MD6o3Iro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPljD-006Ozw-Is; Mon, 13 Sep 2021 15:10:31 +0200
Date:   Mon, 13 Sep 2021 15:10:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [RFC PATCH net 1/5] net: mdio: introduce a shutdown method to
 mdio device drivers
Message-ID: <YT9Nx9hvSnRYmJ4Q@lunn.ch>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912120932.993440-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 03:09:28PM +0300, Vladimir Oltean wrote:
> MDIO-attached devices might have interrupts and other things that might
> need quiesced when we kexec into a new kernel. Things are even more
> creepy when those interrupt lines are shared, and in that case it is
> absolutely mandatory to disable all interrupt sources.
> 
> Moreover, MDIO devices might be DSA switches, and DSA needs its own
> shutdown method to unlink from the DSA master, which is a new
> requirement that appeared after commit 2f1e8ea726e9 ("net: dsa: link
> interfaces with the DSA master to get rid of lockdep warnings").
> 
> So introduce a ->shutdown method in the MDIO device driver structure.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
