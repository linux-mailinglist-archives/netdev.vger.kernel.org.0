Return-Path: <netdev+bounces-3419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EC97070C7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BE4C1C20E9B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 18:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BADAB31F12;
	Wed, 17 May 2023 18:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6772531F0C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 121AEC4339B;
	Wed, 17 May 2023 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684348221;
	bh=5n2xWYkC7Q2DExzJ/UmMMo67ywKAzPgrPRsVY76tte4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=I2zHFspoVES1c1wXLo/9+TNmNhjhLnKfaCWA9PKhQugBGkQuLynpRB1E2B5/K+7tw
	 lXq+NDD+iEv6eOSXwACfNhKOEd6j/sv1xvFq+pXCZPVqMAaWUv3S0aSn36rrA28nSz
	 5ujY0m9vLOArQye7XIy+Oz8CI0xIzrOXFFDR1hjZVm6ND8Fhe78qm9AvYPWYtUSFM+
	 jgwq0VjA5VuStFVHQ1Y96bGqY3VpGsza7+6DcOcfORMx735aQ3YyfQu1JRq9q97qS1
	 jKTXgU2mR4zqnN38LuOj1jX6xaOd9eOks4w7ZsxzgzxkSajVNaH/pkV4FyBhF3zEsz
	 Bf7YpWeOrF67A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E89CEC41672;
	Wed, 17 May 2023 18:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] CREDITS: add file
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168434822094.28879.15243458428038335904.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 18:30:20 +0000
References: <20230514022613.10047-1-stephen@networkplumber.org>
In-Reply-To: <20230514022613.10047-1-stephen@networkplumber.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Sat, 13 May 2023 19:26:13 -0700 you wrote:
> Like the kernel, record some of the historical contributors to iproute2.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  CREDITS | 30 ++++++++++++++++++++++++++++++
>  README  |  4 ++--
>  2 files changed, 32 insertions(+), 2 deletions(-)
>  create mode 100644 CREDITS

Here is the summary with links:
  - [iproute2] CREDITS: add file
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=db7ad0503c76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



