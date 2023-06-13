Return-Path: <netdev+bounces-10312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4288F72DCC9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C692811F0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7613D78;
	Tue, 13 Jun 2023 08:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7A210D
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25489C433A0;
	Tue, 13 Jun 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686645620;
	bh=pVA7NtaVSG2jGLC4sck3GJKJYMm7KhMvFWTQCM1Mgrg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OwrNVJmYU/dFnG03vNUiIO4GXZRmNCIbgguMGAfaAVKUm5WTwq0yeD80P4CYN7jL1
	 Qkw8arAU31X7HvoA5OoubELp6Xv7shiLQasbLHAuc3QZCo4M5/VXY6PoeGo4KeoNk9
	 jXxiptokBdg3k+jBcKov88XkXqOyYFb55tliOQkg72AsD++vypbgrUoXkCYmAW7xXE
	 k07d8YSCbCsukpcpRQbzO5Kh8vs1YhrezKQ7+vjsfuJa8Za7mTxZnWceLPyJp5+Wlt
	 jYiY6CnME3/gL6YMPWjxACKHaBrH7nMZhnjbX4Qq2ShS2cSHL5BKjnh+o3ODp6o/VL
	 hnc1sEU2JxwGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 055EDE2A04A;
	Tue, 13 Jun 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: Fix layer 2 miss test syntax
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168664562000.8462.12970060679944399326.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 08:40:20 +0000
References: <20230611112218.332298-1-idosch@nvidia.com>
In-Reply-To: <20230611112218.332298-1-idosch@nvidia.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, razor@blackwall.org, petrm@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 11 Jun 2023 14:22:18 +0300 you wrote:
> The test currently specifies "l2_miss" as "true" / "false", but the
> version that eventually landed in iproute2 uses "1" / "0" [1]. Align the
> test accordingly.
> 
> [1] https://lore.kernel.org/netdev/20230607153550.3829340-1-idosch@nvidia.com/
> 
> Fixes: 8c33266ae26a ("selftests: forwarding: Add layer 2 miss test cases")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: forwarding: Fix layer 2 miss test syntax
    https://git.kernel.org/netdev/net-next/c/c29e012eae29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



