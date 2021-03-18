Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7BF340FD4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 22:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbhCRVap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 17:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhCRVaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 17:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 09E0D64EB6;
        Thu, 18 Mar 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616103010;
        bh=njIxVbMP2TpTidEcVGE5rBGrmzNdINWBbtvz4f0g1ng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g6I43FoETF+MB+kPHxHCwCYSvq/G7LTyRtol75wG5QaeKWl3arXJhD24o1CjqhUQm
         MNq1eU0yIyMNlfwqTkLC4R1nQmvGJr8kw2fzQQdLRG2YB6y1TTjQGdbuYfD7QySHEt
         aKSF9PyckCyKN6AJ+KI2xceg1REzlKllFeea6BYDz1g05j4P6mrjFwdEaviSyCwpjn
         ZAz2UktEnta2yzz3hgfgJlUi4vOyyKC2Zv9piQStddIdxHibEbhXIlT8FMEAQIdp1J
         pqPXbot+XRoydmc5CQcEtc741N24cvWgY/CPANz98OwIPPwH50u8xto0xVGCok8ZmG
         RU0n23r7b6Gtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED34960951;
        Thu, 18 Mar 2021 21:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: Remove reference to CONFIG_MV64X60
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161610300996.15925.6620318542461392361.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 21:30:09 +0000
References: <7fc233cfbda60b87894c3f4a3b0d1e63fdb24b37.1616085654.git.christophe.leroy@csgroup.eu>
In-Reply-To: <7fc233cfbda60b87894c3f4a3b0d1e63fdb24b37.1616085654.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     davem@davemloft.net, kuba@kernel.org,
        sebastian.hesselbarth@gmail.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 18 Mar 2021 17:25:08 +0000 (UTC) you wrote:
> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
> removed last selector of CONFIG_MV64X60.
> 
> As it is not a user selectable config item, all references to it
> are stale. Remove them.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> [...]

Here is the summary with links:
  - net: marvell: Remove reference to CONFIG_MV64X60
    https://git.kernel.org/netdev/net/c/600cc3c9c62d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


