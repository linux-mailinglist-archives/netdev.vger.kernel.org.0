Return-Path: <netdev+bounces-8690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C2D8725327
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA7F1C20943
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8B81845;
	Wed,  7 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274E6A41
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9634FC433A7;
	Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686114022;
	bh=23sO2JjqET0F38OrhWvx5ICd5wy4g2HqzQ77BsppUis=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aJqG9VXEShUKNihF0WwZhKlmvBSaKWXbYrR68y5V/s8BnUirwv6zjg9JMr8sx2Iy5
	 kC11c1cWvhbP4XQLH/jPXedgpGVMUQ1O4JunMEVecQJ2R88GpeNJB+5OLaQVT2+1WO
	 ag9MwoXlmNrUF6Pv2Z02+JhcRNy5rjukfY2ZEGOpbBF/EsSM1DOG9vyQXYD2KLmCgv
	 pQztgseOO7wdESKoTknKPPSyuRt7YTa8Ron9ANu7ggVSmXUNePt5KJ/juIKjevknnf
	 jm26nF8gvLFQiSXfcmH53tZQ1lZ7unIXC1Ja+/9CwDY4a5aysHRxiW2zclsmiyV8JB
	 OGW1SrjAfk5HQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C909E4F139;
	Wed,  7 Jun 2023 05:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tipc: replace open-code bearer rcu_dereference
 access in bearer.c
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611402250.26969.2061729105978679866.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 05:00:22 +0000
References: <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
In-Reply-To: <1072588a8691f970bda950c7e2834d1f2983f58e.1685976044.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
 davem@davemloft.net, kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
 jmaloy@redhat.com, tung.q.nguyen@dektech.com.au

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  5 Jun 2023 10:40:44 -0400 you wrote:
> Replace these open-code bearer rcu_dereference access with bearer_get(),
> like other places in bearer.c. While at it, also use tipc_net() instead
> of net_generic(net, tipc_net_id) to get "tn" in bearer.c.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/tipc/bearer.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] tipc: replace open-code bearer rcu_dereference access in bearer.c
    https://git.kernel.org/netdev/net-next/c/ae28ea5cbdee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



