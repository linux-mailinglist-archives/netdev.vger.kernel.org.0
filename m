Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547655260BB
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379786AbiEMLKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379787AbiEMLKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C4C2A76A1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D34E661743
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38AABC34114;
        Fri, 13 May 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652440213;
        bh=zBeBkszl8j7e+8W6RJlyFoe2tHs7KYkhPV3NXtwUzsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D+5EvamH6CafyqmBqHJfjMxreA/7n3WvDlz9/GFickwbsMD43LNNEQj6mwl403hLO
         tmHQxMtFwHW/MBwUwlb31iC7j/2J4x9JieMkk5bZenQhmQjo7du6BSr/qW1ZShAquw
         glfj14z/YTwaPlSfDakvChvcjCgPZzOXPFjtBuqD9iioSLgrL6J48MvEXdun8ehTe+
         q480U4P+Xf47+64TzPK8S+/ZEPnnclBCHkk3OgzGXHlMwgoqTx4zsZMsOmJyVcP5Vg
         NHV31R8fD5ucaVoBaKzaacWRj0Bau03y18jd21B/rAv5wodjL3wg9VZR7CyJ43VIS9
         MMEmtRz353Ojw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16C99F03934;
        Fri, 13 May 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: fib_nexthops: Make the test more robust
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165244021308.2364.3445222668590598795.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:10:13 +0000
References: <20220512131207.2617437-1-amcohen@nvidia.com>
In-Reply-To: <20220512131207.2617437-1-amcohen@nvidia.com>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        mlxsw@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Thu, 12 May 2022 16:12:07 +0300 you wrote:
> Rarely some of the test cases fail. Make the test more robust by increasing
> the timeout of ping commands to 5 seconds.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
>  1 file changed, 24 insertions(+), 24 deletions(-)

Here is the summary with links:
  - [net-next] selftests: fib_nexthops: Make the test more robust
    https://git.kernel.org/netdev/net-next/c/49bb39bddad2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


