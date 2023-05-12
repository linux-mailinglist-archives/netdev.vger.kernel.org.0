Return-Path: <netdev+bounces-2060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13909700214
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD569281870
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582D1BA48;
	Fri, 12 May 2023 08:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938D29448
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA077C433B3;
	Fri, 12 May 2023 08:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683878423;
	bh=VF/1iL8w3aqPXtsJnK1hmBaBpzWSxDlF3NaoKwTeCGA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DoyvoVV7pOd+9wN090iC6z9xWcaEkh0XzX04+QdRxiTGoY9sMBiQ7dRhzNdwP4uui
	 Vyo1ZOwbwywasedu0vphdMiDimeWa8krGvwgPDYjAIACI0Xv1VdbuLU4xPyzuC8Gz3
	 E03CDMR2fXMYO4425nC5SFGpaBH2t9BMUE4pPh6xgV9kivF6YxPrDFNXaVSP1rhvo3
	 VqkH58DnC2nBzlc86q6OtTNuamxbEX8r9LzstTzchnyf9rLxefrQPkvKHmW6SYatlS
	 /ARSL/lJEy933VzToagE7tHgbC/5RTLVLXx6Tf+GuzHm+D8K2Kr+EbcUcZlzl3yBcK
	 rTE7q3+2wiJPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94762E501EF;
	Fri, 12 May 2023 08:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: samsung: sxgbe: Make sxgbe_drv_remove() return
 void
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168387842360.16770.7266879456299201971.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:00:23 +0000
References: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230510200247.1534793-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: bh74.an@samsung.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 22:02:47 +0200 you wrote:
> sxgbe_drv_remove() returned zero unconditionally, so it can be converted
> to return void without losing anything. The upside is that it becomes
> more obvious in its callers that there is no error to handle.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h   | 2 +-
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c     | 4 +---
>  drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c | 5 +++--
>  3 files changed, 5 insertions(+), 6 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] net: samsung: sxgbe: Make sxgbe_drv_remove() return void
    https://git.kernel.org/netdev/net-next/c/7f88efc8162c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



