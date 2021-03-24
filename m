Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E96E34847A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhCXWUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhCXWUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 18:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FEC661A1F;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616624409;
        bh=pc+weiJ+nCBpCweEA+twPjrVd5Nk26jGIdg141sl3IM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KzjH8Yi9+BddH0+MUN2EVeSiDJaikZ1EwgT2dg4Ew4P0WS9/aJsX8gB1sRpKoiiDw
         GlXGT07Yulr+keh5cXQofqgKx7I9MaDj3wpSV4h7aH1DZRqjoTXjH+xJHD3V/bcJSF
         fMSPLQJ+w6g0Tsv84br7ZuQQs1vmfODunjV1dckySYdU4LpsZQqn/b/Uzw1uBQfque
         SfREWeSIxSUdDj5QlAwylXwAkGRvvjtQZD7ZACiuwxIp2H0oNT+2xwm1LEffrKLJ3y
         QehlLktMHw95XVwmGnd/8oWs2od9RBz2WiqAg8S7NXwa+boDqD3iL+hCAecEIHTJqS
         Dwa/rYlcON0mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3330460C27;
        Wed, 24 Mar 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rhashtable: avoid -Wrestrict warning on overlapping sprintf
 output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161662440920.20293.8537957789439812189.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 22:20:09 +0000
References: <20210323130338.2213241-1-arnd@kernel.org>
In-Reply-To: <20210323130338.2213241-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     tgraf@suug.ch, herbert@gondor.apana.org.au, arnd@arndb.de,
        colin.king@canonical.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 23 Mar 2021 14:03:32 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> sprintf() is declared with a restrict keyword to not allow input and
> output to point to the same buffer:
> 
> lib/test_rhashtable.c: In function 'print_ht':
> lib/test_rhashtable.c:504:4: error: 'sprintf' argument 3 overlaps destination object 'buff' [-Werror=restrict]
>   504 |    sprintf(buff, "%s\nbucket[%d] -> ", buff, i);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> lib/test_rhashtable.c:489:7: note: destination object referenced by 'restrict'-qualified argument 1 was declared here
>   489 |  char buff[512] = "";
>       |       ^~~~
> 
> [...]

Here is the summary with links:
  - rhashtable: avoid -Wrestrict warning on overlapping sprintf output
    https://git.kernel.org/netdev/net-next/c/4adec7f81df8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


