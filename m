Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B9A524042
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348752AbiEKWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242945AbiEKWaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F7C20CDAE
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F194861D27
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FF7AC34119;
        Wed, 11 May 2022 22:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308213;
        bh=cYBkqyVlcyuMBAEmu7REbtYSdwXJwD4ffG2Bnf/Gsl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dpxbzl26E3bHjdQcuhTF9Fl/7X99xm1qAI/Qpoue8R8vBSnBugm9i+qq70KYlaLyP
         IRBT0TFB6vyWvhjxH5YPMAD5W6cZTD5ZYm/Mi246byTqSduRnwSWj4ecL/ZJUoZHMe
         qo0lxf2CSo/TxiYoJbQGhZLuuyEMWbz9WkF5/nrIQjpTsXgEwqTQtKFbJYPI3xkpqR
         r9SE5IiwX0FBVH5bKPS3ZJUDv41Gz7QXH6nZWjGC8hlitYLcmdfCS/hjZO3UHmvOIL
         qgC9ZqRnkZbhYEIV9SumbuPUfycvGfQzZw6Okh9vvjPq8QPoiEzf5fR6L/KIPep6Kk
         KNlVQqOHtnBbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A04BF03935;
        Wed, 11 May 2022 22:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: forwarding: tc_actions: allow mirred
 egress test to run on non-offloaded h2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165230821322.9762.15466410391107047291.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 22:30:13 +0000
References: <20220510220904.284552-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220510220904.284552-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, jiri@nvidia.com,
        idosch@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 11 May 2022 01:09:04 +0300 you wrote:
> The host interfaces $h1 and $h2 don't have to be switchdev interfaces,
> but due to the fact that we pass $tcflags which may have the value of
> "skip_sw", we force $h2 to offload a drop rule for dst_ip, something
> which it may not be able to do.
> 
> The selftest only wants to verify the hit count of this rule as a means
> of figuring out whether the packet was received, so remove the $tcflags
> for it and let it be done in software.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: forwarding: tc_actions: allow mirred egress test to run on non-offloaded h2
    https://git.kernel.org/netdev/net-next/c/b57c7e8b76c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


