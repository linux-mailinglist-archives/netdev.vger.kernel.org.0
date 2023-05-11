Return-Path: <netdev+bounces-1641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0105C6FE9BD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B11A02814CA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76FEF1F18E;
	Thu, 11 May 2023 02:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A971F18A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B30ABC4339B;
	Thu, 11 May 2023 02:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683771021;
	bh=r7cJ6hTw0f6gjCjmRW7DE3AIgRyg917G6BLJiE3BG0c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XeKXRD1KobfUGApM1CKhykpyyKvVGfTfpO5M7UvJ5fXb0IJHcwRit776HNfD5a/Em
	 LrICrM/h7p/OA3fZNNIn+mE6G1t0yJ2DA5tugHDVszwoFxu7mBUTuSPPSRDPNr2v8c
	 oQ2xG0+jRhg+1CIntMDZWaYr//A9n6QCec4HWcYSN9sBu25/+uC62Vj3c46c/Jj+GI
	 aYkMuwBALI98GgrkTkl0sY+sG7FYyIGaQuGzOLabqJdr9yS9mF/69P+oik51R0JTMM
	 Yd8xsoJE8NNK3bH1L90IE8lc7WamMdsS3//59rBNeIigVS19STG2/VpP+AYjwDNxiB
	 jKFlmII/79xIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82075E4D010;
	Thu, 11 May 2023 02:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: datagram: fix data-races in datagram_poll()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168377102152.6855.2484055761766516586.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 02:10:21 +0000
References: <20230509173131.3263780-1-edumazet@google.com>
In-Reply-To: <20230509173131.3263780-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 May 2023 17:31:31 +0000 you wrote:
> datagram_poll() runs locklessly, we should add READ_ONCE()
> annotations while reading sk->sk_err, sk->sk_shutdown and sk->sk_state.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/datagram.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net] net: datagram: fix data-races in datagram_poll()
    https://git.kernel.org/netdev/net/c/5bca1d081f44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



