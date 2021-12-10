Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8B4706BC
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbhLJRNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:13:51 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39034 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJRNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:13:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65FCECE2C19
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 17:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 860F1C341C5;
        Fri, 10 Dec 2021 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639156209;
        bh=fx49EgaFeDSn48YbutipnTxiLknMSPGLRS2EXltKBf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F6psbvzVvjV0k7Juwo57u5baPjnXNX8gJ2rLrNKn1UJo2T4FhrtKerjplhKBiQSr4
         w5FEBFbRqophY9kywPk6lqScdGQSHIFU+PCWZwVCDK1Rx4W1jxZziU5pQFve++q7Gb
         nT7CoeExBiNFYDgUtO1uKgb126Y4yIRoeJdd0j1EY0922ox5HGXIiq1/hYuUT6KzLc
         hWVS7b9bE/OVRMET8lTi3EjA7izAcbylCo7nNqiawKHpxtze4tHl97hsyVltah95cl
         gfdFHRICPbi5tTWCwIFnp2rNXhCYosKpHCRvuHBIbcEZhKFd4D3cXYO6y6mMIkwO14
         tp/A1itXtOyCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E55960A4F;
        Fri, 10 Dec 2021 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xfrm: add net device refcount tracker to struct
 xfrm_state_offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163915620938.16075.2181512766216340106.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Dec 2021 17:10:09 +0000
References: <20211209154451.4184050-1-eric.dumazet@gmail.com>
In-Reply-To: <20211209154451.4184050-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, steffen.klassert@secunet.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 07:44:51 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/net/xfrm.h     | 3 ++-
>  net/xfrm/xfrm_device.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] xfrm: add net device refcount tracker to struct xfrm_state_offload
    https://git.kernel.org/netdev/net-next/c/e1b539bd73a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


