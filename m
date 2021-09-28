Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7E41AECE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbhI1MVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240599AbhI1MVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2039961159;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831607;
        bh=27GvGY4etF9w0Sy7ohnMVhPCXT/biduEjd4/bSmkfo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PqjnFh12hQKbK6Rg3H5nCafJQTkfAxnNn7KqXu1+mkZIF+lF1ZLON9EaX/fykAr0L
         oMsFHBoQfi0Ta5oFyuEaFeG+eyW6aAbDZpkE0poiFK9jb/XLzy6E0fuyPJ74Ntknpo
         g0BBHeWGjoR98IZft71kc2IhBI0FrcflY7YO6SDTg3xKKpFiTcP7w8S2qlaxKS84+a
         y8AERSgYOkCQC90L7vfleYkK3NPBx018M1SHuHOiQb9gw9t7p3FMz1g7yzY+DUi1d0
         2LuekSJ3V5Nv/7vw8Toihc52URpZZRzjj4e9mjihruGE9N+BKxeVJwgxpEez+X/x16
         X7RSK5KsfL43A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1622560A69;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dmascc: add CONFIG_VIRT_TO_BUS dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160708.2416.15922633509363078589.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:07 +0000
References: <20210927141529.1614679-1-arnd@kernel.org>
In-Reply-To: <20210927141529.1614679-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 16:15:24 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Many architectures don't define virt_to_bus() any more, as drivers
> should be using the dma-mapping interfaces where possible:
> 
> In file included from drivers/net/hamradio/dmascc.c:27:
> drivers/net/hamradio/dmascc.c: In function 'tx_on':
> drivers/net/hamradio/dmascc.c:976:30: error: implicit declaration of function 'virt_to_bus'; did you mean 'virt_to_fix'? [-Werror=implicit-function-declaration]
>   976 |                              virt_to_bus(priv->tx_buf[priv->tx_tail]) + n);
>       |                              ^~~~~~~~~~~
> arch/arm/include/asm/dma.h:109:52: note: in definition of macro 'set_dma_addr'
>   109 |         __set_dma_addr(chan, (void *)__bus_to_virt(addr))
>       |                                                    ^~~~
> 
> [...]

Here is the summary with links:
  - dmascc: add CONFIG_VIRT_TO_BUS dependency
    https://git.kernel.org/netdev/net/c/05e97b3d33cb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


