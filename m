Return-Path: <netdev+bounces-523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D126F7F44
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D78A91C21765
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9592D6FB8;
	Fri,  5 May 2023 08:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84081C08
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DC5AC4339B;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683276019;
	bh=XOs+jNRK6gLYLM3XPBHPgEgfHyDVEfzNnpyAwCTFgMc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Yzls/BkRuF3UGziRlIn3T5CE0lNmhDEpFvd0vBDwYo9IREURSRVNzhQNVMhMSGxf4
	 aINUdODNgPcQfXWTbnsXhPfqbfTvELtH0AUN8XkHBcVvJ5yvBnUkqB0I4Fvz82elKK
	 ZpnjqHxlypUu2pRhz3e66EKEfyAUH8//KtAVY5IRvV7yjTFmvCPpA0b/k+A3PVJMDE
	 G9Y8p/eRFcLxuICPbs2qOBJpvAYeZfOKuCWbvi5zlSr2NVAb4Fb51ILcVL8Wv1mn/c
	 Ni68fnq9QV5/YxJAn9MF8NlfJQNC2KX2rRpuWynxU8v4QwNGwn4VL4knp3VcbrH8ak
	 6dpFnsnPl5qsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 730E0C43158;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: block LAN in case of VF to VF offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327601946.11276.12239803363047232359.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:40:19 +0000
References: <20230503153935.2372898-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230503153935.2372898-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org,
 michal.swiatkowski@linux.intel.com, Sujai.Buvaneswaran@intel.com,
 george.kuruvinakunnel@intel.com, simon.horman@corigine.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 May 2023 08:39:35 -0700 you wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> VF to VF traffic shouldn't go outside. To enforce it, set only the loopback
> enable bit in case of all ingress type rules added via the tc tool.
> 
> Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
> Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net] ice: block LAN in case of VF to VF offload
    https://git.kernel.org/netdev/net/c/9f699b71c2f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



