Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C68447628
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhKGWCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235210AbhKGWCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 17:02:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B1E761165;
        Sun,  7 Nov 2021 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636322407;
        bh=941HGfFQOQJ4fRvMa7Kb8ACJvmAK41E0GU4IMZsgbNc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X2j+Zy9QkidqJWHiMCBUIzYqoT2X+X/WYcYf04JYcLB4q/PP6KlzK92DsDNJZW70o
         4bq+2tSj2s0P8BPNiurx9h5mpGqwGwYF2JSvXLHgrsEY9tAmCTKLL7P5y5pgX1zQXQ
         /c/oTH3ijk4HK9Dk8otWadftA4phkTcUWh+bG+Y8WecMBUONZ6LEkVHCGAuK7cQAVu
         UN9Oq0WlR0Uv+EyAqSQ3LbiXy8TVgegpSizE/nEtFBxk5VLfQmRs9yaoz7uyXJn25a
         P9RKCP39v4erV8R3/Q5/IJxADUrE/cC3Zs38KE30323CdAUkGB4s4vUr30dd8AgeXn
         EwxLXx8HAsmuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DD6260966;
        Sun,  7 Nov 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] litex_liteeth: Fix a double free in the remove function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163632240711.15866.10191810758157275927.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 22:00:07 +0000
References: <25b34e3bea4da381228953e484e5c699796dafe8.1636315896.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <25b34e3bea4da381228953e484e5c699796dafe8.1636315896.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, gsomlo@gmail.com,
        joel@jms.id.au, caihuoqing@baidu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  7 Nov 2021 21:13:07 +0100 you wrote:
> 'netdev' is a managed resource allocated in the probe using
> 'devm_alloc_etherdev()'.
> It must not be freed explicitly in the remove function.
> 
> Fixes: ee7da21ac4c3 ("net: Add driver for LiteX's LiteETH network interface")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - litex_liteeth: Fix a double free in the remove function
    https://git.kernel.org/netdev/net/c/c45231a7668d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


