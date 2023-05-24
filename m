Return-Path: <netdev+bounces-4926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD2770F330
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 784BC1C20C4D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9069CC8DD;
	Wed, 24 May 2023 09:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07708C8D3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A37E0C4339B;
	Wed, 24 May 2023 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684921220;
	bh=Z58ofIwpx0xqu90o+JAxX76lMP3al0afoqz7guUamFE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Xm7KXaWlxqTTCtfNv/krq2ucjhb4pOjj5GsUG9+ImwzS2ZCMjtyPz+DwR4WGY7Pz2
	 fCD6GRAzqIHdzCbJwsozx21bM94KkrvLwgtEoV6rWIbJRXt3RK0vaenOOk9Sxu9S9Q
	 7GYSfRAQMJT0BmifeQIKi+s/F6bs7tA9cxpodP13ELbtUsw88DLAjBWiGMgKWbXa/B
	 +YSzHYJb5pfzsHfXUy+Jip273/0B61p+YVEIZHWNjjawJzqZHUqhwaKvmizFDp+DhU
	 TDEgazHx4Cgb6S4mbQuuVSNMW6filUfFJXSuZMhutSgDgPHFv91hNiC8315ZFFHm86
	 v2zgzkWY2oLHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A1D9E21ECE;
	Wed, 24 May 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/3] devlink: small port_new/del() cleanup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168492122056.15562.1210635654819470935.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 09:40:20 +0000
References: <20230523123801.2007784-1-jiri@resnulli.us>
In-Reply-To: <20230523123801.2007784-1-jiri@resnulli.us>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 davem@davemloft.net, edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
 moshe@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 May 2023 14:37:58 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset cleans up couple of leftovers after recent devlink locking
> changes. Previously, both port_new/dev() commands were called without
> holding instance lock. Currently all devlink commands are called with
> instance lock held.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] devlink: remove duplicate port notification
    https://git.kernel.org/netdev/net-next/c/c496daeb8630
  - [net-next,2/3] devlink: remove no longer true locking comment from port_new/del()
    https://git.kernel.org/netdev/net-next/c/1bb1b5789850
  - [net-next,3/3] devlink: pass devlink_port pointer to ops->port_del() instead of index
    https://git.kernel.org/netdev/net-next/c/9277649c66fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



