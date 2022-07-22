Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40C157D873
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiGVCUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiGVCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3E113D0E;
        Thu, 21 Jul 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C8DDB826CF;
        Fri, 22 Jul 2022 02:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9783C341CB;
        Fri, 22 Jul 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658456413;
        bh=a2AuV6CiLWyI8BPpBH3RS8CU26ZIoTBnwSK4EBuXjp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a0QfnPcmBwQ9Uftw1Quujzimoyon+aN2ljmP/jgJ7mNW7rfy4dpeV8yU8SBR1+VWm
         MbRYCkwuNHegA+UnfPSXa6yc1UYFext7D860rK5LKZtMuGIxFOrm9I7sWDcrM0BGtg
         CVnny+6LV7rERm2uvUThOHgFu07ski+z+GAzdaO3AUSKiZ7qerXnGjPlmNUe59RJfO
         PLRjh/X7KmhFQKrhNuJyj7bO1WcGSkyTF0VJZ2WJvOP71RWyK/RrgXIFG9ivF40j97
         MDbI6d4KgSsC4ZSXrlX5swl6qYqUEGZKOgvoXNQtoPCoqXkmQ2rlB7z2mwRHj82wfy
         4zYUFsu/DniIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A375BD9DDDD;
        Fri, 22 Jul 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: ipv6: avoid accepting values greater than 2
 for accept_untracked_na
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165845641366.11073.341683788896208979.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 02:20:13 +0000
References: <20220720183632.376138-1-jhpark1013@gmail.com>
In-Reply-To: <20220720183632.376138-1-jhpark1013@gmail.com>
To:     Jaehee <jhpark1013@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, dsahern@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, roopa.prabhu@gmail.com, aroulin@nvidia.com,
        sbrivio@redhat.com, nicolas.dichtel@6wind.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Jul 2022 14:36:32 -0400 you wrote:
> The accept_untracked_na sysctl changed from a boolean to an integer
> when a new knob '2' was added. This patch provides a safeguard to avoid
> accepting values that are not defined in the sysctl. When setting a
> value greater than 2, the user will get an 'invalid argument' warning.
> 
> Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
> Suggested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Suggested-by: Roopa Prabhu <roopa@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: ipv6: avoid accepting values greater than 2 for accept_untracked_na
    https://git.kernel.org/netdev/net-next/c/b66eb3a6e427

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


