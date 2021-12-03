Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F20446796D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381484AbhLCOdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381468AbhLCOdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:33:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D856C061751;
        Fri,  3 Dec 2021 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDB5D62B90;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52635C53FD5;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541810;
        bh=q30pyTBR82omI8E5JxUHdp2juwGj4MauuXsFkozBqTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RIZ17F6SBRWoNkvGoJOP9FQbf5qOtjQP3fwHjjKmlHeYUcMWH/wxd1LvyhbymHrJL
         /QWbNc5cuhBDEf8eOwUtG9ByZHj4r4pE/RS0zvr0C0+2CkcDZWwsZrKFfsK36Z3Wup
         1Xq4H8ILKnWBLJh8R06uYncW3JT8N+4vjtB5rLwsMV15pSGtmwGTjx5mKjHRyD/2ho
         SxlCnBEC/b6yIK1l+3W3wiD2FiF2oO1xj0DXtLsm0aO+0pswmE1qngWktaZPFES8cM
         SgNWp327/y70mBlrqGC6E9l6Z59j/H27N8LMxvldxob0Dm9+uNSNtO2qZHXsRSMqvB
         Q+iriatXxQqrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F3A260A90;
        Fri,  3 Dec 2021 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: fix a IS_ERR() vs NULL check in
 lan966x_create_targets()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854181025.31528.983813324370479762.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:30:10 +0000
References: <20211203095531.GB2480@kili>
In-Reply-To: <20211203095531.GB2480@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 3 Dec 2021 12:55:31 +0300 you wrote:
> The devm_ioremap() function does not return error pointers.  It returns
> NULL.
> 
> Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: lan966x: fix a IS_ERR() vs NULL check in lan966x_create_targets()
    https://git.kernel.org/netdev/net-next/c/bb14bfc7eb92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


