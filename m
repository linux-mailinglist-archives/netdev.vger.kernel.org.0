Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0834D94C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhC2UuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231228AbhC2UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA098619B1;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051010;
        bh=LGPC3mz337sN6XAk1oBFdAMURlC6ZCCYeCBkalLqsu4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iwy4hlNkI4kTdHFenFySs0qS8+oI1HrlZIPhrfi2hXdKtEDPPLZQcKM5S7Jzoi+oO
         WPjMPlTNePAlvHbQpzjlqmO4PTiuUHRq4bAwDDadUHtc/7DyrJ47KiL64SsrgjznMO
         Ta8JFzFjQ4AzrZdNZUxpdmxHaqz1kSjPw8QXDTiSCjRQEo7sZ417/WQc0O93BGWXg3
         yF0k2w/NfuLhwQYrzjUXcPe4Df/rJNqUpZBUtDJjb17tyOBIZt/QVffgx0GkDPQc2y
         mFkBom5QuaUOkJPWbi809YJlx3QceGvL1/Oon+XPXFtboL16f7m7wvX+LZQgcc+imy
         6Dn7KdD1mUaNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C1F8660A1B;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: phy: Correct function name
 mdiobus_register_board_info() in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705101079.19110.7379565486763630610.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:50:10 +0000
References: <20210329124046.3272207-1-yangyingliang@huawei.com>
In-Reply-To: <20210329124046.3272207-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 20:40:46 +0800 you wrote:
> Fix the following make W=1 kernel build warning:
> 
>  drivers/net/phy/mdio-boardinfo.c:63: warning: expecting prototype for mdio_register_board_info(). Prototype was for mdiobus_register_board_info() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: phy: Correct function name mdiobus_register_board_info() in comment
    https://git.kernel.org/netdev/net-next/c/4db0964a75a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


