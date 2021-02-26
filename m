Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B710A326A73
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZXkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:40:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229698AbhBZXkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 18:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E6F9B64F13;
        Fri, 26 Feb 2021 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614382809;
        bh=KsaD2a4pUvntQwIV9RRK+DaCGMzkSgC/qt8mdxixQV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ODYqlGL42+ILOxgO75Zw+bHW1FN1CXpEH5orTw+6cIiOUdr4EJCzIOnmmvH4g+MnS
         LB+IIoPA5Vv3tkYqMahdZGdZNv2qpy7aGo+VssnWBlz7EOn43hC3qbWs7EItdDMrqq
         tsLW7WROuNU5iqXDDfLEVra/m3FKZhDV3duM1JvANR1X1bbTXbevfivzZc5gLpEw+S
         fAXqEn7VHtHKQArwR2aUSUfnQhsXHuqBdXN5sHwxdUGyioNDeTFqXqoDO2NuA0E18X
         r70q4BZ1VFFhzklPsDVTtnnnIYif5IvXOY+cO752lZZmwIvok1xAhb8cFb8454YX/r
         5WDIb+ZachwDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB94660A14;
        Fri, 26 Feb 2021 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: don't build GPIO support if !GPIOLIB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161438280889.26339.13789793775995873719.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Feb 2021 23:40:08 +0000
References: <20210226063226.8474-1-dqfext@gmail.com>
In-Reply-To: <20210226063226.8474-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linus.walleij@linaro.org, arnd@arndb.de, landen.chao@mediatek.com,
        sean.wang@mediatek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 26 Feb 2021 14:32:26 +0800 you wrote:
> The new GPIO support may be optional at runtime, but it requires
> building against gpiolib:
> 
> ERROR: modpost: "gpiochip_get_data" [drivers/net/dsa/mt7530.ko]
> undefined!
> ERROR: modpost: "devm_gpiochip_add_data_with_key"
> [drivers/net/dsa/mt7530.ko] undefined!
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: don't build GPIO support if !GPIOLIB
    https://git.kernel.org/netdev/net/c/63c75c053b41

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


