Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DCC45B30E
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhKXEXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232004AbhKXEXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B72D60FD9;
        Wed, 24 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637727609;
        bh=u0y6rb8426CSFuBKCFKA+iDsvdD9sinWWJume8DbMVo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mXB76L9vU3cYz4I/HkK/PUr16Z9OA0PgdpW8NKFrg6PiBREJFGySE3Dgg3D1oaCfH
         +J9LQ1+y6R71wIB/yNJjfrFvERHiFWXzu8FX5uSko10ZkYZfRL43tv65DLIRybS+ou
         n5twgWuiujXo8OSdF2o5xmW6p7en+tx209p5mSuEd7YJlWWVdGtKnVbWvA1qF1nZON
         W3xPgYKabir8fOyBny1PZQxnoLmhK9cV9t2Oubu/wnVZmJyaQGcOWGF2pUpXl1AEIN
         HFv9EDQAb94z6bzv//mpkHsOWjFgQZD1Nd6sAJZlYoJuM7iCTFv+LjT5XZ6ncJZLT6
         ordQU0hZgcmmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B63D60BC9;
        Wed, 24 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: add arp_ndisc_evict_nocarrier to Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163772760950.14808.1734972164408990351.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 04:20:09 +0000
References: <20211122171806.3529401-1-prestwoj@gmail.com>
In-Reply-To: <20211122171806.3529401-1-prestwoj@gmail.com>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Nov 2021 09:18:06 -0800 you wrote:
> This was previously added in selftests but never added
> to the Makefile
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  tools/testing/selftests/net/Makefile | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - selftests: add arp_ndisc_evict_nocarrier to Makefile
    https://git.kernel.org/netdev/net/c/619ca0d0108a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


