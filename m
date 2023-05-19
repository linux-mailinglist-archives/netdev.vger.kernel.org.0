Return-Path: <netdev+bounces-3894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 029BF70975C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA9B4281C94
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 12:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30A46AA8;
	Fri, 19 May 2023 12:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572007C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 12:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03A8EC433EF;
	Fri, 19 May 2023 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684500020;
	bh=1F/eCrwSGc2hHPgPSPDKPCdMBjTHdEI3aAVVcnFlGww=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eS1w3brs3WjLrMf0KjXfoutzueby77dJP7qLdW8uJVtwA8WB93XCeID3osPXNuBw5
	 K3OaslOpC8Aw/kRYteSRt4xejEfWDpRKch+n0N8hhRgBtMirgQQaoXf2pJZuniRPT7
	 VNDiZtDgFqYwd+1Ls/fsuYfRMBNPvualzRJOF6mAOpi+CS1yMZC6rJzkagzJwae/+x
	 nhMMjr3R/wV+BskpAP/JchBch5z09C7ygwnWQ+RXeRogNKZpzLwIxURHqxaxqf65S8
	 4iP8wAkx6uNy3U//0AR09fVEyKKK11++9Owv4L6JYjHHSif4XK62pCEb+TfT8RFVHT
	 Dp0pgdlOradvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF2D4E21ED3;
	Fri, 19 May 2023 12:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: arc: Make arc_emac_remove() return void
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168450001983.31347.7784908819627881488.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 12:40:19 +0000
References: <20230518203049.275805-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230518203049.275805-1-u.kleine-koenig@pengutronix.de>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@codeaurora.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, heiko@sntech.de, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 kernel@pengutronix.de

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 22:30:49 +0200 you wrote:
> The function returns zero unconditionally. Change it to return void instead
> which simplifies its callers as error handing becomes unnecessary.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/arc/emac.h          | 2 +-
>  drivers/net/ethernet/arc/emac_arc.c      | 6 +++---
>  drivers/net/ethernet/arc/emac_main.c     | 4 +---
>  drivers/net/ethernet/arc/emac_rockchip.c | 5 ++---
>  4 files changed, 7 insertions(+), 10 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] net: arc: Make arc_emac_remove() return void
    https://git.kernel.org/netdev/net-next/c/20d5e0ef252a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



