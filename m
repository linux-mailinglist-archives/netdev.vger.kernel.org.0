Return-Path: <netdev+bounces-11764-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DC47345C6
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CF922811D4
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C500715D4;
	Sun, 18 Jun 2023 10:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E661386
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ED4EC433C9;
	Sun, 18 Jun 2023 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687083019;
	bh=fROmknSM7ATz20+6q6GGk2mhyjnDcirQFgg0f7+mmdw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OpMEunrqfhcDoEKh6lDm7Z5qdtjOOYl4GOi8batSFcSKtc6MB5HID8wl5pqr7EJbe
	 3SnO9zGqLOnszaehKmSzfzIV4L+HLZ2UGXgccVAACR8SM1PqWCkr8/t33shkKqJvrR
	 TW6tn4Ohv7VFNfoLz/uVhRyzlbHHi6EIx0ScIXnlEl5YJJH5sahVdBnxBpn+OVk/Le
	 TzwGexmw0kORDTF5z3kGm/+StOaktgcSRYdZRibhWUW3Z7SSJIqeOW6rqlhyWQji8C
	 DssXVDvtJmmvqvWXsUNxM/IumxyX302O4KEu7hGUXddT/MqfIs2/jIw9gG5tpcq8X8
	 579NNi2GSmDgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66B76C395C7;
	Sun, 18 Jun 2023 10:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5] tcp: enforce receive buffer memory limits by
 allowing the tcp window to shrink
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168708301941.26302.3803837965273180103.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 10:10:19 +0000
References: <20230612030524.60537-1-mfreemon@cloudflare.com>
In-Reply-To: <20230612030524.60537-1-mfreemon@cloudflare.com>
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com, edumazet@google.com,
 ncardwell@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sun, 11 Jun 2023 22:05:24 -0500 you wrote:
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
> 
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning (sk_rcvbuf) is increased due to incoming data
> packets as a result of the window not closing when it should be.
> This can result in the receive buffer growing all the way up to
> tcp_rmem[2], even for tcp sessions with a low BDP.
> 
> [...]

Here is the summary with links:
  - [net-next,v5] tcp: enforce receive buffer memory limits by allowing the tcp window to shrink
    https://git.kernel.org/netdev/net-next/c/b650d953cd39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



