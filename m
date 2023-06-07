Return-Path: <netdev+bounces-8755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F79725895
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64FB11C20CEE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C758BF7;
	Wed,  7 Jun 2023 08:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264C96FB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91267C4339E;
	Wed,  7 Jun 2023 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686127820;
	bh=IIyOROjdNjxeEb0UvMyIbTg8b9AVkiKvs6VlFnwoAA0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QGtNFL5r1UHfGdQy7fmQ66lNZzxZCbzvyyBphKKFIJNo6aJqlc8jQhzkNZtvYKS//
	 B6I8MgPun3S5IeFMowSCl7BHfutTVnKcbFAMDLILZMRsYwqaGhnMcsUGWWnLHBxSsZ
	 +en8bufufAqaAgqfk2mnCA8EOhyEhBt0y17WRsFyGcgAegXCcF4Tqf6cd4gPDrcyBm
	 DUxpXUf2b91/4J6ocT+xMkH+RTltzmtWDihqItZRz72Myyizj3RAMh10Yjd89qPJzN
	 2DaBlz8bHYg87T4HU/Xl36R1gzZn+LHx+5kIltpG1+j7Rpvo0SPGmxY39x9DzwNyEY
	 DouIxM4+LfUnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76141E29F3C;
	Wed,  7 Jun 2023 08:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6] hv_netvsc: Allocate rx indirection table size dynamically
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168612782047.19677.12670846520240383400.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 08:50:20 +0000
References: <1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com>
In-Reply-To: <1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kys@microsoft.com, haiyangz@microsoft.com,
 wei.liu@kernel.org, decui@microsoft.com, longli@microsoft.com,
 mikelley@microsoft.com, davem@davemloft.net, steen.hegelund@microchip.com,
 simon.horman@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Jun 2023 04:30:06 -0700 you wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> Testcases:
> 1. ethtool -x eth0 output
> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
> 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV
> 
> [...]

Here is the summary with links:
  - [v6] hv_netvsc: Allocate rx indirection table size dynamically
    https://git.kernel.org/netdev/net-next/c/4cab498f33f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



