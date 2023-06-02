Return-Path: <netdev+bounces-7308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B86071F983
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 074C62819D3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA143D7A;
	Fri,  2 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D61867
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE17EC433EF;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685682020;
	bh=+0YnzVPdvfQsJB2IuBvdw3uDqzNe7nGlUfPDVvc5UBg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=a8xpx63iAQKFimh6//rF1YQg63ucpL6/jE0B2luM+zu+4jNvwNFsZtgcZj0zBmO5+
	 Ksyg/nItb0PWwQfUZUv40zyvzvGvOK0lwbIdTWLMd7IsXfSjqdc8XvIAqPMuD59PBr
	 oyqL4v3Qv7wO/yQsedSX2cUzCDG39iy4XcZsTHn/sraZiDKK4gh+XVdwL8NSuQ3ucc
	 /CL0bm5Ilnj1w0gg6aiDOaANyF0xs92cFZlURtuOLYEgq0cIXomqnVciFDhY2HATVE
	 PPiuHaSjgnJTbNu0Xq3I5/YXXSD5p96tASJ7O6JXYPLnqWrefab5gWXnuLfnjXbtD8
	 vQjejlw5uJrFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2746E29F3E;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] selftests/tc-testing: replace mq with invalid
 parent ID
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568202066.24823.18027233483936915493.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 05:00:20 +0000
References: <20230601012250.52738-1-shaozhengchao@huawei.com>
In-Reply-To: <20230601012250.52738-1-shaozhengchao@huawei.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, jhs@mojatatu.com,
 xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
 kuba@kernel.org, victor@mojatatu.com, peilin.ye@bytedance.com,
 weiyongjun1@huawei.com, yuehaibing@huawei.com, pctammela@mojatatu.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 1 Jun 2023 09:22:50 +0800 you wrote:
> The test case shown in [1] triggers the kernel to access the null pointer.
> Therefore, add related test cases to mq.
> The test results are as follows:
> 
> ./tdc.py -e 0531
> 1..1
> ok 1 0531 - Replace mq with invalid parent ID
> 
> [...]

Here is the summary with links:
  - [net-next,v2] selftests/tc-testing: replace mq with invalid parent ID
    https://git.kernel.org/netdev/net-next/c/a395b8d1c7c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



