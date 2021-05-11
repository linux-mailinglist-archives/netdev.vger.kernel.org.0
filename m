Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD837A719
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhEKMwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:52:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35132 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhEKMw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 08:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AewQcOd+v8uts915TNTPNYS0AvYJ7nHNWXSQ/Hje0P0=; b=cNzvs/E8PhADt0sLVMJ93Z2Twu
        FfF3uac7J56lkx+eFL2Pu5vqB3zAPYFToJkAqPiRXSFKEpBlwx8XL3lFkWKqeZYl2DeC5GbL9CO/3
        zFvKN3ESefM3emirh2oWwrhwIhoGGimgUZELJZLDvgxzMBQPY86OwtWoXeKmvdTGuIW4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lgRr4-003kFB-1v; Tue, 11 May 2021 14:51:18 +0200
Date:   Tue, 11 May 2021 14:51:18 +0200
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
Subject: Re: [PATCH v3 4/7] ARM i.MX6q: remove clk-out fixup for the Atheros
 AR8031 and AR8035 PHYs
Message-ID: <YJp9xi315E7Aksyg@lunn.ch>
References: <20210511043735.30557-1-o.rempel@pengutronix.de>
 <20210511043735.30557-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511043735.30557-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 06:37:32AM +0200, Oleksij Rempel wrote:
> This configuration should be set over device tree.
> 
> If this patch breaks network functionality on your system, enable the
> AT803X_PHY driver and set following device tree property in the PHY
> node:
> 
>     qca,clk-out-frequency = <125000000>;
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
