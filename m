Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18E43E26C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJ1Nmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhJ1Nmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1F0561108;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635428407;
        bh=zLg45tPH3YWCn+HpbPJFz48i4v70NOHcl/6yl8+8pEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cNu2aBgF9vNGiXQo9WNWEvprUQmL5zLXzIc/zPhzAWa70aJoSZpptOsPwT2/X7IA5
         XaDtWBhk+VnMI2FnaA4Qex+5KiM7V0za7BY1nXbo3okfRCVigulnadm0oEOV1vjSEQ
         3i8xZOsu00P0PFWlgYim6boNtZshk4jdahIcZuVncGQDY1WqlAZ4+3bd/Ued0hDMRY
         l8Q1nsmW0enXCUL6udlx6PnhItr4cAE68SvzmjNXBtBYWJ3Jj388F+v8gX9A7DFzft
         W5EVo4tUGEX0KejW30QeN7Lxe4zOz2c1dm8oqO3tNB+V58q438oFi7S5HyHxP191LV
         IqBHaYdxa3EvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC22C60A6B;
        Thu, 28 Oct 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ipconfig: Release the rtnl_lock while
 waiting for carrier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542840769.2633.15242995859268025107.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 13:40:07 +0000
References: <20211028131804.413243-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20211028131804.413243-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, linux@armlinux.org.uk,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        atenart@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 15:18:04 +0200 you wrote:
> While waiting for a carrier to come on one of the netdevices, some
> devices will require to take the rtnl lock at some point to fully
> initialize all parts of the link.
> 
> That's the case for SFP, where the rtnl is taken when a module gets
> detected. This prevents mounting an NFS rootfs over an SFP link.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ipconfig: Release the rtnl_lock while waiting for carrier
    https://git.kernel.org/netdev/net-next/c/ee046d9a22a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


