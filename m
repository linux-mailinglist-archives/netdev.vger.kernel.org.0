Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4429C59EE6E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 23:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiHWVuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 17:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiHWVuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 17:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973C03DBC1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 14:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7A83B821B1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 21:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DB52C433C1;
        Tue, 23 Aug 2022 21:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661291415;
        bh=YtqzTYJfmyTdmuXWmjS7+JrzR9N8Pv85mRg2QFrZCrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+3PhnK/U/aKBElrbpfEh+DhVviwHgukdURxQc+tGoO2jzf7o0n5bAYl7qY7Ks719
         UGJ1j086MAwA9JtEFAtYXWeQEJWN/BUv0VY7qu0psaCPN7EqQSR/5JqokH5gZr4SFS
         F9mWpe6yaWjtKIpvzWSc3YcC7GR1IPthEROby6gjRh4BG+tRKlD+7zpNhXpzwFMKZ3
         hOqmcNPWyR85Gq7xwTfVMZwNM62N7sj3FEYigP//lPHG2UUDk8XUScAnqWCNvUPI6S
         nlxkIODbRbl1B29OLBrArzrTW1H8TKuo/peThqZ+bEvJGqdok3/jWtJnZGRkAnISVf
         85kaddP3Mre3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E823E1CF31;
        Tue, 23 Aug 2022 21:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: microchip: make learning configurable and
 keep it off while standalone
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166129141524.16181.6871143654799657941.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 21:50:15 +0000
References: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220818164809.3198039-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com,
        arun.ramadoss@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, b.hutchman@gmail.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 19:48:09 +0300 you wrote:
> Address learning should initially be turned off by the driver for port
> operation in standalone mode, then the DSA core handles changes to it
> via ds->ops->port_bridge_flags().
> 
> Leaving address learning enabled while ports are standalone breaks any
> kind of communication which involves port B receiving what port A has
> sent. Notably it breaks the ksz9477 driver used with a (non offloaded,
> ports act as if standalone) bonding interface in active-backup mode,
> when the ports are connected together through external switches, for
> redundancy purposes.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: microchip: make learning configurable and keep it off while standalone
    https://git.kernel.org/netdev/net/c/15f7cfae912e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


