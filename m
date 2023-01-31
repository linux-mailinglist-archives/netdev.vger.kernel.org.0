Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207356823BE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjAaFUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjAaFUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:20:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E923A5AA;
        Mon, 30 Jan 2023 21:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 961E6B819D1;
        Tue, 31 Jan 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26CCCC4339B;
        Tue, 31 Jan 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675142420;
        bh=X+CQNowbMPWihw84rL/sCobYKV6h3aCwloefj4LPI8Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9oNffJkS797GTGB8zI3b87ZO+sKnWW+aRlOkUsokTiv44PmQ/bHkmlmkFOaExueU
         9YvEzC/DrOpf7RmSYqEor03qS6yRwaZfiY/i2RthS9u05u6SbASpP0ca5yxKdc7ipF
         Reo1MxZJraxpHO2g+ea8w9457njy0Nvb2+iVjHf1Lsvazz/zbnfQ6jcYdFObfjAmCM
         KmDRuripmTEWiStO1N+cKypxiyR1NUFKwNekAN6Hro4OzRGpSt2Zs3upkDvgQ5Qztb
         zDnyS/OLh4nbCQOUvLh3bTeKZu5v+3O5mE1G5uHBmBlzvoi0twAHxq1veGwdS8qhQS
         9/5tJxAag+lYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F7FAC0C40E;
        Tue, 31 Jan 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/13] add support for the the vsc7512 internal
 copper phys
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514242005.16180.6859220313239539967.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:20:20 +0000
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        richardcochran@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        lee@kernel.org
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

On Fri, 27 Jan 2023 11:35:46 -0800 you wrote:
> This patch series is a continuation to add support for the VSC7512:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*
> 
> That series added the framework and initial functionality for the
> VSC7512 chip. Several of these patches grew during the initial
> development of the framework, which is why v1 will include changelogs.
> It was during v9 of that original MFD patch set that these were dropped.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/13] net: mscc: ocelot: expose ocelot wm functions
    https://git.kernel.org/netdev/net-next/c/c6a9321b0811
  - [v5,net-next,02/13] net: mscc: ocelot: expose regfield definition to be used by other drivers
    https://git.kernel.org/netdev/net-next/c/728d8019f1a3
  - [v5,net-next,03/13] net: mscc: ocelot: expose vcap_props structure
    https://git.kernel.org/netdev/net-next/c/beb9a74e0bf7
  - [v5,net-next,04/13] net: mscc: ocelot: expose ocelot_reset routine
    https://git.kernel.org/netdev/net-next/c/b67f5502136f
  - [v5,net-next,05/13] net: mscc: ocelot: expose vsc7514_regmap definition
    https://git.kernel.org/netdev/net-next/c/2efaca411c96
  - [v5,net-next,06/13] net: dsa: felix: add configurable device quirks
    https://git.kernel.org/netdev/net-next/c/1dc6a2a02320
  - [v5,net-next,07/13] net: dsa: felix: add support for MFD configurations
    https://git.kernel.org/netdev/net-next/c/dc454fa4b764
  - [v5,net-next,08/13] net: dsa: felix: add functionality when not all ports are supported
    https://git.kernel.org/netdev/net-next/c/de879a016a94
  - [v5,net-next,09/13] mfd: ocelot: prepend resource size macros to be 32-bit
    https://git.kernel.org/netdev/net-next/c/fde0b6ced8ed
  - [v5,net-next,10/13] dt-bindings: net: mscc,vsc7514-switch: add dsa binding for the vsc7512
    https://git.kernel.org/netdev/net-next/c/dd43f5e7684c
  - [v5,net-next,11/13] dt-bindings: mfd: ocelot: add ethernet-switch hardware support
    https://git.kernel.org/netdev/net-next/c/11fc80cbb225
  - [v5,net-next,12/13] net: dsa: ocelot: add external ocelot switch control
    https://git.kernel.org/netdev/net-next/c/3d7316ac81ac
  - [v5,net-next,13/13] mfd: ocelot: add external ocelot switch control
    https://git.kernel.org/netdev/net-next/c/8dccdd277e0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


