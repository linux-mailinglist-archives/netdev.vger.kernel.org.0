Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AE03A2015
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhFIWcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 04FBE613FE;
        Wed,  9 Jun 2021 22:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277806;
        bh=dfQpZkYjZy37ikwuEdjp+n+jzQDu+rP4gGrc2LDkG88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MvAdaG1zP3/sXpAk+BM22qGC791lkvAZ6PDKj9Z0HJhWZVQiW/ZCtLEt9kqqa7X4C
         yZ7vAUMt5PnmT9+A3yPzOTHnoZ6/jP+qyIkIOtJS7r7lXp8RAfga+6HlROZZFTfNrb
         Gx0uL3NN0dHoQp2Wz6XEeUgLOh5Kqx4pusE6iQNXD9j8BdR1BUcUNnAA+Sb1eyyXOl
         yx4t60AABsOhh7EObcul7ZJwX6AW7nRrGlx13tYKVd1yGE4kYx+L2vhk/l/SI/p3bL
         DBTEmghL/KbyG0jSF1cMfpCkXwTd5CXZdRRhfHKU447kTYxf+/1y20b6+cO3kBHT1a
         J2gbcjkgBjuIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E9973609E3;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sgi: ioc3-eth: check return value after calling
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780595.20375.8102574349200301025.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609132515.2701394-1-yangyingliang@huawei.com>
In-Reply-To: <20210609132515.2701394-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 21:25:15 +0800 you wrote:
> It will cause null-ptr-deref if platform_get_resource() returns NULL,
> we need check the return value.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/sgi/ioc3-eth.c | 4 ++++
>  1 file changed, 4 insertions(+)

Here is the summary with links:
  - [net-next] net: sgi: ioc3-eth: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/db8f7be1e1d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


