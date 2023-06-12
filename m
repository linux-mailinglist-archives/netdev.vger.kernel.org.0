Return-Path: <netdev+bounces-9994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC0BA72B989
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C431F2810F5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9D6FC09;
	Mon, 12 Jun 2023 08:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA39F9D6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3F5AC433B4;
	Mon, 12 Jun 2023 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686556820;
	bh=Lt5F43sjDQNpKoJrbGBSmTS/eMsFrRizoVj3t9OjL60=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QWNhO5d+3UDPilq+rkvIR9S9UoZwpgFpOk2oKRB/ZGJlcPuSXjPode/bkzK84lDDx
	 3+Sbv8m7goNjlDRiOHa4c2FAwKtEGGdM9/XFzLGdq6nlTewKWE8R+Y0s1E+SDqxATF
	 KcgfTrn+pUJ30w4FetXp/nYfDN62DFjMTG1781ElYV1sW8fzHQIOwRXntRtWP7BVSy
	 H/OWPpUv+y6dccZ4Ilj3j3jyajDcQDWNG84WJP4aOIJRdAUMv5BeQRUFvik1vxpw6m
	 +aKMV36uNcFuCGzoL+rRLfh8jOic9NXzCgiXVlthDCncGERorhvixkqVFxKOGAU6AM
	 FXuo1Nkq++XFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82915E29F37;
	Mon, 12 Jun 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: enable runtime pm support for 7560
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168655682053.11914.3571229011024962751.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 08:00:20 +0000
References: <1b0829943267c30de27f271666cb7ce897f5b54a.1686218573.git.m.chetan.kumar@linux.intel.com>
In-Reply-To: <1b0829943267c30de27f271666cb7ce897f5b54a.1686218573.git.m.chetan.kumar@linux.intel.com>
To: Kumar@codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
 linuxwwan@intel.com, m.chetan.kumar@intel.com, edumazet@google.com,
 pabeni@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 15:38:03 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> Adds runtime pm support for 7560.
> 
> As part of probe procedure auto suspend is enabled and auto suspend
> delay is set to 5000 ms for runtime pm use. Later auto flag is set
> to power manage the device at run time.
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: enable runtime pm support for 7560
    https://git.kernel.org/netdev/net-next/c/e4f5073d53be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



