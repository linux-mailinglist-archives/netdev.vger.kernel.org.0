Return-Path: <netdev+bounces-5126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8841870FBB2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428002811C2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB0919E6F;
	Wed, 24 May 2023 16:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF9619E62
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91A77C4339B;
	Wed, 24 May 2023 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684945822;
	bh=vsc4bt3gaW6qy1Kxmkr8ZD0JxX1Os+4ai2m8Xhu3p2s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hAqASac6dUn/YENnCHc9puMhj2Yutar+c60eLlVANUx6hOg+esC9DjRF1XMou8QUx
	 teSEGm5bwODj+xvJPycw09O/27IqzkaiXOkOvTlCI/UropT+3Q7YwpXjEOWBmCjQA6
	 hQ71qc4vQbtPEVeTqCnXreFtYiQLct1eQ9zPuo3pY3HGcJaDgCmWcCSKavKrRMgo5K
	 CgEPq4L0bH0ZugaKmkFJN3oXTfXbZ9hhHhogt6/dvd1BTPFtWdQC1pbj2kCCu+t51L
	 XP5SOpbivbfmoIP+La+a9tAZ0J5+lCP6go4BZrq27C1wEL2bvLs31w+cqy9V9Dcz6n
	 PUnaUUcFDSKmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 674FDE21ECD;
	Wed, 24 May 2023 16:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: pcs: xpcs: cleanups for clause 73 support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168494582241.4520.6601999344453082573.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 16:30:22 +0000
References: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
In-Reply-To: <ZGyR/jDyYTYzRklg@shell.armlinux.org.uk>
To: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Jose.Abreu@synopsys.com, andrew@lunn.ch, davem@davemloft.net,
 edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 May 2023 11:14:22 +0100 you wrote:
> Hi,
> 
> This series cleans up xpcs code, moving much of the clause 73 code
> out of the driver into places where others can make use of it.
> 
> Specifically, we add a helper to convert a clause 73 advertisement
> to ethtool link modes to mdio.h, and a helper to resolve the clause
> 73 negotiation state to phylink, which includes the pause modes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: mdio: add clause 73 to ethtool conversion helper
    https://git.kernel.org/netdev/net-next/c/e9261467ae86
  - [net-next,2/9] net: phylink: remove duplicated linkmode pause resolution
    https://git.kernel.org/netdev/net-next/c/dc7a51411ec5
  - [net-next,3/9] net: phylink: add function to resolve clause 73 negotiation
    https://git.kernel.org/netdev/net-next/c/dad987484eaa
  - [net-next,4/9] net: pcs: xpcs: clean up reading clause 73 link partner advertisement
    https://git.kernel.org/netdev/net-next/c/6f7b89b45f1e
  - [net-next,5/9] net: pcs: xpcs: use mii_c73_to_linkmode() helper
    https://git.kernel.org/netdev/net-next/c/3f0360e09c8d
  - [net-next,6/9] net: pcs: xpcs: correct lp_advertising contents
    https://git.kernel.org/netdev/net-next/c/1f94ba198bda
  - [net-next,7/9] net: pcs: xpcs: correct pause resolution
    https://git.kernel.org/netdev/net-next/c/428d603fcaeb
  - [net-next,8/9] net: pcs: xpcs: use phylink_resolve_c73() helper
    https://git.kernel.org/netdev/net-next/c/21234ef16665
  - [net-next,9/9] net: pcs: xpcs: avoid reading STAT1 more than once
    https://git.kernel.org/netdev/net-next/c/883a98ede4b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



