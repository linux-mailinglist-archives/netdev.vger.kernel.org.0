Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649F45A26D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhKWMXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhKWMXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3522761074;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670012;
        bh=WkMO/VMiXOj+84qMj03vbdqlOhNSkofdGwOvZuJXn/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IelQCPjNJh6o8c831CPR9KkWYND4MbVWQldSpA7LX4FXbJhNLp+i/2gtthv2KsYQp
         CbLlD+3aXEy0rEggVbnxdLCHyZI5NYuG/oFAdD8NVyky2HuT9/CHJc6e7udgMWtUhk
         +htHELQSjh4cF5SkpeglZmSMPAevAvd6k1FrU3Ubpu4YIqpRglwCMXoOtaGfSe10Ub
         CdqB/dsEpv5Y/Ns1SYYmAQJjeljRwekB3b6gQelKh5xVvX1an2g0cKZfCbK1TTGdUx
         pcV/W5N3DloOk0lQOGl+jEq6I1NsL2WtI4rEp4sAzFKgSldzHtvoAH/DnIp+YuW++M
         nTkw+ibK7Bqtg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2ED0B609BB;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 0/2] Add mirror and LAG support to qca8k
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001218.10565.2058417522678749662.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:12 +0000
References: <20211123025911.20987-1-ansuelsmth@gmail.com>
In-Reply-To: <20211123025911.20987-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 03:59:09 +0100 you wrote:
> With the continue of adding 'Multiple feature to qca8k'
> 
> The switch supports mirror mode and LAG.
> In mirror mode a port is set as mirror and other port are configured
> to both igress or egress mode. With no port configured for mirror,
> the mirror port is disabled and reverted to normal port.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: qca8k: add support for mirror mode
    https://git.kernel.org/netdev/net-next/c/2c1bdbc7e756
  - [net-next,2/2] net: dsa: qca8k: add LAG support
    https://git.kernel.org/netdev/net-next/c/def975307c01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


