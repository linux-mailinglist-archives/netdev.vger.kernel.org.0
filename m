Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054E957916B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiGSDkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiGSDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:40:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58592BCE
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 20:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06DFACE1A93
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 342C6C341CA;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658202014;
        bh=YwJi7KDNUEDmjrZ8U982FEfXKAH/XBwrosirTm0F6/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iLWkVwAUU19yWh5wJXCos1ThL7Cexxf1w2/n5y7qMcpYBqXStij1evHOmQpWWTHcq
         Yb7eV9ItkuO4s24LRmyLCcbIthnWGcHKOOhguzeaXglNh6lSMLbN94rUlzf6TIdk0P
         S0YtIyhs32tOsKVFxtMaImqiep3bryQ2fDs/GDLcV7Za4Iu3uFC8oDwD3MQeW8ZOVU
         SocHppehp1gAu/ZpQMcRM4ze3LU4utxoriXFgCEM7Ccy1Krk4RRfgTO/b2fNT/pkX5
         mS2hxpbRw6S4CgReUAhqsTYbLcYGpFRNWVTquK9JIQDdp4O/4y6gayWSepJ/VPDaTG
         rcnOl7K4B2RHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15E54E451B0;
        Tue, 19 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix 2 DSA issues with vlan_filtering_is_global
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820201408.29134.8594088991564106361.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:40:14 +0000
References: <20220715151659.780544-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220715151659.780544-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Lucian.Banu@westermo.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Jul 2022 18:16:57 +0300 you wrote:
> Hi, this patch set fixes 2 issues with vlan_filtering_is_global switches.
> 
> Both are regressions introduced by refactoring commit d0004a020bb5
> ("net: dsa: remove the "dsa_to_port in a loop" antipattern from the
> core"), which wasn't tested on a wide enough variety of switches.
> 
> Tested on the sja1105 driver.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: fix dsa_port_vlan_filtering when global
    https://git.kernel.org/netdev/net/c/4db2a5ef4ccb
  - [net,2/2] net: dsa: fix NULL pointer dereference in dsa_port_reset_vlan_filtering
    https://git.kernel.org/netdev/net/c/1699b4d502ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


