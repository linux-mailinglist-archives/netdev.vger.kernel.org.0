Return-Path: <netdev+bounces-3229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA737706251
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 790661C20DEB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780E11549F;
	Wed, 17 May 2023 08:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF0A101E8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C4F3DC4339C;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684311020;
	bh=J95ETtWj/ClKNuMO0i6UcqA9C8357/9fOTa1PGDP95A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EcMY2OPZHdL28j5qal/0s5vfc8jkinVZ5MYtN4YLdY5ZhhLXMOvhz3bTdJ4goo/k/
	 yVw8MAwHSTMdNQbcx29N7P5zsmgKkMtgvT24+8hPCuPYUlDD6heW1sijm67NJVe6Vi
	 5mXjNLNLlCJkkuPUKVZ2jlMGsHR0BF3yx8PI+WRHl13ewbCrUeSAAMchjVzqow2Wfh
	 gYxrVY+l7PfEP1jVG+fZ/+g0ooe5YYKH1QTfMa4+GEo1g1+ddUGe+gGuIdlZpBISKB
	 vAc2hd761UetpFKDwoM4ZHGLuTAfwX7XPM/pbZWhmt1ilsflc7VU8HnQrwfvg07TYi
	 ARjdrMRCPWoLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC4CAC73FE2;
	Wed, 17 May 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] tun: Fix memory leak for detached NAPI queue.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431102070.18881.1820968110952318419.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:10:20 +0000
References: <20230515184204.10598-1-kuniyu@amazon.com>
In-Reply-To: <20230515184204.10598-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, jasowang@redhat.com, kuni1840@gmail.com,
 netdev@vger.kernel.org, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 May 2023 11:42:04 -0700 you wrote:
> syzkaller reported [0] memory leaks of sk and skb related to the TUN
> device with no repro, but we can reproduce it easily with:
> 
>   struct ifreq ifr = {}
>   int fd_tun, fd_tmp;
>   char buf[4] = {};
> 
> [...]

Here is the summary with links:
  - [v1,net] tun: Fix memory leak for detached NAPI queue.
    https://git.kernel.org/netdev/net/c/82b2bc279467

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



