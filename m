Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7068938CEF9
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhEUUWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231178AbhEUUVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0948A613F3;
        Fri, 21 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621628410;
        bh=zdT3b3xyJ/3Ktivp4H8Pyhy4+37XFUk256l9Eac/hpQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VgxbQhCSWKTwOHUF1zRuUVT3I6YFKrHpuj7fUEKTEPOvzdPrMKt1HsbANuf2KRUyD
         GZPAbuvH92XJnXoa1QXnSIX5q74/rMVSaqa7uqZcRVDAcR5teo48Hsjb0Rvbvg80I8
         Lq3ZOQ1BMHVwCgcvEPolo7BuDmOyXo2z3cPbqdoRbeQpCyXEtSz6u5ewNJte/t3sdu
         sKVeQKHffS/qwJoCTHota0tWQ9Y3VM5FFonHejez+ByCDzYEGjnuPekaAGy2UeGOU6
         ssS2AyszTvR1dTJ1E/nBe872lNsPTuTha6WmO4K4nLtvQt9mls3FIJYqbm2Ybr/exn
         +MA5fELWfafhw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 037A56096D;
        Fri, 21 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: xilinx_emaclite: Do not print real IOMEM
 pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162162841000.7187.7518770038763917551.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 20:20:10 +0000
References: <20210519024704.21228-1-yuehaibing@huawei.com>
In-Reply-To: <20210519024704.21228-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 10:47:04 +0800 you wrote:
> Printing kernel pointers is discouraged because they might leak kernel
> memory layout.  This fixes smatch warning:
> 
> drivers/net/ethernet/xilinx/xilinx_emaclite.c:1191 xemaclite_of_probe() warn:
>  argument 4 to %08lX specifier is cast from pointer
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: xilinx_emaclite: Do not print real IOMEM pointer
    https://git.kernel.org/netdev/net-next/c/d0d62baa7f50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


