Return-Path: <netdev+bounces-10581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FF972F33B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 05:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2EC01C209BF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 03:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419B3801;
	Wed, 14 Jun 2023 03:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A4964C
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B735C433C8;
	Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686714622;
	bh=2doPMc7CchbE/oRF/eOr9kaW6x5+7kGZIHwg+VP5nzU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Ysf7n9TATvLmcbf/Ebk8Q5pbmXqTvIBPlq6nPmZUwqoWg5uEZv8y6MZ0lcIgWFHQR
	 qS3n90MX083fb4G/oVnDdzxsHDkmAhYrlEv9SSsVJHvdi6KHXePkX9tQIEO/W8impg
	 lUoYVZYRinnefSqvrX/GAqvZCcJUvLKaDGBN0MBRr/VoHF9uSUD7FujzReHGa4TU1F
	 fCNF3PQVIOrCBttqiW1ddO3oNM0O6QhzXc9I1lkrcnsk0brXAgiNb92NTLkf4wHAYH
	 EhFyMVLWR7wM+0ULAO3TQtGWjPfi7c6obMR7sUbIknO3N+7xZ/iXvZStgjmm4FarYn
	 wffP0YXQOFWgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09CE8C3274D;
	Wed, 14 Jun 2023 03:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Call of_node_put() on
 error path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168671462202.18215.7347917401810887721.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 03:50:22 +0000
References: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
In-Reply-To: <e3012f0c-1621-40e6-bf7d-03c276f6e07f@kili.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: s-vadapalli@ti.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, rogerq@kernel.org,
 netdev@vger.kernel.org, kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Jun 2023 10:18:50 +0300 you wrote:
> This code returns directly but it should instead call of_node_put()
> to drop some reference counts.
> 
> Fixes: dab2b265dd23 ("net: ethernet: ti: am65-cpsw: Add support for SERDES configuration")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: ethernet: ti: am65-cpsw: Call of_node_put() on error path
    https://git.kernel.org/netdev/net/c/374283a10012

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



