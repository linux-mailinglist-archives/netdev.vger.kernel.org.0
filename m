Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64675441BDB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhKANmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232323AbhKANml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A9C3161051;
        Mon,  1 Nov 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635774008;
        bh=cQmBYeNBc2IM8+16lz28v3iVZb2qnxjRj1wy6vfXPno=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kHOmdnuluCFGl6SGbVZUg2rjP7gJqzHOnJ3cuprSItznccVzy8c2C9zr3GnYzGVE5
         modt5th23xqRE1ToLj3jlw9Xn3eHZ2+7dIKcPX3OgszL3C9nN6d7zd6AkKlKfhpuGg
         kIedmnibExMtKDdc45S5tpe4KWE3oMq1Ek1qoeAoeBEhrELyweLws39N+L0kwfaQbH
         lbfKexy/a0efGKBsC7Ajk0FzNEzykauBNEDKfzq7z8DwCXheCIeuXb4lmWUmU+w7mA
         FYfY8rvuRtg+iQnc8/a2Yc/6Awxv66FNDagiwhjg6RNcV57hcuchpS1q5hUyC4Qbdb
         sNCucqKnlSOUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9914C60A94;
        Mon,  1 Nov 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] netdevsim: improve separation between device
 and bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577400862.7648.12142216089187411154.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:40:08 +0000
References: <20211030231505.2478149-1-kuba@kernel.org>
In-Reply-To: <20211030231505.2478149-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 30 Oct 2021 16:15:00 -0700 you wrote:
> VF config falls strangely in between device and bus
> responsibilities today. Because of this bus.c sticks fingers
> directly into struct nsim_dev and we look at nsim_bus_dev
> in many more places than necessary.
> 
> Make bus.c contain pure interface code, and move
> the particulars of the logic (which touch on eswitch,
> devlink reloads etc) to dev.c. Rename the functions
> at the boundary of the interface to make the separation
> clearer.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] netdevsim: take rtnl_lock when assigning num_vfs
    https://git.kernel.org/netdev/net-next/c/26c37d89f61d
  - [net-next,v2,2/5] netdevsim: move vfconfig to nsim_dev
    https://git.kernel.org/netdev/net-next/c/5e388f3dc38c
  - [net-next,v2,3/5] netdevsim: move details of vf config to dev
    https://git.kernel.org/netdev/net-next/c/1c401078bcf3
  - [net-next,v2,4/5] netdevsim: move max vf config to dev
    https://git.kernel.org/netdev/net-next/c/a3353ec32554
  - [net-next,v2,5/5] netdevsim: rename 'driver' entry points
    https://git.kernel.org/netdev/net-next/c/a66f64b80815

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


