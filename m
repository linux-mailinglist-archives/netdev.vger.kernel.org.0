Return-Path: <netdev+bounces-2327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D35070142B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 05:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D53EB281C1A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 03:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5171EBC;
	Sat, 13 May 2023 03:28:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E8A44
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 03:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF527C433EF;
	Sat, 13 May 2023 03:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683948502;
	bh=lXHrgI0Wa2xK+EyaUVkgD9PUBghEREsVO73WCxNEA3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mFKH6+2CJJnjdsuFpoHp9zieRsaC4qjGXYd6h2Q2ULG5O9C8cydtY/nZFUS7+Y+jF
	 UBRzcB+WIjb+AnWz42AoYHDjyieesFY5wMdO8nnzb+Z0wtsoiOK5+O2gO2opOhX/Q2
	 94c5LGwD3a4dNOpjg8hWZNPZHzJ8XHXLGdb/0obRJ9bPfEAcqMcYLrd+Hu2HEOrVzF
	 JWXv86p0KmS0zmAKLA1uVJvC/JWpYDd8JXlqnlOH5CYTKQVOV4pdbFqOJWrNM9yWf1
	 xCU0AS31Qmfr2mhSnc7zy7AfDJDRlAyWuKE+i018iTKGTtHN87y74pog4WZoObS4QE
	 VtRO3gcbPILZw==
Date: Sat, 13 May 2023 11:28:12 +0800
From: Shawn Guo <shawnguo@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>, arm-soc <arm@kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Add missing DSA properties for marvell switches
Message-ID: <20230513032812.GC727834@dragon>
References: <20230408152801.2336041-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408152801.2336041-1-andrew@lunn.ch>

On Sat, Apr 08, 2023 at 05:27:58PM +0200, Andrew Lunn wrote:
> The DSA core has become more picky about DT properties. This patchset
> add missing properties and removes some unused ones, for iMX boards.
> 
> Once all the missing properties are added, it should be possible to
> simply phylink and the mv88e6xxx driver.
> 
> v2:
> Use rev-mii or rev-rmii for the side of the MAC-MAC link which plays
> PHY.
> 
> Andrew Lunn (3):
>   ARM: dts: imx51: ZII: Add missing phy-mode
>   ARM: dts: imx6qdl: Add missing phy-mode and fixed links
>   ARM64: dts: freescale: ZII: Add missing phy-mode

Applied all, thanks!

