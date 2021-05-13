Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C61380086
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhEMWvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhEMWvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 18:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E4DE6143D;
        Thu, 13 May 2021 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946212;
        bh=ogiDbGpL6jzQFZeSq3khfOSqBHfA7DpwytczL2J4Q9s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SLqczQImCQEe5zkJkK9VgafZpQyc+d5dV5wHa2+DkUz7XZNh/5NU+I92Q6UbaNTsf
         GMOKqDRNmiXAQYWShStp0/So1O5GTpfRBGoYwwWyeLQga9m0cPle6GBS24zJERKdBE
         AcZOAPZSMcHpwrFKotc5VNKl3yWtpaxYIazgr9sMFaOyJqmIYDfjUx35JW9fArYcUN
         WIxnrNnHZuLPW3kUqGYJhWfb0Pw+lVxJBEkl61r9MrzpOuyf+cruT7yNxvAy+Fod2O
         wLmWYum4CRrYLjaBkcF7Xq2q89LV5qxelj7e1xf+d1G/Z27ZukhID/Un91qVHXRE8/
         aRzmAU75IF0Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1937460A4D;
        Thu, 13 May 2021 22:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] atl1c: support for Mikrotik 10/25G NIC
 features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094621209.964.2203616230195452447.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 22:50:12 +0000
References: <20210513114326.699663-1-gatis@mikrotik.com>
In-Reply-To: <20210513114326.699663-1-gatis@mikrotik.com>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 13 May 2021 14:43:21 +0300 you wrote:
> The new Mikrotik 10/25G NIC maintains compatibility with existing atl1c
> driver. However it does have new features.
> 
> This patch set adds support for reporting cards higher link speed, max-mtu,
> enables rx csum offload and improves tx performance.
> 
> v2:
>     - fixed xmit_more handling as pointed out by Eric Dumazet
>     - added a more reliable link detection on Mikrotik 10/25G NIC
>       since MDIO op emulation can occasionally fail
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] atl1c: show correct link speed on Mikrotik 10/25G NIC
    https://git.kernel.org/netdev/net-next/c/f19d4997fd1f
  - [net-next,v2,2/5] atl1c: improve performance by avoiding unnecessary pcie writes on xmit
    https://git.kernel.org/netdev/net-next/c/d7ab6419bdee
  - [net-next,v2,3/5] atl1c: adjust max mtu according to Mikrotik 10/25G NIC ability
    https://git.kernel.org/netdev/net-next/c/545fa3fb1e84
  - [net-next,v2,4/5] atl1c: enable rx csum offload on Mikrotik 10/25G NIC
    https://git.kernel.org/netdev/net-next/c/b0390009502b
  - [net-next,v2,5/5] atl1c: improve link detection reliability on Mikrotik 10/25G NIC
    https://git.kernel.org/netdev/net-next/c/ea0fbd05d7bd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


