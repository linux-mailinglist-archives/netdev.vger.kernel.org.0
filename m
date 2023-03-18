Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D810D6BF7EE
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCRFKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCRFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E22F79C;
        Fri, 17 Mar 2023 22:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A81F660A4D;
        Sat, 18 Mar 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2206C433D2;
        Sat, 18 Mar 2023 05:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679116219;
        bh=D/d22Njz3XOcBdSeTtWNfpjkqhDLL85p8xrZO06ZWbU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OF+OZby4SOWsqeHrleP0LCpee1eYNBl7m62NplStOoffcIqShSK60QnzdpVrn045d
         P1HuU5k7tEzwLYCiGTWBfbGqi8A+vabe2tnwj2Fi7PokPYAIXidV9PDR6lwy0dAySf
         CllkVXL4NUkaa4b3eVv5ECIlS6nyLIED0I0F4Krex5FEbN2Tkw5Z2a2Dh+DtJybd1/
         bh8Dz4126SkerQxkIgwd0QBl2+su5KBCXB1pnieczbU7qhqeV+6GV7bsiTLGYLQeSD
         4z3vr2U0SfiQANphIB4ef4v8O094joxc+pINbOH1N4lRjD9vinITlMFnGoA70TDgwY
         7e/PzNjdT/2QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5A06E21EE5;
        Sat, 18 Mar 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: smsc95xx: Limit packet length to skb->len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911621880.29928.18096232901813385120.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:10:18 +0000
References: <20230316101954.75836-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230316101954.75836-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 11:19:54 +0100 you wrote:
> Packet length retrieved from descriptor may be larger than
> the actual socket buffer length. In such case the cloned
> skb passed up the network stack will leak kernel memory contents.
> 
> Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: usb: smsc95xx: Limit packet length to skb->len
    https://git.kernel.org/netdev/net/c/ff821092cf02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


