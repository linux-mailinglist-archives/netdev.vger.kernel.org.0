Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735126046F5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiJSNZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiJSNY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:24:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0677125014
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA0FC6188D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A117C433B5;
        Wed, 19 Oct 2022 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666185018;
        bh=3SuNpoIgdEO1FaK9qVJ8D/b6c+x9wtrjYTjO6P594w0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=az3SJqjUA8V0MGo9iH3jLjEGYnqbpHSTZFxuGtKq3ocLOYizbECrPnnXClOdViFCG
         jc2sKUdV+WAjD6X2dK09/Ppk2isldYScus/kHtyuCWjf5bI3bV/XXdDv2jon/rlZdp
         j7OaRVde1R7RSqPOlnRoUWLTq4Y3qSJ2d2oj9V6J+a32aGOChyk50OYgCw/KsN49fw
         hXLVQ9vMFdlt2rEwULtPz25eorO8boQN9xrsLK7JlxYczdtpn0XLG8NAa/cLCYvZrB
         h/JcvJlCbRZg0hKt4az+6RG7urkGIvL3quWne9vVAznsq/VAJkKfNFzGMlh0OsULX3
         IsUmtHSM55ERA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EEE8E29F37;
        Wed, 19 Oct 2022 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] net: Fix return value of qdisc ingress handling on
 success
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618501811.21602.274157555454273001.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 13:10:18 +0000
References: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
In-Reply-To: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     daniel@iogearbox.net, vladbu@nvidia.com, ozsh@nvidia.com,
        roid@nvidia.com, netdev@vger.kernel.org, saeedm@nvidia.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Oct 2022 10:34:37 +0300 you wrote:
> Fix patch + self-test with the currently broken scenario.
> 
> v4->v3:
>   Removed new line in self test and rebase (Paolo).
> 
> v2->v3:
>   Added DROP return to TC_ACT_SHOT case (Cong).
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] net: Fix return value of qdisc ingress handling on success
    https://git.kernel.org/netdev/net/c/672e97ef689a
  - [net,v4,2/2] selftests: add selftest for chaining of tc ingress handling to egress
    https://git.kernel.org/netdev/net/c/fd602f5cb52e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


