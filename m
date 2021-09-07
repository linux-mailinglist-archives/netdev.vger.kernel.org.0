Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B616402970
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344715AbhIGNLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344647AbhIGNLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 91A78610C9;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631020206;
        bh=JyvSDYPox4Mi3dALWWcTY57F7utP4yVcm7sd1cJavZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xo5/uSDaM+ha4HNP+8+WVdjQUMGu45A1R/edGqpxAmusfxdwI+lgHzSpwhMZENO9t
         OUut9fHqGswKGwJJU3XwNSiLwgq+yyWIOf/hZaClcElc/fz8h9LzTfqwDBwxOLSumy
         DdKhQHseESisopax/Lgcb0l7Pm7V2CiJAIH49vXrs/eZTS7FmXuzYMwhwHbLkxcVj6
         FoE6dcxHnuY/g+4iYeKusj8Qh6Tr+tE5OrMAR2FLgZw6bKLmLUtCaf/HZ63TJ3AUrX
         heLo68bqLCxoURKcj5pJQGLjt79oVlvZ9fazJ5QDi/iL02bOn26n0R+nrD+lRnxG6b
         2TvMBd8xDZDLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 853FD60A49;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: renesas: sh_eth: Fix freeing wrong tx descriptor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163102020654.3494.4198631893442233493.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 13:10:06 +0000
References: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20210907112940.967985-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 20:29:40 +0900 you wrote:
> The cur_tx counter must be incremented after TACT bit of
> txdesc->status was set. However, a CPU is possible to reorder
> instructions and/or memory accesses between cur_tx and
> txdesc->status. And then, if TX interrupt happened at such a
> timing, the sh_eth_tx_free() may free the descriptor wrongly.
> So, add wmb() before cur_tx++.
> Otherwise NETDEV WATCHDOG timeout is possible to happen.
> 
> [...]

Here is the summary with links:
  - net: renesas: sh_eth: Fix freeing wrong tx descriptor
    https://git.kernel.org/netdev/net/c/0341d5e3d1ee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


