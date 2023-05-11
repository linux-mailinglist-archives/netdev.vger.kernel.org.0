Return-Path: <netdev+bounces-1736-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC076FF062
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A4D02816C2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF42018C08;
	Thu, 11 May 2023 11:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A9A57
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35A8AC4339C;
	Thu, 11 May 2023 11:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683803422;
	bh=ro0oxCbiS0WtHtYkUc+JN3qvn70Qr7sLnWT1N6yZY7o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pZ9Uz8sSJYGz2CUTM1AR4G7ca4OLGUlLx3hBPhjsTkLqZ8iv47/ZEm/oiwEif0Bub
	 cLSufcKlv1peIr0mGfA/bhsQXBIj2ZbJdzH+hBpttbeuziK7W6FbYHqutYAJngeU70
	 jB0tmMSo/SgG+S2Pz/0UCU/pZCrbFVWannv/5Fu06+ZKDnmprAm8HUd81rXGxunvnZ
	 Zi4NCDtweXY8JcRlzgdLxDKszk+n2aHJ3jSCClhJPeAnfw+zl7qSfiZEUp+lHblXP3
	 YauFesUivpJytBkxy42vax5zJgDe3xh+URG5gQl7pkRxypugpCo4e3Mo5x1gphI4Na
	 8+piz2fFLTg4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 195D9E450BA;
	Thu, 11 May 2023 11:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168380342209.3308.11892374459667294124.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 11:10:22 +0000
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
In-Reply-To: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: kabel@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 thomas.petazzoni@bootlin.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 10 May 2023 11:14:28 +0100 you wrote:
> Hi,
> 
> With reference to
> https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
> https://github.com/openwrt/openwrt/pull/12375#issuecomment-1528842334
> 
> It appears that mvneta attempts an order-6 allocation for the TSO
> header memory. While this succeeds early on in the system's life time,
> trying order-6 allocations later can result in failure due to memory
> fragmentation.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: mvneta: fix transmit path dma-unmapping on error
    https://git.kernel.org/netdev/net-next/c/fef99e840d46
  - [net-next,2/5] net: mvneta: mark mapped and tso buffers separately
    https://git.kernel.org/netdev/net-next/c/b0bd1b07c3ad
  - [net-next,3/5] net: mvneta: use buf->type to determine whether to dma-unmap
    https://git.kernel.org/netdev/net-next/c/f00ba4f41acc
  - [net-next,4/5] net: mvneta: move tso_build_hdr() into mvneta_tso_put_hdr()
    https://git.kernel.org/netdev/net-next/c/d41eb5557668
  - [net-next,5/5] net: mvneta: allocate TSO header DMA memory in chunks
    https://git.kernel.org/netdev/net-next/c/33f4cefb26e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



