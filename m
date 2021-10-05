Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A044226A9
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhJEMcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhJEMb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DA9C2615E1;
        Tue,  5 Oct 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633437007;
        bh=X3qjpqrOMjjgSbHit94G9HnK13zoWhTRrDveSyrqgDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sxj45ogyAtE2IQgvfIOWjWyv8qm7F2WeXcq5DrKGGFwuIvaAHPbyZircyz7vvCr6L
         13NJ6fmekmDKXo3bA8k32dyqDnNBxZV5zpfs397NaKpNMeAS5y+TwUPOsa1m27HyHu
         JpyP/RJfNCIE0emPZu1X9PokEgxa1BwNWo9Zmkd53IWkbSbZh5E6cSfBWcK+78TkgE
         VJiA5YT2WOil0n5ShFwf+e2H3Yxb4nO3Bddme+SgUzYuZfuzI9p93L+6tQtOUX4/7S
         x9QHYKsaUZwF86RVF+wwIhnqTDE4EYa1woRCtLUz+R2GyVeq2VfCz3XugI3tTB2UYV
         UvVP8ilbeIZHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF59360A3A;
        Tue,  5 Oct 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] ethernet: use eth_hw_addr_set() for
 dev->addr_len cases
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343700784.31035.8586148715068113446.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 12:30:07 +0000
References: <20211004160522.1974052-1-kuba@kernel.org>
In-Reply-To: <20211004160522.1974052-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  4 Oct 2021 09:05:21 -0700 you wrote:
> Convert all Ethernet drivers from memcpy(... dev->addr_len)
> to eth_hw_addr_set():
> 
>   @@
>   expression dev, np;
>   @@
>   - memcpy(dev->dev_addr, np, dev->addr_len)
>   + eth_hw_addr_set(dev, np)
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ethernet: use eth_hw_addr_set() for dev->addr_len cases
    https://git.kernel.org/netdev/net-next/c/a05e4c0af490
  - [net-next,2/2] net: usb: use eth_hw_addr_set() for dev->addr_len cases
    https://git.kernel.org/netdev/net-next/c/49ed8dde3715

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


