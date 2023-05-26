Return-Path: <netdev+bounces-5504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1987E711EAB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD7731C20F7C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8127F1C26;
	Fri, 26 May 2023 04:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC2220E6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AC3CC433A8;
	Fri, 26 May 2023 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074221;
	bh=Pj/vDSe8irCkD5VfjzmyPnbOqWfZufrzNijl7p5smhc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ppM+8xBNSA6YDT+FdyZz60Lp2roLRSnDWLM9oBFqVn9ogubq1xUoyPji8eccf8x2m
	 cCcyPKbUxsT+1Xt9XOt/Dapj/CtaMHTw3B0El0pXb6ulm8f9fslmLnrxsUu08A2d0N
	 czxwWysPpHLgUQe7FSTfeiNLZ2adnLh1aKN6BDQOCk8aFNK+A3y15EqGh32Ad6mKhT
	 DvooY/bCzlNoy1Y8jLgeqz29LP5FDJ8LckxCt99Qvq9vBRJsMwWUAYGxbLypv3wW7Q
	 gdYgPAftudIraiVT00knaSj8NMEx4/EJIOZtJCXVc9ITYpOZ053ll/lluPQ7cf/6Rm
	 P2OdeJdAJ2uSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2E24E4F133;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] af_packet: Fix data-races of pkt_sk(sk)->num.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507422098.22221.577900661698187414.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:10:20 +0000
References: <20230524232934.50950-1-kuniyu@amazon.com>
In-Reply-To: <20230524232934.50950-1-kuniyu@amazon.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, willemdebruijn.kernel@gmail.com, xemul@parallels.com,
 kuni1840@gmail.com, netdev@vger.kernel.org, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 16:29:34 -0700 you wrote:
> syzkaller found a data race of pkt_sk(sk)->num.
> 
> The value is changed under lock_sock() and po->bind_lock, so we
> need READ_ONCE() to access pkt_sk(sk)->num without these locks in
> packet_bind_spkt(), packet_bind(), and sk_diag_fill().
> 
> Note that WRITE_ONCE() is already added by commit c7d2ef5dd4b0
> ("net/packet: annotate accesses to po->bind").
> 
> [...]

Here is the summary with links:
  - [v1,net] af_packet: Fix data-races of pkt_sk(sk)->num.
    https://git.kernel.org/netdev/net/c/822b5a1c17df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



