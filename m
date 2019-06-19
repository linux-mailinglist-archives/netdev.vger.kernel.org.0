Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647044BAD8
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfFSOLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:11:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfFSOL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 10:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v0kj21FKTfc8hI0Hhv3Jpr9qgTaeqZ90JjRurjLbLxE=; b=aJW4ugajucQKu9Yyy9ttcxLUbB
        /OMtxcJOC9W9XEDDqR5MHfWCpOiBiRNCkdDCCcFQ8QwEcWC1OGDIZ3P/ln8CWphBQqcIU32s1MFqI
        85ao32RIPpUllKTmvCc8SsxJDxiRkXmohQ4E6ID7RzulnFWX2s6mBzFc2CNy8ESYZZ28=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hdbJ2-0001ul-Hn; Wed, 19 Jun 2019 16:11:20 +0200
Date:   Wed, 19 Jun 2019 16:11:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v3 14/16] ARM: dts: sunxi: Switch from phy-mode to
 phy-connection-type
Message-ID: <20190619141120.GD18352@lunn.ch>
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <50f869f466acb110c5924d7e8a67087fd97106fd.1560937626.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50f869f466acb110c5924d7e8a67087fd97106fd.1560937626.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 11:47:23AM +0200, Maxime Ripard wrote:
> The phy-mode device tree property has been deprecated in favor of
> phy-connection-type, let's replace it.

Hi Maxime

net/ethernet/stmicro/stmmac/dwmac-mediatek.c:		dev_err(plat->dev, "not find phy-mode\n");
net/ethernet/stmicro/stmmac/dwmac-anarion.c:		dev_err(&pdev->dev, "Unsupported phy-mode (%d)\n",
net/ethernet/stmicro/stmmac/dwmac-meson8b.c:		dev_err(dwmac->dev, "fail to set phy-mode %s\n",
net/ethernet/stmicro/stmmac/dwmac-meson8b.c:		dev_err(dwmac->dev, "fail to set phy-mode %s\n",
net/ethernet/stmicro/stmmac/dwmac-meson8b.c:		dev_err(dwmac->dev, "unsupported phy-mode %s\n",
net/ethernet/stmicro/stmmac/dwmac-meson8b.c:		dev_err(&pdev->dev, "missing phy-mode property\n");

As a follow up patch, you might want to change these error messages.

   Andrew
