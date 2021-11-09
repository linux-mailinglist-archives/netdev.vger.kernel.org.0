Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC2B44AF36
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhKIOM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhKIOMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 60B45611C5;
        Tue,  9 Nov 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636467007;
        bh=zn5UzZl7c1y46/sBicFGO6ktBWwvdCl5cH4ZCLRo0yM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a3/LnwMToOwIAG/7jfvd4yp51Hz5zUVpHdlSKfTv6o3+PYfVhPoalqMTOQBSNv3ow
         3tZ7c6JxHq3V3TiUKsNdLv9oNkFv7Xjkg6STYIHaJq7pR5xM4Klge+BNkk8XWMHXy3
         QrmpWYJ/U78L5dVy9Dal++OIt/sVuN+dPLtID4vrITA406jZPLr99Qgt1f4SmUYvh1
         qim/uI6XiG4fNFrMB2KpXtfX3NIoJsBY8021Y416vvb4VZ9mpSsz49/rqI3W/hHMRV
         drJc/YSvhcowh2y0uXVOzR+iOBhBwjwgEYxP/Fa187CWN3Hhhhbb0yWjMxBy6zAaXW
         z3vf/9LetuwKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5476360A3C;
        Tue,  9 Nov 2021 14:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amt: add IPV6 Kconfig dependency
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163646700734.20937.7035104041345204085.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Nov 2021 14:10:07 +0000
References: <20211108111322.3852690-1-arnd@kernel.org>
In-Reply-To: <20211108111322.3852690-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, ap420073@gmail.com,
        arnd@arndb.de, loic.poulain@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Nov 2021 12:12:24 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver cannot be built-in if IPV6 is a loadable module:
> 
> x86_64-linux-ld: drivers/net/amt.o: in function `amt_build_mld_gq':
> amt.c:(.text+0x2e7d): undefined reference to `ipv6_dev_get_saddr'
> 
> [...]

Here is the summary with links:
  - amt: add IPV6 Kconfig dependency
    https://git.kernel.org/netdev/net/c/9758aba8542b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


