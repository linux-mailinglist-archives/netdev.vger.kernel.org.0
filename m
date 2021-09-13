Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C10408D8E
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240738AbhIMN1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:27:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238675AbhIMNYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n0dItjjT5XWhIzVf5X3VVz9S0GyGpfJIrKxVaJFogkM=; b=G7yHa1lPBpB0jLb9Gp57umPchJ
        HV+9nAj2jNe9UhSFCddAmXJuJ1/xFSdtFahpTFxp1c5xnawrVvlMj52WyQxXc0zWmSyuNDurUiV3J
        sFvuwDGfkai0U7R+i86gbiTb2D5WKpht99PhdtkI5avtDmkC9wEHMU4CpdjVNrip+7Cw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPlvU-006P5l-UG; Mon, 13 Sep 2021 15:23:12 +0200
Date:   Mon, 13 Sep 2021 15:23:12 +0200
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
Message-ID: <YT9QwOA2DxaXNsfw@lunn.ch>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-3-vladimir.oltean@nxp.com>
 <20210912131837.4i6pzwgn573xutmo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912131837.4i6pzwgn573xutmo@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I will fix this when I send the v2 patch, but I will not send that now,
> as I would like to get some feedback on the approach first.

It would of been nice to have less boilerplate code, but the basic
idea seems O.K.

Have you tested it with a D in DSA system?

     Andrew
