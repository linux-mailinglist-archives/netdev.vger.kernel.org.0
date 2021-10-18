Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A676431887
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhJRMMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhJRMMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C661610C7;
        Mon, 18 Oct 2021 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634559011;
        bh=cmd+syFuvJM5JGm9Kxyf5/gg+02J31vZi2XeonvAT3s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TDra0Z9q40GEPUminf2pe/75CV9+QKGPOCLKWmPidXgyBM2CFTZeXtw6wgN6ct6DT
         +gh/2YCDpqvNuh0M++MARCrlNEHatLJUo9ntwFzAi83HzfISLnvHQgAEJ7YSgzlLik
         PopdE+LI6sDJj5Kj1nWx5jti4WdZwi5CbhB2cf7yXHRZroYCDsFqS+GZk8bkxlFCAr
         ZXVLUdGEu/gJSkReJjNak76ajU9dC/Bu7L+s+c0rHsgKy86ZHK0NLEl069UCI/XF84
         jmSCsHekdodrjaMMKH5zuqfx9Wwqf3VrkUzAEBpzjI6tdLwn+oYPDSxC7KRPyhSYsS
         ScYLCCa+1NXKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 407A460A2E;
        Mon, 18 Oct 2021 12:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2 net-next] Let spi drivers return 0 in .remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455901125.7340.7337638653547301526.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:10:11 +0000
References: <20211015065615.2795190-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20211015065615.2795190-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        arnd@arndb.de, marex@denx.de, broonie@kernel.org, michael@walle.cc,
        nathan@kernel.org, trix@redhat.com, yangyingliang@huawei.com,
        zhengyongjun3@huawei.com, kernel@pengutronix.de,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Oct 2021 08:56:13 +0200 you wrote:
> Hello,
> 
> this series is part of my quest to change the return type of the spi
> driver .remove() callback to void. In this first stage I fix all drivers
> to return 0 to be able to mechanically change all drivers in the final
> step. Here the two spi drivers in net are fixed to obviously return 0.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: ks8851: Make ks8851_remove_common() return void
    https://git.kernel.org/netdev/net-next/c/2841bfd10aa7
  - [v2,2/2] net: w5100: Make w5100_remove() return void
    https://git.kernel.org/netdev/net-next/c/d40dfa0cebd8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


