Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1BA4742C9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhLNMkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhLNMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CF45614D4
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D13D9C34611;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485611;
        bh=6Sn7rWImhA4DfHzFyMdmPEzOrb+OPr15CPUiY34J2Ys=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BjMgxn4MLijxEfGRqjncQ7kgB6r9iTsYtOZgH9E4Jv2DHCFZETtC3Gyt2i3fpok5W
         uZF4O2uM0sCxwesn/GhHXvx5Yt1GEjIAgLyEL11edm7zSgrys1oukOob61nnGThWdV
         VFNe/0dNpOtFoj95wPC6exJalv71nut+oqCDf01Un9PT/jNDPdPrUTT6/ZeYZa4m59
         vvE1VdR9VWNiGxItis8kWWSfEg6rfpw1j+YLouMFUcJCWq3QSJgTUpQijUqpOySbLQ
         ++ybOMX4GI5TE7tUexIVwCuXjqw0SzwAyNKSqzUO91nGzXtGf2uVUj73rjJXQuMp0U
         Ivpl+y0FotlVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BAF5D60984;
        Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dev: Change the order of the arguments for the
 contended condition.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561176.12013.5715209247504998823.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:11 +0000
References: <Ybd06waO3S5y1Q6h@linutronix.de>
In-Reply-To: <Ybd06waO3S5y1Q6h@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 17:29:31 +0100 you wrote:
> Change the order of arguments and make qdisc_is_running() appear first.
> This is more readable for the general case.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dev: Change the order of the arguments for the contended condition.
    https://git.kernel.org/netdev/net-next/c/a9aa5e3320ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


