Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306243A5017
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhFLSSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:18:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLSSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 14:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PW5YMG3wPfnoUiWr5cQbSIG6ZoWwTuLJxiuiSv6X/b8=; b=CitasYQ3AwLo9oS3BfUYH3V3gD
        IDOmzQHzlhME3nDvnJOD7Arrx66XHvVcMUZekZTeRgw3PK4dHUXrRjbhmddKck/R+gw7JXmK3lIpP
        oX8vvqdFQTsI21EbBfy1yfbSVmaGH6RXOXW7LZMXt3HRscHc2z2pYuxZ/r1OhjTaF4mA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ls8Aw-0091OE-5J; Sat, 12 Jun 2021 20:16:06 +0200
Date:   Sat, 12 Jun 2021 20:16:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v4 7/9] net: dsa: microchip: ksz8795: add
 LINK_MD register support
Message-ID: <YMT55lTgiIByAeJe@lunn.ch>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611071527.9333-8-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 09:15:25AM +0200, Oleksij Rempel wrote:
> From: Oleksij Rempel <linux@rempel-privat.de>
> 
> Add mapping for LINK_MD register to enable cable testing functionality.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
