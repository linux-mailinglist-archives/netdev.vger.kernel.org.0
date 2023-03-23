Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43206C5D85
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjCWDvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCWDub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:50:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DF5303E1;
        Wed, 22 Mar 2023 20:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D96F3B81D52;
        Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84B1FC433D2;
        Thu, 23 Mar 2023 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679543418;
        bh=DIA+JARayck8Z2S9fORdjqHPp2ZTncELzRmEMDcShiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lWdjR7+wYEKg5VgT+XkFPmhVwZ3iW+3fguz8wVlDd2UEBLtdG4UOwnvcRpZWGDRq+
         gC3loRDx577EoDBgsn3mY1nkJRTBRVO6Z1wHHdPctM2yDr4xZfUZf+WtuC8Ek+Rz/Y
         dAjqEN3AmuS6SUxKERCazWrAUUXFXplkmjOedWiDazh17Fjn2K5KK/xvqjNWqJhA8Q
         Kq+4bD69i1FZmT/MPIpSi7+yh1mBFalCzdolY/rvI/T/ktJZl0BJUdAiwrAq1sj56U
         FcSUddvu6pUSeTcTf8gA+85oiJ0wPj5osTvVlIKWPHqrOjxeogYbmmwWYLSOAggKC9
         +24BiWR73ftzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6170DE61B85;
        Thu, 23 Mar 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: fix aggregate RMON counters not showing the
 ranges
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954341839.25225.7175104804585958844.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 03:50:18 +0000
References: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230321232831.1200905-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, claudiu.manoil@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Mar 2023 01:28:31 +0200 you wrote:
> When running "ethtool -S eno0 --groups rmon" without an explicit "--src
> emac|pmac" argument, the kernel will not report
> rx-rmon-etherStatsPkts64to64Octets, rx-rmon-etherStatsPkts65to127Octets,
> etc. This is because on ETHTOOL_MAC_STATS_SRC_AGGREGATE, we do not
> populate the "ranges" argument.
> 
> ocelot_port_get_rmon_stats() does things differently and things work
> there. I had forgotten to make sure that the code is structured the same
> way in both drivers, so do that now.
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: fix aggregate RMON counters not showing the ranges
    https://git.kernel.org/netdev/net/c/c79493c3ccf0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


