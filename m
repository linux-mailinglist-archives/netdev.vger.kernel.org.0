Return-Path: <netdev+bounces-537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D63046F7F9F
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 919B8280EB0
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78432538B;
	Fri,  5 May 2023 09:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C0B6D1B
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38839C433EF;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683277821;
	bh=0hAoMe/RkHIXSGpv4lIQ+zDfTDe6qsEo7o6Ru3YcTPo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lXajDlLXogBU3vWVGna76OveOKHrXjjKSxX/ShzneLodaMVEVornsctHyEoD7GWRO
	 d+2JYmFAS3rH4amdLRCNQG+GDDSzaYU/PDXVrlorprwO3l+O6Wxl3/kwhwBmsFYIuv
	 deV0xnOkBshlG2F581EWTDPeD+QNMuTnKujvz5h+e7DWgjQcremrgWeCGKqs87Tbnx
	 JnYMvoyJI9Kb122VtxvhAFrYCn9VSaixtMLZKyTiA8JFPFEuk22NHZ/LN/bULM3tR5
	 19zNhaHIl9UFIHza+e+G72W7EFoZFW1NnwlR4k1F6/hzA6kfEh8W2PNKw05OujTh1y
	 4lX0Q9lj5zs0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11238E5FFCE;
	Fri,  5 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] pds_core: fix mutex double unlock in error path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327782106.8511.9840821021018679324.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 09:10:21 +0000
References: <20230504204459.56454-1-shannon.nelson@amd.com>
In-Reply-To: <20230504204459.56454-1-shannon.nelson@amd.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
 kuba@kernel.org, dan.carpenter@linaro.org, drivers@pensando.io,
 kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 4 May 2023 13:44:59 -0700 you wrote:
> Fix a double unlock in an error handling path by unlocking as soon as
> the error is seen and removing unlocks in the error cleanup path.
> 
> Link: https://lore.kernel.org/kernel-janitors/209a09f6-5ec6-40c7-a5ec-6260d8f54d25@kili.mountain/
> Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] pds_core: fix mutex double unlock in error path
    https://git.kernel.org/netdev/net/c/1e76f42779d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



