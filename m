Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E122C46CD39
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhLHFno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:43:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34300 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhLHFno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:43:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 25443CE1F97;
        Wed,  8 Dec 2021 05:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46087C341C6;
        Wed,  8 Dec 2021 05:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638942009;
        bh=nU5XG+b8MCrFzNwOjetq2h09RutOxnQGJxWJ+Try7+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EPA7FpJon9+ktrdS4mnuykd4bWx5xVni5siOHmhKou636GVp7wp/0JMyRe+uztvKz
         sNROZ9H0LgA4kZm6oskAwkqhxA5+yFLY6du+Oar51GWo60m6gNVfNETf55JrIXDIkr
         DwmH2cUCfdgdvZwdY5DoZQ5qa68goPGuyOLf07zx1MD6NVt2Ka2LMH2CvXwwibeR9m
         Zs3jZcE+7jTU/T+beIXPwPBnoG0V8uFEu3cnNztes5iYyKfeOP0T3RKRhMnIULLeVi
         PuBhxjcEIEzw4Dlz07WJoEJFUjakO4ckEA1okIr1INTD27JeT4hWL5FucDYTKj78YD
         /Qy8ZdwYfyDGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A16260A53;
        Wed,  8 Dec 2021 05:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: hns3: Fix spelling mistake "faile" -> "failed"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894200916.7821.12190074698627367127.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:40:09 +0000
References: <20211206091207.113648-1-colin.i.king@gmail.com>
In-Reply-To: <20211206091207.113648-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, huangguangbin2@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 09:12:07 +0000 you wrote:
> There is a spelling mistake in a dev_err message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] net: hns3: Fix spelling mistake "faile" -> "failed"
    https://git.kernel.org/netdev/net-next/c/3c5290a2dcdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


