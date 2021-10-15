Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC9442EEF7
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhJOKmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhJOKmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CDFE61056;
        Fri, 15 Oct 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634294407;
        bh=FOYvUhqg8F7JGlf84dnt7hHVnjpsrBbGqNvl7gebi/s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bePMfmwIHe3UYG7JHRDvl/tYEdLHqY78iTDnyRk4GuosnqMm+A1vuUVlU9cbFeGSA
         ojgIDOPR85ILsPWHK6riLLom/98A687NOuW3Av3P0akx33g+MfF4xpdyNTYNqoQ5oj
         teSs1G4zhX4VtrTsUjnYqMLvJudZyexzyyZf0kHan3+UbD5e6z5H+fiYg3x013t9d3
         Ug2XOIJ4+PbsA3pnjSYfIyaUx+/IKCgx+cXlIVjBVGDAYioUl/HB1J/jCTtWW7qM9j
         Mmp8x0OI5krAlZVulSbZDk2UMczMx0E0rO53hDPglUfQZgpgu3HVM1nqFkAz5CUJxa
         PDcIJoUSKjITA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FFBD60A47;
        Fri, 15 Oct 2021 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/sched: implement L4S style ce_threshold_ect1
 marking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429440706.6571.2942933078477320787.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:40:07 +0000
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
In-Reply-To: <20211014175918.60188-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 10:59:16 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> As suggested by Ingemar Johansson, Neal Cardwell, and others, fq_codel can be used
> for Low Latency, Low Loss, Scalable Throughput (L4S) with a small change.
> 
> In ce_threshold_ect1 mode, only ECT(1) packets can be marked to CE if
> their sojourn time is above the threshold.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: add skb_get_dsfield() helper
    https://git.kernel.org/netdev/net-next/c/70e939ddea7f
  - [net-next,2/2] fq_codel: implement L4S style ce_threshold_ect1 marking
    https://git.kernel.org/netdev/net-next/c/e72aeb9ee0e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


