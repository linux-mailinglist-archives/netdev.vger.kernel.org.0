Return-Path: <netdev+bounces-11011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 775CB73115D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14C372816FA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2523FFF;
	Thu, 15 Jun 2023 07:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12620E3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C3D3EC433C8;
	Thu, 15 Jun 2023 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686815420;
	bh=zun/Pp2HfNTP0g+oW4guAz8PIZ3oIfm+vw18roGseO8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UgBEUPJ9KKTaDkr6fhn2t0DbW7xtLhXwKn/LtT811TPANzY+N5CiZpd2v5giowQSx
	 q/mteKWSgBURD0vL+xlvlCeNGXZZhbdq+AZpMXXzREgwLrKSsY/VDAx+LXUOTHsYMC
	 iVWbkmENptppcaxsrvxco0eZaxsmU6I3jvOU1qbLQOHtjljT7SQIE7WI6mRaPgWGQZ
	 3BKdTupcY0XXi6wRAO99Q8JztQl8tjer3xP4KwXMFhoYBvoiBOFY3uCcmqVgrIhMds
	 vC5cG/nOM3h+jqW8SS7cP5N2GhOD3BvjTGDDyXSfaOlCQ0ABurD6LChkoqOuGVymrm
	 txhmoMFSDYw8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD071E21EEA;
	Thu, 15 Jun 2023 07:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH next-next v4 0/2] Add support for partial store and forward
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168681542070.22382.18369277791311849849.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 07:50:20 +0000
References: <20230613054340.12837-1-pranavi.somisetty@amd.com>
In-Reply-To: <20230613054340.12837-1-pranavi.somisetty@amd.com>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 nicolas.ferre@microchip.com, claudiu.beznea@microchip.com, git@amd.com,
 michal.simek@amd.com, harini.katakam@amd.com, radhey.shyam.pandey@amd.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 23:43:38 -0600 you wrote:
> Add support for partial store and forward mode in Cadence MACB.
> 
> Link for v1:
> https://lore.kernel.org/all/20221213121245.13981-1-pranavi.somisetty@amd.com/
> 
> Changes v2:
> 1. Removed all the changes related to validating FCS when Rx checksum
> offload is disabled.
> 2. Instead of using a platform dependent number (0xFFF) for the reset
> value of rx watermark, derive it from designcfg_debug2 register.
> 3. Added a check to see if partial s/f is supported, by reading the
> designcfg_debug6 register.
> 4. Added devicetree bindings for "rx-watermark" property.
> Link for v2:
> https://lore.kernel.org/all/20230511071214.18611-1-pranavi.somisetty@amd.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] dt-bindings: net: cdns,macb: Add rx-watermark property
    https://git.kernel.org/netdev/net-next/c/5b32c61a2dac
  - [net-next,v4,2/2] net: macb: Add support for partial store and forward
    https://git.kernel.org/netdev/net-next/c/cae4bc06b3e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



