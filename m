Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABD3EBDFF
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhHMVke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhHMVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 29B256109E;
        Fri, 13 Aug 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628890806;
        bh=HSPVKgnclFyLgZkIOXt7/FuCg1iZw+X2xBGR+mB0kN0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uewyeRtFTsDxRgT+nQBbUrNhdbfrH1b3EKGgDgq8hYko/9oWxWCC8YLuj5ptHFhQS
         rQk/pBgXh9Wlq649jY6+Q5TPb/iWyhH9gvZJUEXn/KKFXcqhsG+x6ll08VNcIAohNd
         QaV0xQAKT2u3lGnTmrZ2TdSGX3QCHB1RCo5S2nObeBJCZPw3bhSqM46rj8vPmPxhyi
         2a5X/VmX2Agj2T3oJMAYnhXbXwsSWMpyKSP15jd41BzYKFYgPzzc+Td1ZWRQGWUPGf
         HHOAoiPEHp6pMh5q/FRplK4iRcCOCrpJ34mk7AXEja3zWWY7/ZopfQ9R//ghxTwRHi
         JANlQNbxJVMvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19C7B60A69;
        Fri, 13 Aug 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: in_irq() cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162889080610.27108.16076576161064219009.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Aug 2021 21:40:06 +0000
References: <20210813145749.86512-1-changbin.du@gmail.com>
In-Reply-To: <20210813145749.86512-1-changbin.du@gmail.com>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        krzysztof.kozlowski@canonical.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 22:57:49 +0800 you wrote:
> Replace the obsolete and ambiguos macro in_irq() with new
> macro in_hardirq().
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> ---
>  include/linux/netdevice.h | 2 +-
>  net/core/bpf_sk_storage.c | 4 ++--
>  net/core/dev.c            | 2 +-
>  net/core/skbuff.c         | 6 +++---
>  net/nfc/rawsock.c         | 2 +-
>  5 files changed, 8 insertions(+), 8 deletions(-)

Here is the summary with links:
  - net: in_irq() cleanup
    https://git.kernel.org/netdev/net-next/c/afa79d08c6c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


