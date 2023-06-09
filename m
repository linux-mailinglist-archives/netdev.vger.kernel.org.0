Return-Path: <netdev+bounces-9416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78A10728DFD
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C245C1C210B2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFC5A946;
	Fri,  9 Jun 2023 02:30:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748DB8F4F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02B0FC433A4;
	Fri,  9 Jun 2023 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686277824;
	bh=oEpczABkS2ipZs7ltYGF0878TRFi/7OjvRhGSGsRzZc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PkeaKUmFt82nQbA+X4l66LTWlJdPM2GuCmtTuc2G37uqY4+jddIqn+06rIkVNG8tp
	 rjOgPIJv5tWmoZxXbACW1/vrtjqY7xQ2sJ4NyRz8E802CDRZCgQuGqMCyDGntzOE4P
	 JS8Zxh3Oe0DS/gtG6D2JgErwoPdimBZGuevHPVP+n4RjOXg8K2JcOIyS3HyywLsgTN
	 XJqI5CkgTHnXbxdhhm2aqKE8po6tnV/XIu9PvATxkJwWrH3IvrDkY9RCcoMWnlgiqv
	 fdy1uS3wZyGPeFgJ6AnLCfwqZes+dxHedk3eNksNW5Wp/Q33PP9cBO3E02gmrbEosw
	 we45VEjujhnQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0675E29F3C;
	Fri,  9 Jun 2023 02:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168627782391.6230.2148656230557724849.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 02:30:23 +0000
References: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
In-Reply-To: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 13:59:53 +0800 you wrote:
> MIPS Boston board, which is using MIPS_GENERIC kernel is using
> EG20T PCH and thus need this driver.
> 
> Dependency of PCH_GBE, PTP_1588_CLOCK_PCH is also fixed for
> MIPS_GENERIC.
> 
> Note that CONFIG_PCH_GBE is selected in arch/mips/configs/generic/
> board-boston.config for a while, some how it's never wired up
> in Kconfig.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
    https://git.kernel.org/netdev/net-next/c/c8cc2ae229ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



