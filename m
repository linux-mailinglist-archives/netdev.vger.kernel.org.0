Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B363CF772
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhGTJ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235975AbhGTJ3Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 05:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 661026113B;
        Tue, 20 Jul 2021 10:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626775804;
        bh=yABBTN23ANDNk3tFqDrNGvC0AT3X8Fv6CxCj6E6cE6s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X1GhBEt49QICC6Ss7InUO8U8xjwloC3eEWcZcuPJMoIVuMhhKBBn0Cy7Xyw8mUxdD
         YVJHHof7yyeQ0cz5bvY9Yx6797mlN/IhemCZRkT6lQWCvUYiGVI5WmTFKE2/vbCHGD
         NWYnRIwpukYcVKvDXpzSN/KCvyQZq4/2yi8c5NLXRdvPcQwmPMUypUsh8rxE1BxvqW
         kFIUOGbyeax6CFc0yp3BcSKJIEwsiX+MXclEzXQMojhCa4Xp7QMrbAjA441JibLvrd
         bLlEOZQSf+ZZFF1mFrK4XnS3x/93/Fm7o+4p3YtvGT0PW9e3I4JXp+I+DWKl1XMKKX
         X0FHltkYJ+laQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5971860C2A;
        Tue, 20 Jul 2021 10:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH NET] ipv6: ip6_finish_output2: set sk into newly allocated
 nskb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162677580436.19024.594625629183939751.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 10:10:04 +0000
References: <70c0744f-89ae-1869-7e3e-4fa292158f4b@virtuozzo.com>
In-Reply-To: <70c0744f-89ae-1869-7e3e-4fa292158f4b@virtuozzo.com>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org, kuba@kernel.org,
        eric.dumazet@gmail.com, yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 10:55:14 +0300 you wrote:
> skb_set_owner_w() should set sk not to old skb but to new nskb.
> 
> Fixes: 5796015fa968("ipv6: allocate enough headroom in ip6_finish_output2()")
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  net/ipv6/ip6_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [NET] ipv6: ip6_finish_output2: set sk into newly allocated nskb
    https://git.kernel.org/netdev/net/c/2d85a1b31dde

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


