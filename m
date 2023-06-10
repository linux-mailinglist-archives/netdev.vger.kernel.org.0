Return-Path: <netdev+bounces-9796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F1672A9CD
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 09:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72C21C20F05
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 07:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7744479F1;
	Sat, 10 Jun 2023 07:21:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FE4A93F
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 07:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0B02C433A4;
	Sat, 10 Jun 2023 07:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686381694;
	bh=aN6RyebIPV23jIovuodEDkOVfgIt9Ez4gMvDX/brxCE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=g1u6k7CYk2zrannO1BhmMPG/VtC5t4zzZZVCtAKuluOzXGocH9tb6yYUvnckD3pTc
	 eecIwNwkyWnefBu4iOO9mEzbsHy/Xqn+tQLYOTnTUcMwqTUy7gyEsxaOYHOUezpNJ8
	 k603vFG1kzAgfdDSNk0Cbw4+jbeA9cb/qCnrNxmSwy1BtgS8pAky7fue/q7tkZVbwp
	 M6MDP3ohg3+2fndgUHDQGhkTr0Ldam0lEEUSJu6MPPPCsgiFhblKF7zCkK7Nip1DZ5
	 sgHwPqM7EOpGHzzghA73H2nPdo/g81F4DEOziYWkUPXTgJJwIMuGupFnpYdiiic19M
	 XUZjaF/qTylag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D8DDE87232;
	Sat, 10 Jun 2023 07:21:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/6] sfc: TC encap actions offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168638169464.9909.10938668183396287229.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 07:21:34 +0000
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1686240142.git.ecree.xilinx@gmail.com>
To:  <edward.cree@amd.com>
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, ecree.xilinx@gmail.com,
 netdev@vger.kernel.org, habetsm.xilinx@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 8 Jun 2023 17:42:29 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series adds support for offloading TC tunnel_key set actions to the
>  EF100 driver, supporting VxLAN and GENEVE tunnels over IPv4 or IPv6.
> 
> Edward Cree (6):
>   sfc: add fallback action-set-lists for TC offload
>   sfc: some plumbing towards TC encap action offload
>   sfc: add function to atomically update a rule in the MAE
>   sfc: MAE functions to create/update/delete encap headers
>   sfc: neighbour lookup for TC encap action offload
>   sfc: generate encap headers for TC offload
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/6] sfc: add fallback action-set-lists for TC offload
    https://git.kernel.org/netdev/net-next/c/e16ca7fb9ffb
  - [v2,net-next,2/6] sfc: some plumbing towards TC encap action offload
    https://git.kernel.org/netdev/net-next/c/b4da4235dc69
  - [v2,net-next,3/6] sfc: add function to atomically update a rule in the MAE
    https://git.kernel.org/netdev/net-next/c/69819d3bc408
  - [v2,net-next,4/6] sfc: MAE functions to create/update/delete encap headers
    https://git.kernel.org/netdev/net-next/c/f1363154c474
  - [v2,net-next,5/6] sfc: neighbour lookup for TC encap action offload
    https://git.kernel.org/netdev/net-next/c/7e5e7d800011
  - [v2,net-next,6/6] sfc: generate encap headers for TC offload
    https://git.kernel.org/netdev/net-next/c/a1e82162af0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



