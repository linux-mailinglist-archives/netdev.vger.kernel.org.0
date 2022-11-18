Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2262ED95
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiKRGa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiKRGa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:30:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DAB97A99
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:30:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D27862339
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1FB8C433D6;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753024;
        bh=R9PlGEvwmYiD6of1MEn8s2lud8KehB5UmhDwMIB728s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sq9rRLdai7x6HHBSq8FyGWkdnMETLOaeXPllsjqsHnMR3aW3DEqczs4BRYX6wFwgt
         /NV9uPHcYREGA4+xqbx5t605TepgNiNASODVZ8BHj/SfZ7Fgs6beby12WeaL395Shp
         GgPz0ewHssD1HYq9XQZLHO1qnnuZF5l7d8Z/ibCyZltQr9qg4chjO6s3tMXYNhUsJz
         tolHaQOlYKzFXI1p63jE6f72FHg9sfjwv/L/F9IXUlZgHTeKZeCXcQelJK+JF5HObQ
         P6FigjZZhgsdaV/SSObicflKMz1mH4l8z+y58gJH0L/eqpYVQX4OklJnVWfotltGjf
         r303SrJF2o9/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 908DEE21EFA;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/6] Autoload DSA tagging driver when dynamically
 changing protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875302458.3603.3950099126468086217.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 06:30:24 +0000
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, michael@walle.cc,
        heiko.thiery@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 15 Nov 2022 03:18:41 +0200 you wrote:
> v1->v2:
> - fix module auto-loading when changing tag protocol via sysfs
>   (don't pass sysfs-formatted string with '\n' to request_module())
> - change modalias format from "dsa_tag-21" to "dsa_tag:id-21".
> - move some private DSA helpers to net/dsa/dsa_priv.h.
> 
> v1 at:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=689585
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/6] net: dsa: stop exposing tag proto module helpers to the world
    https://git.kernel.org/netdev/net-next/c/9999f85ba346
  - [v2,net-next,2/6] net: dsa: rename tagging protocol driver modalias
    https://git.kernel.org/netdev/net-next/c/2610937d7e95
  - [v2,net-next,3/6] net: dsa: provide a second modalias to tag proto drivers based on their name
    https://git.kernel.org/netdev/net-next/c/94793a56b3df
  - [v2,net-next,4/6] net: dsa: strip sysfs "tagging" string of trailing newline
    https://git.kernel.org/netdev/net-next/c/e8666130b995
  - [v2,net-next,5/6] net: dsa: rename dsa_tag_driver_get() to dsa_tag_driver_get_by_id()
    https://git.kernel.org/netdev/net-next/c/54c087e83945
  - [v2,net-next,6/6] net: dsa: autoload tag driver module on tagging protocol change
    https://git.kernel.org/netdev/net-next/c/0184c07a11a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


