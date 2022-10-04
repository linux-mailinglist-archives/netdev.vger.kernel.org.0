Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431675F3B23
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 04:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJDCKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 22:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJDCKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 22:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B7223153;
        Mon,  3 Oct 2022 19:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4E7861226;
        Tue,  4 Oct 2022 02:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E13DC433D7;
        Tue,  4 Oct 2022 02:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664849422;
        bh=SLkbv2B4JHPRilUVLrjFbn07v1YGDn4jS0ZXUk/n9ag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xgea8fo/9mtanPdV+WOvAU+EovTzkk/JlxO4WTet1r8l0vT0gm2Rs2wbIQATB1ti4
         w/e30WSlcQCgJA1qyxLGTxy3a0U9v5eFJxUN5fW5/mY/kkZmkicBFkjB6srGEXPJel
         /zTiBen7vMV+RxteODKZrVnUBF+yDvgpJBwUD4A9azGsNGj2uPirWhNTfx//SpAGGF
         rkju0YCQ2Zcx4rkPo26QpJUGa+w0xA5QIX04OM0CH7pelQ/7N5IxqeUaFnxKKeIvIZ
         73e2tFCo8wntpUROVkD4kVLEwpiTYaZVBA5FL1ZoddNpA/cXqKIBNBbp0X90yfw+97
         10vY4Bq26UoMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F0F27E4D013;
        Tue,  4 Oct 2022 02:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/7] add generic PSE support 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484942198.5153.10769126898481789778.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 02:10:21 +0000
References: <20221003065202.3889095-1-o.rempel@pengutronix.de>
In-Reply-To: <20221003065202.3889095-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, corbet@lwn.net,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, david@protonic.nl,
        luka.perkov@sartura.hr, robert.marko@sartura.hr
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

On Mon,  3 Oct 2022 08:51:55 +0200 you wrote:
> Add generic support for the Ethernet Power Sourcing Equipment.
> 
> changes are listed within patches.
> 
> Oleksij Rempel (7):
>   dt-bindings: net: phy: add PoDL PSE property
>   net: add framework to support Ethernet PSE and PDs devices
>   net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
>   net: mdiobus: search for PSE nodes by parsing PHY nodes.
>   ethtool: add interface to interact with Ethernet Power Equipment
>   dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE
>     controller
>   net: pse-pd: add regulator based PSE driver
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/7] dt-bindings: net: phy: add PoDL PSE property
    https://git.kernel.org/netdev/net-next/c/e9554b31aff0
  - [net-next,v8,2/7] net: add framework to support Ethernet PSE and PDs devices
    https://git.kernel.org/netdev/net-next/c/3114b075eb25
  - [net-next,v8,3/7] net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
    https://git.kernel.org/netdev/net-next/c/cfaa202a73ea
  - [net-next,v8,4/7] net: mdiobus: search for PSE nodes by parsing PHY nodes.
    https://git.kernel.org/netdev/net-next/c/5e82147de1cb
  - [net-next,v8,5/7] ethtool: add interface to interact with Ethernet Power Equipment
    https://git.kernel.org/netdev/net-next/c/18ff0bcda6d1
  - [net-next,v8,6/7] dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
    https://git.kernel.org/netdev/net-next/c/f05dfdaf567a
  - [net-next,v8,7/7] net: pse-pd: add regulator based PSE driver
    https://git.kernel.org/netdev/net-next/c/66741b4e94ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


