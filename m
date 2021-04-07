Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D2B357796
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhDGWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhDGWUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:20:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 685306139C;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617834030;
        bh=b1NavNNdw+5uBnWCb2VQ6QNkSYJ8ZSCIedSHiNDfWUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVEcRbyrxC3IwuyTZQQ+rCGvQI3LvZv8vgiCb93RaM9pu8OvfgaA2Uha1DC8jDUxD
         n59fyYBPrMHgeuivRXOjcCohRnvU4Rir666DL1B+4tmKxjRuxBK3+i0aHgrYXtBEql
         UVJEchasLfdeXOa/WIvhrEq5OVY1lonGPPipvQS1RLKouKez23lrSCRU5yn/SiDJBN
         l0QfWaPJLTcmFC6tvQ9oKu1fgUJ2DsdzRtqkTYTRp1ZkN72cBas++gTvFYBNKcjLIC
         SMLGUxmfAir0t4IzSZ1bvX41yDSAYcT36CSb5MXkMDosq/SZVc3NOmPS58Z9oKHfTP
         NYzW/0n79MM+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 62DAD609B6;
        Wed,  7 Apr 2021 22:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: encx24j600: use module_spi_driver to simplify
 the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783403040.11274.11051928321266522809.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:20:30 +0000
References: <20210407150704.359424-1-weiyongjun1@huawei.com>
In-Reply-To: <20210407150704.359424-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     kuba@kernel.org, yanaijie@huawei.com, dingsenjie@yulong.com,
        hslester96@gmail.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 7 Apr 2021 15:07:04 +0000 you wrote:
> module_spi_driver() makes the code simpler by eliminating
> boilerplate code.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  .../net/ethernet/microchip/encx24j600.c  | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: encx24j600: use module_spi_driver to simplify the code
    https://git.kernel.org/netdev/net-next/c/4e92cac843d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


