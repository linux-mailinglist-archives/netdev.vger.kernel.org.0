Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A67389648
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhESTLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:11:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhESTL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C682C6135A;
        Wed, 19 May 2021 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621451409;
        bh=PYT8jjEyoFWiAiSZLbz5154TfdZP8R6YBwmPK8+Q7H0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EAo8vX8hmPLM7YXvTaqX5DpleR4E/kxePL9QhukOqbtj0VrMG/neXrOSZivS4vS6Q
         ySp+KRX46cOtnKxK9+h8OIaTWsK1lpQI7HckLGZOpigjWvVMq6XIGwXWzVY9Wd3z4X
         sCAyER9XW4zN6tUQ3CSfkz6sqCPY4432f2VEcaeuBy5AXQQKaflcVAK5Flr1NISBJZ
         T9AHe0YrOQfBSOVkaCyUQJO1GjSODG/gKKjn5aFUxV7I7UGRf9R0F96T4uvrW2B2sH
         KDQz781pSaUsUfiKVweked9IQjJtYoDcDA+cVv5mNkFUpqzDgdSv757hN8bGCMrjDi
         6lNTz3D/O03Rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA2B760A2C;
        Wed, 19 May 2021 19:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tun: use DEVICE_ATTR_RO macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145140975.13987.1726694497643123002.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:10:09 +0000
References: <20210519023850.256-1-yuehaibing@huawei.com>
In-Reply-To: <20210519023850.256-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 10:38:50 +0800 you wrote:
> Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/tun.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next] tun: use DEVICE_ATTR_RO macro
    https://git.kernel.org/netdev/net-next/c/bc6d076daa8c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


