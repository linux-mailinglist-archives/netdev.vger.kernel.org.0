Return-Path: <netdev+bounces-8680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27777252BD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 06:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA40928120F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70ADA5E;
	Wed,  7 Jun 2023 04:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727B97C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7F54C433D2;
	Wed,  7 Jun 2023 04:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686111622;
	bh=uy9jfLLSMmjj2jVXVKRm0XjxRlU7y8rVj5QchtHRfT0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TGkBN/OIKF8DJydz2TCtcy5h7wKAMX0oNk1LQ3kulCPdOiOQeCXKYSZWBlB4Tq173
	 t5l9g9isMnOccyMQzUa/XJgoA8vt8UdIctw8vpmSDaPw4aeXeCSedrB+5mE1rW6CM7
	 AzEZJc0er1yhw/ogpLnZt+xWA8v2fPJ6L3zSX7O3eyygYz6QdkURc1YI4/n1w2Oywh
	 7Sxzw828Sv34otVc7wGO/2PUXSJTPWeOjxaMAPFCCgeLT7g2HXnqZmlMuoDD7v9Czb
	 rAFZS+Wt26XXocWgLqo4C8mmR6mxq1VHapl42yuVhFNoHhNpg8+4FzVfMegBVChj9n
	 a28qG/G+kIsXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF2B5E29F3A;
	Wed,  7 Jun 2023 04:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio_net: use control_buf for coalesce params
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168611162271.32150.1707955265186129057.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 04:20:22 +0000
References: <20230605195925.51625-1-brett.creeley@amd.com>
In-Reply-To: <20230605195925.51625-1-brett.creeley@amd.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 virtualization@lists.linux-foundation.org, alvaro.karsz@solid-run.com,
 pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 xuanzhuo@linux.alibaba.com, jasowang@redhat.com, mst@redhat.com,
 shannon.nelson@amd.com, allen.hubbe@amd.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 5 Jun 2023 12:59:25 -0700 you wrote:
> Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
> support") added coalescing command support for virtio_net. However,
> the coalesce commands are using buffers on the stack, which is causing
> the device to see DMA errors. There should also be a complaint from
> check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
> coalesce params from the control_buf struct, which aligns with other
> commands.
> 
> [...]

Here is the summary with links:
  - [net] virtio_net: use control_buf for coalesce params
    https://git.kernel.org/netdev/net/c/accc1bf23068

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



