Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1A73F72D4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbhHYKVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238783AbhHYKUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:20:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E15EF61181;
        Wed, 25 Aug 2021 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629886808;
        bh=TMVIOQGKX9rDKi9mEJtwQevZno6SE1kvisi9NxHV8Tk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Alr+AuOG6+V0MZwLJYS1QczUrv9CgqPugsrIr6qJCls1pN5UsGz3IXIOrFEAYqB/z
         04ewRQ1yONlZTm6wVofMbET1VA9W0br3vxZvQz5C/8YKythHBu2WirC0rlxRvCfzew
         H/wz/51IqknN1pqzAzeTLjwzMhjToOx+X11Z6oIWKKRykbwpKiDmJvwLgp2kKB8iJO
         RRkKoOGuAwvjg7OJdBSRuLmjK1YFu4Ejbaxc1cqeXedqGzUxk0oL7yD9xf7aOciV2J
         Z05w8aRxectuY6Seebb4GxDjkwMOMeRNEubH5g5vuE5v2SeebAZnCNrKeG6QYIbtMz
         83jIoA3jbAPAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DB88160A0C;
        Wed, 25 Aug 2021 10:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Make sja1105 treat tag_8021q VLANs more like
 real DSA tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988680889.8958.5434578700591120496.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:20:08 +0000
References: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 20:14:59 +0300 you wrote:
> This series solves a nuisance with the sja1105 driver, which is that
> non-DSA tagged packets sent directly by the DSA master would still exit
> the switch just fine.
> 
> We also had an issue for packets coming from the outside world with a
> crafted DSA tag, the switch would not reject that tag but think it was
> valid.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: sja1105: prevent tag_8021q VLANs from being received on user ports
    https://git.kernel.org/netdev/net-next/c/73ceab832652
  - [net-next,2/3] net: dsa: sja1105: drop untagged packets on the CPU and DSA ports
    https://git.kernel.org/netdev/net-next/c/b0b8c67eaa5c
  - [net-next,3/3] net: dsa: tag_sja1105: stop asking the sja1105 driver in sja1105_xmit_tpid
    https://git.kernel.org/netdev/net-next/c/8ded9160928e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


