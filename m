Return-Path: <netdev+bounces-3327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE26070675C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EFB6281283
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D722C74F;
	Wed, 17 May 2023 12:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990FA2C737
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45ACAC4339C;
	Wed, 17 May 2023 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684324820;
	bh=H16T75U7SxMU7g7+DhG1gMCbUUVJ8VaQdUI0QsxR5V4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Ki9k22Z9lWAxzSwxkgkKgN8TeDvnTq7R73t3WtbQRfsHpt2zdngZeKKJ2GbOH0Bqy
	 /NfkqAh0cTv5gvDJlYQUTFulvIN6yDXk22VpiASjtgie4NdGisy5NWFSRiF1dO2WXS
	 +uU4jxN4hJMXuh+B4E+6bUKrBN6rziAyk4nqy2BRHnXu+4osMXwepUk/PThbukqY42
	 TUY9PWcT93MIPm5RPTDCklOGZFvMPpH4ByuvcJX2LwHjNlLfDQD/P3mcwOGsWagbDR
	 Djj+5F/xLc3PB9nMXgGG8P5Az53p6w7cECYhD321Y0CgjtBLr1jsC/TGMb+pUWZE1e
	 6/Is/Pa067zKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E918C59A4C;
	Wed, 17 May 2023 12:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net: wwan: iosm: fix NULL pointer dereference when
 removing device
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168432482018.30872.8605947380694334089.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 12:00:20 +0000
References: <6d9e4d90ec89d8ac026e149381ca0c8243a11a19.1684250558.git.m.chetan.kumar@linux.intel.com>
In-Reply-To: <6d9e4d90ec89d8ac026e149381ca0c8243a11a19.1684250558.git.m.chetan.kumar@linux.intel.com>
To: Kumar@codeaurora.org, M Chetan <m.chetan.kumar@linux.intel.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 johannes@sipsolutions.net, ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
 linuxwwan@intel.com, m.chetan.kumar@intel.com, edumazet@google.com,
 pabeni@redhat.com, simon.horman@corigine.com, sam@samwein.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 21:09:46 +0530 you wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> In suspend and resume cycle, the removal and rescan of device ends
> up in NULL pointer dereference.
> 
> During driver initialization, if the ipc_imem_wwan_channel_init()
> fails to get the valid device capabilities it returns an error and
> further no resource (wwan struct) will be allocated. Now in this
> situation if driver removal procedure is initiated it would result
> in NULL pointer exception since unallocated wwan struct is dereferenced
> inside ipc_wwan_deinit().
> 
> [...]

Here is the summary with links:
  - [v3,net] net: wwan: iosm: fix NULL pointer dereference when removing device
    https://git.kernel.org/netdev/net/c/60829145f1e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



