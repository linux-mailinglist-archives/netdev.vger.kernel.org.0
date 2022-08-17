Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AA459751E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiHQRaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiHQRaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DD8D7A;
        Wed, 17 Aug 2022 10:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7D3B612D6;
        Wed, 17 Aug 2022 17:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C865C433D7;
        Wed, 17 Aug 2022 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660757415;
        bh=QQurvPROr0COx5gjVSIWquos59ckDeR9FG6jNTrlN+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CR+0KKbcQUzXt4+3bCCBl4wndO7eP4wsqR5/LtKy3V4PQEl95J3zfPgzu6AGjYLlH
         nG3699Q8nJwbJGIPVTvVLoDs2a0vNOs6FOls58e/xKP53/KSoZPkibx9mdrhFHncMI
         +kG2maVgQPSy6cx9G5V24h4ufJF3y6DjDCBrNb3Dh55EqvDq3C976LWggpKc3Xd+a1
         8XPpfS5gPQMZgsVIyxxfswIrO6XyC1gtfT6bAFn8Nb2elp6JaZEi0+YG6Zd+Es1SpO
         uIT1JHPlphTSYYjxL8+oO6c4xNmh/Y7OA/EiUIMogFX5a/QHJTLx36vt+afnnd9t5H
         rBn3Es3tJhiGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C710E2A052;
        Wed, 17 Aug 2022 17:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166075741511.18749.15672219198322368784.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Aug 2022 17:30:15 +0000
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
In-Reply-To: <20220813204658.848372-1-beniaminsandu@gmail.com>
To:     Beniamin Sandu <beniaminsandu@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 13 Aug 2022 23:46:58 +0300 you wrote:
> This makes the code look cleaner and easier to read.
> 
> Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
> ---
>  drivers/net/phy/sfp.c | 121 +++++++++++++-----------------------------
>  1 file changed, 38 insertions(+), 83 deletions(-)

Here is the summary with links:
  - net: sfp: use simplified HWMON_CHANNEL_INFO macro
    https://git.kernel.org/netdev/net-next/c/815f5f574144

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


