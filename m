Return-Path: <netdev+bounces-5223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BFF710528
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED4681C20E9A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF0F5250;
	Thu, 25 May 2023 05:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D863D8F;
	Thu, 25 May 2023 05:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5EE0C433D2;
	Thu, 25 May 2023 05:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684991423;
	bh=5511nHK3pmwHkOmFpJnIvrSdZBLdKcRsM7ran3CX0eE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FyIUE+E4Rq5pQVsvRtrLjCyeALpfvEjNEjTZ0hbUE7EFOiW+Hi+NhV1kOWMOMqnnF
	 Dmgq717bifzUsKTYUtc4//+Ms5OU4rWCehAJ/iCxNORy3BsU6Fw8WHM6ap9/naigc2
	 tnruB4n4KxXbFbSnFJySBUuBgjWvUgJ2R629Rpl7GskTlS95ix8FNW61IR3YhZwYbq
	 trRLR8SvyvCrdaj4ekEposO7+Snh2Cg5kVnAdi7eOXBY+iObmuKFPCl+Paj4aHNfwi
	 0BZSVfZJNdUduZIm4vSRcS/lfthKSqc2kgfBuxZa708UCaQ3X5ENFkCDy0vM4OtWni
	 8IrCARDWhZzZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98BB7E4F133;
	Thu, 25 May 2023 05:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2023-05-24
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168499142362.5256.9092605757282919723.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 05:10:23 +0000
References: <20230524170839.13905-1-daniel@iogearbox.net>
In-Reply-To: <20230524170839.13905-1-daniel@iogearbox.net>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 19:08:39 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 19 non-merge commits during the last 10 day(s) which contain
> a total of 20 files changed, 738 insertions(+), 448 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2023-05-24
    https://git.kernel.org/netdev/net/c/0c615f1cc3b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



