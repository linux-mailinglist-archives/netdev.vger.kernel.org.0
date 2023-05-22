Return-Path: <netdev+bounces-4201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D91E970B9EB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C698280EFC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B522BA28;
	Mon, 22 May 2023 10:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3162EAD55
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF184C4339B;
	Mon, 22 May 2023 10:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684750819;
	bh=PV9zecWy4/YM6WwOgR+pxHNR54i6kDfQ45MfSYPZp4Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=D0sL1PcEOi/4T8VJ/5N/rXNmWIeUsNmT7p0CsvZSlEHsN+PPDm1r8p8soY7PHuc8r
	 nQwc9ldAEskiMHUgXC2e03E7YwGDauomYkmMDn7W9rxb5n55ygCQ3V3FbxFEslYjtY
	 SzBCPDMRKzxC+kdlbIumE087pW18AktZ5aH+DYKcC0y3UAGPx3rzT9e/jNYXP0uU7l
	 Jo5OdCVpiGhhf5EZF9LTIfvlpOvam51WJfxCD1SqwsR6k7dFO7IF2r1lR4ppjLwFP1
	 trQ+yG4D9RPGUe0Vj/hR9Dlza9xxgLpPAH8cPFasvJ7d678clgUcTe0UbwYc9jbh93
	 /OCBhGE0DPcvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3674E22AEB;
	Mon, 22 May 2023 10:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [net-next] net: ipconfig: move ic_nameservers_fallback into
 #ifdef block
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168475081973.10880.7575726899017008344.git-patchwork-notify@kernel.org>
Date: Mon, 22 May 2023 10:20:19 +0000
References: <20230519093250.4011881-1-arnd@kernel.org>
In-Reply-To: <20230519093250.4011881-1-arnd@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, martin@wetterwald.eu, arnd@arndb.de,
 chenxuebing@jari.cn, gregkh@linuxfoundation.org, saravanak@google.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 May 2023 11:32:38 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new variable is only used when IPCONFIG_BOOTP is defined and otherwise
> causes a warning:
> 
> net/ipv4/ipconfig.c:177:12: error: 'ic_nameservers_fallback' defined but not used [-Werror=unused-variable]
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipconfig: move ic_nameservers_fallback into #ifdef block
    https://git.kernel.org/netdev/net-next/c/dbb99d78522a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



