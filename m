Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28264395B5
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhJYMMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231699AbhJYMMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B3516103C;
        Mon, 25 Oct 2021 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163815;
        bh=NjhtS3knLLm/CN2ModPzCERl04jdcfAWyDzVKRS0eks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRa8z2O/WOBZOn7TAgzbELvVWKfo5AbSNXHr7qb+EAoFUeYJm10b4VJz4q6rq75r9
         A+9mM7v2pTBeERC4wbt3tm8HmLzNwZ8BG1G4Tt9n5gbixVpyessP3f3dR9wQ2YoADp
         +2f9HWrqmVtWwegi56u5+MZKdo23GHR+11khFRlvvf6fHL84fbXMOpANqAq1FoIeMc
         uob5pA5Rq2EMMwZMWdxzqknPrxcuT2SrmnO9V1cYSqHi13n6A4rK01uuzizxxAOOq6
         RyUgW49WInZe/6tK5/migM6KXw5j1W6Jw+xnnCO1qFUKVjWFCsc7M46D93HP7cmdUe
         MhfB4k8Cb8prw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F020E60BD0;
        Mon, 25 Oct 2021 12:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/10] Drop rtnl_lock from DSA .port_fdb_{add,del}
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516381497.1029.795808307516282716.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 12:10:14 +0000
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, UNGLinuxDriver@microchip.com, dqfext@gmail.com,
        kurt@linutronix.de, hauke@hauke-m.de, woojung.huh@microchip.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        alexandre.belloni@bootlin.com, george.mccollister@gmail.com,
        john@phrozen.org, olek2@wp.pl, privat@egil-hjelmeland.no,
        o.rempel@pengutronix.de, prasanna.vengateshan@microchip.com,
        ansuelsmth@gmail.com, alsi@bang-olufsen.dk, claudiu.manoil@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 20:17:47 +0300 you wrote:
> As mentioned in the RFC posted 2 months ago:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210824114049.3814660-1-vladimir.oltean@nxp.com/
> 
> DSA is transitioning to a driver API where the rtnl_lock is not held
> when calling ds->ops->port_fdb_add() and ds->ops->port_fdb_del().
> Drivers cannot take that lock privately from those callbacks either.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/10] net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
    https://git.kernel.org/netdev/net-next/c/232deb3f9567
  - [v5,net-next,02/10] net: dsa: sja1105: wait for dynamic config command completion on writes too
    https://git.kernel.org/netdev/net-next/c/df405910ab9f
  - [v5,net-next,03/10] net: dsa: sja1105: serialize access to the dynamic config interface
    https://git.kernel.org/netdev/net-next/c/eb016afd83a9
  - [v5,net-next,04/10] net: mscc: ocelot: serialize access to the MAC table
    https://git.kernel.org/netdev/net-next/c/2468346c5677
  - [v5,net-next,05/10] net: dsa: b53: serialize access to the ARL table
    https://git.kernel.org/netdev/net-next/c/f7eb4a1c0864
  - [v5,net-next,06/10] net: dsa: lantiq_gswip: serialize access to the PCE registers
    https://git.kernel.org/netdev/net-next/c/cf231b436f7c
  - [v5,net-next,07/10] net: dsa: introduce locking for the address lists on CPU and DSA ports
    https://git.kernel.org/netdev/net-next/c/338a3a4745aa
  - [v5,net-next,08/10] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
    https://git.kernel.org/netdev/net-next/c/5cdfde49a07f
  - [v5,net-next,09/10] selftests: lib: forwarding: allow tests to not require mz and jq
    https://git.kernel.org/netdev/net-next/c/d70b51f2845d
  - [v5,net-next,10/10] selftests: net: dsa: add a stress test for unlocked FDB operations
    https://git.kernel.org/netdev/net-next/c/edc90d15850c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


