Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C2D35487C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242700AbhDEWKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241364AbhDEWKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20519613D3;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=1lJ056GCjbxnzNynKykDUUZsliAT/dX3iv2FakI4cRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aLaXp8Kw9p8KOwOIqF+9CpDF5zLfUXY6ZZzUpC+gPU8RxJq8Fv41zE01ZF8eWDL/6
         yqQ54QDh2nzkaEMkgC1za+nCuRK1QdzUk56ZauIKFsuIRPN6RrISHWGn3Jmr1dFEGs
         7K44RQwgnxtKHILkvM1lld2trVzKLQHoAlQwxgLsxU77ZL6t3fbP66v4y+QBlPzn8V
         J+5Q5mlzqxbkZQv0Occ/D8YUSlQvnREaAVdehmDSUG/mBOyVKmlSUkwPdIrunEThMb
         w3d2Elbc+zOJjoDXMpV02SCGVXosFGAvwtb3C9kskI+NDs/+9rjFNNJaepKHMjWucW
         K7SdrVCK/AMIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F0A960A38;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-ipv6: bugfix - raw & sctp - switch to
 ipv6_can_nonlocal_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060905.24414.9464010875754844065.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:09 +0000
References: <20210405070652.2447152-1-zenczykowski@gmail.com>
In-Reply-To: <20210405070652.2447152-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Apr 2021 00:06:52 -0700 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Found by virtue of ipv6 raw sockets not honouring the per-socket
> IP{,V6}_FREEBIND setting.
> 
> Based on hits found via:
>   git grep '[.]ip_nonlocal_bind'
> We fix both raw ipv6 sockets to honour IP{,V6}_FREEBIND and IP{,V6}_TRANSPARENT,
> and we fix sctp sockets to honour IP{,V6}_TRANSPARENT (they already honoured
> FREEBIND), and not just the ipv6 'ip_nonlocal_bind' sysctl.
> 
> [...]

Here is the summary with links:
  - net-ipv6: bugfix - raw & sctp - switch to ipv6_can_nonlocal_bind()
    https://git.kernel.org/netdev/net/c/630e4576f83a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


