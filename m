Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312BA33E134
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCPWK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhCPWKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 27D3964E86;
        Tue, 16 Mar 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615932608;
        bh=yHyXcIk35VgTHeKnskAF1Jri2H7ZYmTuRWq372ITctI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kzL7HCYE+e93H62Cn/RoCBvxQ5pIpLPZUQH0Iae0kkyYY/YEwWFlKY/nsrHkv7d5t
         E6hqBkpkw7tSL5fbZEoohYk7lOqpfFi1ob1AgRd2YVSFWPXSx0PF9G85ars6ly6Wmd
         a00QAMIXDKHSWzxvtfAy+oknJBT3UwsPEQJC2lVxRHxCPvTwYb4pw7QILlXUYPRjyq
         Jw95sxGFfYjlLmz3OLjDC5ANY+EunFhCxY60cwQDVwjU6w/CKLicY+KytLJbGhcHO5
         ZvNHV/5c5jaGSDwQyXeL2QvR2O/RZ+jtRVdSXpw3BeQBZLeeHmDXDYrV3LtGYtTW6S
         RvBNMdGGc0+TA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 220CF60965;
        Tue, 16 Mar 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-03-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593260813.31300.14807554720705655276.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:10:08 +0000
References: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210316031659.3695692-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, kai.heng.feng@canonical.com,
        rjw@rjwysocki.net, len.brown@intel.com, todd.e.brandt@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        yu.c.chen@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 20:16:57 -0700 you wrote:
> This series contains updates to e1000e only.
> 
> Chen Yu says:
> 
> The NIC is put in runtime suspend status when there is no cable connected.
> As a result, it is safe to keep non-wakeup NIC in runtime suspended during
> s2ram because the system does not rely on the NIC plug event nor WoL to
> wake up the system. Besides that, unlike the s2idle, s2ram does not need to
> manipulate S0ix settings during suspend.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] e1000e: Leverage direct_complete to speed up s2ram
    https://git.kernel.org/netdev/net-next/c/ccf8b940e5fd
  - [net-next,v2,2/2] e1000e: Remove the runtime suspend restriction on CNP+
    https://git.kernel.org/netdev/net-next/c/3335369bad99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


