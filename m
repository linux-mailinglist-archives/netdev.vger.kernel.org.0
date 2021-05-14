Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB36380F41
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhENRvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhENRvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 13:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20EF761451;
        Fri, 14 May 2021 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621014611;
        bh=ITIYWRThVy75hL8YSOEF42po6HdS2uvCYIMvsA9CPXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nzvebk6ixZSOl/chKmhwPNg45zybUy8HuH1Oa04fgdj6kLhzQAMOUN+VvET0asVEd
         XdQNH6DCALVM50P9xcl2E14j8kuREpiO0vHYKOW/Uppokm08jh/GTHIZ6gwTmp8V2d
         boIEJN/YFYc9HgbXFifM5tqvTlTO1vZ43DBbCt76vcyCDcEObJiDjSEhScuaSTa9SB
         SAhjZOpGQ+i7dg86dEen4O+LtH/O/e0g9jaT0Vx5b0dbt6+rLKYsGr0RaGg4d04Jap
         hFfUfpIRKBTyD52DzoijEn7w2+IbBRCJynQ8k5wJqimyNj1/EMWhKZwbQv9OIBZOtI
         cM5UPpvWUsrcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 13DE660981;
        Fri, 14 May 2021 17:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf 1/2] netfilter: flowtable: Remove redundant hw refresh bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162101461107.25927.14176689671275717682.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 17:50:11 +0000
References: <20210514144912.4519-2-pablo@netfilter.org>
In-Reply-To: <20210514144912.4519-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 14 May 2021 16:49:11 +0200 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Offloading conns could fail for multiple reasons and a hw refresh bit is
> set to try to reoffload it in next sw packet.
> But it could be in some cases and future points that the hw refresh bit
> is not set but a refresh could succeed.
> Remove the hw refresh bit and do offload refresh if requested.
> There won't be a new work entry if a work is already pending
> anyway as there is the hw pending bit.
> 
> [...]

Here is the summary with links:
  - [nf,1/2] netfilter: flowtable: Remove redundant hw refresh bit
    https://git.kernel.org/netdev/net/c/c07531c01d82
  - [nf,2/2] netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version
    https://git.kernel.org/netdev/net/c/f0b3d338064e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


