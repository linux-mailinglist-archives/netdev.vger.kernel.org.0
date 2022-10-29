Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F059261204C
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 07:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJ2FAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 01:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ2FAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 01:00:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584275DF10;
        Fri, 28 Oct 2022 22:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B349BCE3010;
        Sat, 29 Oct 2022 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9BF7C433B5;
        Sat, 29 Oct 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019616;
        bh=r39SWXL3wbyY8oShTz+E3TbmLnnuGdYTOVQpsFsf2lo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XRE2C3ZD+XBhGcgOdMmFhOqChsdpKtxLRLSwbruL2sKCt5iVKZPTx8/FQAMuAloLA
         1C7uaDPWGaTTzi0nTknzvjllhQDsFb8eS2OnbwEop320r4X0R3hqt9kphFOO8knl1V
         PaPEeEeYKBELX1r1OTNq3URUxgzeHKUg/v0Jly3fnWEYt5Q9Pi0rYwpJ/rp4P4k5El
         OJadC0BehGtuoTQ+F+qfJvRzMwDygOxzIKVYYLW72zgOfQIlTBasUXpitjUpJz3CzS
         d9+Z4RMVAQD6LgJX29ETtscEga/NGFv130osVgq48QT9QKtor528yrTPymUMOScJK1
         pcklnmo5twNsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB8D1C41672;
        Sat, 29 Oct 2022 05:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v4 0/1] net: ethernet: adi: adin1110: Fix notifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701961669.17481.13383952035765589597.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 05:00:16 +0000
References: <20221027095655.89890-1-alexandru.tachici@analog.com>
In-Reply-To: <20221027095655.89890-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        lennart@lfdomain.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 12:56:54 +0300 you wrote:
> ADIN1110 was registering netdev_notifiers on each device probe.
> This leads to warnings/probe failures because of double registration
> of the same notifier when to adin1110/2111 devices are connected to
> the same system.
> 
> Move the registration of netdev_notifiers in module init call,
> in this way multiple driver instances can use the same notifiers.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/1] net: ethernet: adi: adin1110: Fix notifiers
    https://git.kernel.org/netdev/net/c/21ce2c121fa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


