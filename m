Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4B39E816
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhFGUMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231517AbhFGUMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 084E1611AD;
        Mon,  7 Jun 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623096610;
        bh=jDWkT13qC7Ai8BDngXN4CsmKqEQQ5K2QaJ+easO8ri4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qdl/f4NS1Ymnhgy3Qd4q/Ul/zCLYvXkXoAMjjDURwDLAkvuYczgB46tt5TUkzG2ln
         WgSwC9iyVGvm3X4POfmKjnTXcQXD7AaDy7E1zfcjAHCTUrTZkXT1X2d/fa2JDoXvWX
         fjJxnZ4dL9ShmORIaUL4iZxbT1m1mt/6mYj2rJXNYwXQXzaeoRFmS2Li8XZSDmIqYT
         9az6nJH/Z0Odbwyi4lFfUkvl6cOxGUQXyEdzqTn+5vh4VFvT27FBgQZRwl2yalxh9K
         X/R89Jq+NybPITP8wCskaU5RHQwUjz3//YRRiBt/x4zp/hHMCQmxuUGBRnF4CMNmub
         B4t+jDKb2mDvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F215C609D2;
        Mon,  7 Jun 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ethernet: ixp4xx_eth: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309660998.3673.17422333049324363221.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:10:09 +0000
References: <20210605122515.2476263-1-yangyingliang@huawei.com>
In-Reply-To: <20210605122515.2476263-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        khalasa@piap.pl, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 20:25:15 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   remove 'res'
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ethernet: ixp4xx_eth: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/ec89c2b55dc7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


