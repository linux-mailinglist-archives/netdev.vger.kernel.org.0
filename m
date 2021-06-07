Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29B239E90B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFGVWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231160AbhFGVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 66AB96124C;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100804;
        bh=CEnEF+urhZePx7bgHVYDJTnN8hLuPlG/HAHmO5yJKig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uvkZqZprHW2RmOm/97koo9pFHFZMVvb30e4hL3BjOgouXvEOaymhPGG7o2gST2McW
         4cYDd8a0hYwURNITXuaw1ImEfeqIw89et5KkSDYij18uWH3Lzgy/6LCbzNZsTd8VUM
         wd9qkLMoOhjXwuUZtNXCTmgAnfk/fKf5JVakzIOlxbIwXtEKt0QGQKHcx7mo+nPf1a
         gKGNc5DXxjP1FqyGTIWm0FRsQd6rzPpWoodskd1zpnZM0RsOQWyGIsIIKEttbXVXOM
         nWUayjudiCaHIQ0z4I5xBBpZEWVnbDN9eN9BqXIN2POiUbJ3PqLQbGt+LKzcOkfuYW
         noDC9RqwokDqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5CE1D60CD1;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: moxa: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310080437.4243.15294603650747603292.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:20:04 +0000
References: <20210607150259.4013977-1-yangyingliang@huawei.com>
In-Reply-To: <20210607150259.4013977-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 23:02:59 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code and avoid a null-ptr-deref by checking 'res' in it.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/moxa/moxart_ether.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: moxa: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/35cba15a504b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


