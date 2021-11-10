Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00AF444C358
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhKJOw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhKJOw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:52:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C6B46611ED;
        Wed, 10 Nov 2021 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555808;
        bh=HgMWkYtOSz6jECOI8QEdUortwYduasizrrX+uLJcajA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T+aZST568XT+vdg5GSp4zHKwhWd431TDJjlmvMyfcujIxQQ7V9JkbvvJc+LNf/5n0
         DPRvGeT3nObJz2DhDkippf3Uj5rxflxDI03Z6N9Arxj/idlxifudoOPJyYNK9ZUcf1
         6oxWsIEpzqA1IWHrJ/ZsWKeyLhWvWW5dKZH/M4ghp864UVHAJqeiqRswcqqP+Bp9q+
         Xnq/4jTDvK/pu0/n+thpWw8gG38HrqGmeFaD52TC3xgF1U8lSDHwuDUugt8tMqL3Dr
         KJoqkn648xhSjhuFg+etK8JqYEiTjdn8Rmz//Ryc8KsWqyHZjKszuagH/iuusdg1CC
         P8H6FQTu9lQjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA12960A6B;
        Wed, 10 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: fix unmatched u64_stats_update_end()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655580875.25401.12976986969339348798.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:50:08 +0000
References: <20211110081109.GG5176@kili>
In-Reply-To: <20211110081109.GG5176@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jeroendb@google.com, awogbemila@google.com, csully@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        willemb@google.com, jrkim@google.com, yangchun@google.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Nov 2021 11:11:09 +0300 you wrote:
> The u64_stats_update_end() call is supposed to be inside the curly
> braces so it pairs with the u64_stats_update_begin().
> 
> Fixes: 37149e9374bf ("gve: Implement packet continuation for RX.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Based on the indenting.  Not tested.
> 
> [...]

Here is the summary with links:
  - [net-next] gve: fix unmatched u64_stats_update_end()
    https://git.kernel.org/netdev/net/c/721111b1b29c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


