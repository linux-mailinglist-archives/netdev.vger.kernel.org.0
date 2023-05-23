Return-Path: <netdev+bounces-4609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A2C70D87B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62191C20D17
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9061E516;
	Tue, 23 May 2023 09:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352951D2A8
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD84BC433D2;
	Tue, 23 May 2023 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684833020;
	bh=zkDmgnsUslUo65iN/Jku30zughMB9z0sqwl+9thvuIw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Uv4engFN4DU+NQTuAZ3hn5YCOSaQsFK8NuM+DzqpZpla6yivdly0l4pKxbmcA5Y94
	 0Vo0ii7yLw30lh5oF5tefbLhbt+g3vaaicFTZD/6pggb0wDOSfEcrRY/LuFmT5tH3G
	 PPGBmYrcfZIoAiHx+WzAO/GcfZvCsDBwGpshiAmdFlMxEycfQfF8njUW8J1YmIizam
	 Lk0yq/qg8fNTIe3Mwv+ldFz1KEQyFIYX4P6icGh+E2d0xG/hcLelJGsJlbLJ5AHY4b
	 j6dFyz60WOQiFoXULDmo3JT50i62yqMTOs6884PHRyDHAWWlYkj+Iz/vj2lcu/yMIP
	 INHpXFZ5yyFtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0C68C395F8;
	Tue, 23 May 2023 09:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] octeontx2-pf: Add support for page pool
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168483302072.12699.17624055821161782289.git-patchwork-notify@kernel.org>
Date: Tue, 23 May 2023 09:10:20 +0000
References: <20230522020404.152020-1-rkannoth@marvell.com>
In-Reply-To: <20230522020404.152020-1-rkannoth@marvell.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linyunsheng@huawei.com,
 simon.horman@corigine.com, sbhatta@marvell.com, gakula@marvell.com,
 schalla@marvell.com, hkelam@marvell.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 22 May 2023 07:34:04 +0530 you wrote:
> Page pool for each rx queue enhance rx side performance
> by reclaiming buffers back to each queue specific pool. DMA
> mapping is done only for first allocation of buffers.
> As subsequent buffers allocation avoid DMA mapping,
> it results in performance improvement.
> 
> Image        |  Performance
> 
> [...]

Here is the summary with links:
  - [net-next,v4] octeontx2-pf: Add support for page pool
    https://git.kernel.org/netdev/net-next/c/b2e3406a38f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



