Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD4E38DE5F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhEXAbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232110AbhEXAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3DD1B611EE;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816211;
        bh=K/fWhKNN1VGkbAY/Tgqq2mkSmILj9mfF6IuFawaUBF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BvMB7l2rLJaA7bDacdQUV9KpLxfO3Q1uZsQG/KHTJWYXwUk6fqLY/NU0trf6Mym86
         A2cU2fUCw6uSHZhsKTodDwthdKYy/ELcKF0hVBJkvX8RAQNGmF6fy57y4FajHJ71ah
         gyitJdwVfCLcy9aovsHyFGEoakJUtUKh4jClpEFLQ5heJ3fmrAu+2vbUFpAN+XCLTo
         Btq2b8H7U5sUKkPSsyTzCPUlwr6spR/DPYNYYzrW6DasLaO78RUqI7gNhRxmkb3mhg
         Qld+c+14Xxpkjx6pUJFMZI3O8RxMO6nE3+Ae7xPTuhRU8TLVvocSLe+FqUUpB1hMrS
         ktb3WXCrv4UZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3810C60BD8;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: r6040: Non-functional changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621122.30453.5963616888599452675.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:11 +0000
References: <20210523155411.11185-1-f.fainelli@gmail.com>
In-Reply-To: <20210523155411.11185-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 23 May 2021 08:54:09 -0700 you wrote:
> Hi David, Jakub,
> 
> These two patches clean up the r6040 driver a little bit in preparation
> for adding additional features such as dumping MAC counters and properly
> dealing with DMA-API mapping.
> 
> Thanks
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: r6040: Use logical or for MDIO operations
    https://git.kernel.org/netdev/net-next/c/190e6e291a4c
  - [net-next,2/2] net: r6040: Use ETH_FCS_LEN
    https://git.kernel.org/netdev/net-next/c/06666907a38a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


