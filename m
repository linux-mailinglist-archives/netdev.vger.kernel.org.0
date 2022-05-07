Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3E51E3EC
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 06:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353486AbiEGEOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 00:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445487AbiEGEOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 00:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BEE6D4E2
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B34060A64
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 04:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB929C385A6;
        Sat,  7 May 2022 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651896614;
        bh=FQEdUfi4q/dhZhrvbVLsQCPVG5G8nPlirx/8PquLXe4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XCMXKF7jxyJNDW2vAi/JsxylywMamOxh4QeB8Wrpz6S4d23eOASyBNsAg16mJZWpK
         cUlUQI3mIYuOchVnMR5qqLxFBtzaNOToS+65nDKW7NS3b4JL/E5ORVr0/D+RsX3neH
         Kvd4Ms6EwSBN4LFHkSjy0pJhE1igM2WY8bimoDt+zUxuuBccJEY8tjyUwbkGkvd+Z1
         Rl7/9FVeItO4X8nl5X0PPXjmqvTOxorRfNxP17CoddHikfOQ/UmvJ2yjMVplAj4rq5
         ld2qEKgdYFYbemWGK9PBiMu0HxicLKo8EL/ldwqJcZAVEYJ/kFj5mbFltSeUqjMUZ8
         68i19uISbHF0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9936BF03926;
        Sat,  7 May 2022 04:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Simplify migration of host filtered addresses in
 Felix driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165189661462.31844.1111727569036409002.git-patchwork-notify@kernel.org>
Date:   Sat, 07 May 2022 04:10:14 +0000
References: <20220505162213.307684-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220505162213.307684-1-vladimir.oltean@nxp.com>
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  5 May 2022 19:22:09 +0300 you wrote:
> The purpose of this patch set is to remove the functions
> dsa_port_walk_fdbs() and dsa_port_walk_mdbs() from the DSA core, which
> were introduced when the Felix driver gained support for unicast
> filtering on standalone ports. They get called when changing the tagging
> protocol back and forth between "ocelot" and "ocelot-8021q".
> I did not realize we could get away without having them.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: dsa: felix: use PGID_CPU for FDB entry migration on NPI port
    https://git.kernel.org/netdev/net-next/c/2c110abc4616
  - [net-next,2/4] net: dsa: felix: stop migrating FDBs back and forth on tag proto change
    https://git.kernel.org/netdev/net-next/c/a51c1c3f3218
  - [net-next,3/4] net: dsa: felix: perform MDB migration based on ocelot->multicast list
    https://git.kernel.org/netdev/net-next/c/28de0f9fec5a
  - [net-next,4/4] net: dsa: delete dsa_port_walk_{fdbs,mdbs}
    https://git.kernel.org/netdev/net-next/c/fe5233b0ba0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


