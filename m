Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF96691670
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBJCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBJCAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FABB59EC
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC185B823B7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FE10C433D2;
        Fri, 10 Feb 2023 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675994418;
        bh=yVHRUc8PUE1BXSCnoQCP489+Vl+R2y+ScGbm3qRg/YA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XM4eVNTxa53wOlFBiJ7lI/9MUl6+pjx2Ob28ZLQ7cqm/UbCikdrohTnwtfegsxqqb
         dIyZz+9ftoZ+A/tCdSxDp40GRXDpRvOG7zl5G/dhOoL9SQQC5F9kCIOxovcRp/mMBE
         Zn/xgxcXNpllFf+JWu16QSfkaPhi0wGlCTO2/BlI5FYXIi8PAjhlnv/iLdPI+iRDIK
         sb9YYU7vs2Lbi6UMmDxAszCnHSQH3MdrPRAYrBqWV9ZnuSgldPNWBFD8xBu1A/3OvJ
         TWlqfKVGhx+dTU9HBKdvrqc/32rnU1/ll3Lyo5YftePnfDoyFhtc9J7UJG5g6moeBt
         UX2Mihqpr2n9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67F0BE21EC9;
        Fri, 10 Feb 2023 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/4] net: introduce rps_default_mask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167599441842.20637.18193994604882592103.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 02:00:18 +0000
References: <cover.1675789134.git.pabeni@redhat.com>
In-Reply-To: <cover.1675789134.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, corbet@lwn.net, shuah@kernel.org
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

On Tue,  7 Feb 2023 19:44:54 +0100 you wrote:
> Real-time setups try hard to ensure proper isolation between time
> critical applications and e.g. network processing performed by the
> network stack in softirq and RPS is used to move the softirq
> activity away from the isolated core.
> 
> If the network configuration is dynamic, with netns and devices
> routinely created at run-time, enforcing the correct RPS setting
> on each newly created device allowing to transient bad configuration
> became complex.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/4] net-sysctl: factor out cpumask parsing helper
    https://git.kernel.org/netdev/net-next/c/135746c61fa6
  - [v4,net-next,2/4] net-sysctl: factor-out rpm mask manipulation helpers
    https://git.kernel.org/netdev/net-next/c/370ca718fd5e
  - [v4,net-next,3/4] net: introduce default_rps_mask netns attribute
    https://git.kernel.org/netdev/net-next/c/605cfa1b1090
  - [v4,net-next,4/4] self-tests: introduce self-tests for RPS default mask
    https://git.kernel.org/netdev/net-next/c/c12e0d5f267d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


