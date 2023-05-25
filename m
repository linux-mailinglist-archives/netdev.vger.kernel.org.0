Return-Path: <netdev+bounces-5309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD59710B3F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EB1C2814EB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F26AFC11;
	Thu, 25 May 2023 11:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB48FC08
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8587C433EF;
	Thu, 25 May 2023 11:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685014821;
	bh=3v/jzca5/u4ZdT2KhsBW54pILYScwd01Wld0+qVzkHA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EvKRc2TurnOSl3xDZJMlDV7sHXUitzdowhhbVRLhqdcDAHqgdkslYYvt6d1EPLkei
	 btiTJ0fK7dXbKtp36nyJA1jUXnuPI/UTYVkzHIKKDt5j01oKAnG2CGPPDfLpiIUrvN
	 +7isdJ/17VueY7MT1WjXfadvgdYh0lnqV0xnop3bMrqr2R226SuPUMo7YdnZE2Vsem
	 rXnniDHjs90eX6ngf3Hczw8mkxppBnpjxexAEb3qfuv1Dchk//C+1ka7QW1Tg8e6g5
	 OCQQCGdCrms72nlupL/Cm+l5LKOrRpitPcnVNFf49QfyI0MBIdl9mzKcoJCp3AtOfO
	 Qi+DL2V0GxMzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B1DFC4166F;
	Thu, 25 May 2023 11:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx4: Use bitmap_weight_and()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168501482156.11061.4458413113759538534.git-patchwork-notify@kernel.org>
Date: Thu, 25 May 2023 11:40:21 +0000
References: <a29c2348a062408bec45cee2601b2417310e5ea7.1684865809.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a29c2348a062408bec45cee2601b2417310e5ea7.1684865809.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: tariqt@nvidia.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 23 May 2023 20:17:52 +0200 you wrote:
> Use bitmap_weight_and() instead of hand writing it.
> 
> This saves a few LoC and is slightly faster, should it mater.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net/mlx4: Use bitmap_weight_and()
    https://git.kernel.org/netdev/net-next/c/623a71385312

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



