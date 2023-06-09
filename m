Return-Path: <netdev+bounces-9497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5996072971E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB9981C20D1F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E8EA93C;
	Fri,  9 Jun 2023 10:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8523B0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18FBFC4339B;
	Fri,  9 Jun 2023 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686307221;
	bh=bmK7GKeO4yAe5dnQNCi7jMw6V0mfDeaNUKDOcDc3dxY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qU1V8FRqnOYgyaieKTIipkBuLAJHN9paGU5VZbJhSDuzOqoaLM4Ij0S2RpxJj7/7f
	 VIuMWFDHDDE4N9kEIit+ckAmRyhdnFyXd3u9M4Az4R8n0FknG4eqefoKsGB+aw6d5W
	 PuK2wUlbS/Fnib0oRs/L+jm6eL5rrCs3KHl/W77DhYYniTW3gCpPyhj5jbhK27PaOg
	 yHtscMdqnhSmwzi8bvzgAzzfk+nPa3a3ddNpdlFJJrlQbwae8Cso5YjtkHZL+Cb7vo
	 puy6t1qiK29rMJLVBziiNdTEisS7/C25puZL0Q+vTKkKA2G7hL3LXMySzfnVP0X0UN
	 H4fwht625m1jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7AD8C395EC;
	Fri,  9 Jun 2023 10:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] tools: ynl: Remove duplicated include in
 handshake-user.c
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630722093.15877.581453069789899655.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 10:40:20 +0000
References: <20230608083148.5514-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230608083148.5514-1-yang.lee@linux.alibaba.com>
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 abaci@linux.alibaba.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  8 Jun 2023 16:31:48 +0800 you wrote:
> ./tools/net/ynl/generated/handshake-user.c: stdlib.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5464
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  tools/net/ynl/generated/handshake-user.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [-next] tools: ynl: Remove duplicated include in handshake-user.c
    https://git.kernel.org/netdev/net-next/c/e7c5433c5aaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



