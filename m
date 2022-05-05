Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C7B51B620
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 04:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239983AbiEECxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 22:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiEECxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 22:53:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C6AE36
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 19:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10783618B0
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 02:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E541C385A4;
        Thu,  5 May 2022 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651719014;
        bh=HMX2+TYEYlbX4eWQMxOyeGBQ+bEEl7vvfs1GvXVqNm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lE0NzF4VpZrAs+1okJNgnIB9hJKvT8sUr1zrl0X1PMJ40BTPY0M6v51sh6PppESyM
         pKbsGjP26cRnm986nJuJ+fsApQlnKT85qOk3r0ebRFwRp/15M8Tp7z0cWEh7ynWPu6
         RKoJl8Ibi8rfCDnbQnA+RR6GzvvPfkfPSF4JA962FZnMkXD/j3ZEJijZXnvLLdwJcm
         nUc2IZDQktNPK0OQNxmG6JHyDuPbZyvGT84045ODIsAsz0k6LcEwBA/8W2xOFpsq/C
         aR8hNzxo3plIWC8QxjIbs5b9HUml3muus/jzyXPCij0Ow3f7/gekeSzNoCc+XW6yAK
         xOmLzz3XvFXKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47649E5D087;
        Thu,  5 May 2022 02:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: ocelot: tc_flower_chains: specify
 conform-exceed action for policer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165171901428.9346.11488357746990066914.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 02:50:14 +0000
References: <20220503121428.842906-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220503121428.842906-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        colin.foster@in-advantage.com, idosch@nvidia.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 May 2022 15:14:28 +0300 you wrote:
> As discussed here with Ido Schimmel:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220224102908.5255-2-jianbol@nvidia.com/
> 
> the default conform-exceed action is "reclassify", for a reason we don't
> really understand.
> 
> The point is that hardware can't offload that police action, so not
> specifying "conform-exceed" was always wrong, even though the command
> used to work in hardware (but not in software) until the kernel started
> adding validation for it.
> 
> [...]

Here is the summary with links:
  - [net] selftests: ocelot: tc_flower_chains: specify conform-exceed action for policer
    https://git.kernel.org/netdev/net/c/5a7c5f70c743

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


