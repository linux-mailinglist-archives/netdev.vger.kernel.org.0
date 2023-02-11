Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3912C692E2C
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBKEA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjBKEA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:00:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6F18128C;
        Fri, 10 Feb 2023 20:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F0E61F1D;
        Sat, 11 Feb 2023 04:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11F9DC433A1;
        Sat, 11 Feb 2023 04:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088024;
        bh=6OFgI2L+KduKRVNbwLP7A1bRHnsmiMztHE4HiC/Fa54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=txQuVW25oHLxRHc1J+a8EuR5VXBaPzWImrbzW2WqQz/fU2G3ucOdAXWkQSqIECJsR
         1oYsXGlZgGnZ/XCLMmyL8jNgsTaFUpwivvcDZKics67vGALOWl1K8tWV5GWVdEFynO
         v7DCUvH6GqL9xJQOY84fwF09C4GH9twDqb0fbD36yv5vmEK9hDF/OGocL0RqET2wKr
         cwNpKiNuDfqhuVw5x1Bf7kf7gonziGnioeU3aJzZ58Jil4ZqcAb312isGXXPUVCiE5
         0W9gUUkapntK0Kdkd10Ps5Z+yqaC+D4Dm44XhzaMXiniD5uo13uLbKoR/3WJMTkrvC
         mT3gkPXINHLbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAB0BE29F47;
        Sat, 11 Feb 2023 04:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: renesas: rswitch: Improve TX timestamp
 accuracy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608802389.32607.1713467175785166563.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 04:00:23 +0000
References: <20230209081741.2536034-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230209081741.2536034-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
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

On Thu,  9 Feb 2023 17:17:37 +0900 you wrote:
> This patch series is based on next-20230206.
> 
> The patch [[123]/4] are minor refacoring for readability.
> The patch [4/4] is for improving TX timestamp accuracy.
> To improve the accuracy, it requires refactoring so that this is not
> a fixed patch.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
    https://git.kernel.org/netdev/net-next/c/251eadcc640a
  - [net-next,v3,2/4] net: renesas: rswitch: Move linkfix variables to rswitch_gwca
    https://git.kernel.org/netdev/net-next/c/e3f38039c681
  - [net-next,v3,3/4] net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
    https://git.kernel.org/netdev/net-next/c/48cf0a25702b
  - [net-next,v3,4/4] net: renesas: rswitch: Improve TX timestamp accuracy
    https://git.kernel.org/netdev/net-next/c/33f5d733b589

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


