Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D765410B55
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhISLvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhISLvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5979A61242;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632052207;
        bh=4cATa78od9a+ZgrbaAty5fYxNPCuRIoDM1e5fk+5+A4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cIBgTVUI+qmYQeDtZzLN/zOxIk9lFQ1PP7E/xM5qbqpqs/N3ZKnbw/xe/jnypl5nF
         RCqRqg+LAHNjyXXeycWUOguNdvj+9fuG0e6pP7/YIc6dL3FfUWuHGGKa6pToAkSZ87
         WTvkhKwuvtQ8SAjbDOUz9R/kRVFdauYOBr30w147bPmMutUxgEwMpyvgANp0nJL5Su
         hzpB6q/bV7ddDHu9WiretrWTn3NNOZv5KzO2eBb9MB/W/9rJH6AlJVU6Xs2dF4HbEC
         EB9DpK/GPNvyIGCzClSv1k42OOny4OJ9N2iauiNU/BK5fTkQRghwNtLveIJsYHLwDD
         LO86i0lEOIgUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 464A660A3A;
        Sun, 19 Sep 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]     NET: IPV4: fix error "do not initialise globals to 0"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205220728.27306.15673066563508279538.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:50:07 +0000
References: <20210918093910.31127-1-wangzhitong@uniontech.com>
In-Reply-To: <20210918093910.31127-1-wangzhitong@uniontech.com>
To:     wangzhitong <wangzhitong@uniontech.com>
Cc:     paul@paul-moore.com, davem@davemloft.net, ckuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 18 Sep 2021 17:39:10 +0800 you wrote:
> this patch fixes below Errors reported by checkpatch
>     ERROR: do not initialise globals to 0
>     +int cipso_v4_rbm_optfmt = 0;
> 
> Signed-off-by: wangzhitong <wangzhitong@uniontech.com>
> ---
>  net/ipv4/cipso_ipv4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - NET: IPV4: fix error "do not initialise globals to 0"
    https://git.kernel.org/netdev/net-next/c/db9c8e2b1e24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


