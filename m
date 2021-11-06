Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17609446C29
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 04:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhKFDCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 23:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhKFDCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 23:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F99160EBB;
        Sat,  6 Nov 2021 03:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636167607;
        bh=axACwuwSd8HnjHHPp8qZEz07q30ERonRNw6m+mDyUqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vP3/EdBGmDuM2kJ6cVZJ92VAYZTjkCDWGjWtBI+BX+d0g0q4DuJGv7cXpd8ynEnC8
         lVu5RkxKM7wMEn2VMvtU1gemiTx1JB3TLB+dvD/gt8SixSRy3i7xnGk/QpMZ04+So1
         /lp78NLYRj4ucFxMl25+JkVPFz0R8YQxxuP9d+6Z7V2E7xZxEWA4Qijv4x88oiLzVC
         m2WCwA8XT3W9Z/CyA3Oub5thhFUgh2It5yx4IFolLilLSFvsdv/hmpUFS9V0eevV6P
         a5vhcjItruMlDCTPx1HZV1u4yGsGbX5M0kAIVBwNk2wDrVxxLaDXGJTTiEw/NRKzBn
         cC5ZF74N5XoRg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E1AD609D9;
        Sat,  6 Nov 2021 03:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: remove useless assignment to newinet in
 tcp_v6_syn_recv_sock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163616760718.459.15604217607658404644.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Nov 2021 03:00:07 +0000
References: <20211104143740.32446-1-nghialm78@gmail.com>
In-Reply-To: <20211104143740.32446-1-nghialm78@gmail.com>
To:     Nghia Le <nghialm78@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, lukas.bulwahn@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Nov 2021 21:37:40 +0700 you wrote:
> The newinet value is initialized with inet_sk() in a block code to
> handle sockets for the ETH_P_IP protocol. Along this code path,
> newinet is never read. Thus, assignment to newinet is needless and
> can be removed.
> 
> Signed-off-by: Nghia Le <nghialm78@gmail.com>
> 
> [...]

Here is the summary with links:
  - ipv6: remove useless assignment to newinet in tcp_v6_syn_recv_sock()
    https://git.kernel.org/netdev/net/c/70bf363d7adb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


