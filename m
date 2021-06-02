Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E5397D82
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhFBAL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235245AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A19B613CD;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=tY5uGh41IwBSTTrtSqcUjJKDEZ1QZwSVC2zxm/n6/5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O1JUHKE23QjZB1UhPLWpPbWBJcwaEtrw+avy5Qiiy9jHyoReZLcFgws77+ZBNdyXu
         Bza6igpy+UpY+jFI93UaqcA4CjxbWToVNSVv1AXyigWEtOieT8aDhbleThHvAc7Ro0
         H6sHlNfCJE8gEDG8P5Hh96/dqQKA5FG1Kjv0z9cUnVaxcAcy2qA+zV5k8Ihqc0xrln
         FMCtNYig9ZjVdzsIYeSXlCz1Ez0L0hPorKrcd/yESbJtn/8yniHXS0zJ3KS5t1aMCz
         0sVj0Prqk2AC5F+SzhGB+dUHqhiCuoPaDTOWPlFj6k1ZfEMvjmhgcFwVsOMG1bQvlt
         6SZWqM5jgjuWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 11E2A60953;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] macvlan: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260806.22595.11030294829851009183.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601141610.4131373-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601141610.4131373-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:16:10 +0800 you wrote:
> underlaying  ==> underlying
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/macvlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] macvlan: Fix a typo
    https://git.kernel.org/netdev/net-next/c/26d3f69c500c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


