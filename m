Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9290488109
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiAHDKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiAHDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDD0C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 483B8B827F7
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4544C36AF2;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641611410;
        bh=4fP2amx6l6A3UZBG5Q8eIPPx1rprGQOlc1ugPxhSk2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JrxsC07yVeBaign1Yamf/rJe70+VnAi8QMgInf9EHo8uT49AXtGE7dyaYZy0POMGM
         P4ATl6a8NtTPWdWPFOncVYmYXJklZ5hA2rhKAiyPh8ognjcILSb2L7c8WYWoGhFALt
         AFeHsTsKXIpU1oEex5jUdvURwFPPi6Fy1634oVtsAtky3RIicC9Eq3t+ALQCggmPNZ
         xRLBBO0J1sH/jT6veyEjQOJxy0eAQHMyO87h37ueDYxMZ+/fLPTrl7k8LFuEBGMg/z
         F1cWZKpIG/MYo/6vlvQCtfx/MLNTi7NihImKvFXCOzajptHvk2AlNecLTQF2elIjY5
         3ymDY/xG9CQWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C36D1F79401;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: mscc: ocelot: fix incorrect balancing with
 down LAG ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161141079.29029.4081900562686606337.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:10:10 +0000
References: <20220107164332.402133-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220107164332.402133-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 18:43:32 +0200 you wrote:
> Assuming the test setup described here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/
> (swp1 and swp2 are in bond0, and bond0 is in a bridge with swp0)
> 
> it can be seen that when swp1 goes down (on either board A or B), then
> traffic that should go through that port isn't forwarded anywhere.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: mscc: ocelot: fix incorrect balancing with down LAG ports
    https://git.kernel.org/netdev/net-next/c/a14e6b69f393

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


