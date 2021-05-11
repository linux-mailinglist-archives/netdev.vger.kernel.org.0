Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2537A71F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhEKMxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:53:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhEKMxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=u1NuYk2ex4NBFMQ2JiO31D3AuSD9KNKv1NFh6g+i2iU=; b=pGsHvWsWlc81PSzm2OzJQBbxOi
        oz9WlHXMeHnnPZs8fxDyfglel7t50GZvQRvx9NsjzxhOEBsLPeVnlXoLh818NX9xtSpj9e6pyo1Cp
        i0va/XtX8HSc6OLK64bhWToDrY76vqMoGV7mWrKxdD9GxlK5r2Flzbw1UrGTteSOnNl4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRsI-003kI3-2C; Tue, 11 May 2021 14:52:34 +0200
Date:   Tue, 11 May 2021 14:52:34 +0200
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
Subject: Re: [PATCH v3 6/7] ARM: imx6sx: remove Atheros AR8031 PHY fixup
Message-ID: <YJp+EiQ4grTumO4j@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-7-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:34AM +0200, Oleksij Rempel wrote:
> If this patch breaks your system, enable AT803X_PHY driver and add a PHY
> node to the board device tree:
> 
> 	phy-connection-type = "rgmii-txid"; (or rgmii-id)
> 	ethernet-phy@X {
> 		reg = <0xX>;
> 
> 		qca,clk-out-frequency = <125000000>;
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
