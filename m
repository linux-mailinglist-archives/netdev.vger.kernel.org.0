Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368FC59914B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345979AbiHRXkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 19:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbiHRXkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 19:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5326E887;
        Thu, 18 Aug 2022 16:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76024B824CD;
        Thu, 18 Aug 2022 23:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE287C433D7;
        Thu, 18 Aug 2022 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660866016;
        bh=AUWFfAd9O6evdwg8IvIuX9m4sd2tnjr+fQ8V/Vmxqlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EossSRgdRaM3UhV6R6ziREAJWAq0rg7T/p4YSqhEQe7cSJWhCccgUSnTqDcupzxMa
         YVfYu6HggQCDfn3473Fv59XoapBNKKwRoOvesZgB4j6M1zGY6o9jFg1TCgcydlhM8L
         ofmCrrJiR9SoAIqaaQI1eB34OUoyLx/h8sFelY3ozvirWBKnuV8idJG9ay2PasGN6C
         fhOqSLrLjYge8hv9RwLwx3W3Zc+oZn1SZ5OokZuPSg3AitP4IjpGtslLt4HQHqH2Ui
         Q6XhJIXiQzESc1FJ7ci9HOvNyY5od0kjtZ+pVbWoOkbMux81cgSj0AxwEPs8DqPbnA
         3HMW6gXx0pzYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C30D0E2A05E;
        Thu, 18 Aug 2022 23:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net 0/2] Add DT property to disable hibernation mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166086601579.17056.4173885487488321475.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 23:40:15 +0000
References: <20220818030054.1010660-1-wei.fang@nxp.com>
In-Reply-To: <20220818030054.1010660-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Aug 2022 11:00:52 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The patches add the ability to disable the hibernation mode of AR803x
> PHYs. Hibernation mode defaults to enabled after hardware reset on
> these PHYs. If the AR803x PHYs enter hibernation mode, they will not
> provide any clock. For some MACs, they might need the clocks which
> provided by the PHYs to support their own hardware logic.
> So, the patches add the support to disable hibernation mode by adding
> a boolean:
>         qca,disable-hibernation-mode
> If one wished to disable hibernation mode to better match with the
> specifical MAC, just add this property in the phy node of DT.
> 
> [...]

Here is the summary with links:
  - [V3,net,1/2] dt-bindings: net: ar803x: add disable-hibernation-mode propetry
    https://git.kernel.org/netdev/net-next/c/2e7f089914b9
  - [V3,net,2/2] net: phy: at803x: add disable hibernation mode support
    https://git.kernel.org/netdev/net-next/c/9ecf04016c87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


