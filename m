Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7FA3FD826
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhIAKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235980AbhIAKvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 06:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5FA5C61053;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630493406;
        bh=Nt/HWsz8607d3pnpZCEQr4o2CyEi7Wh3ptY5aycgpqk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i2yoEKdNSSJDfWWDzOpCnoMeXrRW1MUjdKquu3e2Xj4ueam0iidGEOOHCgSPyXWKD
         CKhe7YOK8H5wVXfkU3C/QQl7iLSwZ4BERMFaw0e313/GmKUwi64WLzCQFR1z7WcWFb
         U4b2y+P0o6mMViNcVb1RbH3x5tehdordfZoKWuLXIsyrrag525nYQ6aytjWyQ1muhq
         2g8Ch2+VFeqeEIqJ7k6hagMf/e8iBcUiJ87y3NXC5LU8tlBSGrNSqXIZpBB9ettPMg
         uVXL9QCMmgg2z04bQxTNmsgI4mPSuLlZUjf2yaqO6XZIAdb4MDU/OR0O0NrjyX9p1w
         nzk9z/y4KYPKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4E4926098E;
        Wed,  1 Sep 2021 10:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ixp46x: Remove duplicate include of module.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163049340631.3899.18001961883066425665.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Sep 2021 10:50:06 +0000
References: <20210901022059.4126-1-wanjiabing@vivo.com>
In-Reply-To: <20210901022059.4126-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 10:20:57 +0800 you wrote:
> Remove repeated include of linux/module.h as it has been included
> at line 8.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/xscale/ptp_ixp46x.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: ixp46x: Remove duplicate include of module.h
    https://git.kernel.org/netdev/net/c/8eebaf4a11fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


