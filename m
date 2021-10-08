Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9327442741B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243795AbhJHXWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 19:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhJHXWD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 19:22:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA30860FA0;
        Fri,  8 Oct 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633735208;
        bh=I6DxrsIzm1c9ClUZq6AReVAqCoc0SK9fF6LQyYo2wLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U468bteuJDYjA3YLZqQ3bQ6JhW0oTZCEbjE8pNURH8lwnU/KtIsmEUUgohgsN/otA
         PV3IqClEe4TnFnW+i2fSEjjWsSsYW4ZNpi66HjblRUbPzG/Qqw5bv1xBXnDEvKTQF3
         yUAwzXp8UvG5Flw/hJsr5xCmYaW1WhoP+6PDajLW/dpe3H0BOUjdEwkeJwYKI40Q7e
         Bix/WDyyX6gJ7ylSSuUnNZjcvymCYnRlvcb4Zz7+NwDReGSZiIDCVZy80BJ6v7Yk2z
         77QUKaAivY0JO3GxKBo0VcyZKhGpoa0KmJW7b718my+IB7ycB835zV7Syx2EPNbbt4
         4l1x8h3007EkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE38A60A38;
        Fri,  8 Oct 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/4] DSA bridge TX forwarding offload fixes - part 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373520790.13788.6202290638163809372.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 23:20:07 +0000
References: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tobias@waldekranz.com, dqfext@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Oct 2021 19:47:07 +0300 you wrote:
> This is part 1 of a series of fixes to the bridge TX forwarding offload
> feature introduced for v5.15. Sadly, the other fixes are so intrusive
> that they cannot be reasonably be sent to the "net" tree, as they also
> include API changes. So they are left as part 2 for net-next.
> 
> Changes in v2:
> More patches at Tobias' request.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/4] net: dsa: fix bridge_num not getting cleared after ports leaving the bridge
    https://git.kernel.org/netdev/net/c/1bec0f05062c
  - [v3,net,2/4] net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware bridges using VID 0
    https://git.kernel.org/netdev/net/c/c7709a02c18a
  - [v3,net,3/4] net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
    https://git.kernel.org/netdev/net/c/8b6836d82470
  - [v3,net,4/4] net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports
    https://git.kernel.org/netdev/net/c/5bded8259ee3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


