Return-Path: <netdev+bounces-10070-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B85E72BD11
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6051C20AA4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5779118C2D;
	Mon, 12 Jun 2023 09:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA7F18C14
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44269C433B3;
	Mon, 12 Jun 2023 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686563421;
	bh=CezdVL33asTp+QCAsDrtsg3Oq74MmAINSOzqCnmZfIU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=d3JaJT5sf8uBfMGJTZ2DbEYdYIVpDLExSESatpg+QlWFRPeARnXaQdNiVzGtnYSNe
	 40V0TD5MhuVCCqHE9O/G2WvZwD1bFSBDo0O8mC2vtg0az0OvK3T0R7QhiA95tw9ZDQ
	 LrQePyfApalrUrEbhI3cLIs8EvmcSTE6Jl+X8TcMOUvL2TTcC+YO9uCWY/KZc6pAp6
	 R3UleSRQtkxcxkHw+0IDAUUgLEwQhVrV4av8+QA9uCu1nOusmTQKa0UcdF45cUMMvf
	 gEI2HcNCv/+BTRcvEoE/zOZ79B8x2xS5UV4oCF6PclotXQ/Ci88QhIjt+aUWhryiYw
	 sCQkWN4jyHIbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAAE7E1CF31;
	Mon, 12 Jun 2023 09:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/4] Add SCM_PIDFD and SO_PEERPIDFD
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168656342089.25012.9925385632760123942.git-patchwork-notify@kernel.org>
Date: Mon, 12 Jun 2023 09:50:20 +0000
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
 dsahern@kernel.org, arnd@arndb.de, keescook@chromium.org, brauner@kernel.org,
 kuniyu@amazon.com, mzxreary@0pointer.de, bluca@debian.org,
 daniel@iogearbox.net, sdf@google.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 22:26:24 +0200 you wrote:
> 1. Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
> 
> 2. Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
    https://git.kernel.org/netdev/net-next/c/5e2ff6704a27
  - [net-next,v7,2/4] net: core: add getsockopt SO_PEERPIDFD
    https://git.kernel.org/netdev/net-next/c/7b26952a91cf
  - [net-next,v7,3/4] selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
    https://git.kernel.org/netdev/net-next/c/ec80f488252b
  - [net-next,v7,4/4] af_unix: Kconfig: make CONFIG_UNIX bool
    https://git.kernel.org/netdev/net-next/c/97154bcf4d1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



