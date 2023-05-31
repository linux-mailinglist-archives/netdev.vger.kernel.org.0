Return-Path: <netdev+bounces-6774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C64717DC0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90A651C20506
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9C914277;
	Wed, 31 May 2023 11:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C324BC8EA;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68FCFC433AC;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685531421;
	bh=FPFcVsxFDHWUA/K7a3KuzDqudNUNFy//Xing6rKzvoQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=m+DqHJ0zQj8KriiyBfn1TRBjWr08KcVIH4vf2cmjjXqSR0fn/PiWQSHx/9zJ3jfsw
	 6RmrMLArE7YG+3SNjhHGt2AR9f4caAFND+reU1bugY0KR9PfuBFWSsIfbZmMqGgpeI
	 1myxhAaorRGbkpQvZKNdtPAQjX00nc0cVUdor8M1NjRKYTE66VLy++5YAiozrT0V4Z
	 7vwKUT6USkUWoXbAU9FB7B9eXKvrYx9+FgUcwtbVHQwYxrM+Hxcd649GhyGe4cSKHu
	 STAau6N7M/jGQRijQluWopO5UV56Gqo9uGPdYnfXn93eFKovOIpL380v8Ib9Kt4Glg
	 Q6hWT4bwdGeGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42D93E21EC7;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: use umd_cleanup_helper()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168553142127.8778.2442831312976659281.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 11:10:21 +0000
References: <20230526112104.1044686-1-jarkko@kernel.org>
In-Reply-To: <20230526112104.1044686-1-jarkko@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: davem@davemloft.net, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 26 May 2023 14:21:02 +0300 you wrote:
> bpfilter_umh_cleanup() is the same function as umd_cleanup_helper().
> Drop the redundant function.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/linux/bpfilter.h     |  1 -
>  net/bpfilter/bpfilter_kern.c |  2 +-
>  net/ipv4/bpfilter/sockopt.c  | 11 +----------
>  3 files changed, 2 insertions(+), 12 deletions(-)

Here is the summary with links:
  - net: use umd_cleanup_helper()
    https://git.kernel.org/bpf/bpf-next/c/9b68f30b6870

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



