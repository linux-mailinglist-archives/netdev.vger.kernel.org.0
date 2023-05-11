Return-Path: <netdev+bounces-1647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95AEB6FE9CD
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A63D1C20A36
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B33427701;
	Thu, 11 May 2023 02:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74361F199
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3838CC433AA;
	Thu, 11 May 2023 02:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683771623;
	bh=r7JYZTv3tv9CR1MxYtcwp0IiUmAFEhP7XVDvjBCg15g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oCkQXeRodAXAOlE0XUFPeYX41natMfSwW91lGno1Kx2TRQKPCQkS9lehld8rIO3u5
	 i/72Dgq6CCpKwofu6e0uo50q3xk2bVN55pFO2d1AUIdVCZJh+4qbZPTOqbMcncQQol
	 tTEoZughOtHTTJmq7foYY8XOLIzMDpWW6o8mws5OFHCAn2aseRE7PKQrnvcmS1kOmu
	 L+eMRcKlUw4PnQPNmCiDc0jixdylr+Dpnv3nEcJs3Bw9RgwzAuC67mD5dS1njvl3CQ
	 OGK2B/gXMezgLBX+tH7S2Dr8heNZajT+oc6Fct/lK/8cNEk5b/Nc2r4g4V5f8qGkCI
	 5dmS2B3ZnTOaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25FB4E26D21;
	Thu, 11 May 2023 02:20:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] net: wwan: iosm: remove unused macro definition
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168377162315.11094.5029889465748103715.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 02:20:23 +0000
References: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
In-Reply-To: <0697e811cb7f10b4fd8f99e66bda1329efdd3d1d.1683649868.git.m.chetan.kumar@linux.intel.com>
To: Kumar@codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
 linuxwwan@intel.com, m.chetan.kumar@intel.com, edumazet@google.com,
 pabeni@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 May 2023 22:05:55 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> IOSM_IF_ID_PAYLOAD is defined but not used.
> Remove it to avoid unexpected usage.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: wwan: iosm: remove unused macro definition
    https://git.kernel.org/netdev/net-next/c/796fb97a8cd9
  - [net-next,2/3] net: wwan: iosm: remove unused enum definition
    https://git.kernel.org/netdev/net-next/c/c930192572db
  - [net-next,3/3] net: wwan: iosm: clean up unused struct members
    https://git.kernel.org/netdev/net-next/c/8a690c151134

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



