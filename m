Return-Path: <netdev+bounces-2067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 116E6700287
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1BD8281A54
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93FE9BE53;
	Fri, 12 May 2023 08:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B1FAD50;
	Fri, 12 May 2023 08:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C011EC433D2;
	Fri, 12 May 2023 08:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683880222;
	bh=8N3DXJcAr3A7kCJuTG/s18y8W0HarR46MZ27ZVZkNDY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=rrl9yuvXHe1b4u0E1nLcdJmGbJDaUMvDcNGxXonDYAQ4muTG6bXqgP9zk0ZCTZejy
	 yPc0T5SWsCy5Jo0dUe+Os9Jz9Nu6f6GBSRY/h7uO7cT8OZ88yW7GBZiKy2/ZFnwOkQ
	 9HMEOCnwiHRwCoBwmKzgzsgpiO+MGUor9+8bAHam+7RVLTIN7bB3JISxIjSZo5WtiT
	 7PL9KotjLu5dyb3BqX0HcnZWv1sMdfynSew5UsulmrFtrAfCtjIenTwSkz0eL8q//P
	 Rr9u0CIyeRDfZj8NJpiyFoXKFOrmOgAw36OMSdHIVYnjwPdL7RarQlr90ul8XzCx9A
	 6+juf2RaYnUOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A356DE450BB;
	Fri, 12 May 2023 08:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/6] Bug fixes for net/handshake
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388022266.32195.10733387382160295222.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:30:22 +0000
References: <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <168381978252.84244.1933636428135211300.stgit@91.116.238.104.host.secureserver.net>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
 dan.carpenter@linaro.org, chuck.lever@oracle.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 11:46:39 -0400 you wrote:
> Please consider these for merge via net-next.
> 
> Paolo observed that there is a possible leak of sock->file. I
> haven't looked into that yet, but it seems to be separate from
> the fixes in this series, so no need to hold these up.
> 
> Changes since v2:
> - Address Paolo comment regarding handshake_dup()
> 
> [...]

Here is the summary with links:
  - [v3,1/6] net/handshake: Remove unneeded check from handshake_dup()
    https://git.kernel.org/netdev/net-next/c/b16d76fe9a27
  - [v3,2/6] net/handshake: Fix handshake_dup() ref counting
    https://git.kernel.org/netdev/net-next/c/2200c1a87074
  - [v3,3/6] net/handshake: Fix uninitialized local variable
    https://git.kernel.org/netdev/net-next/c/7301034026d0
  - [v3,4/6] net/handshake: handshake_genl_notify() shouldn't ignore @flags
    https://git.kernel.org/netdev/net-next/c/e36a93e1723e
  - [v3,5/6] net/handshake: Unpin sock->file if a handshake is cancelled
    https://git.kernel.org/netdev/net-next/c/f921bd41001c
  - [v3,6/6] net/handshake: Enable the SNI extension to work properly
    https://git.kernel.org/netdev/net-next/c/eefca7ec5142

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



