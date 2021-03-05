Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595F432F52C
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCEVKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCEVKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:10:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 62BCB650B1;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614978609;
        bh=MhaNOUG9C8mNaglH6NiBaYfSD1D026SBkCEvk86ZE4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tO7X0rTMg0D2avoUDTt2mTUHPwJ9I9x1PGU/IRCBFsuO3M++XsR4PtXWLhuLpneWk
         I5usBcsihTB2NckvsKqcfXzgdLKI2RON1wr6MYSPbRXKHpMzZXlOM2+T3xEX42/wFi
         qpmQP4PeqNKyw6wGgC7khCit7CJChB8p5NwUSDwAxjDJMXSzefyhMZ3lSiQNevBSzu
         Eii6Vt6ZGs/KfDuRECTeCamOxOdFAWW0AbQ+Kycxn4rDgSrf6ueeUjhi54M+DKaCIZ
         SLNp7U3Zkzh1MVyU5VF9STWFLadmMj+3kCFlM3a39v4LMu591xtpZWMAPZEZtwqsyO
         cYolyPDr50iIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 55C6A60A22;
        Fri,  5 Mar 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/hamradio/6pack: remove redundant check in sp_encaps()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497860934.24588.18272207864656241633.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:10:09 +0000
References: <20210305162622.67993-1-efremov@linux.com>
In-Reply-To: <20210305162622.67993-1-efremov@linux.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 19:26:22 +0300 you wrote:
> "len > sp->mtu" checked twice in a row in sp_encaps().
> Remove the second check.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/hamradio/6pack.c | 5 -----
>  1 file changed, 5 deletions(-)

Here is the summary with links:
  - net/hamradio/6pack: remove redundant check in sp_encaps()
    https://git.kernel.org/netdev/net/c/85554bcd123e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


