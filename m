Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9244D6A9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhKKMc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhKKMc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 07:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 27D6A61177;
        Thu, 11 Nov 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636633807;
        bh=n2VwqmbJrYxRh2AQClIPiS8bYHX4uH7SspzoT9IgABU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VfLBxzOgIG/EZGUZOCgnI9PaYSTVohRLPd3OmqSJhM9RM73/iCoRWTs1ON1STzu+a
         otKeYCjIoPKvthdo3zOFcBkSeUQy4xtGOPPcIAT4GgtQfsQXMZly6isRior08MlEOh
         A2NZLp97JGE0BhKRo/EbyRnXK3b4s/CCEdJhedHVe+grg9KqY3zFFx/NQJ3iANqRQp
         2iLfz6Q8F2KD5yy48mtVsc4le3yILY+BPRlcQQ65mEIIOXeAvtMAliVNz2mqvP93O3
         dmkTYFl3TdSK7rNoO1WStZprh8fRXUbk3JexHFIm7pzipiHVOx9N8I43Ot8ETZwkWw
         iGDmzVwLQckeg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 14A6260965;
        Thu, 11 Nov 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/net: udpgso_bench_rx: fix port argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163663380707.8916.12501076663361563113.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Nov 2021 12:30:07 +0000
References: <20211111115717.1925230-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211111115717.1925230-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 06:57:17 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The below commit added optional support for passing a bind address.
> It configures the sockaddr bind arguments before parsing options and
> reconfigures on options -b and -4.
> 
> This broke support for passing port (-p) on its own.
> 
> [...]

Here is the summary with links:
  - [net] selftests/net: udpgso_bench_rx: fix port argument
    https://git.kernel.org/netdev/net/c/d336509cb9d0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


