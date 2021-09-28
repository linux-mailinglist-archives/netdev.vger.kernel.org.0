Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC041AED4
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbhI1MVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240564AbhI1MVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:21:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0AB7F6127C;
        Tue, 28 Sep 2021 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632831608;
        bh=28Fz6ucy0pi/0ge6dmeHDLLKqHWw8QguuponhsjX4cM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KE0pICFTspnK27EWbee3UztlYBPvTPoCQpCb1RtJ41Sp+HREHG9avU+FxKjkDBOZM
         /E2CqFwb2T+2H72KIzWPUuqnUudPhk1TJcm1VYCuQyxKBIooY4lN0ghflcwTzo7CFR
         bq6se8RNypbGIYKX1LncqJXsFStQwGrXeKN3YFBt3Tof9wYSWioDtENd3rOM5/FcZj
         /IcyLONCHIvVbkyBKpZ7sJCvOhCo8XTANAgX9GCD5xF1J+1hagJiyUe1ghiL9wMPaZ
         GA85M0qaIq+exOKnujpkVBY43uhDJ99ANbU01Nb9CXdJ9S//wtJ1U+2skuXOdWyP44
         5mh3t0Eo8XOjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F22DB60A7E;
        Tue, 28 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] am65-cpsw: avoid null pointer arithmetic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163283160798.2416.16978084459031907599.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 12:20:07 +0000
References: <20210927093803.474510-1-arnd@kernel.org>
In-Reply-To: <20210927093803.474510-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 27 Sep 2021 11:37:57 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about arithmetic on NULL pointers:
> 
> drivers/net/ethernet/ti/am65-cpsw-ethtool.c:71:2: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
>         AM65_CPSW_REGDUMP_REC(AM65_CPSW_REGDUMP_MOD_NUSS, 0x0, 0x1c),
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/ti/am65-cpsw-ethtool.c:64:29: note: expanded from macro 'AM65_CPSW_REGDUMP_REC'
>         .hdr.len = (((u32 *)(end)) - ((u32 *)(start)) + 1) * sizeof(u32) * 2 + \
>                                    ^ ~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - am65-cpsw: avoid null pointer arithmetic
    https://git.kernel.org/netdev/net-next/c/861f40fa0edf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


