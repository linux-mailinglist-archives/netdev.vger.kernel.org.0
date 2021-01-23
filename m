Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA53301888
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAWVax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbhAWVau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 69F6B22CB3;
        Sat, 23 Jan 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611437410;
        bh=mIwCz3e5wggyiLievM406wxYGfd92Z0fEGQcLOf1fcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KOW9R/FwmfT61FTbgYMupdV2OlqTJxt+ci5gFizTR1mutAABx+cWYDUEa0HYKZatL
         HU4Ovt3rzYQRSc2SeZpcQdBuPi9pf8MT08mSOQk1bt3wHJ9Br6CUJpwn2NgT0B6N5p
         LEFu/kqogxYHMyQ4Q9n3eKnDetvbk0mdj0hMmzGLzWozBvsSi9S05op1HNtN8HX9Os
         F8Zl2dRys9nfQwWLI3TjNbONnCVPrp6k6P/Pf9JL7u+hxpLbpm0518l8z6ehZBvy+r
         2JvNrbHd0I1SaOU/BbdlHAV/aFX32AzbJD95qWygHxkE84dOVpbstl+823H5Lx2qzn
         sLM+xPPtEVrdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B2F6652E6;
        Sat, 23 Jan 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] chtls: Fix potential resource leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143741036.6169.15421270286833058037.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:30:10 +0000
References: <20210121145738.51091-1-bianpan2016@163.com>
In-Reply-To: <20210121145738.51091-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 06:57:38 -0800 you wrote:
> The dst entry should be released if no neighbour is found. Goto label
> free_dst to fix the issue. Besides, the check of ndev against NULL is
> redundant.
> 
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - chtls: Fix potential resource leak
    https://git.kernel.org/netdev/net/c/b6011966ac6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


