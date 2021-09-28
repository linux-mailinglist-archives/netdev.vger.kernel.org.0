Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285841AECC
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240599AbhI1MVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240559AbhI1MVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 183F26101E;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831607;
        bh=schGRFdjJDCpJQzMBQ5TEMEFyPj8xqlPF0C6UXv4JkU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EvdNabbju648TKg0aDuuD9wzlWUXaoXS4BTTolfoSSSFhMQwWEEtYMfqbq9RGy74H
         P+PBI3UV6/qRhr9JVxjnpToqcKxtDPhgB5shPNcT7O0Lk/NVFS7fE9f3MY4byfd97t
         ZM1GsGWp6X83Mt48KV6tb/wzuGBLD+BhENcPmg0lZwJ1EiX7caJAZ4MF+zevKwaVZZ
         itqWuIxuTHe12oimEg6eK4Fc4pHHM9Cck7UUDmJcqVD9eK5CSwMKfPNFx68OfJ3ga2
         iYV+IiP/B7gnHWbRNxUKq5tZ3rdqchDXNRpsIBMH5Rmg0dP2nGFJXJ4Vg2kuTY8ovG
         bbw50sO1G8iXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BED360A7E;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [RESEND] net: ks8851: fix link error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160704.2416.5814873993469611911.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:07 +0000
References: <20210927141321.1598251-1-arnd@kernel.org>
In-Reply-To: <20210927141321.1598251-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        marex@denx.de, arnd@arndb.de, jgg@ziepe.ca, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 27 Sep 2021 16:13:02 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> An object file cannot be built for both loadable module and built-in
> use at the same time:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> ks8851_common.c:(.text+0xf80): undefined reference to `__this_module'
> 
> [...]

Here is the summary with links:
  - [RESEND] net: ks8851: fix link error
    https://git.kernel.org/netdev/net/c/51bb08dd04a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


