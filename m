Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D98F3A3520
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFJUwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhFJUwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0B746141E;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358206;
        bh=iOCvqbcdbTetx9TgmK7AN5r3j2XsveiWSJWgx5aX3yU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgwvDB3T5dehWbPb9W9niasZneMA94gFudxrDugQtWGm4xopyNgQ4xLo/Y9/bDIpc
         lr8oZSzdPUn3yg5aKG8M+f6bTqadExpqaNbw5pCcMy38aQGzdpQ3dqL9Oi94v2qBa2
         zI/F7tHS6yfUGlsci4yij5CrpuVWtz2kz1S/6MRy/LNDchSuHu7hw5GKbFGXH8zi/x
         280pS9V6ixarHoq/KHcoo6nSsgi9ZDu2zSGMeA5c3WJ0/VDa2ZYYMh37jxZSH7k1d3
         R37M2AS+tWLsO+Do21+33gfBj9O+sCIqdlPgh4GVmOZxHb2JaMgm8MbloSLTZDAs5h
         MmvXWQZDvKtiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8BE360952;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] node.c: fix the use of indefinite article
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820681.975.17808761996434583505.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:06 +0000
References: <20210610055046.37722-1-13145886936@163.com>
In-Reply-To: <20210610055046.37722-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 22:50:46 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix the use of indefinite article.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/tipc/node.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - node.c: fix the use of indefinite article
    https://git.kernel.org/netdev/net-next/c/15139bcbb610

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


