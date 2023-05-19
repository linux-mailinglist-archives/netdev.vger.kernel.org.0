Return-Path: <netdev+bounces-3838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D397E70911F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B469281B30
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852F45667;
	Fri, 19 May 2023 08:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788E42109
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D569C433AE;
	Fri, 19 May 2023 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684483221;
	bh=TDR/scnjzukq+dLtHX6t1WC2zHG2+M9GmFkzYORuBB0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QG1QdB90nnAtdVeZaog2Pf7rW4+4xuI0sH1gCNUWr3sX1dMXMnSoEP7iIDc7HcB/R
	 LIA7lKP8+WTuRXqcguT+h8Mkzm2RYbqCZCjtjkjXTfL1kJu2FI1MsfdQVkqYslwUKb
	 /pygi7q71tbBnwKQPHfMIdBrWG6uBmCNyMt4m0c7hnA1qJN88s9+9HPq3QSMLm5d7D
	 JUBByUFbuCAWSm9VIAgcOTNiRf9KdCQEhsAqvlZ2HlvdFO3QISkIDj0XDd+GDNHAOV
	 cYUqf5S8dQcwke2BDZKyuhRBWsMP+m+ZAN0vel4iEhX811qCcitvZ2Qw3uX8DLK9t5
	 zjK6RIg/aub1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4CFFE21EFA;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] selftests: fib_tests: mute cleanup error message
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448322092.32188.11445831777854335044.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 08:00:20 +0000
References: <20230518043759.28477-1-po-hsu.lin@canonical.com>
In-Reply-To: <20230518043759.28477-1-po-hsu.lin@canonical.com>
To: Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 netdev@vger.kernel.org, roxana.nicolescu@canonical.com, shuah@kernel.org,
 pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 12:37:59 +0800 you wrote:
> In the end of the test, there will be an error message induced by the
> `ip netns del ns1` command in cleanup()
> 
>   Tests passed: 201
>   Tests failed:   0
>   Cannot remove namespace file "/run/netns/ns1": No such file or directory
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] selftests: fib_tests: mute cleanup error message
    https://git.kernel.org/netdev/net/c/d226b1df3619

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



