Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C5C31E2B6
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhBQWpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233025AbhBQWky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 17:40:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6648360241;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613601607;
        bh=sWubiTSTGUbhgj9QmN8/B6LZjzkciGgIHXvXLX+YjE8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M0Ypie6tZzTkR/mIF5ZMaOk/i3SJC2GLNbnMZ0WN8M2e8N9k4q4vVwC16mS5KGHmL
         eNBoZ8ozVXviPLPR7LpNT3zYN0bvAj+TiOs6RHGi7Km/pBBh1ulPbekZ6RzN9rbcQb
         +sg7LBrzS23SA8EjLkPJYniIxDcsEUYX2fTsQgxg5nt658nQs5L1eJ5c5oIOu2H/es
         P1NGJ7QiRYIJHyoFvD/Vgyh3n9UadQ+8NoXSI/ol9XhLAFRLiLp6OfntmYu8RzSnxM
         3j2uPV/mDetJ1BVrE5c3OyDZyhgXzEmndwmsrL6XrgjzYiNCD/4gGDnNL+lLWANXql
         1aEwcyrZkwQEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 557D560A21;
        Wed, 17 Feb 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-pf: Fix otx2_get_fecparam()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161360160734.1867.9120165404237124929.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 22:40:07 +0000
References: <YCzIsxW3B70g7lea@mwanda>
In-Reply-To: <YCzIsxW3B70g7lea@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, hkelam@marvell.com, gustavoars@kernel.org,
        cjacob@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 10:41:39 +0300 you wrote:
> Static checkers complained about an off by one read overflow in
> otx2_get_fecparam() and we applied two conflicting fixes for it.
> 
> Correct: b0aae0bde26f ("octeontx2: Fix condition.")
>   Wrong: 93efb0c65683 ("octeontx2-pf: Fix out-of-bounds read in otx2_get_fecparam()")
> 
> Revert the incorrect fix.
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: Fix otx2_get_fecparam()
    https://git.kernel.org/netdev/net-next/c/38b5133ad607

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


