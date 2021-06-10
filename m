Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D93A354A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFJVCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhFJVCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E824613B3;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358807;
        bh=EbwC/lV3KZTkyB+8efzPfbKjWeM+XpbUJb6LeTtnTO8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r8CG2zoGNz9bOq0kie3QQhXlboCO18x0ZVAIjOAtdbsDKzcimZbP+R2D1tMqa4mDQ
         mJl8DBtHsn1KzcoLzeyB9aHVC8nVbXGFwtlNEoZBwd/9qtlatmFj8JoukGkz9r89fI
         lzLG/TRA/ABJwmanUXW4cLMtGyCLKgnX581EDu3xx2LHZtGZa1dGxZxBgG8v29Wqg9
         fLFaneBYycgIcjMoJdMtMlqYvuVNwu59j+ZumnrOc6dGMiU/ZCyQ4E/bTTqmSMZkfe
         yWr73lRhQVKwK8HsZR7D7i5iBMdiuwluLZMekRAggjqwc9s6jDJKdPm1BgxkJGIwsW
         KPb37AZv22Sbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 205CF60A6C;
        Thu, 10 Jun 2021 21:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: w5100: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335880712.5408.16486670396324481340.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:00:07 +0000
References: <20210610072933.4074571-1-yangyingliang@huawei.com>
In-Reply-To: <20210610072933.4074571-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 15:29:33 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/wiznet/w5100.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Here is the summary with links:
  - [net-next] net: w5100: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/0b462d017caf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


