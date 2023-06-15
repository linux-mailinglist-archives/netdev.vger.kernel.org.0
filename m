Return-Path: <netdev+bounces-11053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 467B37315C2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:50:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788C01C20CB2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2059963A7;
	Thu, 15 Jun 2023 10:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF052F3B
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B53AC433C8;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686826220;
	bh=ND1qzrA0F1q4onWM/ocX5EQDwzJiiGhPIH8Mkux/m08=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=m1xNJy5AWk7V1YZ8A/Tcv6vjwKCAQ+uTKKVU6mYWY8//j5/umCXz2wTRsTVmh07q7
	 S2G1lqn7DgqjHoqRUA0h3mAqL4qH9iXWdTTqTrpSwIEmUQ+87DNgSSVw1jOEFlujAS
	 h54b8Yzl1/nHiqGKfifv1A2llcHj2wX1ayrL+eQyF78Rd87aUV2YLX5NwJQrzZC4ja
	 X5Rhc7s+BuIYlo2b5Z5L4NJpJptHin35p43m9TqDaZguqjM36ZCdIwzWWpwOoP2O/8
	 S5YsJQQ45fQoHqCoFCV5B0qDJJHUroi8E5UqeBJUGCf64fh/n5vCTdMmYv1mkkZnjd
	 FQhBDLqqdfolg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A665C395C7;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix XDP queues mode with legacy IRQ
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168682622016.15431.1529561381455480099.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 10:50:20 +0000
References: <20230613133854.37832-1-ihuguet@redhat.com>
In-Reply-To: <20230613133854.37832-1-ihuguet@redhat.com>
To: =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@codeaurora.org
Cc: ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-net-drivers@amd.com, yanghliu@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Jun 2023 15:38:54 +0200 you wrote:
> In systems without MSI-X capabilities, xdp_txq_queues_mode is calculated
> in efx_allocate_msix_channels, but when enabling MSI-X fails, it was not
> changed to a proper default value. This was leading to the driver
> thinking that it has dedicated XDP queues, when it didn't.
> 
> Fix it by setting xdp_txq_queues_mode to the correct value if the driver
> fallbacks to MSI or legacy IRQ mode. The correct value is
> EFX_XDP_TX_QUEUES_BORROWED because there are not XDP dedicated queues.
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix XDP queues mode with legacy IRQ
    https://git.kernel.org/netdev/net/c/e84a1e1e683f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



