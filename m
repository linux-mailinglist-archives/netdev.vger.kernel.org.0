Return-Path: <netdev+bounces-1698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B335A6FEE06
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 474EA281659
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8BBA936;
	Thu, 11 May 2023 08:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185CE1B91A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7CE8C433EF;
	Thu, 11 May 2023 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683795020;
	bh=xl0Xitq47KEArGlxAkR+il8pxTTflnRB/a/XUe6Iaco=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=By156cclBzaz0yvGJZEg/bmlqiQZJnhJjq0D0/mbOa9c3JBB17nSpaEHB5GmjZgBo
	 pq78GDRQ99Xz4Axc+zeOjWjcI3Fdp+OT99m/d4C9Y3fvXUrrwSYFdgBMcVN8NblsDb
	 imMijzewRVrbAv0DpUAMetewsNkJ3LcqaDZhtIVQ77MEy6rMGbm0M0ghDEfT0qFn9A
	 1H3xn3DlvIyWAptcrQQLAPI+DM+XpkIaKn/7P8PjcdGLDKEZE9u7UGfZr6CZujhU4l
	 GSJJUPiQKkQrKV/r8bPkxJjyw2YzGpz3DHMedk/HxpEHWkAEDo5iv0TO6ASCT9rwQz
	 o/w/7NHjpI+NA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA21CE270C4;
	Thu, 11 May 2023 08:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: make the first N SYN RTO backoffs linear
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168379502075.11924.14596770886532600952.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 08:50:20 +0000
References: <20230509180558.2541885-1-morleyd.kernel@gmail.com>
In-Reply-To: <20230509180558.2541885-1-morleyd.kernel@gmail.com>
To: David Morley <morleyd.kernel@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org, morleyd@google.com, ycheng@google.com,
 ncardwell@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  9 May 2023 18:05:58 +0000 you wrote:
> From: David Morley <morleyd@google.com>
> 
> Currently the SYN RTO schedule follows an exponential backoff
> scheme, which can be unnecessarily conservative in cases where
> there are link failures. In such cases, it's better to
> aggressively try to retransmit packets, so it takes routers
> less time to find a repath with a working link.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: make the first N SYN RTO backoffs linear
    https://git.kernel.org/netdev/net-next/c/ccce324dabfe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



