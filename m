Return-Path: <netdev+bounces-10313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E08C72DD29
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 108541C20C26
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946D5566D;
	Tue, 13 Jun 2023 09:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E60B23A5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADC61C4339B;
	Tue, 13 Jun 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686646822;
	bh=V6VMJAU+YfvD5iwPxnnjcr/KmYw+6C6H5kBbQNLOdDE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mR0SPTbAFLz2N9BDK0eBGTgnGePseNAnxez+O0YW68c1XiLOSXo4hshBN+xe0V2py
	 ErlB56DI3Np9sT64mLDjL+luFK1K4Lg/5Hy82PZm/ShrSMqWfcpRb3bW1PFCiJ9I1P
	 NqbSbPDA/j+CaTyFu6i2+rEksZ5kt8Yrz5fxz0QlqTgLDUGmoPj+1TR08nO5ADrjEq
	 CJQgy7mYipXIRVYE6HwMgLK0Y9nQ17mZkq8TDGda1NHT/dqyU8t1pXIjwGVtQpLvO9
	 liGbNFphFHUXnvaA13luQc/xEk805NXovGJ1nXhPUXcEVukH6I8Aan3r6nxk12qr7C
	 JyUqdFCWgqoig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93CC3E2A04A;
	Tue, 13 Jun 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 0/6] RVU NIX AF driver updates
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168664682259.19154.12736399904597345437.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 09:00:22 +0000
References: <20230612060424.1427-1-naveenm@marvell.com>
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
To: Naveen Mamindlapalli <naveenm@marvell.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sgoutham@marvell.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 11:34:18 +0530 you wrote:
> This patch series includes a few enhancements and other updates to the
> RVU NIX AF driver.
> 
> The first patch adds devlink option to configure NPC MCAM high priority
> zone entries reservation. This is useful when the requester needs more
> high priority entries than default reserved entries.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] octeontx2-af: Add devlink option to adjust mcam high prio zone entries
    https://git.kernel.org/netdev/net-next/c/09de114c770f
  - [net-next,v2,2/6] octeontx2-af: extend RSS supported offload types
    https://git.kernel.org/netdev/net-next/c/79bc788c038c
  - [net-next,v2,3/6] octeontx2-af: cn10k: Set NIX DWRR MTU for CN10KB silicon
    https://git.kernel.org/netdev/net-next/c/bbba125eade7
  - [net-next,v2,4/6] octeontx2-af: Enable LBK links only when switch mode is on.
    https://git.kernel.org/netdev/net-next/c/b6a072a15327
  - [net-next,v2,5/6] octeontx2-af: add option to toggle DROP_RE enable in rx cfg
    https://git.kernel.org/netdev/net-next/c/4ed6387a61fc
  - [net-next,v2,6/6] octeontx2-af: Set XOFF on other child transmit schedulers during SMQ flush
    https://git.kernel.org/netdev/net-next/c/e18aab0470d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



