Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E3B45E690
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352179AbhKZDfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 22:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358035AbhKZDdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 22:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3AD1961058;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637897409;
        bh=WUwgxtqP5oM+FXTNfOQWvAe6Gsqnvg1oWLzR3NL71Rg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RbmYahh4KEH+HwXfUEjVAt6onE7We1Bft3GuH79nl7/jPQZbzPyXeW8yBVS9KazmK
         wzMC+ZMjVJ2f/uA3aOC8SECBYHQNTpIt1F6NchcAj8GkxgWjQ+V1VsH65B/sb9y3AX
         yE8O64o6vpZdE4sRdE7kvxATmV75aPfX8fvev3iWrPhjegeOwnZEVkP+pqeA7ct1c8
         1vNIr4xWlvXk6CzuOQlItOUEQCqMpbI2+Smgg+JVJzcjB6Zib6YFe2Jh5yIhZVTmw7
         UHv6SaIon6bbaZ5JBjxWM9bKq8PiJqglxjQwGx5wuhwMo/MjLVsdja7P8FMwIltV/H
         J3h9S0xW2rLGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DE0E609B9;
        Fri, 26 Nov 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] tsnep: Add missing of_node_put() in tsnep_mdio_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163789740918.8117.17965472591365808434.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 03:30:09 +0000
References: <20211124084048.175456-1-yangyingliang@huawei.com>
In-Reply-To: <20211124084048.175456-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        gerhard@engleder-embedded.com, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 16:40:48 +0800 you wrote:
> The node pointer is returned by of_get_child_by_name() with
> refcount incremented in tsnep_mdio_init(). Calling of_node_put()
> to aovid the refcount leak in tsnep_mdio_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] tsnep: Add missing of_node_put() in tsnep_mdio_init()
    https://git.kernel.org/netdev/net-next/c/739752d655b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


