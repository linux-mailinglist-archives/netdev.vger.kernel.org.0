Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC564194D9
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhI0NLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 09:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhI0NLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 09:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 134276103B;
        Mon, 27 Sep 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632748207;
        bh=oPJELZZlIkktUvT3mKf6uyN+sQK9W7flk5QCU8eLGk8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=diHMh6d9hVs2lSbgeHAWUtqQ4UJIhRgPw5Aug/I+uSlauhQ8gDrCJRszwm3l00hYg
         tgpiZheT0ZeL+b5VZDlJvEegou/X0p5WE5dPH3OQ1u+VVWEgxWMavt9YKroBL7l5O4
         KxEAKKB9d8uDTvmQQahnqqIfernX1vjIHfsazlRpj9ie/sBziOcUDkZNIq+LC0qHkC
         ItENoEIET4Ho5zQaDrv65pZ0rnMokGHEtNyqfM0S4BZEYWbk2EbHWynhCpEcdHBA2y
         wGlYOzLKtfkeSywCvLuoWfvLsniiWgm67WLgUlD8yuhoD3qRQA6hHtIQvX2DGA8pMG
         GBUjKsFlCbmHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02E3B60A59;
        Mon, 27 Sep 2021 13:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb: avoid open-coded offsetof()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274820700.19532.2923722207844060183.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 13:10:07 +0000
References: <20210927121611.940046-1-arnd@kernel.org>
In-Reply-To: <20210927121611.940046-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 14:16:04 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang-14 does not like the custom offsetof() macro in vsc7326:
> 
> drivers/net/ethernet/chelsio/cxgb/vsc7326.c:597:3: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
>                 HW_STAT(RxUnicast, RxUnicastFramesOK),
>                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/chelsio/cxgb/vsc7326.c:594:56: note: expanded from macro 'HW_STAT'
>         { reg, (&((struct cmac_statistics *)NULL)->stat_name) - (u64 *)NULL }
> 
> [...]

Here is the summary with links:
  - cxgb: avoid open-coded offsetof()
    https://git.kernel.org/netdev/net-next/c/ef5d6356e2ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


