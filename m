Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914CE33E1B2
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhCPWuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231664AbhCPWuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C815464F41;
        Tue, 16 Mar 2021 22:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615935008;
        bh=xIH2gb/CofT4JE6aVd1zdg0czU7V4ufYezWAVdq4PTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XR4Dpqbhung/mG8SuTO+rIzqfx6LRQQPV9h7lRV1hENI+Bvay+CwIWHvRnJI0wDK5
         Bmeaa58TuDOG1RWiVt1mkq1h2eZHJowKIrmAzGTmmZmo46W9XeOo24bGo4CmjkXOMG
         9bGcxT/G9wxbJfTnKsdCwiygGF3YxBf9hoBhLWz4OjR8QnL2gZsS4PbUyOwUtAjQT0
         vrit07yhdwivJOifLLPiGHdgFBk7tepgsCxZNzKTuTSewZjBFsbRapKGOsQwnfqz+w
         uTtfMSqAdVVTXK1FtN5llxfEO/JtGbYHVzslnOOnN3C69pCbDmV+y6U9RAAi2W3X1Q
         b3oyzH6nb/XxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B95B360A60;
        Tue, 16 Mar 2021 22:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Update Spidernet network driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593500875.15002.17476700812563690539.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:50:08 +0000
References: <6399e3a4-c8b0-e015-c766-07cbb87780ab@infradead.org>
In-Reply-To: <6399e3a4-c8b0-e015-c766-07cbb87780ab@infradead.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     davem@davemloft.net, kuba@kernel.org, kou.ishizaki@toshiba.co.jp,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 10:13:52 -0700 you wrote:
> Change the Spidernet network driver from supported to
> maintained, add the linuxppc-dev ML, and add myself as
> a 'maintainer'.
> 
> Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: Update Spidernet network driver
    https://git.kernel.org/netdev/net/c/fc649670ba50

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


