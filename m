Return-Path: <netdev+bounces-9132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C8A727673
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 532212815CB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:01:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A311463A8;
	Thu,  8 Jun 2023 05:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F2046B0;
	Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F3B6C433A0;
	Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686200423;
	bh=yCt5QRWWhXw/+6LFwmpWYwFYgJ/btCI/6MDTutMl3JM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WyDKA65czsbT77q7BAcccpTd1qdzmfG5UlSQhtfaZzpqT8403xcldBgmIIjubdoGs
	 Wnoem2iIRDBNbf8enD4HcZTNc4AeGOO9hsbGh9QIoSlZDdJelmgjz0hfEvcgBToSkI
	 vvkiuq0iqx7FJkU9xd0bat3C9M+gIEbG36SeZ7tA86ydEFJtNyxCFXPxe4RNe0KCBq
	 S6pD/A9I5RlII5TssNZ9Ya/QZqLN6C+PWMTsxjCK0sfNG3pAkmFcGdG1EPzvnXqHGo
	 MOVzfA5QzjKIsBhBDQCYLoAIJw3/Yt/mVKHdP99uEseBJ2Pz7xWGwC23bxniDBZ1hH
	 Z9bkrSF2vZMLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03FFEE4D015;
	Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-06-07
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168620042301.23382.8768833714174581147.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 05:00:23 +0000
References: <20230607220514.29698-1-daniel@iogearbox.net>
In-Reply-To: <20230607220514.29698-1-daniel@iogearbox.net>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Jun 2023 00:05:14 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 7 non-merge commits during the last 7 day(s) which contain
> a total of 12 files changed, 112 insertions(+), 7 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-06-07
    https://git.kernel.org/netdev/net/c/c9d99cfa66df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



