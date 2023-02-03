Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720D568941D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbjBCJkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjBCJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B02B091;
        Fri,  3 Feb 2023 01:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86F16B82A29;
        Fri,  3 Feb 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 136BAC433A0;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675417221;
        bh=4Zk9Uo9AxRh9BqHukSeYkBrv7hngxVxHj5e07LtJxDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GicKhm6bz8idBBisc49RdQWZA2JbZvVOhCdf0jrXluKKxRX5jfC3AjOquSEOhMDYO
         inhkNcm4cT6ZL/6rz3KxCQvUo0UtoRDTaEGlkZHAczDfzMFLK0SewbLM7ORIfzlUuf
         8sZhQq15Cqcd7hD6t30hTVBFnuRA54OKZYcbSG1vuALR0r1aHj69taMRnMgDqZezUa
         NDo7qGNHVAHEbd12xoGsR46IWEZgH4iwrhjcQ6MLWnVqcPHQwgiraWqpV5mXkA1bzF
         mewBM0fcFmog+1U/o9IF0Xj2kvyIy1LwraCcPMNzpanb7DDV9RGm6afALSgqQq4ccG
         SyCZbAGpP3o5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED80CE4448D;
        Fri,  3 Feb 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/5] add dts for yt8521 and yt8531s,
 add driver for yt8531
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167541722096.18212.4636658624969452175.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 09:40:20 +0000
References: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
In-Reply-To: <20230202030037.9075-1-Frank.Sae@motor-comm.com>
To:     Frank Sae <Frank.Sae@motor-comm.com>
Cc:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, yanhong.wang@starfivetech.com,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
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

On Thu,  2 Feb 2023 11:00:32 +0800 you wrote:
> Add dts for yt8521 and yt8531s, add driver for yt8531.
>  These patches have been verified on our AM335x platform (motherboard)
>  which has one integrated yt8521 and one RGMII interface.
>  It can connect to daughter boards like yt8531s or yt8531 board.
> 
>  v5:
>  - change the compatible of yaml
>  - change the maintainers of yaml from "frank sae" to "Frank Sae"
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
    https://git.kernel.org/netdev/net-next/c/cf08dfe8ae7e
  - [net-next,v5,2/5] net: phy: Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet phy
    https://git.kernel.org/netdev/net-next/c/4869a146cd60
  - [net-next,v5,3/5] net: phy: Add dts support for Motorcomm yt8521 gigabit ethernet phy
    https://git.kernel.org/netdev/net-next/c/a6e68f0f8769
  - [net-next,v5,4/5] net: phy: Add dts support for Motorcomm yt8531s gigabit ethernet phy
    https://git.kernel.org/netdev/net-next/c/36152f87dda4
  - [net-next,v5,5/5] net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy
    https://git.kernel.org/netdev/net-next/c/4ac94f728a58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


