Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D543D5A35
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhGZMjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233408AbhGZMji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2847060F5B;
        Mon, 26 Jul 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627305606;
        bh=klR9V1cWpoAfm72zBHn9dzvHkiSIlTKvlHy1oS47rk4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N0xwLbXSdQLqscZf2cbVxRJG+fbFeYP7/0JEf/at5rId9TmX/vYvl4Q2w2I5ztCut
         lx6XY7evT/HcImvl+zJvpvrV18QQmP+zs44xyYYRK29tYWyhbRwMwhNe43aP8HM5Zi
         Jp0EIM3FuedfZKNYxl/n2hfogJdLBPy/2eqrvZlWgzdmnzm/qFma0eKkV+YlYvUZXW
         hB3hqhljFnzKG9cYQEHDD/A6LDFPcUrEbuwreJzJz+2R8O8yQk9PhoxVPKjbSJ37ZO
         7kn5Y9RMazFTl35k5z3PiiqOKB3cCHGdCluYfbyuPIaiC2m9B6m2MRq5IUu/i3WMz7
         3+wGmsh4DtaDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 232CB60A12;
        Mon, 26 Jul 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ixp4xx_hss: use dma_pool_zalloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162730560614.19326.17438761795827347339.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 13:20:06 +0000
References: <20210725144221.24391-1-wangborong@cdjrlc.com>
In-Reply-To: <20210725144221.24391-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 25 Jul 2021 22:42:21 +0800 you wrote:
> The dma_pool_zalloc combines dma_pool_alloc/memset. Therefore, the
> dma_pool_alloc/memset can be replaced with dma_pool_zalloc which is
> more compact.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/wan/ixp4xx_hss.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - net: ixp4xx_hss: use dma_pool_zalloc
    https://git.kernel.org/netdev/net-next/c/af996031e154

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


