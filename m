Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384D03AF5F8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFUTWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhFUTWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0981861356;
        Mon, 21 Jun 2021 19:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624303205;
        bh=b44G8g9bppS0Gm+biXLIchdUB72Mnr2l2IiVtQxeM4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H9y6LGw86g+ozrHUZgBPcsHzqcC8NJHAQvgznIS0XT3SWOI1uKFlLRQ8AgRgxW3Ph
         6dTSyWh0btyDDEfiFPMNOZ8oCqJana5wmaOR5t/IEF4KOZhreU+aygSzSjhwg1YYx0
         1Hor3wlfKfkG0w8HV2PH5BKpImc40qUNajISRnRUb23CimNFfmopafaGIZowlOFYf+
         71rc5BEzObMGqXcMDU8dXAq+EVZA1YtFSKCvCycFnA461OUEqrqk1+8nxIHO9EAf3y
         xVr1Yu7RpX5LJJEjFzOu0c+yMaL7JFawUi1355bXxS+rgBQyEupIZ3iNfThP/Zp0xq
         n5TuCxCG5YxsQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F336A60A37;
        Mon, 21 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] selftests: tls: clean up uninitialized warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430320499.6988.9835964890406190142.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:20:04 +0000
References: <20210618202504.1435179-1-kuba@kernel.org>
In-Reply-To: <20210618202504.1435179-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        vfedorenko@novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 13:25:03 -0700 you wrote:
> A bunch of tests uses uninitialized stack memory as random
> data to send. This is harmless but generates compiler warnings.
> Explicitly init the buffers with random data.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/testing/selftests/net/tls.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

Here is the summary with links:
  - [net,1/2] selftests: tls: clean up uninitialized warnings
    https://git.kernel.org/netdev/net-next/c/baa00119d69e
  - [net,2/2] selftests: tls: fix chacha+bidir tests
    https://git.kernel.org/netdev/net-next/c/291c53e4dacd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


