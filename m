Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF3949BB92
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiAYSxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbiAYSxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:53:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC9C06173E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 10:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6F4B81A17
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2374EC340E0;
        Tue, 25 Jan 2022 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643136785;
        bh=iIsDIofxdHO/kYl3PGfWu5p5sOUN6/kd7s463fCVl+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JzCi1WQCGXT/72UAF30/6rXvvR3VRVSBpDcUQ/NOszaqH16mdFmAz9u6aisDxLrAc
         xqw/tUTB0eR0GDC93SzPgAOKvJgP8Gv+HCfJmePqWBzoHQF1SBr0xSjWZT7vFECiFy
         YsvBwqrwMGODYqovueMCIe55tkYa75dH0m0MVN/BZ30YoDURD+KZm9EMeAXOvzhz0h
         JZC+ja2BlCwEz74Xidhr2ozLd1mnUBzaekNYrnsPFRlcVqe8+Q4TRKJvACg67oNu2T
         MX5LqAHDGeuvt3UV088rREbFxM3Mww1zdV/ZJvYdpdi08qQc8OBM2bqAuumiquzwb2
         SVjSmp7s8p8lw==
Date:   Tue, 25 Jan 2022 10:53:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: stmmac/xpcs: convert to
 pcs_validate()
Message-ID: <20220125105303.2025dfae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <E1nCOs4-005LSp-HF@rmk-PC.armlinux.org.uk>
References: <YfAnkuhiMoeFcVnb@shell.armlinux.org.uk>
        <E1nCOs4-005LSp-HF@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 16:40:40 +0000 Russell King (Oracle) wrote:
> stmmac explicitly calls the xpcs driver to validate the ethtool
> linkmodes. This is no longer necessary as phylink now supports
> validation through a PCS method. Convert both drivers to use this
> new mechanism.
> 
> Tested-by: Wong Vee Khee <vee.khee.wong@linux.intel.com> # Intel EHL            Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Sign-offs got scrambled.

Transient warning from here to patch 6:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:943:22: warning: unused variable 'priv' [-Wunused-variable]
        struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
                            ^
