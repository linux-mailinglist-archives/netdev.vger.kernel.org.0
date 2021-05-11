Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD29F37A723
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhEKMyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:54:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhEKMyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aSOix/5MbzOgdJO/NKPINzOhzg7QH2L15KpaGIaxB0Q=; b=xFeALSAqFIoet+pjU+nimUvk3+
        DsYSH++pwzLulo9kTSNazq1fqPJkPRtHIOO2F1vOdI8iRdMe3jphdrbXBkhL1XKbkMvMmb43Ktii3
        FmWZNNcIukx4ohwBGDjKP8hstbukOzeaAUDuooeI4JM3qwkzQ6gGYTJI1T9xhQYbZeuY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRsg-003kIz-DE; Tue, 11 May 2021 14:52:58 +0200
Date:   Tue, 11 May 2021 14:52:58 +0200
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
Subject: Re: [PATCH v3 7/7] ARM: imx7d: remove Atheros AR8031 PHY fixup
Message-ID: <YJp+KpCXy9qF+uy2@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-8-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:35AM +0200, Oleksij Rempel wrote:
> This fixup configures the IO voltage and disables the SmartEEE
> functionality.
> 
> If this patch breaks your system, enable AT803X_PHY driver and configure
> the PHY by the device tree:
> 
> 	phy-connection-type = "rgmii-id";
> 	ethernet-phy@X {
> 		reg = <0xX>;
> 
> 		qca,smarteee-tw-us-1g = <24>;
> 
> 		vddio-supply = <&vddh>;
> 
> 		vddio: vddio-regulator {
> 			regulator-name = "VDDIO";
> 			regulator-min-microvolt = <1800000>;
> 			regulator-max-microvolt = <1800000>;
> 		};
> 
> 		vddh: vddh-regulator {
> 			regulator-name = "VDDH";
> 		};
> 	};
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
