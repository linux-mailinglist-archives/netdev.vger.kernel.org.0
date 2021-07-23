Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224683D3D72
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhGWPjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhGWPjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:39:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F29360EB6;
        Fri, 23 Jul 2021 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627057205;
        bh=kqS2kByvwynWZWKFwSZmaJR1oj2dffPL6WtIB/tyOyw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W/6JYuTsDAYkJIR3edDeImX/gm0u5eYKo1SwbSIfhMIT28n/XIatQvuNUsB3vHqok
         JHgAbkzO7e9OUT3a5630Ku7ciUnbYhmj/jQn6+DpBrIvK4BpHZ+J1fwLXpGX1JXb8l
         QUE9iygmG/TmfcgZKx8ZyBOTqQBGTeCbKmmhVMhIcQYk8cFDVSd+u3nMlhBU9JFJWI
         Nzz2xGcuzOsdx5JspJT27JSmOdUSV9ppk9ywub8pMhF2lCjrwcMaxniZq6mOBF0gdH
         ofk2LZL1L4b4Cw8VQp15m65kcaMM5ZsBHs39c2zF2WqYBIu4HjyF1RqL5IcgLvwBe9
         UvKmf/PJbO7IA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89E1460976;
        Fri, 23 Jul 2021 16:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mpls: defer ttl decrement in mpls_forward()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705720556.6547.10125703038792378091.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:20:05 +0000
References: <20210722185028.17555-1-l4stpr0gr4m@gmail.com>
In-Reply-To: <20210722185028.17555-1-l4stpr0gr4m@gmail.com>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, martin.varghese@nokia.com,
        jiapeng.chong@linux.alibaba.com, gustavoars@kernel.org,
        gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 03:50:28 +0900 you wrote:
> Defer ttl decrement to optimize in tx_err case. There is no need
> to decrease ttl in the case of goto tx_err.
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
>  net/mpls/af_mpls.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - mpls: defer ttl decrement in mpls_forward()
    https://git.kernel.org/netdev/net-next/c/6a6b83ca471c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


