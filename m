Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE254959A9
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378602AbiAUGAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378597AbiAUGAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F1C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 22:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57AB6616C3
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5747C340ED;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642744813;
        bh=+1xpREMuHgR504MncKWM6VI7v2oyA5vck04rXA/UP+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mcmbggbcZtqBvRJlNF5/bH79ZXM2/X5xzCV6WxOzZ2CDBoYHVWM0AQ8D6a3POY6ER
         oH351YWqyZXZj1fmuZeasSW+IcKS/mDkrHkAL1qeBO6yh5Bzu/3XNX92e5zakkxhJZ
         BgaxlwuxCGtJEXQIlOYfZ72QYCVVmXC91dRFuMbJ8rxNOgdkEyUrZQZ/l1wQl/nLhW
         Gmb+6AJgqal5uOIlcrWg6t7vW8O4EEwb2JMzyL11pGkq9rvnWgYkASrDrZzMny2Ql6
         NWOBAllCF5d71LfJgaFmGlko6Wgy66jidRO40pbdxcKJlwBhgFXv+69H+J67RdpLBt
         wLaD64PfrEiBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 997CFF607A2;
        Fri, 21 Jan 2022 06:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: add a missing sk_defer_free_flush() in
 tcp_splice_read()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164274481362.1814.14876248751453842066.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 06:00:13 +0000
References: <20220120124530.925607-1-eric.dumazet@gmail.com>
In-Reply-To: <20220120124530.925607-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, gal@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Jan 2022 04:45:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Without it, splice users can hit the warning
> added in commit 79074a72d335 ("net: Flush deferred skb free on socket destroy")
> 
> Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
> Fixes: 79074a72d335 ("net: Flush deferred skb free on socket destroy")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Gal Pressman <gal@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] tcp: add a missing sk_defer_free_flush() in tcp_splice_read()
    https://git.kernel.org/netdev/net/c/ebdc1a030962

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


