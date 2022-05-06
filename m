Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6729551CF02
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388337AbiEFCeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388339AbiEFCd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:33:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EBFDC7
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE5BB832A4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 02:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D5B3C385A4;
        Fri,  6 May 2022 02:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651804213;
        bh=dHP5o3y91R9xyYZtipL7bpSr+f58YaO3tcxnicEbG+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=reSA93qNVm5UvhuIMmHxRIZb4uXwvgRnx8D7fikYHh2+Mx7/UGgxoNpKvovQbwc1L
         JJJe8npZzHQ/ah0VSRFiipRo9LwRNSl3t3tsCsUA+7WD5j3MWUq9uyPqqaB7HhfhyU
         0i8321FMQVyIkffXFa3Wr7HCLvlRJpEASDemWyL9kRb7HMXWqepkIAfetz4G0iIE3q
         1chSTzQ6zJZ5IWpMHjA2OHo3uEfivazJdjq+IlRqGXQFeGu0DvREzApy9oWTySLqfc
         U1rM+y8p6S62wM46qOll2RZEvxjoJ4SyDN8cICXnGx8zRO7nIAklvROP/jJzyyK2pH
         Kgs2vrSn2I0kA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CC0BF03874;
        Fri,  6 May 2022 02:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/5] Ocelot VCAP fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165180421317.14903.5805954595659117185.git-patchwork-notify@kernel.org>
Date:   Fri, 06 May 2022 02:30:13 +0000
References: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220504235503.4161890-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, xiaoliang.yang_1@nxp.com,
        colin.foster@in-advantage.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 May 2022 02:54:58 +0300 you wrote:
> Changes in v2:
> fix the NPDs and UAFs caused by filter->trap_list in a more robust way
> that actually does not introduce bugs of its own (1/5)
> 
> This series fixes issues found while running
> tools/testing/selftests/net/forwarding/tc_actions.sh on the ocelot
> switch:
> 
> [...]

Here is the summary with links:
  - [v2,net,1/5] net: mscc: ocelot: mark traps with a bool instead of keeping them in a list
    https://git.kernel.org/netdev/net/c/e1846cff2fe6
  - [v2,net,2/5] net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
    https://git.kernel.org/netdev/net/c/16bbebd35629
  - [v2,net,3/5] net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
    https://git.kernel.org/netdev/net/c/6741e1188000
  - [v2,net,4/5] net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0
    https://git.kernel.org/netdev/net/c/477d2b91623e
  - [v2,net,5/5] net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters
    https://git.kernel.org/netdev/net/c/93a8417088ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


