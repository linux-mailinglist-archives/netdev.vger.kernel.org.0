Return-Path: <netdev+bounces-716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 681346F9416
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25E4B281188
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 21:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EA5101FA;
	Sat,  6 May 2023 21:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF8F210C;
	Sat,  6 May 2023 21:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FBB2C433D2;
	Sat,  6 May 2023 21:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683407419;
	bh=S2SnPkSUSJ6su6J8UTAAsasVzLaGWiu3YCm9awqcdxc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XXMFgn2GbwEZsWPvLu4R9QTtc95p45wE8QJCJge304gwgmnfEbVbIPwB5+MoZt7Zc
	 yKEEB6ZeKKN7n6h+YVe8aTVjK1I4ctIAkhwChVqaQ3rTWtONPXxEp88fXJ+LuErq4V
	 FEfqXC/4YciKJOqt7Zst0bviKcgbzEo1lrcUeizQ3LVqZRbUH3GrcAy8AqA/GlT/px
	 xzkguuHM7f04pzilaONWu9r3VES0mewn2QOCdbNv0k95Cp4thnIe6aVOoB+0BM6Jiw
	 jeLqGvT84gHPDbfAvQn+ScEjiwHkT/QWvDTJ17Ay/1Mb7CehRceSq23mO4NthYSaCS
	 UyhdyB3h5dzHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 312A9C395FD;
	Sat,  6 May 2023 21:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v7 0/2] Introduce a new kfunc of
 bpf_task_under_cgroup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168340741918.8652.6550838631520181968.git-patchwork-notify@kernel.org>
Date: Sat, 06 May 2023 21:10:19 +0000
References: <20230506031545.35991-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20230506031545.35991-1-zhoufeng.zf@bytedance.com>
To: Feng zhou <zhoufeng.zf@bytedance.com>
Cc: martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
 kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
 wangdongdong.6@bytedance.com

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sat,  6 May 2023 11:15:43 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Trace sched related functions, such as enqueue_task_fair, it is necessary to
> specify a task instead of the current task which within a given cgroup.
> 
> Feng Zhou (2):
>   bpf: Add bpf_task_under_cgroup() kfunc
>   selftests/bpf: Add testcase for bpf_task_under_cgroup
> 
> [...]

Here is the summary with links:
  - [bpf-next,v7,1/2] bpf: Add bpf_task_under_cgroup() kfunc
    https://git.kernel.org/bpf/bpf-next/c/b5ad4cdc46c7
  - [bpf-next,v7,2/2] selftests/bpf: Add testcase for bpf_task_under_cgroup
    https://git.kernel.org/bpf/bpf-next/c/49e0263ab40f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



