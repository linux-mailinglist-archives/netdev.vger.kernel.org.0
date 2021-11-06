Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7C2446D09
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 09:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhKFIww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 04:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhKFIwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 04:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6AAEC60EDF;
        Sat,  6 Nov 2021 08:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636188609;
        bh=UoREJALDUitiFJSJLw40cwE8yAoVkZBcaTawCXauia8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UaUqGaSAdOojLfGzOfHpna75rPZefKqWGN4ZFmHCj2WFzC/UBKmD13LKNQcv+gWOH
         FHd9ALKB/0yGqZ01AkvQxSGCEdePqODWp7Z9kt4gbl8Toa77Y+oGIUNQ2mUnblpd6T
         m/fVifS4DsiWG7l2wqF+MWnONNDErX9RttbpX7KlcXkXRL0nTiHBPbWI6tLGHmAVw/
         ESgqRVDnZEHfQHZ4o4YHxe4Kdq/h8cl6+Bfg1/X0xrE1+oNFKLpts+wzuV5U23f3n4
         /PMWKhMIx8YYZv6Q6q7MM9jMUyWGVmULDmcQVpRsEn7/a2oDWT5HrW5wMXgq6AZWNQ
         ACuVyNUHYYdgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53D5C609E6;
        Sat,  6 Nov 2021 08:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: remove useless assignment to newinet in
 tcp_v6_syn_recv_sock()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163618860933.29185.1385452642605204393.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Nov 2021 08:50:09 +0000
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

This patch was applied to bpf/bpf.git (master)
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
    https://git.kernel.org/bpf/bpf/c/70bf363d7adb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


