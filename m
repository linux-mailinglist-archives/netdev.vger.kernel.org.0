Return-Path: <netdev+bounces-10022-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59F0972BB73
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3097E28112E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6120B14266;
	Mon, 12 Jun 2023 09:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BCF111A1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF38FC4339E;
	Mon, 12 Jun 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686560421;
	bh=cETVgWle9xUiX7QBXYIHXqMUieFJxqH3lFJu/MGpPsk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ijfwbrSTDKXhLN8XRH8UOXxZ1zrTb/Mf5Mnf6CBuSk3aplTUIbvpbcactpZYA7LSB
	 jR3IP0M35a+BoWOR15XvjZe9X0iQuj/5Ekc1eCE9InqZOh5K45bEQ7lA4XNZH4PC2U
	 vCXGDXwnBzEVA8QCd5w7BP9CuBIZwAVr2DLxLaFjT+AbUXe3EuZJyBBMvOaoH2X6Jj
	 98cjivoBvAqg6Uhby2ARGLKC0etOFKbaetZdT3AtbNOcO7xzAhJWazD8Egu0RTCLVD
	 MXKetlQGllsdJQ8Jp6o/2xSCM+UTpflN5K4q8Ab7h5cqZSBl5PvurY3a1JoulpxcK2
	 JVXtbEtL+8x1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9621AE1CF31;
	Mon, 12 Jun 2023 09:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Cleanups in router code
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656042161.13780.5286525591847849083.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 09:00:21 +0000
References: <cover.1686330238.git.petrm@nvidia.com>
In-Reply-To: <cover.1686330238.git.petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
 amcohen@nvidia.com, mlxsw@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 9 Jun 2023 19:32:05 +0200 you wrote:
> This patchset moves some router-related code from spectrum.c to
> spectrum_router.c where it should be. It also simplifies handlers of
> netevent notifications.
> 
> - Patch #1 caches router pointer in a dedicated variable. This obviates the
>   need to access the same as mlxsw_sp->router, making lines shorter, and
>   permitting a future patch to add code that fits within 80 character
>   limit.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum_router: mlxsw_sp_router_fini(): Extract a helper variable
    https://git.kernel.org/netdev/net-next/c/50f6c3d57e9a
  - [net-next,2/8] mlxsw: spectrum_router: Move here inetaddr validator notifiers
    https://git.kernel.org/netdev/net-next/c/41b2bd208e8a
  - [net-next,3/8] mlxsw: spectrum_router: Pass router to mlxsw_sp_router_schedule_work() directly
    https://git.kernel.org/netdev/net-next/c/48dde35ea157
  - [net-next,4/8] mlxsw: spectrum_router: Use the available router pointer for netevent handling
    https://git.kernel.org/netdev/net-next/c/14304e70634c
  - [net-next,5/8] mlxsw: spectrum_router: Reuse work neighbor initialization in work scheduler
    https://git.kernel.org/netdev/net-next/c/151b89f6025a
  - [net-next,6/8] mlxsw: Convert RIF-has-netdevice queries to a dedicated helper
    https://git.kernel.org/netdev/net-next/c/0255f74845c0
  - [net-next,7/8] mlxsw: Convert does-RIF-have-this-netdev queries to a dedicated helper
    https://git.kernel.org/netdev/net-next/c/5374a50f2eb6
  - [net-next,8/8] mlxsw: spectrum_router: Privatize mlxsw_sp_rif_dev()
    https://git.kernel.org/netdev/net-next/c/df95ae66cc0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



