Return-Path: <netdev+bounces-9055-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC73726D3C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA71B1C20F19
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBC91EA8C;
	Wed,  7 Jun 2023 20:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648F51F190
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11881C433A0;
	Wed,  7 Jun 2023 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686170423;
	bh=BOLn3A57823G4qBo+ym8mgcosf66TbhUNu7uFQ63o34=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Vn94KhGlUumk436ycANz1+dZzKB4nm7+IZU9Iqm17MzNu5Ov41U0a5GbNEW+epRix
	 fLGAnjPtINH7rBEYu+dic7HHQyRHIxdfM+07UdsM69cqacN+/XAn6Frwmrr8OtF9vW
	 rCU5wB8V3izIHUEdFAYJy7/ql/D/2kMXKFSaDHH02mxLFgJXGZuy7wVBj131niUzbr
	 4UxUgQulWeYuwzxajdhHWLvMwOwiIeQUHaAAIuMYCPjNjQlexYabhJ3yQDxkwmKd9/
	 doIaGaObGDYwUjOJTkBDUwxcBnHclN53UrbQ2Ai+AknzRm1sAZ0IftqDxyyk2yySkz
	 vK+Mkst2lfpzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2550E29F3C;
	Wed,  7 Jun 2023 20:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/5] Followup fixes for the dwmac and altera lynx
 conversion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168617042292.11974.2218551142896764762.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 20:40:22 +0000
References: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20230607135941.407054-1-maxime.chevallier@bootlin.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com, andrew@lunn.ch,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
 vladimir.oltean@nxp.com, ioana.ciornei@nxp.com,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, mcoquelin.stm32@gmail.com,
 joabreu@synopsys.com, alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
 simon.horman@corigine.com, maciej.fijalkowski@intel.com,
 chenfeiyang@loongson.cn

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 15:59:36 +0200 you wrote:
> Hello everyone,
> 
> Here's yet another version of the cleanup series for the TSE PCS replacement
> by PCS Lynx. It includes Kconfig fixups, some missing initialisations
> and a slight rework suggested by Russell for the dwmac cleanup sequence,
> along with more explicit zeroing of local structures as per MAciej's
> review.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/5] net: altera-tse: Initialize local structs before using it
    https://git.kernel.org/netdev/net-next/c/2d830f7a4134
  - [net-next,v4,2/5] net: altera_tse: Use the correct Kconfig option for the PCS_LYNX dependency
    https://git.kernel.org/netdev/net-next/c/fae555f5a56f
  - [net-next,v4,3/5] net: stmmac: make the pcs_lynx cleanup sequence specific to dwmac_socfpga
    https://git.kernel.org/netdev/net-next/c/a8dd7404c214
  - [net-next,v4,4/5] net: altera_tse: explicitly disable autoscan on the regmap-mdio bus
    https://git.kernel.org/netdev/net-next/c/fa19a5d9dcff
  - [net-next,v4,5/5] net: dwmac_socfpga: initialize local data for mdio regmap configuration
    https://git.kernel.org/netdev/net-next/c/06b9dede1e7d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



