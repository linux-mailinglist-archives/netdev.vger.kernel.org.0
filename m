Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCDE5B34D8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiIIKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiIIKKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7007D78B;
        Fri,  9 Sep 2022 03:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 047AF61F80;
        Fri,  9 Sep 2022 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5059CC433D6;
        Fri,  9 Sep 2022 10:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662718218;
        bh=wR9F8nSh4V4XSc6Tz8iK3zjct6Psyrop68NsVJbELFg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DalXn0OYQczFU/qhFSCFn0lc1dYFxumM0PAtp9Ookp0f8MLJd4xyAEiYJ4Np0ijsE
         CP3mzO4sh17yLczXgHWae6wSfqUDNaVbHu95LBpKo8KuDdm5Zw630uUYSIK1H1TJgG
         1ccY+No/NNOKiGI4yzF+7uFFB9f0+AZD47GMOmszXtg2EAVxSLDEwnJ/H+uj1PY57s
         XfBQqijKP9uw6Znd2+J4y0X6vsCQ3FBn8dkKzm+ZHlGE5d3wGlzZG490ZKqHkFMe0O
         r4am3Hkqfg5iiIr9ilf9Ew4kOM1jvMmQhrqGOmbSTdHvYeQPQTuafLzdw+lvszMhgo
         VFikwvTyzrj2Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22F68E1CABD;
        Fri,  9 Sep 2022 10:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14] Standardized ethtool counters for Felix DSA
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166271821812.3591.390061450752416705.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 10:10:18 +0000
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiaoliang.yang_1@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, fido_max@inbox.ru,
        colin.foster@in-advantage.com, richard.pearn@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  8 Sep 2022 19:48:02 +0300 you wrote:
> The main purpose of this change set is to add reporting of structured
> ethtool statistics counters to the felix DSA driver (see patch 11/14 for
> details), as a prerequisite for extending these counters to the
> eMAC/pMAC defined by the IEEE MAC Merge layer.
> 
> Along the way, the main purpose has diverged into multiple sub-purposes
> which are also tackled:
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net: dsa: felix: add definitions for the stream filter counters
    https://git.kernel.org/netdev/net-next/c/0a2360c59687
  - [net-next,02/14] net: mscc: ocelot: make access to STAT_VIEW sleepable again
    https://git.kernel.org/netdev/net-next/c/96980ff7c2ca
  - [net-next,03/14] net: dsa: felix: check the 32-bit PSFP stats against overflow
    https://git.kernel.org/netdev/net-next/c/25027c8409b4
  - [net-next,04/14] net: mscc: ocelot: report FIFO drop counters through stats->rx_dropped
    https://git.kernel.org/netdev/net-next/c/cc160fc29a26
  - [net-next,05/14] net: mscc: ocelot: sort Makefile files alphabetically
    https://git.kernel.org/netdev/net-next/c/28c8df8d4785
  - [net-next,06/14] net: mscc: ocelot: move stats code to ocelot_stats.c
    https://git.kernel.org/netdev/net-next/c/fe90104cd604
  - [net-next,07/14] net: mscc: ocelot: unexport ocelot_port_fdb_do_dump from the common lib
    https://git.kernel.org/netdev/net-next/c/97076c3cc9fe
  - [net-next,08/14] net: mscc: ocelot: move more PTP code from the lib to ocelot_ptp.c
    https://git.kernel.org/netdev/net-next/c/d50e41bf0234
  - [net-next,09/14] net: dsa: felix: use ocelot's ndo_get_stats64 method
    https://git.kernel.org/netdev/net-next/c/776b71e55384
  - [net-next,10/14] net: mscc: ocelot: exclude stats from bulk regions based on reg, not name
    https://git.kernel.org/netdev/net-next/c/d3e75f1665f3
  - [net-next,11/14] net: mscc: ocelot: add support for all sorts of standardized counters present in DSA
    https://git.kernel.org/netdev/net-next/c/e32036e1ae7b
  - [net-next,12/14] net: mscc: ocelot: harmonize names of SYS_COUNT_TX_AGING and OCELOT_STAT_TX_AGED
    https://git.kernel.org/netdev/net-next/c/be5c13f26205
  - [net-next,13/14] net: mscc: ocelot: minimize definitions for stats
    https://git.kernel.org/netdev/net-next/c/b69cf1c67572
  - [net-next,14/14] net: mscc: ocelot: share the common stat definitions between all drivers
    https://git.kernel.org/netdev/net-next/c/4d1d157fb6a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


