Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F2664681E
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLHEK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiLHEKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186BE8C6BC
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 20:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC79CB8227F
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F54BC433D7;
        Thu,  8 Dec 2022 04:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670472619;
        bh=s4bA1inXYla9p7PtsuzzOXy6cf0Zl73yymnPyZJZj60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PiRCdQ8SYQ84tPVZCJxMAhcQNpFaVhZfeei7F6b75jF2L1c2doShvPSEKs1md0s8R
         N1QQIf6O9/d5N5l/cex+RY8ZQXHA4zgS/K3dg2PeVuie+mUH7rLGshO4mM8sDf2jQq
         CTLU/TKBVCSR5M9C620P978x4b7xsu7O4p0/4eNPN5gclLjitC8OjNfUtcvmEC/sOh
         d0p9GHI3d7JIQ7Ehm85JwlJ2wLl7TsHYEnWV+bQkVmIAaP8Sm8aAEV3HEHvUYzJ5L8
         fJLnXIfOZ43nRdBym2Mnp9zcxePMCC/kELi6CpHDbRAJ1T3FvHrRGL7IMt2Vjv+qMV
         mCpRqAISPHRFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88C3BC395EA;
        Thu,  8 Dec 2022 04:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] bridge: mcast: Preparations for EVPN
 extensions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167047261955.18861.1757446402375104183.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 04:10:19 +0000
References: <20221206105809.363767-1-idosch@nvidia.com>
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Dec 2022 12:58:00 +0200 you wrote:
> This patchset was split from [1] and includes non-functional changes
> aimed at making it easier to add additional netlink attributes later on.
> Future extensions are available here [2].
> 
> The idea behind these patches is to create an MDB configuration
> structure into which netlink messages are parsed into. The structure is
> then passed in the entry creation / deletion call chain instead of
> passing the netlink attributes themselves. The same pattern is used by
> other rtnetlink objects such as routes and nexthops.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] bridge: mcast: Centralize netlink attribute parsing
    https://git.kernel.org/netdev/net-next/c/cb453926865e
  - [net-next,v2,2/9] bridge: mcast: Remove redundant checks
    https://git.kernel.org/netdev/net-next/c/386611681524
  - [net-next,v2,3/9] bridge: mcast: Use MDB configuration structure where possible
    https://git.kernel.org/netdev/net-next/c/f2b5aac68117
  - [net-next,v2,4/9] bridge: mcast: Propagate MDB configuration structure further
    https://git.kernel.org/netdev/net-next/c/8bd9c08e3241
  - [net-next,v2,5/9] bridge: mcast: Use MDB group key from configuration structure
    https://git.kernel.org/netdev/net-next/c/9f52a5142979
  - [net-next,v2,6/9] bridge: mcast: Remove br_mdb_parse()
    https://git.kernel.org/netdev/net-next/c/3ee5662345f2
  - [net-next,v2,7/9] bridge: mcast: Move checks out of critical section
    https://git.kernel.org/netdev/net-next/c/4c1ebc6c1f21
  - [net-next,v2,8/9] bridge: mcast: Remove redundant function arguments
    https://git.kernel.org/netdev/net-next/c/090149eaf391
  - [net-next,v2,9/9] bridge: mcast: Constify 'group' argument in br_multicast_new_port_group()
    https://git.kernel.org/netdev/net-next/c/f86c3e2c1b5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


