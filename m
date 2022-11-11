Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBF06258B4
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiKKKuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbiKKKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC735F94;
        Fri, 11 Nov 2022 02:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BE3B8258E;
        Fri, 11 Nov 2022 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 120E9C433C1;
        Fri, 11 Nov 2022 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668163817;
        bh=CG33xjcu8GCUYHgP7+Ta7yNZMKpwfbVL52EN3gJl4xE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AHLKxSolLtq3ZXZNxz3LylDroICD5Jrw/A2yWcgfGTKO318q9pqeFPIe5VpbVTKeV
         6Y7YGQgJc0ihF38YgokPc9krRfiopfXH/dx05x+EtzJ1RXv5PN/gLwswzQ8u1dZB0K
         L73Zx9CVATuhYQ69e/5kmtPEWRy3zDWa+T79NDFTY4dZZd/DHnlTZA7N+pCLjtLUwl
         MdWWiW3eHfdC7FFHTsdblMxt9kKF4HfpsPvI6DltF/6ly1dNgD8Ms79JZGjVYrR+y9
         knEbXvX6U1EwpTOW02kXpKgbpoefp2zeMGolxf9t+/QUfAeGR6KJORKMQV3cmgoEj9
         2cVnyRvI8rmdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F21F7C395FE;
        Fri, 11 Nov 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/8] Extend TC key support for Sparx5 IS2 VCAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166816381698.5678.8071650741031013684.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Nov 2022 10:50:16 +0000
References: <20221109114116.3612477-1-steen.hegelund@microchip.com>
In-Reply-To: <20221109114116.3612477-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, daniel.machon@microchip.com,
        horatiu.vultur@microchip.com, lars.povlsen@microchip.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 9 Nov 2022 12:41:08 +0100 you wrote:
> This provides extended tc flower filter key support for the Sparx5 VCAP
> functionality.
> 
> It builds on top of the initial IS2 VCAP support found in this series:
> 
> https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/8] net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset config
    https://git.kernel.org/netdev/net-next/c/30172a7241f8
  - [net-next,v6,2/8] net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
    https://git.kernel.org/netdev/net-next/c/d6c2964db3fe
  - [net-next,v6,3/8] net: microchip: sparx5: Find VCAP lookup from chain id
    https://git.kernel.org/netdev/net-next/c/7de1dcadfaf9
  - [net-next,v6,4/8] net: microchip: sparx5: Adding TC goto action and action checking
    https://git.kernel.org/netdev/net-next/c/392d0ab04827
  - [net-next,v6,5/8] net: microchip: sparx5: Match keys in configured port keysets
    https://git.kernel.org/netdev/net-next/c/abc4010d1f6e
  - [net-next,v6,6/8] net: microchip: sparx5: Let VCAP API validate added key- and actionfields
    https://git.kernel.org/netdev/net-next/c/242df4f7f2cd
  - [net-next,v6,7/8] net: microchip: sparx5: Add tc matchall filter and enable VCAP lookups
    https://git.kernel.org/netdev/net-next/c/67456717012c
  - [net-next,v6,8/8] net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API
    https://git.kernel.org/netdev/net-next/c/c956b9b318d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


