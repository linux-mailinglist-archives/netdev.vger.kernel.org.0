Return-Path: <netdev+bounces-5230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E29710552
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8A721C20D30
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5627A847F;
	Thu, 25 May 2023 05:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7651199
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FB90C433EF;
	Thu, 25 May 2023 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684992620;
	bh=69ZscPM+vcMgTLhYEhu0Xt6/uvTeFQNu07bjNBA6cLA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sbqi2QOi3R+525UlFQkU6u3X8MMqmH9eepf0aDVbzOR6sN1HxGjJVrgTNfzFyFcoO
	 3gveS1mFfcdVnNujSFPFnNPGwg3AiESq7GIJESPWipMyaZXfHm3zHhDoUFijO23f0A
	 w1nAg43u0tNZ3Zjm2i5GNp4gcPocUCBKtxWrrXKZrIjcGNkgWlLS6UC4VMo68/I4N+
	 YF//w2CLkGqD7lqMGsXGZVVo6OIAv40xYx3cy3Ec7j1CyrNmq0k8oECaR+5kP2UekX
	 C7Fvwm4Oqq7myyBNP0Y1dXT3ZyiGC4G57lAliJw01GmXs0KhcDFnixh03fVrSWA3PI
	 vHQM7+uL7dOWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F998E4D023;
	Thu, 25 May 2023 05:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: provide phylink_pcs_config() and
 phylink_pcs_link_up()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168499262018.12502.7423850376685443307.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 05:30:20 +0000
References: <E1q1TzK-007Exd-Rs@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1q1TzK-007Exd-Rs@rmk-PC.armlinux.org.uk>
To: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 May 2023 16:31:50 +0100 you wrote:
> Add two helper functions for calling PCS methods. phylink_pcs_config()
> allows us to handle PCS configuration specifics in one location, rather
> than the two call sites. phylink_pcs_link_up() gives us consistency.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 54 ++++++++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 20 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: provide phylink_pcs_config() and phylink_pcs_link_up()
    https://git.kernel.org/netdev/net-next/c/ae4899bb486f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



