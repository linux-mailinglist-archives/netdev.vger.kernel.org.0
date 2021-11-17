Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BEC454B2E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhKQQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhKQQnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 11:43:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9736761B98;
        Wed, 17 Nov 2021 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637167209;
        bh=e8PFDOqel6oPMIOhEK5zQb+W+cnWUJehWMdjSM+NByc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=auASmfwZbggP6aJc1h6vxafrVNBqANtbEVFnOE/fNjspPyXHPRvvKc69VWYVKv/j5
         9B6V9a1MtoHbID2kHOIw4rjLfjtuzBLQ3ZNSYkA73FryAtgdbRBjo6Ikb3fP93sUpi
         STHSAhuSfQJjBaS8IU55R9k56IzcqvxiMXrz33TMuzbJFBlCQiReh1qSpLgTXuMmZ2
         ejOjLYGcraDzFhAfGFuE7NInKgMuvZuCrZ7sG/iDJhOK8tMsh3g255QmUS5FL8OmHc
         hzXQozPuE5gRuXedY9FL2HBOwQkkfrw7nlzMQTr28M4QSx7094N6EaEJkbM95Olv2z
         nAUXoI76eSEoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 847F560A0C;
        Wed, 17 Nov 2021 16:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: add missing include in include/net/gro.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716720953.30858.10436677081749649893.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 16:40:09 +0000
References: <20211117100130.2368319-1-eric.dumazet@gmail.com>
In-Reply-To: <20211117100130.2368319-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, sfr@canb.auug.org.au, rdunlap@infradead.org,
        geert@linux-m68k.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Nov 2021 02:01:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This is needed for some arches, as reported by Geert Uytterhoeven,
> Randy Dunlap and Stephen Rothwell
> 
> Fixes: 4721031c3559 ("net: move gro definitions to include/net/gro.h")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: add missing include in include/net/gro.h
    https://git.kernel.org/netdev/net-next/c/75082e7f4680

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


