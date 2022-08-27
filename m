Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E864F5A33D8
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbiH0CkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiH0CkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909AB72B52;
        Fri, 26 Aug 2022 19:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294DA61DA8;
        Sat, 27 Aug 2022 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AD44C43141;
        Sat, 27 Aug 2022 02:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568015;
        bh=wecaXYmu9OJO5R98rVAmEX9VavU1QyMnE5UQbxW/9i4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KE35G2raHFjd99tmQquSyMMDMDrP6sy3ZXjGqsTt+X+Lp9zT1RXUjx+404Feix9Cf
         hmLyRNU8drxMil+piqkr0PenGqtX4oKQA4SNIY0lW37oq1uXliVb1j2dIuUHE8TBsJ
         v6ZeW4qjXyaz/v/SyNGSY1vI25Yl58nNhZ9dDgAne1XR8CGDpS1xX9KUsWAtYgfgQ9
         ZTYFN10VC0DPNrqcm2pOApn0sgpro472+QMYLsWAG/SRyKU0ETD99TyICJxsjtZJeb
         BMQAKWmuwo3/GDn4H825L3DqjP64wuyAhuemfXWcWrTVU8mKQcHooFHFz48Eb451f+
         34O2kWcE20gSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 671F2E2A041;
        Sat, 27 Aug 2022 02:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow external SMI if serial
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156801541.24651.16548454594963692008.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:40:15 +0000
References: <20220824093706.19049-1-marcus.carlberg@axis.com>
In-Reply-To: <20220824093706.19049-1-marcus.carlberg@axis.com>
To:     Marcus Carlberg <marcus.carlberg@axis.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@axis.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 11:37:06 +0200 you wrote:
> p0_mode set to one of the supported serial mode should not prevent
> configuring the external SMI interface in
> mv88e6xxx_g2_scratch_gpio_set_smi. The current masking of the p0_mode
> only checks the first 2 bits. This results in switches supporting
> serial mode cannot setup external SMI on certain serial modes
> (Ex: 1000BASE-X and SGMII).
> 
> [...]

Here is the summary with links:
  - net: dsa: mv88e6xxx: Allow external SMI if serial
    https://git.kernel.org/netdev/net-next/c/8532c60efcc5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


