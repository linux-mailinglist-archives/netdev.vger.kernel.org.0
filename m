Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1EC4E38AC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbiCVGBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiCVGBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:01:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410341121;
        Mon, 21 Mar 2022 23:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01739B81BA0;
        Tue, 22 Mar 2022 06:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9951C340F2;
        Tue, 22 Mar 2022 06:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647928811;
        bh=zHG+cY/WBZAzU3W3bkrJRho+3VXOG36ullyllS4WVEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S4rp3BZuTLL2USWLHW42NvIU5od58TxdWuu4k8pPD8OeKROyRqqad59CpaP7ph8/q
         4+tzVo/SbHDekrrpXbjBYQR6ECJQgSERudRapRiTOwoQV9ITiNkohsROAL00fxKNlW
         jjO1cZZYcsa/Y/Pjvh/GflbpVpTKblDIutn5E4AxaIk49khvxnzLFV2sbpOdN3boAW
         06v8ZpA5a0poGKwLLDpGdP8BfOww75tz5Dv7uVctpnOG/M8czifCVVUybLYle+8E9B
         hR/1w82QJH/mIpGpelW105EZ92kB4wzRUFy70AjETCRBayIC9Ceni+33S3ngF7vJW7
         vrYgSKuN75IOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92C7DEAC081;
        Tue, 22 Mar 2022 06:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] net: mscc-miim: add integrated PHY reset
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164792881159.30182.5180350088879779765.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Mar 2022 06:00:11 +0000
References: <20220318201324.1647416-1-michael@walle.cc>
In-Reply-To: <20220318201324.1647416-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@canonical.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Mar 2022 21:13:21 +0100 you wrote:
> The MDIO driver has support to release the integrated PHYs from reset.
> This was implemented for the SparX-5 for now. Now add support for the
> LAN966x, too.
> 
> changes since v2:
>  - fix typo in commit message
>  - use microchip,lan966x instead of mscc,lan966x
>  - rename mask variable to {phy_,}reset_bits
>  - check return code from device_get_match_data() right after
>    the call instead of checking it where it is used
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] dt-bindings: net: mscc-miim: add lan966x compatible
    https://git.kernel.org/netdev/net-next/c/a2e4b5adfdf8
  - [net-next,v3,2/3] net: mdio: mscc-miim: replace magic numbers for the bus reset
    https://git.kernel.org/netdev/net-next/c/58ebdba3d851
  - [net-next,v3,3/3] net: mdio: mscc-miim: add lan966x internal phy reset support
    https://git.kernel.org/netdev/net-next/c/74529db3e01d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


