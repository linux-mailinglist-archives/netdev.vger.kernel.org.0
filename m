Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4092541330F
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 14:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhIUMB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 08:01:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52014 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhIUMB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 08:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=KIDaLz2GU9BuGDCX1ZlMguAAI3bird+o76YFq5fpUTQ=; b=yp
        JDbzR/zEk7w+Zr4ta/Kkf5gEtxx9Uit9QHMU0i0xea8IHU+6wLK+uz6RnXBLfQshLRbrjiHcZjVeK
        wvtL0vDK3jG1990nu133/wTSDhIPxqxwhXD34d7CwmIdIuOnL5uITsr3wa1BSMdus7Whs1qWVLx47
        4ujFGnpFOUXIM1M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSeRf-007cfY-RT; Tue, 21 Sep 2021 14:00:19 +0200
Date:   Tue, 21 Sep 2021 14:00:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [PATCH net 2/2] net: dsa: realtek: register the MDIO bus under
 devres
Message-ID: <YUnJU4jazMhWqgmo@lunn.ch>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
 <20210920214209.1733768-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210920214209.1733768-3-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
