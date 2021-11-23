Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACAC45A1DD
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhKWLxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236552AbhKWLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A934461075;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668209;
        bh=9vJoKo72Dp3sUQzV8BID0RMAzD+DE/VYSkH4JpPEtD4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e8UAjwk/OlYlWAV4AwWkjiQ9aipFFouOibGii5vFc4ABnHm8hlwpnxmD+Bf4XaTAw
         4AKBQFtbh6f8dlMa2MvztDSCUHMkRap/bSCPb63r7X7PQXYXX5i45wz+66+vnPtK2a
         iovgyEPYS26dQphMfSnYZ2LI67AikFkJZM6wdMXsrwJpSPZhHKIU4OYeW4RWvE8x6T
         6CwlkuEoU1Qm80q7NaUHi2Kk665WFk4SdlGUBOb8UluVWod2qgVV506/Faw7LScL87
         qKwoecKkFnAJ6oaBH3D4neNV9/2X2sFgjET2JDDYiIOTbA/KZaXpJ4bcy4ChGHyYWS
         1/fQkHNtUrQ/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E7DF60A9C;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: nexthop: fix null pointer dereference when IPv6 is
 not enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766820964.27860.470476268434416916.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 11:50:09 +0000
References: <20211123102719.3085670-1-razor@blackwall.org>
In-Reply-To: <20211123102719.3085670-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org, davem@davemloft.net,
        kuba@kernel.org, dsahern@gmail.com, nikolay@nvidia.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 12:27:19 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When we try to add an IPv6 nexthop and IPv6 is not enabled
> (!CONFIG_IPV6) we'll hit a NULL pointer dereference[1] in the error path
> of nh_create_ipv6() due to calling ipv6_stub->fib6_nh_release. The bug
> has been present since the beginning of IPv6 nexthop gateway support.
> Commit 1aefd3de7bc6 ("ipv6: Add fib6_nh_init and release to stubs") tells
> us that only fib6_nh_init has a dummy stub because fib6_nh_release should
> not be called if fib6_nh_init returns an error, but the commit below added
> a call to ipv6_stub->fib6_nh_release in its error path. To fix it return
> the dummy stub's -EAFNOSUPPORT error directly without calling
> ipv6_stub->fib6_nh_release in nh_create_ipv6()'s error path.
> 
> [...]

Here is the summary with links:
  - [net] net: nexthop: fix null pointer dereference when IPv6 is not enabled
    https://git.kernel.org/netdev/net/c/1c743127cc54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


