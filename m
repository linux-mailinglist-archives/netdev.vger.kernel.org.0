Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53EB5F02B6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiI3CVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiI3CVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:21:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3FDE7202;
        Thu, 29 Sep 2022 19:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C81B826FB;
        Fri, 30 Sep 2022 02:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50430C433D7;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664504466;
        bh=ROxRLVPte8e84EbnN18Xpks0TjftnE0E4uUS75vGqyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j9G32ROSydpqB84cszpWO9XcjVyOHP4FJy6DIJzMN/R4KpUfb4lgA22UC0Y0/xkJz
         FdHcwg+5R2pNX+BpkDXM+XKOgY8g8DMnp3fcfSW4MCv8z/5k2LjnOp/829YmBersum
         rnaOHONkp3hoYhHeqUEkR35an915mRMpyQXpEmxZtyDksGSM7s+or8aZzzxzoOeqcn
         Y7nA1/b+i/65tAcnlyL5DhOGSEPhfHyVSXvMRYjGpU1b/4SI8Ul4qlrH/uw2m++N/g
         68vKsD790xlOqbPav57t1e/OO2OVuYT2xvCl/18U6meaTYqeC52l6L91Q87X6ioqlh
         jLMTDcrum9ThQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 34DCAC395DA;
        Fri, 30 Sep 2022 02:21:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/8] Add tc-taprio support for queueMaxSDU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166450446620.30186.14343605844530400334.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 02:21:06 +0000
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        rui.sousa@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        horatiu.vultur@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, michael@walle.cc,
        vinicius.gomes@intel.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com, richard.pearn@nxp.com,
        kurt@linutronix.de, olteanv@gmail.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 28 Sep 2022 12:51:56 +0300 you wrote:
> Changes in v4:
> - avoid bogus fall-through in the implementations of the tc_query_caps
>   methods
> - fix bogus patch splitting in hellcreek
> 
> v3 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220927234746.1823648-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/8] net/sched: query offload capabilities through ndo_setup_tc()
    https://git.kernel.org/netdev/net-next/c/aac4daa8941e
  - [v4,net-next,2/8] net/sched: taprio: allow user input of per-tc max SDU
    https://git.kernel.org/netdev/net-next/c/a54fc09e4cba
  - [v4,net-next,3/8] net: dsa: felix: offload per-tc max SDU from tc-taprio
    https://git.kernel.org/netdev/net-next/c/1712be05a8a7
  - [v4,net-next,4/8] net: dsa: hellcreek: refactor hellcreek_port_setup_tc() to use switch/case
    https://git.kernel.org/netdev/net-next/c/248376b1b13f
  - [v4,net-next,5/8] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio
    https://git.kernel.org/netdev/net-next/c/a745c697830b
  - [v4,net-next,6/8] net: enetc: cache accesses to &priv->si->hw
    https://git.kernel.org/netdev/net-next/c/715bf2610f1d
  - [v4,net-next,7/8] net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
    https://git.kernel.org/netdev/net-next/c/9a2ea26d97a9
  - [v4,net-next,8/8] net: enetc: offload per-tc max SDU from tc-taprio
    https://git.kernel.org/netdev/net-next/c/dfc7175de3b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


