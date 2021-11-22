Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34D14590C1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239853AbhKVPDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239829AbhKVPDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CF92860F6B;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593209;
        bh=X+TP5xx7Y15WYAhEcSvBGmOZNrrXPznupKqHmh3DwV0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cDA4iGK+jX2Ip8UE11Njtl1jWWfVlyc7J/y4+VeCKf/N5g9HUUn8K0yfoDzXUvCm7
         wxNwHtcCGLqn4Je/Lm2xb+9rsRBPo+/DEw8y6qJU+KN0mVQ1d5qW4ELxYWz7NnepnV
         X6KStjMIREBmmZ0tJ3X/81NTIkNEYcLiYieqwC9/IdeN3oaVd61EvpAJnke1sbJDsb
         17Zfl9yVZYYwk/K65HhHpMUARNiiHkBH0nDIGkuPQqF84v+IhGDRlYoa0CdiV0nrNL
         JzL74rJC7q9hz6B5whE9WZcvXj5i/6EXOpEGq5Mv3kSzKxHzTkffXJ6Wak4tjsVAwr
         oAhoVH8NGo4mg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C5B8D609D9;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] sections: global data can be in .bss
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320980.11926.9911878483911251876.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:09 +0000
References: <20211122142456.181724-1-atenart@kernel.org>
In-Reply-To: <20211122142456.181724-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        jonathon.reinhart@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 15:24:56 +0100 you wrote:
> When checking an address is located in a global data section also check
> for the .bss section as global variables initialized to 0 can be in
> there (-fzero-initialized-in-bss).
> 
> This was found when looking at ensure_safe_net_sysctl which was failing
> to detect non-init sysctl pointing to a global data section when the
> data was in the .bss section.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] sections: global data can be in .bss
    https://git.kernel.org/netdev/net-next/c/cb902b332f95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


