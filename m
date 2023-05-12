Return-Path: <netdev+bounces-2069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EDB87002F8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C2C81C21144
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D48D9448;
	Fri, 12 May 2023 08:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFE263DE
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DAA1C4339B;
	Fri, 12 May 2023 08:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683881421;
	bh=X9Pu/LiQiiKwz6TGPhaPE8hjbz6pdhvFBqu2FNeuMz0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sge5yawgla0F/7DykQ19p+sc3xIQnRp/gOD3aI7LzOmPmH68QVE3yAsKdPHWS+29u
	 QAU0Qjb11K+li8rrARW3ZN8IWJAC2PIwyxDqjv2LHmT7Gwvg5K9tCkgxqQ+nTa7tia
	 aI2ft1tDUA7VZpdG3vogpFx87JCX3A7HJzMmZFVF0TEckZHPzgWD95oYgoQ0bHtDuK
	 AbUQUvnjKjHa+siS6bUknWILHHSbzcakF5wZ+Opnk6eDe6LkU5ce5WhE24cn8FuejL
	 zaZKUN8I67XEYcJ4xpciDRihywJh/6AUP5MJPUnsaLViS8eVAKAyv8HtvstztFKooS
	 0dt92cU4iU9Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F163E26D2A;
	Fri, 12 May 2023 08:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] selftests: fcnal: Test SO_DONTROUTE socket
 option.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388142124.10506.10899839192921232411.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:50:21 +0000
References: <cover.1683814269.git.gnault@redhat.com>
In-Reply-To: <cover.1683814269.git.gnault@redhat.com>
To: Guillaume Nault <gnault@redhat.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 16:39:19 +0200 you wrote:
> The objective is to cover kernel paths that use the RTO_ONLINK flag
> in .flowi4_tos. This way we'll be able to safely remove this flag in
> the future by properly setting .flowi4_scope instead. With these
> selftests in place, we can make sure this won't introduce regressions.
> 
> For more context, the final objective is to convert .flowi4_tos to
> dscp_t, to ensure that ECN bits don't influence route and fib-rule
> lookups (see commit a410a0cf9885 ("ipv6: Define dscp_t and stop taking
> ECN bits into account in fib6-rules")).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] selftests: Add SO_DONTROUTE option to nettest.
    https://git.kernel.org/netdev/net-next/c/aeefbb574c38
  - [v2,net-next,2/4] selftests: fcnal: Test SO_DONTROUTE on TCP sockets.
    https://git.kernel.org/netdev/net-next/c/dd017c72dde6
  - [v2,net-next,3/4] selftests: fcnal: Test SO_DONTROUTE on UDP sockets.
    https://git.kernel.org/netdev/net-next/c/a431327c4faa
  - [v2,net-next,4/4] selftests: fcnal: Test SO_DONTROUTE on raw and ping sockets.
    https://git.kernel.org/netdev/net-next/c/ceec9f272432

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



