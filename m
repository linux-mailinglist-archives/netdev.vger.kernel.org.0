Return-Path: <netdev+bounces-2078-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1A4700366
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876311C21134
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6281CBA47;
	Fri, 12 May 2023 09:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B93EDA
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AAAEC4339B;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683882621;
	bh=AgTS2FXK7D8YWYW0V2wo3iS8yiODvdMp7LIOFcImV68=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hx1dvSlbTl2Wy0ZU2fjhzjRrpj5zFMstaYQxk6+CNFaXNqZIRQUJE0IC2jMXPN9Ip
	 HoVZK6NW8XOmIh2Woib06zikHPARuxeWM/e4FVCvMpVJ4XLinvjlTJrN7PaA8H7Zje
	 nLs9S5NIkqQTehtA4u7ANw3qp18s/bjDwJo/dfyphgKKFnhqR4s5Fm2rodm2t/DkiM
	 FrUeLadOatr9+7XSCFXHw/EMF2ymADpdpgmAecYRcFVM7m9XU9TXr4pgpWuDgIr6Wt
	 3zb2p2e0E+ShGiZa/XM4uCm1NDKbbyhJYYtqWQ3zDoKClNsIL+SvE6DfK5hpNv2EW0
	 NZJ9Dn5gQexjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E52AE49F61;
	Fri, 12 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: fix possible sk_priority leak in tcp_v4_send_reset()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388262137.3920.1330834492964547112.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 09:10:21 +0000
References: <20230511114749.712611-1-edumazet@google.com>
In-Reply-To: <20230511114749.712611-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
 atenart@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 11:47:49 +0000 you wrote:
> When tcp_v4_send_reset() is called with @sk == NULL,
> we do not change ctl_sk->sk_priority, which could have been
> set from a prior invocation.
> 
> Change tcp_v4_send_reset() to set sk_priority and sk_mark
> fields before calling ip_send_unicast_reply().
> 
> [...]

Here is the summary with links:
  - [net] tcp: fix possible sk_priority leak in tcp_v4_send_reset()
    https://git.kernel.org/netdev/net/c/1e306ec49a1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



