Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680764BB100
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiBRFAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:00:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiBRFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:00:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A432BAA00
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB2161E73
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 365C1C340F4;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645160412;
        bh=5zS3EgS+KrA2y/G73nxdAfZKq2YZoeKk5kDfYsTX5eY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PX6qSvSInw66RtW6dI54defotQzFDOUmV7vpctkcDNpMoJ+cwahLfAv6A7QQgzsWW
         0rh9iGIrczNmt2BA/OGUKMFxn7negxaF2DwNS7TfiSS3B5vWLdgTp3iZnwhXiTICcJ
         ENoRpNjnGohLz+rXkncAmF911ZRoWd0Rr6PP3GehtRKDRysa+C/rgcBhpZ9Re8vA3n
         UcNBbFwDhQkloT8f/9Y6Z318arV6L8m/+zcauPeE8cHvWjvkOA0PKguGvlVllkrEC8
         FGEIq4/m9DbinN7KEWyGtlkUR/OzI7FIYtug4EUFoMGRXoU92IlQ01L0R9Bgtq1Jsr
         f4YAWoE+H3jEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C8A0E7BB0C;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: delete unused exported symbols for ethtool
 PHY stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164516041210.28752.2846923956003975222.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 05:00:12 +0000
References: <20220216193726.2926320-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220216193726.2926320-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 21:37:26 +0200 you wrote:
> Introduced in commit cf963573039a ("net: dsa: Allow providing PHY
> statistics from CPU port"), it appears these were never used.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/dsa.h |  3 ---
>  net/dsa/port.c    | 57 -----------------------------------------------
>  2 files changed, 60 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: delete unused exported symbols for ethtool PHY stats
    https://git.kernel.org/netdev/net-next/c/d2b1d186ce2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


