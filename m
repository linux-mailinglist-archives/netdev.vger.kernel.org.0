Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B2332940C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbhCAVpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242872AbhCAVkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:40:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C24C56023B;
        Mon,  1 Mar 2021 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614634807;
        bh=LBRKCRRhWBzq987fHGLcia886JXZVnorYEjMx4E3CP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oNkZBfC0d/uZwbC39vZscHtAtE8JeBmDAaPZfLc2fZRtBrUMvpf3FHyBNd+yJFA0b
         0g2gKfi1TE+xzsdRqSR/cefEXOXseVeOAxOOXB3N+hO4XXmpXgecw2xqPOHxTM2h3x
         dGpP1cz+mJgWO4gEJDYE0RlKQzONrXM98zev49e4zPpNgGTZB5ERQrwRs5iJUWlX0I
         b/2bGe3THQNqrjtz1h3/96dXE+KGgYDUChL+yeuO6RRersJtqF9IKH0wbKemLmBkle
         yYzwXeZHvg/9K3fPJH4MQgR/ySx6viY8mF20ER5P1k4oHDmysgIqnVYTgN8le9VGMZ
         GzBfIYmXBcR5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B25B860C26;
        Mon,  1 Mar 2021 21:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] inetpeer: use div64_ul() and clamp_val() calculate
 inet_peer_threshold
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463480772.18741.509649048962525834.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:40:07 +0000
References: <20210301060548.46289-1-yejune.deng@gmail.com>
In-Reply-To: <20210301060548.46289-1-yejune.deng@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 14:05:48 +0800 you wrote:
> In inet_initpeers(), struct inet_peer on IA32 uses 128 bytes in nowdays.
> Get rid of the cascade and use div64_ul() and clamp_val() calculate that
> will not need to be adjusted in the future as suggested by Eric Dumazet.
> 
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> 
> [...]

Here is the summary with links:
  - inetpeer: use div64_ul() and clamp_val() calculate inet_peer_threshold
    https://git.kernel.org/netdev/net/c/8bd2a0552734

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


