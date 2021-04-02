Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCA13530C0
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhDBVaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBVaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 17:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 951BA610C9;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617399012;
        bh=j5VtPvh3OFpTlFc5p59iqKxfLu4r7IcbvIQqo+cRP0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e7FIhbXxaIk+Cv16VYnOV8ehwLZMKGrCiRNiM+KEpFCb3DNlEAwJZddWTurAY/8bb
         0LXfVkM0rggH8KhJORgsVXZuvm2qG0c2Gx5qbVd0jx1EM3OyXoMHYcGO2ULYM1OgAK
         0Fg1wyENbEcqTvnE60Sw/QOvsYzoIoxLLHNAVPAg08gCaQqErNQNNk49uokLZ7PmD2
         hyTfSn8WkRU8WFs8c5Wblpzza4O6t8VjsejeBa4cdhZtGv/+/MCFqaKV6s78ldk5CF
         EHdzo4NXX9WxYvStVdpL44IxmlR71EKHqyF+lDGU/kXmk0Ez+nStMJUXu06qj6oNFC
         1RNNr1L1qy9IQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B483609CF;
        Fri,  2 Apr 2021 21:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] dpaa2-eth: add rx copybreak support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161739901256.1946.5550774023139514245.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 21:30:12 +0000
References: <20210402095532.925929-1-ciorneiioana@gmail.com>
In-Reply-To: <20210402095532.925929-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  2 Apr 2021 12:55:29 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> DMA unmapping, allocating a new buffer and DMA mapping it back on the
> refill path is really not that efficient. Proper buffer recycling (page
> pool, flipping the page and using the other half) cannot be done for
> DPAA2 since it's not a ring based controller but it rather deals with
> multiple queues which all get their buffers from the same buffer pool on
> Rx.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
    https://git.kernel.org/netdev/net-next/c/28d137cc8c0b
  - [net-next,v2,2/3] dpaa2-eth: add rx copybreak support
    https://git.kernel.org/netdev/net-next/c/50f826999a80
  - [net-next,v2,3/3] dpaa2-eth: export the rx copybreak value as an ethtool tunable
    https://git.kernel.org/netdev/net-next/c/8ed3cefc260e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


