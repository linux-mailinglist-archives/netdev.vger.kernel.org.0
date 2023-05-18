Return-Path: <netdev+bounces-3657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D3A708331
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D04F9281833
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ED9718005;
	Thu, 18 May 2023 13:50:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006F23C7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BD7BC433EF;
	Thu, 18 May 2023 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684417821;
	bh=xQnRUgm4BT1roPqWoEGi+8IoUWJ7NajMkCHHNn7QrFY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZFXMxhgAT8gehaRDAJHcj5yHl+czmf6jM6lI5jqvUNhzqNkBP8RIlKxXXs/iFDxzn
	 FoEhidDmUt5rDDqi2KsOoCLMbtB+bV1Royjg/uYv/kedKb30wvfgbuU7ilaPSh7d3p
	 tpiv2/wYKrsD0vY5PfaBLtfBgcTRqM2CnbZgb6L0HFRdI7/w6pSXk9n/jX1KxVUzbY
	 BSW42XrgzNoybKBgbCykurAe9/Hf9cnTX35+Bx0SKKfuYaa7vpllHPhsYkcIYYSnyz
	 HF84mbEYXyMVw3f/PEhcX1Z2+b94SNtvSlbxb885EFS+EaTS5XfCQJatZm8eiRP4QM
	 NJgWA+JC1TVtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5AB6C32795;
	Thu, 18 May 2023 13:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: lan966x: Add support for PCP, DEI, DSCP
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168441782093.32049.16346050469371833886.git-patchwork-notify@kernel.org>
Date: Thu, 18 May 2023 13:50:20 +0000
References: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230516201408.3172428-1-horatiu.vultur@microchip.com>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
 piotr.raczynski@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 16 May 2023 22:14:01 +0200 you wrote:
> This patch series extends lan966x to offload to the hardware the
> following features:
> - PCP: this configuration is per port both at ingress and egress.
> - App trust: which allows to specify a trust order of app selectors.
>   This can be PCP or DSCP or DSCP/PCP.
> - default priority
> - DSCP: this configuration is shared between the ports both at ingress
>   and egress.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] net: lan966x: Add registers to configure PCP, DEI, DSCP
    https://git.kernel.org/netdev/net-next/c/1fd22211354a
  - [net-next,v2,2/7] net: lan966x: Add support for offloading pcp table
    https://git.kernel.org/netdev/net-next/c/a83e463036ef
  - [net-next,v2,3/7] net: lan966x: Add support for apptrust
    https://git.kernel.org/netdev/net-next/c/10c71a97eeeb
  - [net-next,v2,4/7] net: lan966x: Add support for offloading dscp table
    https://git.kernel.org/netdev/net-next/c/0c88d98108c6
  - [net-next,v2,5/7] net: lan966x: Add support for offloading default prio
    https://git.kernel.org/netdev/net-next/c/f8ba50ea13fb
  - [net-next,v2,6/7] net: lan966x: Add support for PCP rewrite
    https://git.kernel.org/netdev/net-next/c/363f98b96a43
  - [net-next,v2,7/7] net: lan966x: Add support for DSCP rewrite
    https://git.kernel.org/netdev/net-next/c/d38ddd56d90e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



