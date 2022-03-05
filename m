Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11894CE2B2
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiCEFLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiCEFLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:11:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B446C1EF;
        Fri,  4 Mar 2022 21:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 934C2B82C86;
        Sat,  5 Mar 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4211CC36AF5;
        Sat,  5 Mar 2022 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646457021;
        bh=PuVItjNI7IbSDLLa5eTm+DCSzFCt+CF/DvoD47EQg/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jjpZ96Khqb9/yqF73jW6H3QqtxNUCIo7gFnLz3ZKjsAU60c8P92zJagsutliiHAJp
         M7pAEwXxsZrqib0Fv69fgswodn2IlhQtgXT7hbJJmYh0jo7IC7sxo0cyq0amifCxhc
         tH7dHcXk0K6KAaxfdrdu22LAxFk8Xxd9ua9NxEDShcBa97dSs6KZ4CqIoG/MXyWSXW
         ZchCSbGwawqx3Uj93QL7yAMGskRcIhDzwzad0gNp2VKxX9apgE28HbKdkkKJCSAWUW
         80uaAsHxJ3wz4uqHpwyuA9UPhJkMm1pk3S9R8pRsYX0dLeelI2p6v6ZhYmrixia349
         as560xcBbpzwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25803E6D44B;
        Sat,  5 Mar 2022 05:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: Fix initialization of variables on
 stack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164645702115.9129.17833451752880754949.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 05:10:21 +0000
References: <20220304140918.3356873-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220304140918.3356873-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 4 Mar 2022 15:09:18 +0100 you wrote:
> The variables 'res' inside the functions sparx5_ptp_get_1ppm and
> sparx5_ptp_get_nominal_value was not initialized. So in case of the default
> case of the switch after, it would return an uninitialized variable.
> This makes also the clang builds to failed.
> 
> Fixes: 0933bd04047c3b ("net: sparx5: Add support for ptp clocks")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: sparx5: Fix initialization of variables on stack
    https://git.kernel.org/netdev/net-next/c/349fa2796e52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


