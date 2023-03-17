Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4F86BDD9F
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCQAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCQAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BB1BAE4;
        Thu, 16 Mar 2023 17:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A24E26216A;
        Fri, 17 Mar 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10200C433D2;
        Fri, 17 Mar 2023 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013021;
        bh=V0IabrJKAckqatzfWKd53XjvtYMa+qNDmLlYwdANX3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cfNJNC5wcGQTbw3i2g3R/aqR1Ts0Ffzt3JVxypv+UAev+46X4ns/a6XZC2Y3uwpoB
         AdcVhP0cjOiXeXt+GlRKCczsk5UlA3ZqfCF2U8VxoI/nS4foYvG/Iav5XE94NixHBN
         pryqrU56fJ6SWLDc2ktcX7EpCnjO7Kyy6PW8kc3HWO7Lnp8CxYcENVkMT/byajmkET
         Wjz3povjrwm3zwuuAqAGckeGAP+zDkLCmIMhSSQBZC9zhwpjvGfBjyOONQSvgshbYP
         GIU864Tk0LPPI9YgQrVFc5RgDwCmktwwyz6BxxpIyo8WeB4bze3bZlY4irh4DwmGT+
         UieqwMi4iYWeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F01EEE66CBB;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] Add PTP support for sama7g5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901302097.26766.6833385103104590996.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:30:20 +0000
References: <20230315095053.53969-1-durai.manickamkr@microchip.com>
In-Reply-To: <20230315095053.53969-1-durai.manickamkr@microchip.com>
To:     Durai Manickam KR <durai.manickamkr@microchip.com>
Cc:     Hari.PrasathGE@microchip.com,
        balamanikandan.gunasundar@microchip.com,
        manikandan.m@microchip.com, varshini.rajendran@microchip.com,
        dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
        balakrishnan.s@microchip.com, claudiu.beznea@microchip.com,
        cristian.birsan@microchip.com, nicolas.ferre@microchip.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        edumazet@google.com, kuba@kernel.org, richardcochran@gmail.com,
        linux@armlinux.org.uk, palmer@dabbelt.com,
        paul.walmsley@sifive.com, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 15:20:51 +0530 you wrote:
> This patch series is intended to add PTP capability to the GEM and
> EMAC for sama7g5.
> 
> Durai Manickam KR (2):
>   net: macb: Add PTP support to GEM for sama7g5
>   net: macb: Add PTP support to EMAC for sama7g5
> 
> [...]

Here is the summary with links:
  - [1/2] net: macb: Add PTP support to GEM for sama7g5
    https://git.kernel.org/netdev/net-next/c/abc783a7b0ff
  - [2/2] net: macb: Add PTP support to EMAC for sama7g5
    https://git.kernel.org/netdev/net-next/c/9bae0dd05e61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


