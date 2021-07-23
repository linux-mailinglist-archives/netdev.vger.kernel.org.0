Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04BEB3D3CC6
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhGWPJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235685AbhGWPJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A71FF60EBD;
        Fri, 23 Jul 2021 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627055404;
        bh=zvqiw9CiCLzPmpE09P8feDufFP4PpqrMKZXpjQ31WKY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oKaaBOZMfECG/+u1Yxntgpowyro/pquqeP3TrQKil9krx2TMZYRlUHA/yuBFPlnNX
         IYloJsgC4d0ouGj3HnHxwQ5LORxDY6rGPqoaNIEv+hA23Gsr2QM7s4NGnwpABf6tXX
         yZY48WEoGTcuHSUZcW/8VJCqtzTgA3tk57smXRPKhH/YrI67yIEAN9p4IX62BhsDIy
         Htu1a90QHufXaP5fjH/B/bhnVkkxeqhTg6aQ2FYOYFI1um2MTuuXG6bGAkX2Swzh//
         aRwWqgXNN6O0M1F2cdMUJRLkHpZ0NSmFMiO7xiPp3QUy9qq8QJy0BVjYxdv+bbJUSj
         trPpEEI++KGIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D6D960976;
        Fri, 23 Jul 2021 15:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: decrease hop limit counter in ip6_forward()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705540464.23511.7182688750554050826.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:50:04 +0000
References: <20210722174443.416867-1-l4stpr0gr4m@gmail.com>
In-Reply-To: <20210722174443.416867-1-l4stpr0gr4m@gmail.com>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 02:44:43 +0900 you wrote:
> Decrease hop limit counter when deliver skb to ndp proxy.
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
>  net/ipv6/ip6_output.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Here is the summary with links:
  - ipv6: decrease hop limit counter in ip6_forward()
    https://git.kernel.org/netdev/net/c/46c7655f0b56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


