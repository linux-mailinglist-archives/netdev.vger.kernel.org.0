Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF25444074
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhKCLWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231491AbhKCLWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 07:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 203C1610EA;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635938409;
        bh=mJGG4cE/wHQFJxHcwDUf4oWQwsj3TyVtHJH7GdZdg5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nha3l2BxAUhaojZDwhxxhBMIKOkIKG8Lp3EuoQhGcttdKhx8QCoeT50zC9NNBWuTx
         ttQtnMwfoPxA9qEZNGEZ8S7pCHuXuMxHGIySbcEuhm1xiumtTLZvAJh6PmR+VTCusm
         U9ykHbH6WdL4TfDEmCHl0wNQwy8lX5o9AkIFvKlzIHdfvIvxkznWI1b1So/9fCXmMy
         hBCsj9cs7sD/cKZnuhq5389SlByIJ1CUon59ZtZCdVF2m4fq5N+vYdgVrgw8CxZmby
         2VBkMyirjne7J3Qcabvp2qWHG+zh0CMNSvMffZj+fJf8cfq+LFNVpvTSYum4rsEDYS
         3SFI9iBZ7HiMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1194D60176;
        Wed,  3 Nov 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net 0/5] kselftests/net: add missed tests to Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163593840906.17756.7345679624784356310.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 11:20:09 +0000
References: <20211103024459.224690-1-liuhangbin@gmail.com>
In-Reply-To: <20211103024459.224690-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        andrea.mayer@uniroma2.it, lixiaoyan@google.com,
        paolo.lungaroni@uniroma2.it, pabeni@redhat.com, toke@redhat.com,
        linux-kselftest@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 Nov 2021 10:44:54 +0800 you wrote:
> When generating the selftest to another folder, some tests are missing
> as they are not added in Makefile. e.g.
> 
>   make -C tools/testing/selftests/ install \
>       TARGETS="net" INSTALL_PATH=/tmp/kselftests
> 
> These pathset add them separately to make the Fixes tags less. It would
> also make the stable tree or downstream backport easier.
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net,1/5] kselftests/net: add missed icmp.sh test to Makefile
    https://git.kernel.org/netdev/net/c/ca3676f94b8f
  - [PATCHv3,net,2/5] kselftests/net: add missed setup_loopback.sh/setup_veth.sh to Makefile
    https://git.kernel.org/netdev/net/c/b99ac1841147
  - [PATCHv3,net,3/5] kselftests/net: add missed SRv6 tests
    https://git.kernel.org/netdev/net/c/653e7f19b4a0
  - [PATCHv3,net,4/5] kselftests/net: add missed vrf_strict_mode_test.sh test to Makefile
    https://git.kernel.org/netdev/net/c/8883deb50eb6
  - [PATCHv3,net,5/5] kselftests/net: add missed toeplitz.sh/toeplitz_client.sh to Makefile
    https://git.kernel.org/netdev/net/c/17b67370c38d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


