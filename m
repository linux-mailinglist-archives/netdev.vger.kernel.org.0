Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDBC3E3A12
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhHHMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbhHHMAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 412A66105A;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424006;
        bh=0rPFTeCglxE5PhGXHBRIfxjljlrPUV3qvyTh7X//HEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hIxU27FzRETKJk3BkgO0Yp3Z2K6CRn3rdwt4CBe1bkhoHJbKEcF1rXL0lCZITqG7n
         SYpJTHaAoiJovLdQ6t8hPSItP9CUu5zEFLeaS4/r8h2XaJRJzYzzu60bl6qVfZfGvo
         vzk+7rQGz5CG5B++XxfO5XVCkojRahrQP+9VYEUi/IlUWELkv43QIS/u8qrcUkh4kx
         JR1Cg7EfhnBP06xob3/+WnNUdNOxoZDtUWaxMy4e7K7TWOHhvxicnjrsFkmh7h2ZIk
         hhdy7Y6UAtRselR6SNbEQF4M0VN34Rv1btLXOKPEeJMpaeyyPaIJ0KlIEP5Ks3hOO6
         5gqIIjOKzgZpg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37DDD6096D;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: don't fast age standalone ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842400622.17847.7414298564279667332.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:00:06 +0000
References: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210808111637.3819465-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  8 Aug 2021 14:16:37 +0300 you wrote:
> DSA drives the procedure to flush dynamic FDB entries from a port based
> on the change of STP state: whenever we go from a state where address
> learning is enabled (LEARNING, FORWARDING) to a state where it isn't
> (LISTENING, BLOCKING, DISABLED), we need to flush the existing dynamic
> entries.
> 
> However, there are cases when this is not needed. Internally, when a
> DSA switch interface is not under a bridge, DSA still keeps it in the
> "FORWARDING" STP state. And when that interface joins a bridge, the
> bridge will meticulously iterate that port through all STP states,
> starting with BLOCKING and ending with FORWARDING. Because there is a
> state transition from the standalone version of FORWARDING into the
> temporary BLOCKING bridge port state, DSA calls the fast age procedure.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: don't fast age standalone ports
    https://git.kernel.org/netdev/net-next/c/39f32101543b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


