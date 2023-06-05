Return-Path: <netdev+bounces-7962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C25722380
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5024E1C2096D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26638171BD;
	Mon,  5 Jun 2023 10:30:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A194418018
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2663C433A8;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685961025;
	bh=r7SBNDzqQ4HkG3iYEwb6pL1Y01Nzjaui1CwJ0WgZ5iM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=o2hLna/xHHsvisys85SwYE1VKoBEIh5hdOaMAHHcM87tv5pAsgUMZspkTSpIPLJFQ
	 aPdI5meRPprATPVmR2x6PtdfvjyW1nZ6JsaYBKu8mtDAzx0ygRjfBBbc9NXtFZPtbj
	 KqrObSzNdt1sCi9pvBgRu7XPIja/z+64wzoiKpflkoenLOkniLx7Ck0KJROQYbd8lN
	 G4G54wOrjociaXqL2AGgb42s4l/FfhKMJxbgaq+WR/SUEkcbyM61ZPvCNlPrvZjCmk
	 eMZL5ULx08CoJicLRZt3a5isLTKmI5UZa0HwmkWO2OZ56VgbK9XraIj99tdYRz4OKI
	 kAEpq/uP0Elcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C021AE8723C;
	Mon,  5 Jun 2023 10:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] net: add a regmap-based mdio driver and drop
 TSE PCS
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168596102478.26938.1530517069555858195.git-patchwork-notify@kernel.org>
Date: Mon, 05 Jun 2023 10:30:24 +0000
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: broonie@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, alexis.lothore@bootlin.com,
 thomas.petazzoni@bootlin.com, andrew@lunn.ch, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, f.fainelli@gmail.com,
 hkallweit1@gmail.com, linux@armlinux.org.uk, vladimir.oltean@nxp.com,
 ioana.ciornei@nxp.com, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, mcoquelin.stm32@gmail.com,
 joabreu@synopsys.com, alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
 simon.horman@corigine.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  1 Jun 2023 16:14:50 +0200 you wrote:
> Hello everyone,
> 
> This is the V4 of a series that follows-up on the work [1] aiming to drop the
> altera TSE PCS driver, as it turns out to be a version of the Lynx PCS exposed
> as a memory-mapped block, instead of living on an MDIO bus.
> 
> One step of this removal involved creating a regmap-based mdio driver
> that translates MDIO accesses into the actual underlying bus that
> exposes the register. The register layout must of course match the
> standard MDIO layout, but we can now account for differences in stride
> with recent work on the regmap subsystem [2].
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] net: mdio: Introduce a regmap-based mdio driver
    https://git.kernel.org/netdev/net-next/c/642af0f92cbe
  - [net-next,v4,2/4] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
    https://git.kernel.org/netdev/net-next/c/db48abbaa18e
  - [net-next,v4,3/4] net: pcs: Drop the TSE PCS driver
    https://git.kernel.org/netdev/net-next/c/196eec4062b0
  - [net-next,v4,4/4] net: stmmac: dwmac-sogfpga: use the lynx pcs driver
    https://git.kernel.org/netdev/net-next/c/5d1f3fe7d2d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



