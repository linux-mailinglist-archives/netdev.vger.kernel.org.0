Return-Path: <netdev+bounces-3842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E8D0709193
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 771491C20A9A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B904566B;
	Fri, 19 May 2023 08:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311255663
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8B32C433D2;
	Fri, 19 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684484421;
	bh=cYNsUqwT6Czd7CihswXIkDGRkFsuSYQWgVboqu1K6jA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iLAe1xuM9zRLHRQs2u9Yh2Ep0+uBSKH7J+3J1B2F1aOH/s14yG/hy7DV7QZd10HBG
	 pdNZabSLeGwefTNzy84a+Yv+uGJKhYPiMHT4KbmczYxRkfYQNBu01pqguQ4nS/Rhwu
	 vZrWgxo8N+KwQzJxopYrT+qGKvQvJnGmbi6DvQi7Tbp0aVk42j9RNBjNEz+lXaIYBF
	 VchEXOtwfs09I/vrAzoqCz4hIFDvpkprVcQvsFu8I/nK8cKaS5x1sDUok+wOBgTcrV
	 ggNY6JQLQgImY2741lSEyub80t6ZJj7yd1T+GFLGCQ0Sx0lKwJM1nCnloJ/5yB+1qJ
	 5zzLjIOAXBKJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBDE9C73FE2;
	Fri, 19 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: add myself as maintainer for enetc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448442176.11174.1817196669995161023.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 08:20:21 +0000
References: <20230518154146.856687-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230518154146.856687-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 18:41:46 +0300 you wrote:
> I would like to be copied on new patches submitted on this driver.
> I am relatively familiar with the code, having practically maintained
> it for a while.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] MAINTAINERS: add myself as maintainer for enetc
    https://git.kernel.org/netdev/net/c/3be5f6cd4a52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



