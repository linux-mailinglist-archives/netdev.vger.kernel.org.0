Return-Path: <netdev+bounces-535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F716F7F9A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47B9C280EB6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEC76FC4;
	Fri,  5 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809AB4A35
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 329D2C4339C;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683277821;
	bh=sBckcYMOqWQrqFbjrvsya0tY3+7VZWb2oYkleqiwi8o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=opmgLlQzvTpu/dD+474YGzu9wBBByQhGLS+3IyP04fvfOL35PUGcZu4SfwDh8RLvC
	 on6Wy7boIMJ2szX1bbznsgFqNGzPjoCHolQIxlgYobDgqhFGgPrhKNiG75ApOazXwL
	 u6O2oV9Q6FG7OuchmmQUcdeAR8a9pKdE5h2b+omtYW0kywh7P1sRUBWA2rsrXl44y/
	 bCj8DW1Kkf4cZqoTbzNR3mqdHZTtrfoWJbQN9zabM+seRhlmp3FXjhwUgny5MNSa1q
	 fAQ0qsf2QxVy5+RMSxPHOaYKygKcmARt1YteSnfBsmnpZ66nISABAPXo9+fQxDAa1U
	 F/dlv0q2NYZKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B8C5E5FFC4;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Remove phy_stop() from
 bcmgenet_netif_stop()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327782110.8511.3849273203627486340.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 09:10:21 +0000
References: <20230504230727.729539-1-f.fainelli@gmail.com>
In-Reply-To: <20230504230727.729539-1-f.fainelli@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, opendmb@gmail.com,
 bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 May 2023 16:07:27 -0700 you wrote:
> The call to phy_stop() races with the later call to phy_disconnect(),
> resulting in concurrent phy_suspend() calls being run from different
> CPUs. The final call to phy_disconnect() ensures that the PHY is
> stopped and suspended, too.
> 
> Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()
    https://git.kernel.org/netdev/net/c/93e0401e0fc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



