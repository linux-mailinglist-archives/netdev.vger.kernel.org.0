Return-Path: <netdev+bounces-5505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D13CE711EAC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2547A281681
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E97259B;
	Fri, 26 May 2023 04:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551811FD6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03A6FC4339E;
	Fri, 26 May 2023 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074221;
	bh=BBsw3NbG1iCxV5k48iC96IVA5u9+JQQ+YqZt6BPd1wc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=j5fCHo5gIHDYrHoqJF9kDR8IOiCo9hJ2Kibs2o47OVdKuS5+6xo4PaeRmZA3lIimW
	 JYQ0plVsHQrqjUfFtrKmFTv+NcGpLbohasWgi/z+rY6cJpeQoVcjsEyiWRma4UVdEo
	 IFHOgTnAPgaZdyxD0cXU0tok/C1K9r956QyeOW6S88Vfwt6DfpkH4RhIXOeBMnLSXI
	 Rysg7AMAer5egsgxLgN/6N9f6RVNiiZzQMEgsS/Ciy/2FKAyLFzb6jMkwMzWBtJtlQ
	 f9hYWY8c7EgfQ8Wxc042yIWLwYQxR4OXVugBNCqOr/lgeUeulgjZp97nwPdl/OzwTM
	 0TTaMVJupfEIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D481AE270C2;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: mellanox: mlxbf_gige: Fix skb_panic splat under
 memory pressure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507422086.22221.10561998805446517156.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:10:20 +0000
References: <20230524194908.147145-1-tbogendoerfer@suse.de>
In-Reply-To: <20230524194908.147145-1-tbogendoerfer@suse.de>
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, asmaa@nvidia.com, limings@nvidia.com,
 davthompson@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 21:49:08 +0200 you wrote:
> Do skb_put() after a new skb has been successfully allocated otherwise
> the reused skb leads to skb_panics or incorrect packet sizes.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
> Changes in v2:
> - moved skb_put() after dma_unmap_single()
> - added Fixes tag
> - fixed typos in commit log
> 
> [...]

Here is the summary with links:
  - [v2,net] net: mellanox: mlxbf_gige: Fix skb_panic splat under memory pressure
    https://git.kernel.org/netdev/net/c/d68cb7cf1fd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



