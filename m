Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006363A204F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhFIWmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhFIWmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53469613FE;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623278425;
        bh=mKnfoPfoNQ50Hbg5UNhOlgJddrhjTD+bnzKHnkbmodM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cPY20DzBpWKxWVZ4p767SyvM7AyuMGcC9RYqkV/D2lUCc9kITSCEsXAMXhe79QQRs
         CzfblPSIUB3raeZlhcmD79+feRUuiHJ/ptevID7m6CtEry6ItRYgdOkwJl6LOe9a+N
         i2dW4SJ5Zyq305Cl9ZSiy3Ek163C4/InwsofUZaqNpxjjFvCgAks4hfbIYPaIgHF6F
         uA8f8PexjMvVIzubhbE8GZGAoFlddoJNcn7NW0hxQ572EbY4+9/L8J0qJIb59m7EfJ
         MSpMZCFBLLhfeuCC/bA6kx6J8lRF27FExv4vYm0JYBiZp33XLQHGXKPaIhAF+5KcXH
         NkSZ4P8HopNKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48C9060CD8;
        Wed,  9 Jun 2021 22:40:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ena: make symbol 'ena_alloc_map_page' static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327842529.25473.13013541269021930169.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:40:25 +0000
References: <20210609142506.1621773-1-weiyongjun1@huawei.com>
In-Reply-To: <20210609142506.1621773-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     netanel@amazon.com, akiyano@amazon.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        shayagr@amazon.com, sameehj@amazon.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 14:25:06 +0000 you wrote:
> The sparse tool complains as follows:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:978:13: warning:
>  symbol 'ena_alloc_map_page' was not declared. Should it be static?
> 
> This symbol is not used outside of ena_netdev.c, so marks it static.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ena: make symbol 'ena_alloc_map_page' static
    https://git.kernel.org/netdev/net-next/c/6fb566c9278a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


