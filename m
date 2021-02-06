Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8222E311F65
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 19:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBFSku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 13:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhBFSkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 13:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 27B8D64E65;
        Sat,  6 Feb 2021 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612636807;
        bh=y2xADXBGupcbkorncEKQnNBydIwNcvPHkkVfcAS+u5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ht/fDgB9kkMlKEA6CaFKj6UqIgnkOdtvzAUhboZ4NQ29EO0SD+PUAk3yj81gXCZZs
         mReVvyCsQJ8j0womKnsTA/PScj7NCYrNkCPZji2wdCxwlwfkwf4nRFVuHhitVcakUX
         FUlGNGJ7+ykABJdCM0psnDyckyCY+Wq3NcA6CATI8ERV8TRovRSOgWMBxqNJurK0fm
         LxWOGd5GVwaiefgNxI5AFjvcG+Wsjw0OTpJCcHaYqdfwaF2ESobiQ8ota6dD1AtB6I
         SNnPYP8Sm+5bSrOCYHp7fn9KxrrCnEbnS5eBu7FpDwRbvjBkXu/MLo1cWQ2iaxEfKl
         wu4c8q+E9HfiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13862609F7;
        Sat,  6 Feb 2021 18:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dpaa2-eth: Simplify the calculation of variables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161263680707.6816.15998203411073238204.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 18:40:07 +0000
References: <1612260157-128026-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1612260157-128026-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com,
        davem@davemloft.net, linux@armlinux.org.uk, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 18:02:37 +0800 you wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:1651:36-38: WARNING
> !A || A && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - dpaa2-eth: Simplify the calculation of variables
    https://git.kernel.org/netdev/net-next/c/b91b3a211542

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


