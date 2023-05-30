Return-Path: <netdev+bounces-6228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B767154AC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 762DD1C20B1A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80F03D74;
	Tue, 30 May 2023 05:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD71103
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DECDEC433D2;
	Tue, 30 May 2023 05:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685422822;
	bh=TxoAKQUpaSTUcWD6k5DOKp6LeV3n0eo7papce8MsvHw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ECiwvDDE3EeGZ16Qw6v0DrO25JZW6C6Gc+ghpw04YHV2vSRcpBThiPi6i+Eks4RRn
	 d5V0YR9iUZVtt+cPUqZM3ncvWEEwLgfUBxbIttbP2t4weD/5wslWomeYx6mQoJ+obm
	 KyALYqZOij3tKj/XCnzoA7Hwa+GFkB+S8lVY3PMacOZlHMhoUWcHCDR5xiPkcByjDx
	 28p/9s1FbX1vWbVl0PpmE02vwD4y18RYPtwcgKXGcVNtbBuYqQXdWTWC5dQJ/oPnIT
	 MPoOEhyr//M0+sl3WF8/M/cvLrpHBvPoLZN+PaVm0fB8ZocIgw33BCVdKKRZxMVFLN
	 oPDWbaQfwFNMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0A08E52BF4;
	Tue, 30 May 2023 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: pcs: add helpers to xpcs and lynx to
 manage mdiodev
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542282171.21395.3855041574885674177.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:00:21 +0000
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, alexandre.belloni@bootlin.com,
 alexandre.torgue@foss.st.com, claudiu.manoil@nxp.com, davem@davemloft.net,
 edumazet@google.com, f.fainelli@gmail.com, peppe.cavallaro@st.com,
 ioana.ciornei@nxp.com, kuba@kernel.org, jiawenwu@trustnetic.com,
 joabreu@synopsys.com, Jose.Abreu@synopsys.com,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, maxime.chevallier@bootlin.com,
 mcoquelin.stm32@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, UNGLinuxDriver@microchip.com,
 vladimir.oltean@nxp.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 11:13:59 +0100 you wrote:
> Hi,
> 
> This morning, we have had two instances where the destruction of the
> MDIO device associated with XPCS and Lynx has been wrong. Rather than
> allowing this pattern of errors to continue, let's make it easier for
> driver authors to get this right by adding a helper.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: mdio: add mdio_device_get() and mdio_device_put()
    https://git.kernel.org/netdev/net-next/c/c4933fa88a68
  - [net-next,2/6] net: pcs: xpcs: add xpcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/9a5d500cffdb
  - [net-next,3/6] net: stmmac: use xpcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/727e373f897d
  - [net-next,4/6] net: pcs: lynx: add lynx_pcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/86b5f2d8cd78
  - [net-next,5/6] net: dsa: ocelot: use lynx_pcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/5767c6a8d9b7
  - [net-next,6/6] net: enetc: use lynx_pcs_create_mdiodev()
    https://git.kernel.org/netdev/net-next/c/b7d5d0438e01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



