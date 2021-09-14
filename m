Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6270040A283
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 03:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhINBck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 21:32:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhINBcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 21:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KXOg1wnh22KbOjiVoErnse0MPToeoaHhPOYb0uwUyns=; b=K4Inj402fuVbGnCywXEmB2OIZb
        j/MJqTfUMdGDXCqDwMPCx2HoKy8IZfDcJa1ePVQQqFtV7It3ciZmfNIDGp8NJvVBQcTcjtYNOlR0c
        02EODSkYM+tvbiaCaBpyRovGW3qjhTrt4PQhI93R9lZWnPtP7AfUSGTHnsNPHPcg0CZs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPxHl-006Ulp-0X; Tue, 14 Sep 2021 03:30:57 +0200
Date:   Tue, 14 Sep 2021 03:30:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: Re: [RFC PATCH net 2/5] net: dsa: be compatible with masters which
 unregister on shutdown
Message-ID: <YT/7UVJghbbyd1t9@lunn.ch>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-3-vladimir.oltean@nxp.com>
 <20210912131837.4i6pzwgn573xutmo@skbuf>
 <YT9QwOA2DxaXNsfw@lunn.ch>
 <20210913133130.ohk4co56v4mtljyk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913133130.ohk4co56v4mtljyk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Have you tested it with a D in DSA system?
> 
> To various degrees.

Hi Vladimir

I tested on ZII devel C, which has two switches in a DSA
configuration. This worked before, and still cleanly reboots with this
patchset.

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
