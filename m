Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D20659F06E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiHXAuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiHXAuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEC285FF7;
        Tue, 23 Aug 2022 17:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3CAB822AB;
        Wed, 24 Aug 2022 00:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B911FC433B5;
        Wed, 24 Aug 2022 00:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661302216;
        bh=x/TGu8Mqxdo/Av2cBGX54j8I4BWgJeQWDpEtXc/HWRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QZtpmJeoDKGNYhQ6nPeNlIbh8eN6LyPqWYDjJAbm94luD4SHUdecSa+3VHSx6CDUq
         TlgYpZ6Vk/CQpIcq53oTYPDWIx7OL4uz0hi2/2fZGHfNHuod9X3hpBqqiQJ84n3Krz
         +IaD3bnH9j+svGQusFUXv46HUR16kr6frxuDnicV8B8YVhDbYG/Jj3QUhZSYdq6E0O
         E31gOTA7wicoZEEglroRo2XnuS/uPuS6MFnad6iQhjkv8DGMgq/wTrLlzxrVxue5Vg
         HEK+hLSLGW0rej4slaNAsIwtb/KBh4FjMpQx3MADxfzL1yvJoy+bfhe9sYFavJ++bX
         aXFFE18XLjwYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 978CEC004EF;
        Wed, 24 Aug 2022 00:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/2] add interface mode select and RMII
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166130221661.20408.5681001765892113009.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 00:50:16 +0000
References: <20220822015949.1569969-1-wei.fang@nxp.com>
In-Reply-To: <20220822015949.1569969-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
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

On Mon, 22 Aug 2022 09:59:47 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The patches add the below feature support for both TJA1100 and
> TJA1101 PHYs cards:
> - Add MII and RMII mode support.
> - Add REF_CLK input/output support for RMII mode.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/2] dt-bindings: net: tja11xx: add nxp,refclk_in property
    https://git.kernel.org/netdev/net-next/c/52b2fe4535ad
  - [V2,net-next,2/2] net: phy: tja11xx: add interface mode and RMII REF_CLK support
    https://git.kernel.org/netdev/net-next/c/60ddc78d1636

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


