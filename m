Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086E8420B30
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhJDMv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:51:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233141AbhJDMv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:51:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4409F61381;
        Mon,  4 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633351807;
        bh=igJ4KjYFFUHxLlMKO8rivCu2ItMwKsyihZFDh/U7C5A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VFgLGIc9sgwmD6aVXq2a50vFx6VrEzJYUJcXRNsprVgt0E2Pc37jLCz0SY2qp1Qh8
         qaSOMkZ55c2vYp2Mxip7s+1SSB+NKh4CojvT+CkwexIW96Ny+Z7TH/uDUrY/jkjE/4
         ZsPTF39rAmusqwC0eo38WVea+eRuhwOhnHLKeD9qjWwLExASiE/yynTbibnBWnRTZs
         35eQ/81j/AG0oF7/Rc8aqKF+oe+PxUMMunjsyZsKcCx/oeOdhQoT8vZuJWwJBoi/lL
         NveqvIBJs72qm5DAA4yCc6QlHpn5heeiWvxwANjr/Gr5JouIFfUL7LUPQhra2lkuI0
         0kwYzN0CFr4Ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E441608AF;
        Mon,  4 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipv6: fix use after free of struct
 seg6_pernet_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163335180725.12531.17420254186189357840.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 12:50:07 +0000
References: <20211002223332.548350-1-shjy180909@gmail.com>
In-Reply-To: <20211002223332.548350-1-shjy180909@gmail.com>
To:     MichelleJin <shjy180909@gmail.com>
Cc:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  2 Oct 2021 22:33:32 +0000 you wrote:
> sdata->tun_src should be freed before sdata is freed
> because sdata->tun_src is allocated after sdata allocation.
> So, kfree(sdata) and kfree(rcu_dereference_raw(sdata->tun_src)) are
> changed code order.
> 
> Fixes: f04ed7d277e8 ("net: ipv6: check return value of rhashtable_init")
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipv6: fix use after free of struct seg6_pernet_data
    https://git.kernel.org/netdev/net-next/c/23b08260481c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


