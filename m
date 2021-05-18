Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12213881A7
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352262AbhERUvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351962AbhERUvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0502361363;
        Tue, 18 May 2021 20:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621371013;
        bh=ivjLYyzJODhET7YswmfLIWrTHx973bB0ADWW+3rWgJU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BgU/YEOQoaAWWjFhxaU1WIP+rBDDUs9evbs+PrFrFhgbKjYQZdUyXEkYPXZj58Dmf
         1tkt3cnvkfAXqyE3AWFlmtWCJolsT8MYSfFqYvbynJbXx/BzeTd1/+7unVCdIRvmnA
         8cffvl9kA6KRkgeFvLUgfWP6CKRexKjJ3fiyXl0/EGyKqxs0/6S2YipCYBS4UFRcGY
         vPny1s4QqmrVq+U6tOc/LI2vp847pH/l1CHg5e86KSahgG0saeZlsUSqg/BntQy6NP
         oz2YhXQ+r3Qblm60Qx/H/bIqJuR5WZ8PN355q8kbomVDpQQuFjdWCG+gMf/lPcVMTe
         gP9VAbEQaHEbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE14A60C29;
        Tue, 18 May 2021 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cipso: correct comments of
 cipso_v4_cache_invalidate()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162137101297.13244.16382966628455493286.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:50:12 +0000
References: <20210518091141.2316684-1-zhengyejian1@huawei.com>
In-Reply-To: <20210518091141.2316684-1-zhengyejian1@huawei.com>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     paul@paul-moore.com, netdev@vger.kernel.org,
        zhangjinhao2@huawei.com, yuehaibing@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 18 May 2021 17:11:41 +0800 you wrote:
> Since cipso_v4_cache_invalidate() has no return value, so drop
> related descriptions in its comments.
> 
> Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  net/ipv4/cipso_ipv4.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] cipso: correct comments of cipso_v4_cache_invalidate()
    https://git.kernel.org/netdev/net-next/c/4ac9e23cf2cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


