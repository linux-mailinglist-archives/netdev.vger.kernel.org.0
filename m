Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7B842C62D
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhJMQWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhJMQWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 12:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 72E62610C9;
        Wed, 13 Oct 2021 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634142007;
        bh=O2Hmkcq3eZU1HyZe7qDmamyegm961y2wb/2YU85nGwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LFYLnPfMN+s+3mmVvXeS/Y8W2LMUivez3tW/hB+Fzgvi1uavvf/Pt8Ev9S3UGrh9H
         K0emCByhwvcPPbpsWgvdy1jVBS3kJemIStcvGIQjWvHNBPXuZJ5cEj1JAhOMFKxVDg
         PPrwcJnRZwPQ1+IKWtK6uoAG/MaA/H9Hc0WiJjtl0d/ItQcNPelIHf1FHly0KYhNdr
         d1g1uvPI+x2zOaTFQodsqQjC2gQugTWKxFGL/LZ246beVqYSUh6pyHy2CLOEEIDE7j
         6Gx5YjUEHWiG+S5qZ29wR+XTg8xkdEIY2PoEYuXPkcW3kkzVGBD19utYmhtLZb/yNJ
         iWBPrBxaBEOGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64FB860A39;
        Wed, 13 Oct 2021 16:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: arc: select CRC32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414200740.13761.2339659999652970169.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 16:20:07 +0000
References: <20211012093446.1575-1-vegard.nossum@oracle.com>
In-Reply-To: <20211012093446.1575-1-vegard.nossum@oracle.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     davem@davemloft.net, kuba@kernel.org, b.galvani@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 11:34:46 +0200 you wrote:
> Fix the following build/link error by adding a dependency on the CRC32
> routines:
> 
>   ld: drivers/net/ethernet/arc/emac_main.o: in function `arc_emac_set_rx_mode':
>   emac_main.c:(.text+0xb11): undefined reference to `crc32_le'
> 
> The crc32_le() call comes through the ether_crc_le() call in
> arc_emac_set_rx_mode().
> 
> [...]

Here is the summary with links:
  - [v2] net: arc: select CRC32
    https://git.kernel.org/netdev/net/c/e599ee234ad4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


