Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8946636B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357847AbhLBMXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53580 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357823AbhLBMXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1ECFB8234D
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F58DC58321;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=5Z61sTgVE+niG7m3+zYnYBNpODiasBG1m5BRSY0gRik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RSqwb8JuPio9ZF+Q28icIbidG04hfjAVKK/c0VbSLSU7agfNZk3kakGjMnZumTfQr
         3r7r4QEZHPKXPjCV+FZOtppYWyPIKFD+/bbdvzft12CZkSq9u6ZLR4e7lzZ/4nkAu+
         11VamBy0oUg5fckEZ7aLBHlwfRqzL/3DSO3VC4FQXNUpIN40uNmCR0NMEywwXDgncv
         qOaTbPecpGSDgVHm7RwucgjEL5IUJwAYD8qfb/IWscaVKLa556Ty56xfF+gkqMOgvg
         M1MvjiTOf9zC181IpRdE+ZkBtxwJPj0F3a80TO2enfmaDHS8d5GVj7yr3Js4ZfNyFB
         YFRlCJ44CyERg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DB5260A7E;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: convert fib_num_tclassid_users to atomic_t
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761111.9736.18340241811043973488.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:11 +0000
References: <20211202022635.2864113-1-eric.dumazet@gmail.com>
In-Reply-To: <20211202022635.2864113-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 18:26:35 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before commit faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
> changes to net->ipv4.fib_num_tclassid_users were protected by RTNL.
> 
> After the change, this is no longer the case, as free_fib_info_rcu()
> runs after rcu grace period, without rtnl being held.
> 
> [...]

Here is the summary with links:
  - [net] ipv4: convert fib_num_tclassid_users to atomic_t
    https://git.kernel.org/netdev/net/c/213f5f8f31f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


