Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57D936A1DB
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhDXPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 11:55:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhDXPz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 11:55:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laKcF-000pnO-Nd; Sat, 24 Apr 2021 17:54:43 +0200
Date:   Sat, 24 Apr 2021 17:54:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 05/10] net: dsa: microchip: Add Microchip
 KSZ8863 SPI based driver support
Message-ID: <YIQ/Q7hepXiVyl08@lunn.ch>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423080218.26526-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int ksz8795_spi_probe(struct spi_device *spi)
>  {
> +	const struct regmap_config *regmap_config;
> +	struct device *ddev = &spi->dev;
> +	struct ksz8 *ksz8;
>  	struct regmap_config rc;
>  	struct ksz_device *dev;
> -	int i, ret;
> +	int i, ret = 0;

More malformed trees. Once fixed, add my Reviewed-by:

     Andrew
