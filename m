Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C040E3E9B21
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhHKXKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhHKXK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 19:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A0C560E78;
        Wed, 11 Aug 2021 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628723405;
        bh=jLEhFUp9cGc9+pRMLkXxix5oE27mLr04pz6k8usxlxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mBvuSIpvnx/wbvSxUm6d0kpHgibyAwCV1Y8O0yl4HKxMvfF2zcnmbLOEfMyolNKmJ
         byMBavLhj7jo1BGZ1W+yWupAs7KzZHG1T3gT0xtc9v7/Trcskd3azm2m4FhARa2d00
         dL80EQ1F2cq55xrSoN3Mn3PyaN4eyIh7yik9XKpSwKIM3wcnwMInZJ7scK08H+hVAx
         6HfFHd55KufLG98tAVaEWqzYEiiWNSUO+aOlOSq31SJ9ZrDK5pRVluhF74fC9IOfTY
         EKwv3vNqQDBDrvEhv9SjDuVB26mjCBMAFF3f83OnJxPVBOGz+yn8NzDBdC+nzYFU/0
         u1nIsLiRQvGxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E08360A54;
        Wed, 11 Aug 2021 23:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: igmp: increase size of mr_ifc_count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162872340551.19806.12924138705006683082.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 23:10:05 +0000
References: <20210811195715.3684218-1-eric.dumazet@gmail.com>
In-Reply-To: <20210811195715.3684218-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, linux@roeck-us.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 11 Aug 2021 12:57:15 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Some arches support cmpxchg() on 4-byte and 8-byte only.
> Increase mr_ifc_count width to 32bit to fix this problem.
> 
> Fixes: 4a2b285e7e10 ("net: igmp: fix data-race in igmp_ifc_timer_expire()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> 
> [...]

Here is the summary with links:
  - [net] net: igmp: increase size of mr_ifc_count
    https://git.kernel.org/netdev/net/c/b69dd5b3780a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


