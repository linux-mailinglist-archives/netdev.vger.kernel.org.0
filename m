Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3F3EF71D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhHRBAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234119AbhHRBAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 21:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 850FD61056;
        Wed, 18 Aug 2021 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629248405;
        bh=FQVuP9aelN8KtC52L7lYUnz5DwUxsbHq/o14pTx9cck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OutRivo9FirIxfb6CnMbr6tyT4oT/N6dGqX4iNfHnUSl/El9uqXkjR/Q4eUvnGIOf
         MC+U66ubEyyIWFBgjdAyzvTLM3nBJz8cDeNxM15DsZI1dFIqFTpaHqcQ0M8SIj+AZK
         IEf0zSx8l2P1uWD8O4140dVF2ILLjNf2mA+2MwuzWIS36kv/Kp28KTAm+vAnYvjOzn
         BGkR5qLs54wuP9yUcEe02ti3QQEa/y5zZ94sZTf3DCgl+8xY1QmF6nL00CY/pGfGnr
         oH4f08uWBhxv2p5LI3KspsZ5HxD/qE7E5vygBYhUbZevG/t9Sk4f9Zbtu5Hn8u93ke
         7v1aGiQfRSv/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 75A9560A25;
        Wed, 18 Aug 2021 01:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbe,
 xsk: clean up the resources in ixgbe_xsk_pool_enable error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162924840547.10457.731018204959138761.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 01:00:05 +0000
References: <20210817203736.3529939-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210817203736.3529939-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wanghai38@huawei.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, sandeep.penigalapati@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 13:37:36 -0700 you wrote:
> From: Wang Hai <wanghai38@huawei.com>
> 
> In ixgbe_xsk_pool_enable(), if ixgbe_xsk_wakeup() fails,
> We should restore the previous state and clean up the
> resources. Add the missing clear af_xdp_zc_qps and unmap dma
> to fix this bug.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path
    https://git.kernel.org/netdev/net/c/1b80fec7b043

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


