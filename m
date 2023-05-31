Return-Path: <netdev+bounces-6701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D022A717792
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 664691C20A64
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5C4A942;
	Wed, 31 May 2023 07:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF392A92F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64AFBC433AC;
	Wed, 31 May 2023 07:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685517021;
	bh=xfTvOPR8B3iPKl4547i0G1kIdKVE3g52X3vRBjYMByc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NC3n9Gop1xbi4h3d6TXqzUHxxK6tDNI3XQ0Pc9+wC5nWZIdsRL3wIkhElDXy+sERF
	 fvxv681My7sv+oC8rfPTpavSq9JBEgCZl4UwVPCYDz7Jj1d+rcE56MHYzVFsqkqNn7
	 IHe9iOpbCWhGNcRf5fzWngaAyp/w28lQZ3i7Ijdc1WyckQozpbBkwSU6llhF6EbtO3
	 M7cFPzIByB9K910cASdDTmPiu1gqc1JX34gy5n1PfI9hNTLVSJDt9yOkU58pv4V7Hu
	 Po5frXgfEafnBt8Cc2L6ytlJhisLhvZ4DM+Xczx9CM488uwA2ZBF0i1fCjGuTnFom1
	 6tw06NUojW1AQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C037E52BFB;
	Wed, 31 May 2023 07:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: delete tipc_mtu_bad from tipc_udp_enable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168551702130.26195.14895210848100812836.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 07:10:21 +0000
References: <282f1f5cc40e6cad385aa1c60569e6c5b70e2fb3.1685371933.git.lucien.xin@gmail.com>
In-Reply-To: <282f1f5cc40e6cad385aa1c60569e6c5b70e2fb3.1685371933.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 jmaloy@redhat.com, tung.q.nguyen@dektech.com.au

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 May 2023 10:52:13 -0400 you wrote:
> Since commit a4dfa72d0acd ("tipc: set default MTU for UDP media"), it's
> been no longer using dev->mtu for b->mtu, and the issue described in
> commit 3de81b758853 ("tipc: check minimum bearer MTU") doesn't exist
> in UDP bearer any more.
> 
> Besides, dev->mtu can still be changed to a too small mtu after the UDP
> bearer is created even with tipc_mtu_bad() check in tipc_udp_enable().
> Note that NETDEV_CHANGEMTU event processing in tipc_l2_device_event()
> doesn't really work for UDP bearer.
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: delete tipc_mtu_bad from tipc_udp_enable
    https://git.kernel.org/netdev/net-next/c/6cd8ec58c1bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



