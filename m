Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF43F741F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbhHYLK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 07:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhHYLKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 07:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98AB061100;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629889806;
        bh=1Fl9ZThVgv4XTvGOq52ZXyxu1hmzFmF/5tM+IpXt5Nw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUs2PeY4arkN2i7Z6U0h0XWHGevmEfnnebacXvodo4FRf6CAsgsq0AlZWNzgoIJUp
         9mwPajbj1ybJXaVCer5E64w2G4LAl+BUsdwR6NAJpBli1gPNlQBkXJudEl2qN6f/yr
         sRjEDgBVn9pmUuwurK5QdtMl27gm6jw7Ej+jg4h/gHDFAfF4V7l07E8E3ZzqwhhDtP
         U+I1UwrlF139GpZZ5BJqneTpv8ZOe02umNtiQ2CnW0UlkFjjPtXYD6kic8UEzLkLzE
         3otPuRx5mGsApKw7AsSfAEnXM+wpPbwmExjSoG+8oKhv8QxVWpqKjGVCCHSRtBAAFP
         0Q1ddWFdB4UVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C2F260A0C;
        Wed, 25 Aug 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-af: Wait for TX link idle for credits change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988980656.32654.4918844852549392787.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 11:10:06 +0000
References: <20210825054621.3863-1-gakula@marvell.com>
In-Reply-To: <20210825054621.3863-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, ndabilpuram@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 11:16:21 +0530 you wrote:
> From: Nithin Dabilpuram <ndabilpuram@marvell.com>
> 
> NIX_AF_TX_LINKX_NORM_CREDIT holds running counter of
> tx credits available per link. But, tx credits should be
> configured based on MTU config. So MTU change needs tx
> credit count update.
> 
> [...]

Here is the summary with links:
  - octeontx2-af: Wait for TX link idle for credits change
    https://git.kernel.org/netdev/net-next/c/1c74b89171c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


