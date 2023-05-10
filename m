Return-Path: <netdev+bounces-1376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D40D6FDA3F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 341F31C20CD6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DBF65D;
	Wed, 10 May 2023 09:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDBD364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06251C433D2;
	Wed, 10 May 2023 09:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709221;
	bh=17CA1vXSaVt1t/zRcrvZOp1t8vTn7RM/lVbyGqlAE1s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=t4AGts4y6+qPGfMGr4wC0Vt5MfpLj8yVNgNBys5P+bygqYjN43uRvUiKxisdpEbEI
	 TG6Vd5QYQ+7ryna/T+H/0V4DGVby1+TQ6kouhFvRMCuyRpuOHtFWxsjfXLo9B2Kz8t
	 iw0HU/34fbEtwnMhTFRuf4hzXs3sbix81eKVFm4hm31vhKOf11DtSbq6mzgkcSfLKp
	 rhanFHFCSXecSeqR67oTt2jZCBAecDzswuzqkqZP+a9LaQKUuBYxDFpaeRJoqlq/O7
	 O5PAcVix2PFUAZQklWxV3YpEW2CvxCwR406wbZrfOm7AAlsMa2E2ctKxYxaqNGmePv
	 GhirqtJA24QwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DD8A0E270C4;
	Wed, 10 May 2023 09:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: annotate sk->sk_err write from do_recvmmsg()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370922090.25656.11175266867462281656.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:00:20 +0000
References: <20230509163553.3081476-1-edumazet@google.com>
In-Reply-To: <20230509163553.3081476-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 16:35:53 +0000 you wrote:
> do_recvmmsg() can write to sk->sk_err from multiple threads.
> 
> As said before, many other points reading or writing sk_err
> need annotations.
> 
> Fixes: 34b88a68f26a ("net: Fix use after free in the recvmmsg exit path")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> [...]

Here is the summary with links:
  - [net] net: annotate sk->sk_err write from do_recvmmsg()
    https://git.kernel.org/netdev/net/c/e05a5f510f26

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



