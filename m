Return-Path: <netdev+bounces-4485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961C270D16E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50DDB280EDA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD764C95;
	Tue, 23 May 2023 02:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7564C8D;
	Tue, 23 May 2023 02:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A16CC4339E;
	Tue, 23 May 2023 02:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684809619;
	bh=zjgwag9ZdCze0QagvwjnO6eLEQj7OrrBNwtXTpYaZ9U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WvBHOAdx0b6POQ3wdzASqDqHuDJCLPN8oRdS0UZOemy7SJ6uklsK7p+t4SgaI3o6w
	 QRWZY7zd9m9iNSUvc0BnrJ55k0NNitFdVp/unGvP37OqNF90McOyrYzbv62zW0CBKv
	 e8OFsKKSWAtbsgmw0kwVX3gc7wNVBX3zHnEDXr5csprwxV1r31KMhRRGoer6f2Vww8
	 Tg/gVumwSukzH0ka0qaSeKNHpbCKWz5uPbM8CRzGHBYgWA96ck8A7wkk9fxTrNuiWX
	 cj3pYxrxxILzn3CnV8lzdVAZVAL2r+Sv52vCnMSEwBaBljA5/P/MD4HwIHkottfeah
	 nt7yLDCHzXxAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 436D3E22AEC;
	Tue, 23 May 2023 02:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/handshake: Squelch allocation warning during Kunit
 test
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168480961927.27018.8602474022287809118.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 02:40:19 +0000
References: <168451636052.47152.9600443326570457947.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: <168451636052.47152.9600443326570457947.stgit@oracle-102.nfsv4bat.org>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
 lkft@linaro.org, chuck.lever@oracle.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 May 2023 13:12:50 -0400 you wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> The "handshake_req_alloc excessive privsize" kunit test is intended
> to check what happens when the maximum privsize is exceeded. The
> WARN_ON_ONCE_GFP at mm/page_alloc.c:4744 can be disabled safely for
> this test.
> 
> [...]

Here is the summary with links:
  - [v2] net/handshake: Squelch allocation warning during Kunit test
    https://git.kernel.org/netdev/net/c/b21c7ba6d9a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



