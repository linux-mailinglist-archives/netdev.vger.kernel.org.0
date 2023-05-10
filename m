Return-Path: <netdev+bounces-1309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4686FD3EC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 04:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13993281353
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 02:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672F963E;
	Wed, 10 May 2023 02:50:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F05D63C;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 396EEC433EF;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683687026;
	bh=d4WJe7aOQ/hWqiiSIGM04cTuskafOpsupvI1zO45mp4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jEQdK9ShLDcJQJzdigC5FFhCItoY0dzogQMZqV5bLGAZy/9S+2A8l5NQF2Z78akK8
	 oZomF2subVVlzQUE+2tKULcNJ9FuIpzY0t1nZcCvOD7R4Du22qFK0+cMJQsMDAuXYw
	 X8VDKSCwj6yrPSMHDsWAYdrquXk3xL31SVNOWseQfFxKJFkL4kzBtdn8noAf0+uvv2
	 ewmlfF6ek7MLY7etF9u2mv6RKHPvbv55pGHqrbrvdKNJNeVH4qOJmO9XKLgLsQD8hG
	 c16kTko/bVllAqhG7Oe0aT1sB0qbAUO4zinFiemvOz8h9xbzttQEgKNCTuNhnuHvjO
	 MZ4iDfHNfBKwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22252C39562;
	Wed, 10 May 2023 02:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 00/15] virtio_net: refactor xdp codes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168368702613.23144.13458642339700236476.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 02:50:26 +0000
References: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, virtualization@lists.linux-foundation.org,
 bpf@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 May 2023 14:14:02 +0800 you wrote:
> Due to historical reasons, the implementation of XDP in virtio-net is relatively
> chaotic. For example, the processing of XDP actions has two copies of similar
> code. Such as page, xdp_page processing, etc.
> 
> The purpose of this patch set is to refactor these code. Reduce the difficulty
> of subsequent maintenance. Subsequent developers will not introduce new bugs
> because of some complex logical relationships.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/15] virtio_net: mergeable xdp: put old page immediately
    https://git.kernel.org/netdev/net-next/c/363d8ce4b947
  - [net-next,v5,02/15] virtio_net: introduce mergeable_xdp_get_buf()
    https://git.kernel.org/netdev/net-next/c/ad4858beb824
  - [net-next,v5,03/15] virtio_net: optimize mergeable_xdp_get_buf()
    https://git.kernel.org/netdev/net-next/c/dbe4fec2447d
  - [net-next,v5,04/15] virtio_net: introduce virtnet_xdp_handler() to seprate the logic of run xdp
    https://git.kernel.org/netdev/net-next/c/00765f8ed742
  - [net-next,v5,05/15] virtio_net: separate the logic of freeing xdp shinfo
    https://git.kernel.org/netdev/net-next/c/bb2c1e9e75be
  - [net-next,v5,06/15] virtio_net: separate the logic of freeing the rest mergeable buf
    https://git.kernel.org/netdev/net-next/c/80f50f918c6e
  - [net-next,v5,07/15] virtio_net: virtnet_build_xdp_buff_mrg() auto release xdp shinfo
    https://git.kernel.org/netdev/net-next/c/4cb00b13c064
  - [net-next,v5,08/15] virtio_net: introduce receive_mergeable_xdp()
    https://git.kernel.org/netdev/net-next/c/d8f2835a4746
  - [net-next,v5,09/15] virtio_net: merge: remove skip_xdp
    https://git.kernel.org/netdev/net-next/c/59ba3b1a88a8
  - [net-next,v5,10/15] virtio_net: introduce receive_small_xdp()
    https://git.kernel.org/netdev/net-next/c/c5f3e72f04c0
  - [net-next,v5,11/15] virtio_net: small: remove the delta
    https://git.kernel.org/netdev/net-next/c/fc8ce84b09bc
  - [net-next,v5,12/15] virtio_net: small: avoid code duplication in xdp scenarios
    https://git.kernel.org/netdev/net-next/c/7af70fc169bd
  - [net-next,v5,13/15] virtio_net: small: remove skip_xdp
    https://git.kernel.org/netdev/net-next/c/aef76506bc64
  - [net-next,v5,14/15] virtio_net: introduce receive_small_build_xdp
    https://git.kernel.org/netdev/net-next/c/19e8c85e336d
  - [net-next,v5,15/15] virtio_net: introduce virtnet_build_skb()
    https://git.kernel.org/netdev/net-next/c/21e26a71f5d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



