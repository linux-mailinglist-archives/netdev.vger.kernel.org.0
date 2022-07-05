Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39856673A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiGEKA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiGEKAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF13732C;
        Tue,  5 Jul 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 378AAB8173A;
        Tue,  5 Jul 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC9D8C341CB;
        Tue,  5 Jul 2022 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657015213;
        bh=74XQbILbR9Nlv2xBO5HRMzixkytiSzLqgS7IeeoRm/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vz5A3pxCsFSh9Q9jWEfzoo0O58vLubAa1HyX4GwMbRuSqgBg9mw7vqcyKYqMwJoWt
         CZPd4QyHvCq/KoF8nebLKq6EIvs7D1P687xPM5V7VdPN3Qo7gqjNtivKzLjt66zTYw
         s9bwnBD26SkKub9aukWCkv5mCFYFGWyiF5U2nbeFA0kZJZrABGVvXDUeblrpsULDWJ
         u7JrlYMzTqeDgZkvI4LB6+W9HwlqF3eG8FrZM1VQE1HkLxUdcHpP0DgYIDrlaJQqvG
         gRwt25vx1qJ6vsLtmtIlzI1fq/Knm/dI9Wqfj0/Z44rSli6P9AlqWZ8kRCCgItjise
         hGkHrlWq5mS7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C748EE45BDB;
        Tue,  5 Jul 2022 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Fix bridge_vlan_aware.sh and bridge_vlan_unaware.sh
 with IFF_UNICAST_FLT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165701521381.30326.1666734345306316971.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 10:00:13 +0000
References: <20220703073626.937785-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220703073626.937785-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        petrm@nvidia.com, idosch@nvidia.com,
        linux-kselftest@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  3 Jul 2022 10:36:23 +0300 you wrote:
> Make sure that h1 and h2 don't drop packets with a random MAC DA, which
> otherwise confuses these selftests. Also, fix an incorrect error message
> found during those failures.
> 
> Vladimir Oltean (3):
>   selftests: forwarding: fix flood_unicast_test when h2 supports
>     IFF_UNICAST_FLT
>   selftests: forwarding: fix learning_test when h1 supports
>     IFF_UNICAST_FLT
>   selftests: forwarding: fix error message in learning_test
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
    https://git.kernel.org/netdev/net/c/b8e629b05f5d
  - [net,2/3] selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
    https://git.kernel.org/netdev/net/c/1a635d3e1c80
  - [net,3/3] selftests: forwarding: fix error message in learning_test
    https://git.kernel.org/netdev/net/c/83844aacab20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


