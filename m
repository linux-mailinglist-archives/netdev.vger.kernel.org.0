Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CD36A800E
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCBKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBKkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E202057C;
        Thu,  2 Mar 2023 02:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B28AB811E7;
        Thu,  2 Mar 2023 10:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA72AC4339B;
        Thu,  2 Mar 2023 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677753617;
        bh=y+j9NIBFSW9cAD8aY8TdK/tWkUz3bqsEilbJXss1Bsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a3ThesuQtpEOWaWL4NdO0AYZKjTvdivwOU61cEnUwqkUtzVZ1KKjHW1bXD676idg0
         tfkZ3qpJXkLIw4ttkJv+oswumw7MZE4cwvy+JjvBgtc6++kbqWEs1IQZ+dQeTBRmac
         XY+ulW/WklqjLrTl0DUeYk2kXM0ujg2BKRdyoz9NyZ4qNVQjiJyMA1WM59kJUhWGjd
         cf0CqA0OWUQinxKFJmmscuYZk155SBDtijgnuv2QDrimnGSEcVRkSz2NOXIIoy5HZN
         ci7XhJo5BkirchN9epTCAuMDkn9AipCpLUVdkV3Tqd3x1BufD2RMvUfqz6euy7Oooh
         nCcKj0iGyiSsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9752EC43161;
        Thu,  2 Mar 2023 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] selftests: nft_nat: ensuring the listening side is up
 before starting the client
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167775361761.18640.429545418792345434.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Mar 2023 10:40:17 +0000
References: <20230301222021.154670-2-pablo@netfilter.org>
In-Reply-To: <20230301222021.154670-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  1 Mar 2023 23:20:19 +0100 you wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> 
> The test_local_dnat_portonly() function initiates the client-side as
> soon as it sets the listening side to the background. This could lead to
> a race condition where the server may not be ready to listen. To ensure
> that the server-side is up and running before initiating the
> client-side, a delay is introduced to the test_local_dnat_portonly()
> function.
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: nft_nat: ensuring the listening side is up before starting the client
    https://git.kernel.org/netdev/net/c/2067e7a00aa6
  - [net,2/3] netfilter: nft_last: copy content when cloning expression
    https://git.kernel.org/netdev/net/c/860e874290fb
  - [net,3/3] netfilter: nft_quota: copy content when cloning expression
    https://git.kernel.org/netdev/net/c/aabef97a3516

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


