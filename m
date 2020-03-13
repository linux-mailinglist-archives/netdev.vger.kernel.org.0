Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA9B18442A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgCMJz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:55:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgCMJz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 05:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y5jMrVQ1rAmzFXJgVqMw4/HO7DqIcglA8Q3MOxQde5c=; b=pJqmMLtzgUNGpjUJSu2CBoZO+H
        35G+hZ9wBhF01fL7YN2ghhtcenyHC4VjrRk/Zq6tnoEVKr1/LLSw4/SSfuayre8E+a34p2NjGFp05
        6t16FcATEI6wA7e54dEMMdfZz1FJSrcgNqY2m+2Yd6oMfqHD+AByv9xrcYLwZVNs4ys0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jCh2f-00045u-0c; Fri, 13 Mar 2020 10:55:45 +0100
Date:   Fri, 13 Mar 2020 10:55:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 2/2] ARM: dts: imx6q-marsboard: properly define rgmii
 PHY
Message-ID: <20200313095545.GD14553@lunn.ch>
References: <20200313053224.8172-1-o.rempel@pengutronix.de>
 <20200313053224.8172-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313053224.8172-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 06:32:24AM +0100, Oleksij Rempel wrote:
> The Atheros AR8035 PHY can be autodetected but can't use interrupt
> support provided on this board. Define MDIO bus and the PHY node to make
> it work properly.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm/boot/dts/imx6q-marsboard.dts | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/imx6q-marsboard.dts
> index 84b30bd6908f..1f31d86a217b 100644
> --- a/arch/arm/boot/dts/imx6q-marsboard.dts
> +++ b/arch/arm/boot/dts/imx6q-marsboard.dts
> @@ -111,8 +111,21 @@ &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
>  	phy-mode = "rgmii-id";
> -	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
>  	status = "okay";

Hi Oleksij 

I don't see a phy-handle here. So is it still using phy_find_first()?

  Andrew
