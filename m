Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7BD3C7952
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhGMWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 18:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhGMWCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 18:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D954361370;
        Tue, 13 Jul 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626213603;
        bh=3rgNfRAjZVmDU4OL3BJbAK+eKafZmVKBU5ESiMdWrfQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mwiRsmxZHQVxZ6zp5JL8q0lmjBWKpHDXVG36zEoie7DVa7LyvCUJIXJRYRiXTffbJ
         6H28rmRchd1ZibcDhQoFB5HLUzQv29jt0MujqrQi6+JHYegGXYCkjt7ZwD3rNk6had
         +/WEVqVih2E+y+Lj0qDuElTqm5HjzVNRtvddI6n6xQqrP4HCYYYal/U17BSDM5PVOg
         8c8yah0Zj+jn9Dsji34reph/TC9BkBR9gh3uqbqr1iafsoj219Id34kD+ZxvJh6rIU
         M3iAu0O+s1pTWeowHG0L///24cM+La+DYgJzFCb6Hir6kCabzatZesTZhTc2wSOvbh
         YSy2HAHyZPDrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD95460A0C;
        Tue, 13 Jul 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: properly check for the bridge_leave methods in
 dsa_switch_bridge_leave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162621360383.5024.12135940843478792798.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Jul 2021 22:00:03 +0000
References: <20210713094021.941201-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210713094021.941201-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 13 Jul 2021 12:40:21 +0300 you wrote:
> This was not caught because there is no switch driver which implements
> the .port_bridge_join but not .port_bridge_leave method, but it should
> nonetheless be fixed, as in certain conditions (driver development) it
> might lead to NULL pointer dereference.
> 
> Fixes: f66a6a69f97a ("net: dsa: permit cross-chip bridging between all trees in the system")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()
    https://git.kernel.org/netdev/net/c/bcb9928a1554

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


