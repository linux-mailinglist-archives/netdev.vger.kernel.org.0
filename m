Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2946E41FCB1
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 17:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhJBPVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 11:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhJBPVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 11:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2BCFF61B06;
        Sat,  2 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633188007;
        bh=0NdqX5AXnj3U6jq+wBvSsBPAt9a24+NFzsCdzpr1XUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tm59uVkdj2M6MeEd5tfPYNAmIYm0ek6vLlNE298muwdsdesn4wJu7rm+Pj0yG9uC6
         P51WOO6EIjS3tAz6hl2NKna5LWt6PCY6AbRu3YlPKamg3R0z33AElpE8kQRtkZxJb/
         OUGG6zVUEwlAhd6FlDaEs/IW1Fy6WWYzKZpu4gLzIzUrvziXFihsPB2foPzLOdtfrS
         OdVkXBCMWTe877FoKIplon9qCxg/djcgYy3FoImKUbpfbolhiOf2niwBnTjHHOrP5G
         EImrOlKTGYBuafEjetNGK9TXIZHE/UJGBm5IkeiuQrKXeuc7pH/YZOGt0ApNzZ5ioQ
         62LVt5HlS3y3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1D3A1600AB;
        Sat,  2 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 1/1] ptp_pch: Load module automatically if ID matches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318800711.15445.7631528846521046417.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 15:20:07 +0000
References: <20211001162033.13578-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20211001162033.13578-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, lee.jones@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  1 Oct 2021 19:20:33 +0300 you wrote:
> The driver can't be loaded automatically because it misses
> module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
> call to the driver.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/ptp/ptp_pch.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [v1,net,1/1] ptp_pch: Load module automatically if ID matches
    https://git.kernel.org/netdev/net/c/7cd8b1542a7b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


