Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CD03D8AA5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbhG1JaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:30:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235573AbhG1JaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C5B7E60F9E;
        Wed, 28 Jul 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627464605;
        bh=78UH4qs9amkD7Y0zC390ms7kf9EJk2n6+azlfFWCHpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TdxtBCDAEnkTzX3JrfkJITk7WaKMpPXwSdPbBzMmn61fLny5GYxp9UYYsC1iDiiki
         atffj0sEzmdfWHwP0LVo3jGUYKEKzm54jPXDU9n8AJ76x0hmgIlgQwZoOQ41CzB7tT
         hfIlnl+6j4ALDTD9tC0WuAQHNV96bz4XzNgouCIIuDUgn0w0QxUd1EEmWigf76sKEu
         t36RWkCxNWRRTCaRx48iPF/pS/D06cKWfmwZq9CjBMeHJSic+rl9E/nqsG18fQzUCh
         a97fV0KWqycd56ZPhKrr2zfgL+p/MAa8460ZDJdctDi4J+avrzwh+7x9mX2fZpFr+A
         FdRNneaNd3LBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B83F5609E8;
        Wed, 28 Jul 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: nfcsim: fix use after free during module unload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162746460574.7734.11456826869103789563.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 09:30:05 +0000
References: <20210728064909.5356-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210728064909.5356-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Jul 2021 08:49:09 +0200 you wrote:
> There is a use after free memory corruption during module exit:
>  - nfcsim_exit()
>   - nfcsim_device_free(dev0)
>     - nfc_digital_unregister_device()
>       This iterates over command queue and frees all commands,
>     - dev->up = false
>     - nfcsim_link_shutdown()
>       - nfcsim_link_recv_wake()
>         This wakes the sleeping thread nfcsim_link_recv_skb().
> 
> [...]

Here is the summary with links:
  - nfc: nfcsim: fix use after free during module unload
    https://git.kernel.org/netdev/net/c/5e7b30d24a5b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


