Return-Path: <netdev+bounces-9481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D64C17295DB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3160B1C2104B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E70314A82;
	Fri,  9 Jun 2023 09:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BF71427F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FCFCC4339C;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686304221;
	bh=s86jmCAkr0JpuP7hM3Mlm+pM7W9Hp6NzmVs0bBk1hcE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kNWlWuvnPGkiYAeI2o3iQl5iqneKNg9sGX4A5Ql9iBbvuz42bR5tSjyOAArnp1YiV
	 O//qX5so8lTXj6BZImw2A9RCii4ldLddN91R02gQb7xZZEKt5qw/TP8n53A+VTwDln
	 L0f4LgLygqGetaHm6dwCzUiYL+727agqVR3/jZiKysa5mJPZyujzeMkRE0eYlYMer4
	 nf5ofTAeKYCov32jodCOBY7l2i5GZOp10zR15xSxpZw6ycr2zjhnVjk6rrWqXHS6BI
	 7JTDNwXnb/qJ/1bA2nxfcYihPCj3RVOO4iKQtcejiIaikTBWwQivwudORLqYS1HiVb
	 8ucaSwZMM+kTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AECBC395EC;
	Fri,  9 Jun 2023 09:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: Fix promiscuous mode
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168630422130.21394.15550149642866170439.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 09:50:21 +0000
References: <20230608051625.2731378-1-rkannoth@marvell.com>
In-Reply-To: <20230608051625.2731378-1-rkannoth@marvell.com>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 sgoutham@marvell.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, sbhatta@marvell.com, gakula@marvell.com,
 schalla@marvell.com, hkelam@marvell.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Jun 2023 10:46:25 +0530 you wrote:
> CN10KB silicon introduced a new exact match feature,
> which is used for DMAC filtering. The state of installed
> DMAC filters in this exact match table is getting corrupted
> when promiscuous mode is toggled. Fix this by not touching
> Exact match related config when promiscuous mode is toggled.
> 
> Fixes: 2dba9459d2c9 ("octeontx2-af: Wrapper functions for MAC addr add/del/update/reset")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: Fix promiscuous mode
    https://git.kernel.org/netdev/net/c/c0e489372a29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



