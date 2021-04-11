Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947B735B775
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhDKXu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 19:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235768AbhDKXu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 19:50:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0196561205;
        Sun, 11 Apr 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618185009;
        bh=wwL0c57pEM+Jx9lrW79hIcA1CJyrtkLoIIUAvXuh4Ck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d5+q/IIhJgoIxYWEmTNWMO9RQjwDe2HIff/nsZth2R6wPdUAgZdOcHWm4AtI8JoaV
         RxZQkRVUFo0ohJfqH5Be8mQ1HEnCzHgS1WEUcpwgpkPjJzMqJwWERJWgbZpQXfWxHm
         tMpTiAgIBt6WoHWagprxdfQ0ZniGQq8OaHQoo3YTUHjTApXteyhTnV5mMByEvmab4L
         Xu8F7lGR582GM/QQHYm3wb62wCssovdh+nN3fRkYgYfdIKFdkXTRSYkcI4IudkzdUc
         TqUC2m+7jp0W1wMHQ7uDdwzu0ToksyUdXzayJvsK9uNKdJE8NVp8fANArNYeaFLeDj
         +FlNJC0H1GuSg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E527360A08;
        Sun, 11 Apr 2021 23:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: update maintainer entry for freescale fec driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818500893.27089.8181618248969501744.git-patchwork-notify@kernel.org>
Date:   Sun, 11 Apr 2021 23:50:08 +0000
References: <20210409091145.27488-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210409091145.27488-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        hkallweit1@gmail.com, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  9 Apr 2021 17:11:45 +0800 you wrote:
> Update maintainer entry for freescale fec driver.
> 
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - MAINTAINERS: update maintainer entry for freescale fec driver
    https://git.kernel.org/netdev/net/c/4af2178ac605

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


