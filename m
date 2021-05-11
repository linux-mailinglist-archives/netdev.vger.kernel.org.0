Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BC137A71D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhEKMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:53:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231720AbhEKMxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3BqBv5shPIWbqR7hrQzP2WUoMQCkjuhaWwqGLq6xi4Q=; b=1Eeq/Brnwm+6/m3IlrZjbOKqyo
        BfAfmHKA9ru84Z/CYn2yXQuOwZyAP7TSRsNjCj2lIoft/wErgCDmK+XFqM6JNsNHIZHzrehdCpn2t
        Lw3STZBVlEUshD4Q/ZxJgCVu98XVOKDONIKBv8r+sOBw+0nxP5MGvqC08lX44Hu35Wvk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRrg-003kGL-Mv; Tue, 11 May 2021 14:51:56 +0200
Date:   Tue, 11 May 2021 14:51:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v3 5/7] ARM i.MX6q: remove Atheros AR8035 SmartEEE fixup
Message-ID: <YJp97O6AW6uf7nPs@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-6-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:33AM +0200, Oleksij Rempel wrote:
> This fixup removes the Lpi_en bit.
> 
> If this patch breaks functionality of your board, use following device
> tree properties: qca,smarteee-tw-us-1g and qca,smarteee-tw-us-100m.
> 
> For example:
> 
> 	ethernet-phy@X {
> 		reg = <0xX>;
> 		qca,smarteee-tw-us-1g = <24>;
> 		....
> 	};
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
