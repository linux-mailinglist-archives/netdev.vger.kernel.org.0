Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847BB457B29
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbhKTEdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236782AbhKTEdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:33:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AF11C601FA;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637382609;
        bh=GIAi+gb+A/l266T6P+tpWrsu2yOHEM+hZlkVWTP/GU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BLScqyDF4x/bHHgVW1EvwLllvQBSyDF+UuW3h9Vy/LEh4VxBpI9vC08h8E9zI/s+o
         ahLt/PWA45/WKwZSk6PAx9wGLd1ELZDDQ2USOuTEi+qVwjNHXSmb3gr6ZD5Kd5v4fj
         /kZsNavQDcLETrSkafYvCvSabKP+yyf/s9AFSwbikrL+0n+Pl8P/J/lzn/ok4LVCPX
         xmXltI0BuYjuMmvzf9znodarSOFS9AuRTr4Q7xMtWindp+3jGYdE/Vwcgm3jq5kqqK
         G614UiNBawmXANJdnspdoZsYHqclVkizCyNyteK+SUBTxHvyDBZiFTj2iREPDbbOXp
         GFVezqeIurzwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A252D609D9;
        Sat, 20 Nov 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] ethernet: renesas: Use div64_ul instead of do_div
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163738260965.5569.10666285186155196148.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 04:30:09 +0000
References: <1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1637228883-100100-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, s.shtylyov@omp.ru,
        geert@linux-m68k.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Nov 2021 17:48:03 +0800 you wrote:
> do_div() does a 64-by-32 division. Here the divisor is an
> unsigned long which on some platforms is 64 bit wide. So use
> div64_ul instead of do_div to avoid a possible truncation.
> 
> Eliminate the following coccicheck warning:
> ./drivers/net/ethernet/renesas/ravb_main.c:2492:1-7: WARNING:
> do_div() does a 64-by-32 division, please consider using div64_ul
> instead.
> 
> [...]

Here is the summary with links:
  - [-next,v2] ethernet: renesas: Use div64_ul instead of do_div
    https://git.kernel.org/netdev/net-next/c/d9f31aeaa1e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


