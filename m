Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874C25BBA19
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 21:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIQTUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 15:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiIQTUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 15:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DF0275D8;
        Sat, 17 Sep 2022 12:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A41B61194;
        Sat, 17 Sep 2022 19:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9287C43140;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663442422;
        bh=ZgTQw3mV1wPQtA5EN5PFfXsvpfcSz7F6tQqaaWomya8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eMh8VRUGxVu34Tl3E+75SyJYBaNVstxoLSi2+LpusfGAuOpJ11qwIxcTd+OXumfSr
         AZT6GMDtxeqQbG5Uz74qJFqSAShId9ha9OE0/hPxqUPAf58K0cFv1+SYv5gySxVF+p
         nLNcKVzKjGj54L3UH+ouN88HpG1S7WAjJT4sH2LhfudbePAOIDcHlyGc/4VmMsCaNG
         /bzbYR5T3EA6wRUqiprmswDm7M73I0DYU+Ecnviun13nyV0kGeuNAPw4pDOL3ZYpH0
         +xfPZ6MNkgrZEaSbdpZXEXyQabQ9QDcKotxMZe1vZR8+AzEJS3ZeAhRl61/C9fQTMb
         k8cy4TmBWENBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD477C74002;
        Sat, 17 Sep 2022 19:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net: dsa: microchip: add the support for
 set_ageing_time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166344242183.31603.8854858158092771554.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Sep 2022 19:20:21 +0000
References: <20220907072039.24833-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220907072039.24833-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 7 Sep 2022 12:50:39 +0530 you wrote:
> KSZ9477 has the 11 bit ageing count value which is split across the two
> registers. And LAN937x has the 20 bit ageing count which is also split
> into two registers. Each count in the registers represents 1 second.
> This patch add the support for ageing time for KSZ9477 and LAN937x
> series of switch.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: microchip: add the support for set_ageing_time
    https://git.kernel.org/netdev/net-next/c/2c119d9982b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


