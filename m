Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414073530E7
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhDBVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231577AbhDBVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 17:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C48361168;
        Fri,  2 Apr 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617400208;
        bh=/RQ8FzHOiYnf3gCQJWUsQehcyga1njWtD/On9xGYpwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4Xy2naWCX4vObJTgWWAtBy0kHXO+WEOapgPdmiVzrBTwFyN8Di0tGvGd3CWdRh9Y
         JbdO97cCb+Au836NdRywkveAiASdjUuIHjtPrpSbYYp2wIgjgYRyRlIcwBZgsL80MD
         5WeDpheK5OAsmz4zc5hczpMCvkT4z7Y2Vis8mkGzAoD/NpH/t2hfaxOBxcVYI0y6rx
         05EGdGbuf1/2BHM/25Sy11Yp0XMk7ak7CxOyXNlYRw10wH6tIIkV11KbEDGeyF7SQ1
         bQTV1kUz1+/3PQI6toiXZbMCJsSbHwI25BFyUVPAXYS2Ysao3CHtZxq2CJ7OWFPo5w
         km7lVbtasixzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F08A5609D3;
        Fri,  2 Apr 2021 21:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: reorder tcp_congestion_ops for better cache
 locality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161740020798.10375.7702809414360937864.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 21:50:07 +0000
References: <20210402181037.19736-1-eric.dumazet@gmail.com>
In-Reply-To: <20210402181037.19736-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  2 Apr 2021 11:10:37 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Group all the often used fields in the first cache line,
> to reduce cache line misses.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: reorder tcp_congestion_ops for better cache locality
    https://git.kernel.org/netdev/net-next/c/825066651792

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


