Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5848C55A14D
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiFXSaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiFXSaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BC37C529
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 11:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA61BB82B8E
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6F06C341D0;
        Fri, 24 Jun 2022 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656095414;
        bh=H8Itk5q5mS7z5u6R3DLhag4wF+CzOGunzTDkNamtYgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EDyTu/lG/61IkhaoLUivBFsKO/6MyRKiRGLTfJh/CGkzc4skaZldOdJbPj/LGLkQm
         YioJIBY0jLgdz6q5O5cf1VcMD/k5GoXmB1ptp3jLjXb1gMb3kNKrf+KrQ1GleGmYW1
         P4svTq0kQxohZMT9+WmhX9k2fSOE9i4nz4qMuHnGjL8nqcIjUK6Z5KZtYqTHr5R+FT
         WqRMx3tVXtAmTIS8skoYbTW1prNUwZL5ab0SScf+f5DD7gxDhFw1EUsRHHHxNukowt
         yEgG48AdvyJb4SGWHfaGJ7k8fUD8sWhlw3srJt2H1kuRogU8jQcX/T3MRTkufvCsS2
         Ma5YXd7vlCUBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B176E737F0;
        Fri, 24 Jun 2022 18:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: pcs: lynx: consolidate gigabit code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165609541456.17645.11498348254607974634.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 18:30:14 +0000
References: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
In-Reply-To: <YrRbjOEEww38JFIK@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     ioana.ciornei@nxp.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 23 Jun 2022 13:24:44 +0100 you wrote:
> Hi,
> 
> This series consolidates the gigabit setup code in the Lynx PCS driver.
> In order to do this properly, we first need to fix phylink's
> advertisement encoding function to handle QSGMII.
> 
> I'd be grateful if someone can test this please.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phylink: add QSGMII support to phylink_mii_c22_pcs_encode_advertisement()
    https://git.kernel.org/netdev/net-next/c/f56866c486fa
  - [net-next,2/2] net: pcs: lynx: consolidate sgmii and 1000base-x config code
    https://git.kernel.org/netdev/net-next/c/06f9a6148e28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


