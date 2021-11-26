Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0CC45E69D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357943AbhKZDpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344500AbhKZDnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:43:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7439E61154;
        Fri, 26 Nov 2021 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637898010;
        bh=vSn12lrKMoFsWF+FQ3qew4aX7Ao+WycoJE6FAUoxlYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H7vi5h+t34l8Jq1E//utdluzr1NlovYP1wnfe4/i5L04ANGxXJyU3XC4e3lV/6Jgx
         KfjECt5bv8u28HmmvQ8BnDFCj/ugzBQL9mFpdnomqt5XgroMn78c7TY4CPhYWcfGE/
         DL2nPYCxwXGaD7tlWYK5CQI+j+u9dE6h0rHz7YcqYGU0eIQAixhTm/nKKcZMf1UOr3
         dJvIxNUSDSvsZK4C3Q/H0/QFck6RJCYfoWDR2h43FaV0BjGWgxMAuFJ5DbH9d/eTv2
         9zMOGDOamA3c1xSkSqM+GSWfulLApQLCXcRrDvKgjgGkvnwTw8D3M6WkJ8xeLAWNPu
         NBjONZzAbduDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 60E93609B9;
        Fri, 26 Nov 2021 03:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: dsa: qca8k: Fix spelling mistake "Mismateched" ->
 "Mismatched"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789801039.11827.675546722857552340.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:40:10 +0000
References: <20211125002932.49217-1-colin.i.king@gmail.com>
In-Reply-To: <20211125002932.49217-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@googlemail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 25 Nov 2021 00:29:32 +0000 you wrote:
> There is a spelling mistake in a netdev_err error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: dsa: qca8k: Fix spelling mistake "Mismateched" -> "Mismatched"
    https://git.kernel.org/netdev/net-next/c/4636440f913b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


