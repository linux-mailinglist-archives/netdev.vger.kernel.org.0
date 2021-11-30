Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E934633DF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhK3MNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:13:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36292 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbhK3MNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:13:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73C22CE1928
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E9F8C53FD3;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274210;
        bh=2M4+EOpfvh0sGQUpoyUkrZTVg+rNpEohWIXRjdtIMJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GqshJolx35vB9nySUWFiNFN5m8kDGS5zhL8WRvkQhCfUuPuPySO/m5PngvqE8uCmg
         KG0blq8lFJrzs27sCXRqnal+ax/YlYgAKkQLrwk4gdhXP2v/6hDu7/XrGHVZRx+X6V
         NyK4XUZtDdyPeDwogYi1RbMT4YFNEx3rongDDQw+3G2NVGHo+jYbG+57iIBv3PUivb
         gK1c9XhlcokeY8YSCHV0ZVF9eO0UPEHbnp/dgqeeuXoElkGrvZEluOCCYK8Xjb+OwJ
         tnrQIwQ0+M6bTDYFtOLyaUPwF3vPYCDr8Q+n4qGulIpS/YfZD1jHNeXVHSOM6VCVlM
         1fK60EogrSxUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8D1DB609D5;
        Tue, 30 Nov 2021 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ipv6: use the new fib6_nh_release_dsts
 helper in fib6_nh_release
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827421057.23105.17829624018956141994.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:10:10 +0000
References: <20211129154411.561783-1-razor@blackwall.org>
In-Reply-To: <20211129154411.561783-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@gmail.com, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 17:44:11 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can remove a bit of code duplication by reusing the new
> fib6_nh_release_dsts helper in fib6_nh_release. Their only difference is
> that fib6_nh_release's version doesn't use atomic operation to swap the
> pointers because it assumes the fib6_nh is no longer visible, while
> fib6_nh_release_dsts can be used anywhere.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release
    https://git.kernel.org/netdev/net-next/c/613080506665

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


