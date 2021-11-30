Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A6C463D72
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 19:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbhK3SQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 13:16:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhK3SQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 13:16:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nyEKgO2cVoWXQUIJS+Dmd2AJmEEUePOC8YNFDSKHJwk=; b=WIqF4y/N1BCoyF57bVuav6ucRu
        rjOS/2RDluEzGlo8jt6tu7GD7ohPA6ElBC6VNS1XOhtpF2HhpwUHWQEvw9ePp2/2PmO9wmJ2Y1Ir5
        EQqIsojgoDgeeGgh7DVkn/zzgUO+EXiqlPaykl0zyfkj6MxIOueVVeKt0T+v2ToemsVM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ms7cw-00F85R-0M; Tue, 30 Nov 2021 19:13:14 +0100
Date:   Tue, 30 Nov 2021 19:13:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tianchen Ding <dtcccc@linux.alibaba.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio: mscc-miim: Add depend of REGMAP_MMIO on
 MDIO_MSCC_MIIM
Message-ID: <YaZpufJdRIqvm9q7@lunn.ch>
References: <20211130110209.804536-1-dtcccc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211130110209.804536-1-dtcccc@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 07:02:09PM +0800, Tianchen Ding wrote:
> There's build error while CONFIG_REGMAP_MMIO is not set
> and CONFIG_MDIO_MSCC_MIIM=m.
> 
> ERROR: modpost: "__devm_regmap_init_mmio_clk"
> [drivers/net/mdio/mdio-mscc-miim.ko] undefined!
> 
> Add the depend of REGMAP_MMIO to fix it.
> 
> Fixes: a27a76282837 ("net: mdio: mscc-miim: convert to a regmap implementation")
> Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
