Return-Path: <netdev+bounces-1310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F058D6FD3EE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAF211C20C8C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F33F814;
	Wed, 10 May 2023 02:50:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BF9648
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58910C433AA;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683687026;
	bh=V/s57uoRYEm3pt8pyrooJhQRvtvYvdzEJkOWGFvknYA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jJ8DYJTM7t85KbCetZz9MeOS7h5OZrVbjms6jCiXUsnqU7pQZ0QkFfbFYCJad/oJX
	 I+MmejcG9Ls09bnlclIqZx86Sg0/+PzGkBwsuUXVD8mp1umEDtOKHEh0wMvfPs0iEQ
	 g2u5wsE56LPVd72UzACZY3QnYr9i02W/dw4Ywz+GnlsnuaYQnEITkdABWW4UdHmG3N
	 TH/kdtXPis5wOBKrSzYelKI2fZ6CHI4p0Cmjv+jC4T5RgRyXvIH46BD+m7WcvY/gB2
	 kuLrmJ1uMkr9B8SRoRJYtb3U3c/JYIgOEIwoiRzJ3yBfZsxpy9b1USfj8q5+KlAl8a
	 JAXkOv0uTSQyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42745E26D23;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: skbuff: remove special handling for SLOB
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168368702626.23144.11127488053640074262.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 02:50:26 +0000
References: <20230509071207.28942-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230509071207.28942-1-lukas.bulwahn@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, vbabka@suse.cz, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 May 2023 09:12:07 +0200 you wrote:
> Commit c9929f0e344a ("mm/slob: remove CONFIG_SLOB") removes CONFIG_SLOB.
> Now, we can also remove special handling for socket buffers with the SLOB
> allocator. The code with HAVE_SKB_SMALL_HEAD_CACHE=1 is now the default
> behavior for all allocators.
> 
> Remove an unnecessary distinction between SLOB and SLAB/SLUB allocator
> after the SLOB allocator is gone.
> 
> [...]

Here is the summary with links:
  - net: skbuff: remove special handling for SLOB
    https://git.kernel.org/netdev/net-next/c/559ae55cfc33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



