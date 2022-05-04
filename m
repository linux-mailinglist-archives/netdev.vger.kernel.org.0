Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63714519CEA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbiEDKdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbiEDKdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9899B21
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6382461B04
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B58C3C385AE;
        Wed,  4 May 2022 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651660213;
        bh=zN5Gu0EyvxP2xRlolLMdWGPui5Fx7RnCYV6oKwi8cQo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JtybhzCViMMoql6LzHgUJzOwnFySDQJBvJJuDjvoDmNBD/D35Y+k3+PoSYZ/zYsSn
         rSOWrxvTv4FgdAXx3vr4b65OeIS2ZSxcrQDKLN+fC0FYHQeI4gVltZOJwBtkab1xo8
         gSKpYszMUfUfH5aMhFlqtY0uipPI0RIzDhAWeFjqE87GB4piv/0aqYvS7TY6NE+F/n
         CBS7j4mQ0j2XMQTbEeROy8F4cxNTLzFbI6x1hFLcHmDaSogoHNaEmm5TnGGZn2vaJ/
         vkQEgqfviXLcCiPciHKzvDrPcqPf1otyLi00ojyl2DNHnumku4vftUAH9cJm71pRk4
         S8Nu/spGGXYcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91D2EE8DD77;
        Wed,  4 May 2022 10:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165166021359.27992.10606056306672238609.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 10:30:13 +0000
References: <20220504062909.536194-1-idosch@nvidia.com>
In-Reply-To: <20220504062909.536194-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  4 May 2022 09:29:01 +0300 you wrote:
> Patches #1-#3 add missing topology diagrams in selftests and perform
> small cleanups.
> 
> Patches #4-#5 make small adjustments in QoS configuration. See detailed
> description in the commit messages.
> 
> Patches #6-#8 reduce the number of background EMAD transactions. The
> driver periodically queries the device (via EMAD transactions) about
> updates that cannot happen in certain situations. This can negatively
> impact the latency of time critical transactions, as the device is busy
> processing other transactions.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] selftests: mlxsw: bail_on_lldpad before installing the cleanup trap
    https://git.kernel.org/netdev/net-next/c/18d2c710e5df
  - [net-next,2/8] selftests: router_vid_1: Add a diagram, fix coding style
    https://git.kernel.org/netdev/net-next/c/5ade50e2df2b
  - [net-next,3/8] selftests: router.sh: Add a diagram
    https://git.kernel.org/netdev/net-next/c/faa7521add89
  - [net-next,4/8] mlxsw: spectrum_dcb: Do not warn about priority changes
    https://git.kernel.org/netdev/net-next/c/b6b584562cbe
  - [net-next,5/8] mlxsw: Treat LLDP packets as control
    https://git.kernel.org/netdev/net-next/c/0106668cd2f9
  - [net-next,6/8] mlxsw: spectrum_acl: Do not report activity for multicast routes
    https://git.kernel.org/netdev/net-next/c/d1314096fbe9
  - [net-next,7/8] mlxsw: spectrum_switchdev: Only query FDB notifications when necessary
    https://git.kernel.org/netdev/net-next/c/b8950003849d
  - [net-next,8/8] mlxsw: spectrum_router: Only query neighbour activity when necessary
    https://git.kernel.org/netdev/net-next/c/cff9437605d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


