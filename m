Return-Path: <netdev+bounces-2053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0419A7001B7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA281C2112B
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE75E8F51;
	Fri, 12 May 2023 07:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8669B63D8
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31CD4C433EF;
	Fri, 12 May 2023 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683877820;
	bh=UG2XymFt/LVYF7Maho6gjkXm2jm8jJSoTDi9Gbe5NTY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=JOSjI6/Qu+MCybdWFaloBNwPj1gXiafb13MCxCzz1IxgmKvwkVCfEOELtXqAuvPzN
	 YaCA+ispsBXidbphxiXt726mZil+bjh9tAcc0ZE8DUvlPDoV8YgfPBZzqNzBgyPKQr
	 hPHbVKIRNBtDyV1aQRQoraPQkF8Tpcpc8/v/3gf7P96Pd2rGK5CJSDQ07kvf/S2zCr
	 nxdRpp0sq/pxbiFJ2+hn36E/E+huN7adpZr0CLP9XOfidzvh/NZXbcXPU217IL+rVH
	 FXqkJLiBLGhAIeNL4KykNJguB4ZYBiAvmUN4IcgJCqeA6kmJnSnGUJVrSlmb85GW+w
	 XY6wChHxACoVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19799E26D20;
	Fri, 12 May 2023 07:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: phy: dp83867: add w/a for packet errors seen with
 short cables
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387782010.11165.2503364837163624260.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 07:50:20 +0000
References: <20230510125139.646222-1-s-vadapalli@ti.com>
In-Reply-To: <20230510125139.646222-1-s-vadapalli@ti.com>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, srk@ti.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 18:21:39 +0530 you wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Introduce the W/A for packet errors seen with short cables (<1m) between
> two DP83867 PHYs.
> 
> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
> and soft resets as follows:
> 
> [...]

Here is the summary with links:
  - [net,v3] net: phy: dp83867: add w/a for packet errors seen with short cables
    https://git.kernel.org/netdev/net/c/0b01db274028

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



