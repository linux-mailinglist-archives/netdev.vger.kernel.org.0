Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08591558F47
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiFXDuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiFXDuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034DF4EF52;
        Thu, 23 Jun 2022 20:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B9936207F;
        Fri, 24 Jun 2022 03:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6B79C341CA;
        Fri, 24 Jun 2022 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656042612;
        bh=TUJkbFlGeFWgRuWkEm2jJqMlmWm8gmIJsHkxktVMt0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RGP2/RKIdgMSvANtiqADgS4JpmUvf8IpW140TtsOIxv/8ow1MepnlgEupf6XwAoe1
         cygoCFhyn7iQrruUsAI3BKn1Ev+m+VYwHytqxuC3D/pJC/zlndxqjeo7wDxxgbkjsp
         STzjtOFI+MpPOkw6ty13bSeMZ+Vp//6lSoayqUeB/AFarVF2THI97RHyDalj/m9aJT
         9UkLJOnupcpZzxcSWoUw1YC+pj6bJNh/wALJ205A1W7MKIvI3eaY5JHfN2H4K3ViXz
         U0es0XYPuNm4tCWfcu4CpTWtbjQJQMSYu/fU7bV8lv+4KLb08oBmDu3EKOmT9P6M1X
         FrLMDc2w+HXCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 999A4E8DBCB;
        Fri, 24 Jun 2022 03:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: bcm_sf2: force pause link settings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604261262.22770.7795161707609262691.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 03:50:12 +0000
References: <20220623030204.1966851-1-f.fainelli@gmail.com>
In-Reply-To: <20220623030204.1966851-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 20:02:04 -0700 you wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> The pause settings reported by the PHY should also be applied to the GMII port
> status override otherwise the switch will not generate pause frames towards the
> link partner despite the advertisement saying otherwise.
> 
> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: bcm_sf2: force pause link settings
    https://git.kernel.org/netdev/net/c/7c97bc0128b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


