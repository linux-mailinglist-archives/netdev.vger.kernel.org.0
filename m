Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7494F6668
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiDFRHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbiDFRGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2001E2EF846;
        Wed,  6 Apr 2022 07:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0FFB82437;
        Wed,  6 Apr 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98A04C385AF;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255413;
        bh=yH/Z+/bCnu8gjgJYv5IUwtmwdylHuzPcKH3mqaX+6Ic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qsMLAbwCxRofgQ8SMKOgkH2q8St7V94l//kVdvP5n//fMVW5OUtWXFV4Riw1gsvr0
         LJ6p3eHc2wPvRny/0EHpyhv08/pspEvciNtUR2GC55Vrofs0VkSsBDOfkk6j+ipMaI
         ePYDmwkGmnV8XS33a0RhjPKy08rUrn1soXlTEv7QKFj22N+D5vhQF+tkXYvgpQITxd
         lu4KhkFMB0mf/Bk0b1iGPAOJh9BDgDQ2B8jAoVyl0LzGDoqsLc3bD/5akI0zqkLkME
         w7mpaxDK4RUXZSDPitY0MNIR72odZc7t92ngLcF+AxJjo4PYS62PWKmn+sD07ReX2m
         z7fm0tGbs073w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71923E8DBDA;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wan: remove the lanmedia (lmc) driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925541346.21938.8264132794493725230.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:30:13 +0000
References: <20220406041548.643503-1-kuba@kernel.org>
In-Reply-To: <20220406041548.643503-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        khalasa@piap.pl, asj@cban.com, bbraun@vix.com, explorer@vix.com,
        matt@3am-software.com, arnd@kernel.org, tsbogend@alpha.franken.de,
        linux-mips@vger.kernel.org, linus.walleij@linaro.org
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
by David S. Miller <davem@davemloft.net>:

On Tue,  5 Apr 2022 21:15:48 -0700 you wrote:
> The driver for LAN Media WAN interfaces spews build warnings on
> microblaze. The virt_to_bus() calls discard the volatile keyword.
> The right thing to do would be to migrate this driver to a modern
> DMA API but it seems unlikely anyone is actually using it.
> There had been no fixes or functional changes here since
> the git era begun.
> 
> [...]

Here is the summary with links:
  - [net-next] net: wan: remove the lanmedia (lmc) driver
    https://git.kernel.org/netdev/net-next/c/a5b116a0fa90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


