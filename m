Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E548F9B2
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 23:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiAOWkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 17:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbiAOWkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 17:40:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E84C061574
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 14:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CC660F86
        for <netdev@vger.kernel.org>; Sat, 15 Jan 2022 22:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AC2FC36AE7;
        Sat, 15 Jan 2022 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642286409;
        bh=67k/AdtHO5NpEmRYXs1Ku02fERoyfB0z1mz62qXDDBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cts4+4ooakarNj/SyvEkIAc0AsXBrjn5VrlGcJTYLTzeFjLZPlG6lhpG5nSvlPdzs
         m6Xg/+n9zPn/1SO0C8HOq2Bb+a/59sJSi9Z68nSoqQkVSmqmbjSUH+1LD+o74xuob+
         VdCoSv/Qdg3mGnwBMLj1HeFiIR8RfYdcPVghrq9FIdd2HIAd6viUWgLlLuyh22zoft
         dPMOwwyizfkHRcI/gacmTvafzyQzatmpWw1S2lw5S89QPS4mz/2oPoCOMue1hEyi7J
         G96fIKJlyhxOSOg+0A+C7g/YClBPg78XKy6VONCEADU3gnXWIWBjCC3LXdRtnT+1WP
         aHYBBXER11pBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8200AF6079A;
        Sat, 15 Jan 2022 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mscc: ocelot: don't dereference NULL pointers with
 shared tc filters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164228640952.24744.16963221857808664947.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 22:40:09 +0000
References: <20220114133637.3781271-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220114133637.3781271-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 15:36:37 +0200 you wrote:
> The following command sequence:
> 
> tc qdisc del dev swp0 clsact
> tc qdisc add dev swp0 ingress_block 1 clsact
> tc qdisc add dev swp1 ingress_block 1 clsact
> tc filter add block 1 flower action drop
> tc qdisc del dev swp0 clsact
> 
> [...]

Here is the summary with links:
  - [net] net: mscc: ocelot: don't dereference NULL pointers with shared tc filters
    https://git.kernel.org/netdev/net/c/80f15f3bef9e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


