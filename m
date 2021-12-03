Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83E8466F93
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377999AbhLCCNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:13:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58176 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377995AbhLCCNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:13:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3A60B825A3;
        Fri,  3 Dec 2021 02:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49BA7C00446;
        Fri,  3 Dec 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638497409;
        bh=Z1NjbXF27Ti8Cp9950HNlAibJmnKbkep1SMqXxRjCHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JGB89Uj5pfT2tIFjra73LApGap73vgHEk7AvmStfzuitiFTpY8+kNfDt3CVTFZRB/
         0rYCgOddkbNroazAqlKdBJjy0LrgGSG7Ac6o9+g0sSgAg35AvJBhTVv8j8b5aKrOPF
         iLk687VF4L4xowEvDDXLN5VpwM3wNejDqJdIMdh16zFJSEzZtUaj3uK+x8tFB4YvPH
         OpdO8OZGOl8xYZyLgPFVxftaylqhekbxBWxZAawWNOGaq4DtJl8ya/zcpzCU7SlTRY
         WtX6OQ24PZpqEwncg9fnpDrvaVlCxbPRZ4c0ooiWgxxjvYD+qEAg8yej6NO15dfozD
         mrcMmY7XlP8LQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2937F60BE3;
        Fri,  3 Dec 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] selftests/fib_tests: Rework fib_rp_filter_test()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163849740916.2738.7046909132205232442.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 02:10:09 +0000
References: <20211201004720.6357-1-yepeilin.cs@gmail.com>
In-Reply-To: <20211201004720.6357-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        peilin.ye@bytedance.com, xiyou.wangcong@gmail.com,
        liuhangbin@gmail.com, dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 16:47:20 -0800 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently rp_filter tests in fib_tests.sh:fib_rp_filter_test() are
> failing.  ping sockets are bound to dummy1 using the "-I" option
> (SO_BINDTODEVICE), but socket lookup is failing when receiving ping
> replies, since the routing table thinks they belong to dummy0.
> 
> [...]

Here is the summary with links:
  - [net,v3] selftests/fib_tests: Rework fib_rp_filter_test()
    https://git.kernel.org/netdev/net/c/f6071e5e3961

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


