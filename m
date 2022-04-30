Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D53515979
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346741AbiD3BDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbiD3BDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A0E63B5;
        Fri, 29 Apr 2022 18:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F62A62465;
        Sat, 30 Apr 2022 01:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4000C385A7;
        Sat, 30 Apr 2022 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651280412;
        bh=94v0NlAWHiARvSWeYsxU4mSCkycWlemBQQD5ilbrCRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oNc4ckeNmImkFBExqiSbAV6p9Rv7t/EP41gCq54oyPkgPU/sv6/XJ9M11dfjRaRan
         z8vOjILahRF1bEVJVGDlspl5lZ4J7hNw/Asmzas2b2ertgk/AqAVBA6kV6lTgyOhSJ
         4HJ4Rmw83UXuYHN9bkHj10nAa/N5KsBctXQFE6lIL8B1LgHObk28icRhhDHKz0ixvc
         T1ddnzO/RKP2vj8khnMHstTLpPnAApZEAykts2H4DgjFPPWm+H1HRkMXan62v1uqrp
         bL1BdUfC9bhtzz+rk7VAct9khoTAC+/E9E1uSrqjd4wC21jo8yAs+yTPauFOIXYHmC
         MrZPCOuTYGeEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B29DCF0383D;
        Sat, 30 Apr 2022 01:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165128041272.25380.10755696181043924363.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Apr 2022 01:00:12 +0000
References: <20220428044511.227416-1-liuhangbin@gmail.com>
In-Reply-To: <20220428044511.227416-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, dsahern@kernel.org,
        linux-kselftest@vger.kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, idosch@nvidia.com, amitc@mellanox.com,
        petrm@mellanox.com, lkp-owner@lists.01.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Apr 2022 12:45:09 +0800 you wrote:
> When generating the selftests to another folder, the fixed tests are
> missing as they are not in Makefile. The missing tests are generated
> by command:
> $ for f in $(ls *.sh); do grep -q $f Makefile || echo $f; done
> 
> I think there need a way to notify the developer when they created a new
> file in selftests folder. Maybe a bot like bluez.test.bot or kernel
> test robot could help do that?
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests/net: add missing tests to Makefile
    https://git.kernel.org/netdev/net/c/38dcd9570d6f
  - [net,2/2] selftests/net/forwarding: add missing tests to Makefile
    https://git.kernel.org/netdev/net/c/f62c5acc800e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


