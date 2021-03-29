Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C6D34D950
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhC2UuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:50:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhC2UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AAC70619AA;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051010;
        bh=FXBNGqXUmZJutP5RqHBrA77uQQ9fn5YpxeL+zICqKOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hCa3Ahj+VZIK8wax8a+ZM2N6zx/iUWCxhJEAsDK4pWqqETIC+oRAENpGzaibdtRW8
         l59IUbxX2HtagtEyTYWgnlhv8MqlV1ZtztO4FcL+Oqt52dqCPo83k7OnP5BgfrGMrf
         9vBGD9U7V//qpTkW2vYnjC+4ttimpqRxxiTjoBsEYXUxCnZnzxDkKG91Yv3lye6t6l
         azLE49lrrqLM1qFLmvXputNsYiG5TZMG31s48UO0JzCdW7EQCUr+lqF6Q2cSXC4mJP
         ivO4GGw+AA7Heh87zWl8saxAlVVm8esTFfI5Re0zGOY8dooANv6DEuUXMxjscXEvLb
         E7IfX2Cgjnwjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A657A60A1B;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: mdio: Correct function name mdio45_links_ok() in
 comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705101067.19110.9168160530169265173.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:50:10 +0000
References: <20210329124427.3274071-1-yangyingliang@huawei.com>
In-Reply-To: <20210329124427.3274071-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 20:44:27 +0800 you wrote:
> Fix the following make W=1 kernel build warning:
> 
>  drivers/net/mdio.c:95: warning: expecting prototype for mdio_link_ok(). Prototype was for mdio45_links_ok() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: mdio: Correct function name mdio45_links_ok() in comment
    https://git.kernel.org/netdev/net-next/c/177cb7876dce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


