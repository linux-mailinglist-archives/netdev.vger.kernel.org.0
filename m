Return-Path: <netdev+bounces-9344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCF572891E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:00:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E81D1C21054
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7DE2D25C;
	Thu,  8 Jun 2023 20:00:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4526B1F187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AF5AC4339B;
	Thu,  8 Jun 2023 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686254420;
	bh=r2nSOFIBg+bHENR+qPBfGTBrMcI7iQtO19j1qupNUDQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ARcSQARBSf8Dq7RwGVfNSzZoTHG0Y9zO/WRlXJBu+lTzXRJ4Zl5Tc39zNYJjqIXEi
	 DPmSnlyYjC5Ntbbb1R3GVKYPOD7mXV/Ur6cR0awZZHm1HM29mKdpC/ZIcCzffXirm4
	 9TqK3gSb+NAfWbvHrItLeN4aIbAnE3r4crB7kB3tz/wzZRpMfLp3DYfRUb/7O68eYD
	 GbQc9tcMouYX21KP3YSTB0QXnalrXNAUxHlLnDxEnGWezX1rIUz+cMiRUgzIsq2r1+
	 NJwJRfNgT73/nh8QFniPaLVD5fta9LgXjLVXtb8sm8yUCMj21Y3dcMGTeT/BbiP+Bs
	 VS5+M99u9xwIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CD9CE29F3C;
	Thu,  8 Jun 2023 20:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168625442043.20484.1204424752375765875.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 20:00:20 +0000
References: <20230607091048.1152674-1-wei.fang@nxp.com>
In-Reply-To: <20230607091048.1152674-1-wei.fang@nxp.com>
To: Wei Fang <wei.fang@nxp.com>
Cc: claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 maciej.fijalkowski@intel.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Jun 2023 17:10:48 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> For ENETC hardware, the TCs are numbered from 0 to N-1, where N
> is the number of TCs. Numerically higher TC has higher priority.
> It's obvious that the highest priority TC index should be N-1 and
> the 2nd highest priority TC index should be N-2.
> 
> [...]

Here is the summary with links:
  - [V2,net] net: enetc: correct the indexes of highest and 2nd highest TCs
    https://git.kernel.org/netdev/net/c/21225873be14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



