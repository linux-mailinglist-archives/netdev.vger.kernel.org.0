Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A96184DFA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgCMRur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:50:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgCMRur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 13:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nD3n3nGUFD/pHjTY+G4h6EltxeSMd4aqjlspJlueiZc=; b=QJPcmg8lwKnxZTlFKNf/f5oRY0
        ZB6Bj4phk1s6tqn+pF/fHgaG7taE/juW1XktSjXb9BMmKv61juAkTfewq+0jTfoAnwbX0uNQGtPfb
        Cni5bgQakDp2+otFPqayeIHCRN+OvezG4g887Rco3YXXiYfpyLoGaQlgwyhq67H8+ja8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jCoSE-0007Gl-Ew; Fri, 13 Mar 2020 18:50:38 +0100
Date:   Fri, 13 Mar 2020 18:50:38 +0100
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
Subject: Re: [PATCH v3 2/2] ARM: dts: imx6q-marsboard: properly define rgmii
 PHY
Message-ID: <20200313175038.GA27841@lunn.ch>
References: <20200313102534.5438-1-o.rempel@pengutronix.de>
 <20200313102534.5438-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313102534.5438-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 11:25:34AM +0100, Oleksij Rempel wrote:
> The Atheros AR8035 PHY can be autodetected but can't use interrupt
> support provided on this board. Define MDIO bus and the PHY node to make
> it work properly.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
