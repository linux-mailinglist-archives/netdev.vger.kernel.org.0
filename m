Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457E2692E05
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBKDkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBKDkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:40:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E67237555
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EB0DB826AD
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0392FC433A7;
        Sat, 11 Feb 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086820;
        bh=geDtyl2//P/lEiK7xB91DQEObY3k9tBV7LaVhtCjMUs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=un3NAbxfww0DNzcjxB6xt7xPayrxq0OryuMfpssfv9n3ekmesRQDh8PDnN1oQUmUp
         IGLFAp21NjKFN7f3Vv5NQ+KsIHnmSKpM8uIv+WxfrCbwkZzmig0uUvdA0mij8bHCIn
         EqIDunSAoRYd/jMSjdYpEgA+fEzjmq+SVEFSTHHfE6zsceq4l+Im2KKx5Hdh0lTk5y
         wwuLolu9klWm4hpY609jqd0fhZISWZbrdOS8jPr10zIscHONBE2YsclKWIH+Oca5Fe
         nUiSJcj70ywEF2OpoQFu/82MjNCatLMP6iHj/BvHyAe2TBR5VJLo5W1Z2n/aFxt6G5
         UzMXDS2/BZueg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0B99E55EFD;
        Sat, 11 Feb 2023 03:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] bridge: mcast: Preparations for VXLAN MDB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608681991.24732.16960157828156845932.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:40:19 +0000
References: <20230209071852.613102-1-idosch@nvidia.com>
In-Reply-To: <20230209071852.613102-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com
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

On Thu,  9 Feb 2023 09:18:48 +0200 you wrote:
> This patchset contains small preparations for VXLAN MDB that were split
> from this RFC [1]. Tested using existing bridge MDB forwarding
> selftests.
> 
> [1] https://lore.kernel.org/netdev/20230204170801.3897900-1-idosch@nvidia.com/
> 
> Ido Schimmel (4):
>   bridge: mcast: Use correct define in MDB dump
>   bridge: mcast: Remove pointless sequence generation counter assignment
>   bridge: mcast: Move validation to a policy
>   selftests: forwarding: Add MDB dump test cases
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] bridge: mcast: Use correct define in MDB dump
    https://git.kernel.org/netdev/net-next/c/ccd7f25b5b04
  - [net-next,2/4] bridge: mcast: Remove pointless sequence generation counter assignment
    https://git.kernel.org/netdev/net-next/c/7ea829664d3c
  - [net-next,3/4] bridge: mcast: Move validation to a policy
    https://git.kernel.org/netdev/net-next/c/170afa71e3a2
  - [net-next,4/4] selftests: forwarding: Add MDB dump test cases
    https://git.kernel.org/netdev/net-next/c/049139126ec7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


