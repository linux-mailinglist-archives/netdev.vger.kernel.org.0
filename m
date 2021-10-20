Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1750D4349D0
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJTLMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhJTLM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D8064613E8;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634728212;
        bh=ZXcuoJnVgoftupwwWUvj0gPzbTgh40nqvNcq1x0NY0w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lQVL5IoyX5tJe+yXruDT1aZUSu1ZPlc/dqwV5R2V73mDgTQmtWwnyoUc7w3DqzK/y
         oXdvpqISC4qHtZ7dqsL8kTYy5tZvkqNVTmimZMkGDXUmJkHPLrSuzpBco5uV5lpDiB
         3S4ak+yjXA3TMu4KbhKvMpOjw5DJlW/uKrUW+kSKb+tRrCpz3kG8tVUYqhUAH+TcyN
         7OujzyUryWBICUdtBv87s4fNbwa5dz1Gmr8MSmZy8Ug1oRzMabX+z/YiCFRM3BQzbq
         ZHy8mQ08NURrQh+z7dQbS9ifSza0v0tuMP6Ui2mr2vOWKhzE5yHueSQnWxjgeV04FR
         GJxI4aEC2iECQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CB76D60A4E;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ethernet: manual netdev->dev_addr conversions
 (part 3)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163472821282.2036.7442835252708920317.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 11:10:12 +0000
References: <20211019150011.1355755-1-kuba@kernel.org>
In-Reply-To: <20211019150011.1355755-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 08:00:05 -0700 you wrote:
> Manual conversions of Ethernet drivers writing directly
> to netdev->dev_addr (part 3 out of 3).
> 
> Jakub Kicinski (6):
>   ethernet: netsec: use eth_hw_addr_set()
>   ethernet: stmmac: use eth_hw_addr_set()
>   ethernet: tehuti: use eth_hw_addr_set()
>   ethernet: tlan: use eth_hw_addr_set()
>   ethernet: via-rhine: use eth_hw_addr_set()
>   ethernet: via-velocity: use eth_hw_addr_set()
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ethernet: netsec: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/414c6a3c84d7
  - [net-next,2/6] ethernet: stmmac: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/7f9b8fe5445c
  - [net-next,3/6] ethernet: tehuti: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/3d9c64ca52d5
  - [net-next,4/6] ethernet: tlan: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/41a19eb084f0
  - [net-next,5/6] ethernet: via-rhine: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/83f262babdde
  - [net-next,6/6] ethernet: via-velocity: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0b271c48d9c5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


