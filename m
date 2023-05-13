Return-Path: <netdev+bounces-2374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA184701972
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31E0828161A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 19:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2971279EF;
	Sat, 13 May 2023 19:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3C79E4
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 19:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 085A7C4339C;
	Sat, 13 May 2023 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684005021;
	bh=1ZocONp4DA0hZVF5F9FN+KHrG6WuE9g7fF61lMmJBVU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=csx8n/7OUxDIBYiMJEoUhkwdHEkCulTSb7wZlh0pjxr25u3TFMQDklJeObp1xC0yX
	 mOCHwzGBod6wteKTdScXVR3KmXmTayVn1eKu4jjtdrSzMineuCIWT7U43yyPPChLf+
	 HPrUsimaUjeWn+eMif9Mn4iDWnk2GssYDMzddzR4evAgZdfMyS0fzk1YsyRJNOf3H0
	 ZIev93kfcgqecBqcCGS6wgGDyTJLViLnKY5v4AkTCMu+Q/XAF/rJRQZEvj+Fsha/M/
	 ZFPiRhX6B1CiS/lgEYolpq6VxAb1r8plZpttqyYokxrl4tieVjQS+IF1g1CH1D1nW8
	 PaADxUZMN/mPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DEB6AE450BA;
	Sat, 13 May 2023 19:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net-next] ping: Convert hlist_nulls to plain hlist.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168400502090.13341.2786137488958638337.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 19:10:20 +0000
References: <20230510215443.67017-1-kuniyu@amazon.com>
In-Reply-To: <20230510215443.67017-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 14:54:43 -0700 you wrote:
> Since introduced in commit c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP
> socket kind"), ping socket does not use SLAB_TYPESAFE_BY_RCU nor check
> nulls marker in loops.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/ping.c | 41 +++++++++++++++--------------------------
>  1 file changed, 15 insertions(+), 26 deletions(-)

Here is the summary with links:
  - [v1,net-next] ping: Convert hlist_nulls to plain hlist.
    https://git.kernel.org/netdev/net-next/c/f1b5dfe63f6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



