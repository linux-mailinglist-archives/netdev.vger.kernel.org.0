Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA23895FD
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhESTBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhESTB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 530CF61355;
        Wed, 19 May 2021 19:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621450809;
        bh=TVh3v1pQNzOV2rxlph4rOaV5D8wUdPZo2EmD5rB+3Lw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XK4aonHIC2T2i7G4c4MlL8gL28laGb2kPULc0A82scTc2pZWXUTN1FktVFdSe5QAP
         rvljIc0fDpWVR++5QrDkAoHYeK5uZ4NIVab8+SF5TWTOLU1aTWif3ncmgf0vNBbVLV
         tFPSoBhkagFFlj+0+Jbm2ooiD5IsT0TcT4qekjm5UK2836r4y9WqQpsOWXRU1Oh/M5
         kgocJqMtlFsu0X2eD9S+QN59NLoHB7dHwFK/UQc2QlVeeotNSLRXt8+AEczVlBQWjl
         sMGl1/TBCA2Ft6Ak69pDI4o51XgddKX1k9k/tnaXOXgEZxxg1m7R65JkHGcPdS2bqY
         IRIq9YrQyEfaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4790760A0D;
        Wed, 19 May 2021 19:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: stats: Fix a copy-paste error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145080928.10102.16399955039340126516.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:00:09 +0000
References: <20210519021038.25928-1-yuehaibing@huawei.com>
In-Reply-To: <20210519021038.25928-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 19 May 2021 10:10:38 +0800 you wrote:
> data->ctrl_stats should be memset with correct size.
> 
> Fixes: bfad2b979ddc ("ethtool: add interface to read standard MAC Ctrl stats")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/ethtool/stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] ethtool: stats: Fix a copy-paste error
    https://git.kernel.org/netdev/net/c/c71b99640d2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


