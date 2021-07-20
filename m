Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140E13CF802
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhGTJ6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:32834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236321AbhGTJ4R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:56:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0317E610F7;
        Tue, 20 Jul 2021 10:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626777416;
        bh=WXbLO3ynuZgk68itZjTr3Yl7WL4T3TwXvLwO/EgVS1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hQ8ROvRqMBj/0OxRnyRyc78UOnMikN3SUgf8hCYvj4C9n9BJsvGrnsw8dUwrS0Ptn
         rj7VK1dIGRdBSHFQXv6IgvWVbnmtgMLsxhzL0r7dWtJNowTc74+6OSAp16u4r1lX35
         VF2yIxDIqaaipz+c/GARAExJi9wCdkARBlVnDrNKLXSxboZCwf2E8AjXi+xdMYCsh1
         o8izul1FycbzUc1Uzn5mFT9BIHCwYZNoWL6xjQINl9fSAzJ0mJGVkbamql+1aO8Eoz
         KrbxanEFruxDLVbbGkqQIKWlCmD2JPwAIIPnHU0Nx/xbpK6pMcfnhmWAA5QBU0NoDT
         WKGlbd/lbYgIg==
Date:   Tue, 20 Jul 2021 12:36:46 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH net-next v14 3/3] net: ax88796c: ASIX AX88796C SPI
 Ethernet Adapter Driver
Message-ID: <20210720123646.2991df22@cakuba>
In-Reply-To: <20210719192852.27404-4-l.stelmach@samsung.com>
References: <20210719192852.27404-1-l.stelmach@samsung.com>
        <CGME20210719192913eucas1p2f7b31eacf8c77f8c86bf5a5ca88310b9@eucas1p2.samsung.com>
        <20210719192852.27404-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 21:28:52 +0200, =C5=81ukasz Stelmach wrote:
> +	ax_local->stats =3D
> +		devm_netdev_alloc_pcpu_stats(&spi->dev,
> +					     struct ax88796c_pcpu_stats);
> +	if (!ax_local->stats)
> +		return -ENOMEM;
> +	u64_stats_init(&ax_local->stats->syncp);

../drivers/net/ethernet/asix/ax88796c_main.c:971:33: warning: incorrect typ=
e in argument 1 (different address spaces)
../drivers/net/ethernet/asix/ax88796c_main.c:971:33:    expected struct u64=
_stats_sync *syncp
../drivers/net/ethernet/asix/ax88796c_main.c:971:33:    got struct u64_stat=
s_sync [noderef] __percpu *
