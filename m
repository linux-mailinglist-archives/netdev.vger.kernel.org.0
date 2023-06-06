Return-Path: <netdev+bounces-8611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D746724D3C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19F2328102A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012FC23C7C;
	Tue,  6 Jun 2023 19:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF53125CC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C12CC433D2;
	Tue,  6 Jun 2023 19:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686080421;
	bh=tQH9XtdXOdEA5JFMSvmS10leC0FXtBvjMwvlnhgjpT4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XW5CWbFWHOhBEKquhFB4KzAv29iuZkwUAZ5FRp2ueqosSpIbMQLKZlmf0jhCbDcT7
	 Gd6Ov0dj9scf7i2rsLkx07sPTugzt9GBs0H4yIjdSV4rcjphjxlx9X/hmm8S+jsln3
	 FiVr1KBR1QqfTunXooDY+kSo3QYjLizHLyPAHUOA+y8vxjSmaFfIwBRLRNSrCj5gje
	 SBah7eX9eBm5usDNUV9jzlS+12pvGYGwYXxbtVxAu/B5WQn5ocpXhdhqLISGChLjTP
	 5VB9CjZ3nt8xcolSZFf6vA36Vk9bkD4s+0cL/mYtY8oSjENRufrPIzvHAZKeMKgavH
	 CT7jS/y0za9TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0AE91C4166F;
	Tue,  6 Jun 2023 19:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] tools: ynl: user space C
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168608042102.24410.12444977107543828777.git-patchwork-notify@kernel.org>
Date: Tue, 06 Jun 2023 19:40:21 +0000
References: <20230605190108.809439-1-kuba@kernel.org>
In-Reply-To: <20230605190108.809439-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, simon.horman@corigine.com, sdf@google.com,
 willemdebruijn.kernel@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Jun 2023 12:01:04 -0700 you wrote:
> Use the code gen which is already in tree to generate a user space
> library for a handful of simple families. I find YNL C quite useful
> in some WIP projects, and I think others may find it useful, too.
> I was hoping someone will pick this work up and finish it...
> but it seems that Python YNL has largely stolen the thunder.
> Python may not be great for selftest, tho, and actually this lib
> is more fully-featured. The Python script was meant as a quick demo,
> funny how those things go.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] tools: ynl-gen: clean up stray new lines at the end of reply-less requests
    https://git.kernel.org/netdev/net-next/c/a99bfdf64795
  - [net-next,v3,2/4] tools: ynl: user space helpers
    https://git.kernel.org/netdev/net-next/c/86878f14d71a
  - [net-next,v3,3/4] tools: ynl: support fou and netdev in C
    https://git.kernel.org/netdev/net-next/c/d75fdfbc6f26
  - [net-next,v3,4/4] tools: ynl: add sample for netdev
    https://git.kernel.org/netdev/net-next/c/ee0202e2e731

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



