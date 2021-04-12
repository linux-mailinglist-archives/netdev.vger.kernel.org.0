Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D69A35D1E3
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244150AbhDLUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237592AbhDLUU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 16:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE3536135B;
        Mon, 12 Apr 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618258809;
        bh=4ZpgX9uaCXvX6GkH+4T+za4ueOWyd6b41/dNqK3JeKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bF5ep1IWK+h3sxeMfk7DGbf7HbgtascchxbhwxmNJRMKNoIo4axYsAyRtXRfb16mB
         jWxdJY//46kLRpLDmsmGoH5iIWIEqCCFvhagSUCOY4eDyo7u7/g5AsoFwNuNqbVdWq
         Kb4l3GAYShbRG1b6lBcVW4PDspjYRlGZASToErfX4e5U9nkFCy5DigaRkQtyavN1vP
         BNEExCTi3x4Oxi+ZkkWMHl5a00ZqiY0LoP2Yvo410Y3yMxpvTlXmMSrMEKk3SiIkM0
         RhKZy7NUtikjcOPBYbKE+ZDlu2vburrGIirzy5LcQ1g9foNGyT9vSjGfBqsJ2D/+CS
         nUdBFsTWqAIUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E195C60CCF;
        Mon, 12 Apr 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: seg6: trivial fix of a spelling mistake in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161825880891.1346.1282421184336667680.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 20:20:08 +0000
References: <20210410174614.13359-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20210410174614.13359-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 10 Apr 2021 19:46:14 +0200 you wrote:
> There is a comment spelling mistake "interfarence" -> "interference" in
> function parse_nla_action(). Fix it.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: seg6: trivial fix of a spelling mistake in comment
    https://git.kernel.org/netdev/net-next/c/0d7703605778

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


