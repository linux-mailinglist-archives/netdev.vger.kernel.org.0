Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF4E6386CB
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiKYJwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKYJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:52:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7783AC2C;
        Fri, 25 Nov 2022 01:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832AB62333;
        Fri, 25 Nov 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1DE9C43141;
        Fri, 25 Nov 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669369816;
        bh=Qa/i+m10JkcTWdc3pvvmUbyr+7QRhtgDjgw/GDXdceM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sr3MbDRKBC2TftOb6BZMmmhiO+B91G1anGuKl02d6jxp5cQcFJzofi4VX8cqYgWZd
         kZRdIvEnSz3TRlX1FX+nk88HyOC1Z+sMPMkHwqy2uUCdQLJwW3nRlaJsEEomP8l/z6
         LBywAVUlstIucI7amF1T9yhFAYIyyr0zQHdBK2Cbbwv9FmBJpcZhCFjm1DEurtmEmQ
         eHymZVHzPhLw0UCw3eFU7qvvdYUOYdR03Q73uqBvdfkmXJxlyOebIY6Zck8J4IsWfF
         wX6oIq6c1W3Q5BhaKT3bOP4yp41g3GjlVD3/guAGM1uFJAE63vlH7/tb0ghG4LrUIE
         0I7Xn01vwcITQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA938E29F3C;
        Fri, 25 Nov 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] TC protocol all support in Sparx5 IS2 VCAP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936981682.9141.14094692376950850067.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 09:50:16 +0000
References: <20221123152545.1997266-1-steen.hegelund@microchip.com>
In-Reply-To: <20221123152545.1997266-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com
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

On Wed, 23 Nov 2022 16:25:41 +0100 you wrote:
> This provides support for the TC flower filters 'protocol all' clause in
> the Sparx5 IS2 VCAP.
> 
> It builds on top of the initial IS2 VCAP support found in these series:
> 
> https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221111130519.1459549-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221117213114.699375-1-steen.hegelund@microchip.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: microchip: sparx5: Support for copying and modifying rules in the API
    https://git.kernel.org/netdev/net-next/c/465a38a269e9
  - [net-next,v2,2/4] net: microchip: sparx5: Support for TC protocol all
    https://git.kernel.org/netdev/net-next/c/0ca609484877
  - [net-next,v2,3/4] net: microchip: sparx5: Support for displaying a list of keysets
    https://git.kernel.org/netdev/net-next/c/14b639caa6e4
  - [net-next,v2,4/4] net: microchip: sparx5: Add VCAP filter keys KUNIT test
    https://git.kernel.org/netdev/net-next/c/22f3c3257288

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


