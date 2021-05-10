Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411C33799F3
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhEJWVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232009AbhEJWVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 24F2A61585;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=n5YjMWaeeJkUi6Bux0sq9OLNsVytDfxk91Vw8Qg+DqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tet7lBEmswNS92T2EIe4D6hJmJ3cksGYTTMCGn1x1l4KrEGI44LDrPaUP/KXdSFAs
         lGaO5MozX9Ip8yjRVZ6CqHbHdbV1Lv0bzYDcmNgkVq+I3bFSBh9pLHr3lrx5zCnIAY
         pJeQTpHPDBuCzphUhRs+7AWsfqA9EtZc2bQlK1Q9GUETLo7n1k686Q7JrKzirDHS4h
         cmpWPaPrzYVDBS5QTNQ+rmyBcCijkviIZOlj+SqUWJSKGDi/XadKW/WySaZ68BwsC/
         xqYby41KuKdgEy7ogpf6uxbrzQpx1QqpNDzqPQdKDirMYX5YSjwDLVzIdR0MG6+W1Y
         zwL6N8efbyQow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B4AF60CA9;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/4] net: mvpp2: Put fwnode in error case during
 ->probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521210.17141.12537485843274435664.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:12 +0000
References: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
In-Reply-To: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mw@semihalf.com,
        linux@armlinux.org.uk, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 12:58:05 +0300 you wrote:
> In each iteration fwnode_for_each_available_child_node() bumps a reference
> counting of a loop variable followed by dropping in on a next iteration,
> 
> Since in error case the loop is broken, we have to drop a reference count
> by ourselves. Do it for port_fwnode in error case during ->probe().
> 
> Fixes: 248122212f68 ("net: mvpp2: use device_*/fwnode_* APIs instead of of_*")
> Cc: Marcin Wojtas <mw@semihalf.com>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/4] net: mvpp2: Put fwnode in error case during ->probe()
    https://git.kernel.org/netdev/net-next/c/71f0891c84df
  - [net-next,v1,2/4] net: mvpp2: Use device_get_match_data() helper
    https://git.kernel.org/netdev/net-next/c/692b82c57f71
  - [net-next,v1,3/4] net: mvpp2: Use devm_clk_get_optional()
    https://git.kernel.org/netdev/net-next/c/cf3399b731d3
  - [net-next,v1,4/4] net: mvpp2: Unshadow error code of device_property_read_u32()
    https://git.kernel.org/netdev/net-next/c/584525554fd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


