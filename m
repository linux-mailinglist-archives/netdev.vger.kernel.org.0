Return-Path: <netdev+bounces-5836-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E00713148
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:06:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4C322819D4
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E5E380;
	Sat, 27 May 2023 01:06:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF09837D;
	Sat, 27 May 2023 01:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54886C433D2;
	Sat, 27 May 2023 01:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685149570;
	bh=Im+mbOYpXq0psYQk80W8X+3HhgyTTWi4jqRlij+6PsQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BsbdRRQcKt3KAnLDT4TLmB447TV1Xu+3pcFEtD8yfDnwNjqyOsGzd419c0xOLPWQf
	 y1frV8c2aUrmx0SMGCSfE+TgL4NqcMGNFZLcvEK+f59bMsEz3DY52E+qi3LdKEBPN1
	 x8FvGV9HyVFLSeFoOkMIiTvwMgLax1drcvaIm4fu4/70SNhB7Can1+Q0INmXDTorG8
	 2dPcPb9rzB4iLqQcSWwvJyy4bI+BC8OPvTRMXa+PqBrnY7aejoTegy2D5PFnfNjddw
	 qzWgUp8u+8J54J8ILWqV1P0IGMjdE2VjIxfxZgCvG0DYLM72wnNCeMKh8EH0UpOncu
	 tRMoRTW+hCReg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41BD7E21ECD;
	Sat, 27 May 2023 01:06:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-05-26
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168514957026.32430.15128757597078806721.git-patchwork-notify@kernel.org>
Date: Sat, 27 May 2023 01:06:10 +0000
References: <20230526222747.17775-1-daniel@iogearbox.net>
In-Reply-To: <20230526222747.17775-1-daniel@iogearbox.net>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 27 May 2023 00:27:47 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 54 non-merge commits during the last 10 day(s) which contain
> a total of 76 files changed, 2729 insertions(+), 1003 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-05-26
    https://git.kernel.org/netdev/net-next/c/75455b906d82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



