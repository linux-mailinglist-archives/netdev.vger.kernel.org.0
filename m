Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0EA310408
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 05:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhBEEUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhBEEUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 23:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4717F64FA9;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612498807;
        bh=dZ7oBZDsHR/8Z3anSIEZghT8NDUy4ARYKhDT508Eq30=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qwTW9cG5DdwxTRucZ3dABeBWGR8rA6gILnUijkeh5rr98GSznZ/mPlI1coVVuZ9fO
         4g7u+l9VRQ/MCmKtgAK3SbFziAMDzuupnwhJBDGCvQhcafQ/ypnyNBD9keCslyhbxC
         gCsigabbjq4k1cjmqN33RQnrA01+GczMfVES4C6pJzCTi5hCQq5rVZrtgSe49Gtdro
         zk5AuxzcbjzbNOcV4VWZRQk83O905anTnNAYt1A/7uBNhyCraIiiM991EZf5mUQ4P+
         o7YzV6oPJ8L+/kJksdRCNawT0r1XFosls4tIYfj0Map7a8tmCvORN4tlLjqTQ5qrBU
         a4a4K+qZABHlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B351609F2;
        Fri,  5 Feb 2021 04:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in
 netvsc_receive()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249880723.20393.1705346337998765386.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 04:20:07 +0000
References: <20210203113602.558916-1-parri.andrea@gmail.com>
In-Reply-To: <20210203113602.558916-1-parri.andrea@gmail.com>
To:     Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        skarade@microsoft.com, juvazq@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Feb 2021 12:36:02 +0100 you wrote:
> Commit 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V
> values") added validation to rndis_filter_receive_data() (and
> rndis_filter_receive()) which introduced NVSP_STAT_FAIL-scenarios where
> the count is not updated/reset.  Fix this omission, and prevent similar
> scenarios from occurring in the future.
> 
> Reported-by: Juan Vazquez <juvazq@microsoft.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Fixes: 44144185951a0f ("hv_netvsc: Add validation for untrusted Hyper-V values")
> 
> [...]

Here is the summary with links:
  - [net] hv_netvsc: Reset the RSC count if NVSP_STAT_FAIL in netvsc_receive()
    https://git.kernel.org/netdev/net/c/12bc8dfb83b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


