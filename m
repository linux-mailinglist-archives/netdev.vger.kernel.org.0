Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E20A44753B
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhKGTWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhKGTWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:22:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 48F6961165;
        Sun,  7 Nov 2021 19:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636312807;
        bh=ZLfLyLAruXENMI1XjQp2lGrXJbUqRZ0DF6vj1H/nkQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7eE6QyXf2Dnthngcs85Op7fLPT0K0OgUp7gDbtAy8Vo/YJBEwhEkPTEyKPAQPnGB
         YRZExfcWgxCAj6EBqvl/oX/F22wXGiFUoK3fDZuDzGPX8mm6lgpq40sOewWM23NWtj
         HnFn2LLQYnmRCOoZ6ke1CXGZ9ovtXpHzL2XNhkA+2/p1otszCK6kNw9Lc5bEHbiZhQ
         xP/l/RT9mE8iykF27ecuvlbUuDmz7sZp9amLladXGtXLagSkY64FR3vAQxKZ7rG3Wk
         TWc5uPFql9lBv/ibICaVko0+WyfHlOPMhT9aHS2vbr8msZMGT9ZVk3f+xBuhqU/hMU
         W+gRQFvrzgmng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3CFDE60A6B;
        Sun,  7 Nov 2021 19:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: port100: lower verbosity of cancelled URB messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631280724.9669.10610221896311122848.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:20:07 +0000
References: <20211107141400.523651-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211107141400.523651-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  7 Nov 2021 15:14:00 +0100 you wrote:
> It is not an error to receive an URB with -ENOENT because it can come
> from regular user operations, e.g. pressing CTRL+C when running nfctool
> from neard.  Make it a debugging message, not an error.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/port100.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - nfc: port100: lower verbosity of cancelled URB messages
    https://git.kernel.org/netdev/net/c/08fcdfa6e3ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


