Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1C37A70A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhEKMtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:49:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhEKMtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=za/SlmWdvPdRmc35g9O9/VKNPiV/b9PO6aHEWDvR8IE=; b=g7M+Mg8fBQlqo7Rj2U2AFtbMEk
        ymdSeU4gSE4GIrdKb7yqHMdUpLNWqHfW4Uh2SDFyF87ShRhrxaDbCFcpJHjQgLO/1olFytK8oX9kI
        h5d0JL9HduUarU7kQYlAOyEvGwALQJcJUmJZHsOS2Bv8zwIOwB3wD08MttIwx7KX2qD8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRoB-003k7z-DI; Tue, 11 May 2021 14:48:19 +0200
Date:   Tue, 11 May 2021 14:48:19 +0200
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
Subject: Re: [PATCH v3 1/2] ARM: dts: imx6: edmqmx6: set phy-mode to RGMII-ID
Message-ID: <YJp9E/BLZr8rUYyd@lunn.ch>
References: <20210511043039.20056-1-o.rempel@pengutronix.de>
 <20210511043039.20056-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043039.20056-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:30:38AM +0200, Oleksij Rempel wrote:
> Latest kernel is actually using phy-mode property, so set proper value to make
> fec interface work again.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
