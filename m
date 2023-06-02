Return-Path: <netdev+bounces-7363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C75B971FE40
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:50:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 818C7281734
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:50:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A007B17FFA;
	Fri,  2 Jun 2023 09:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686675687
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6928C433D2;
	Fri,  2 Jun 2023 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685699422;
	bh=/nR7hoMNP/QXJWt4Ooi8URGXrov6NWia6pUYCMA7j4c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AhfBHCNuJ6+OZ56dH+87eezIMq5wBKdiH3dDPwBhaYiVlhV8hAetimn9tfimTNtGu
	 2qaHGotAZk4uhXED7T9XJj3X5onByoLU3aab7tOGK4SjN9A/mDncZAaT4hWG6YM96O
	 JoU8zWGV39Hy98FDn28ifgiNdjAaVtXXgX4hcHTw9Vesp/AX7qI3RIFCfD2qqrZdYM
	 3LoZeBG+n4ZJXTQYZT9nZYs0OMSZ1SXyJwl2uMDy1YfIJ0QhW8rtFk09RtyveMFvRD
	 ayAbk+uVx1k4P/gknjqU857Zp7E4o6PdGRcMjXy8hP4ys3rB7aRs0aKD7J8djDHDMO
	 qZMWXR7ILzShw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD55CE52BF5;
	Fri,  2 Jun 2023 09:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan743x: Remove extranous gotos
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168569942183.12617.12043035284004211963.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 09:50:21 +0000
References: <20230602000414.3294036-1-moritzf@google.com>
In-Reply-To: <20230602000414.3294036-1-moritzf@google.com>
To: Moritz Fischer <moritzf@google.com>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
 edumazet@google.com, davem@davemloft.net, bryan.whitehead@microchip.com,
 UNGLinuxDriver@microchip.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Jun 2023 00:04:14 +0000 you wrote:
> The gotos for cleanup aren't required, the function
> might as well just return the actual error code.
> 
> Signed-off-by: Moritz Fischer <moritzf@google.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 20 +++++--------------
>  1 file changed, 5 insertions(+), 15 deletions(-)

Here is the summary with links:
  - [net-next] net: lan743x: Remove extranous gotos
    https://git.kernel.org/netdev/net-next/c/0f0f5868689e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



