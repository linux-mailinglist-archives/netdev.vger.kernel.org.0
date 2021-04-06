Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DF8355F74
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344534AbhDFXaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244125AbhDFXaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 69D78613D4;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617751810;
        bh=P+vTaS+ZfQZZCxOlvG9FvZYU92LZmLA619RZyw2ZFAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y/txJCTOv5+esVXbqkQ1m8vRlUAUbb4anKi36GhEoJhFE6lJAh68rIJAd392yR9df
         qMXh4qIr2LrotoNRBMqfytV8+smokVC3afw+h6FiNX8GzWwUbmNsa5JNuQw9TtNUs3
         ib/THgUD5/LDGxACFZdV0U+btpEcw5n29pCjxF+OMijwoRdpVnGWADDtJc9vI9z9RG
         E58qCOeedl7UKMujAUc1BNggGLP0HcXSrw+PoIorpykKSyHIItQHRnTsJHEKZePU0H
         xwJIH7D5mb1rQkqxrutwfqtlyzgnWjZY0UT5Ag7QZG/ZRsDTe6xHx996M3PXVp9dFs
         8jgeGtWy9+wkg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6193C60978;
        Tue,  6 Apr 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775181039.15996.1066445461229083940.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 23:30:10 +0000
References: <20210406031813.7103-1-linqiheng@huawei.com>
In-Reply-To: <20210406031813.7103-1-linqiheng@huawei.com>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 6 Apr 2021 11:18:13 +0800 you wrote:
> Eliminate the following coccicheck warning:
>  drivers/net/netdevsim/fib.c:569:2-3: Unneeded semicolon
> 
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> ---
>  drivers/net/netdevsim/fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] netdevsim: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/be107538c529

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


