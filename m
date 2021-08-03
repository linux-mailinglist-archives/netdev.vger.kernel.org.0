Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308723DF6DF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhHCVaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhHCVaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:30:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D34A60F46;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026206;
        bh=R4xzortLP7QInQuQ1PRtO1fmbv0e1OOvY+6BFpMEnHc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cve1r67PjsTvtk2Jjlf9W1dmei6NbgwwIzKE1m+7QMHFE+lamI+3mvDp9PmMXjYzd
         RSAF3Iw2sHiEgsr4AUEJNpQbv9r7W54y1F7Pppagp7j/9HkKmTtUgTlT3bMov5qiRU
         izhmALaRnwFX7WSix94d9LwSsaPk07FbpkoYYpJD8uQqHScs6RwrOFjNsHKd6NjRL4
         +vUjuwmr6ekpSd7qUj5ZRigLjpXI1NVGX7+32kb4Q6nG3MS2I82Bl8sz8ptKMr74ZR
         OqbxKMe3k6okZbreuks2MVuN+nTUmfUyCk0/Lf+r3kEXARj68xebnhZqSRSJlBs/dO
         JlI2+A+lRT09g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1FEC660A49;
        Tue,  3 Aug 2021 21:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] octeontx2-af: Fix spelling mistake "Makesure" -> "Make
 sure"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802620612.14199.392270478588061402.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:30:06 +0000
References: <20210803105617.338546-1-colin.king@canonical.com>
In-Reply-To: <20210803105617.338546-1-colin.king@canonical.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 11:56:17 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a NL_SET_ERR_MSG_MOD message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] octeontx2-af: Fix spelling mistake "Makesure" -> "Make sure"
    https://git.kernel.org/netdev/net-next/c/8578880df39c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


