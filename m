Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3ED74FCD63
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiDLECo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbiDLECd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8DF2DD6E;
        Mon, 11 Apr 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57F2FB81B1A;
        Tue, 12 Apr 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17554C385A8;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649736015;
        bh=A71wFm0EZUkh8sOyFXVpNLHCZTvDaLQvxFvblQ+y9ek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R4ahKdMDkrIa3VouEJJsmHWj/L2yGRpY6cc6bisUeH53MypDPOjlHeSr1zIrx8kIz
         gbygVydYtj2ejMkyd18R5PoQuRpHuV89nLP3SwdWsOeNUV3o1mR/RiBn6RDk6lo8Sr
         p+0FhnOKoub8JvxXcZx1xD+JqWsRjoVY2k2rf8swbgyI2fYm+lP1ERSkmfx3FL22cV
         r+vL6adXzzG2/0vrG28IwQaT1jiE0ITjTPz6uvHsI1pTiBIUvoJ+vo5dvbotcfxHQ/
         lHlXq2ncxfWpY9I0oXkV8lpJQJpW+dKXhjG1GtX8o8IZlP8Zi708tEi6nOmJNAInXL
         XSsyeyLIOwE5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE93FE8DD5F;
        Tue, 12 Apr 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] net: lan966x: Add support for FDMA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973601497.30868.12345646401426210203.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 04:00:14 +0000
References: <20220408070357.559899-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220408070357.559899-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, michael@walle.cc
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 8 Apr 2022 09:03:53 +0200 you wrote:
> Currently when injecting or extracting a frame from CPU, the frame
> is given to the HW each word at a time. There is another way to
> inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
> In this way the entire frame is given to the HW. This improves both
> RX and TX bitrate.
> 
> Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] net: lan966x: Add registers that are used for FDMA.
    https://git.kernel.org/netdev/net-next/c/fdb2981c00bb
  - [net-next,v4,2/4] net: lan966x: Expose functions that are needed by FDMA
    https://git.kernel.org/netdev/net-next/c/8f2c7d9ad778
  - [net-next,v4,3/4] net: lan966x: Add FDMA functionality
    https://git.kernel.org/netdev/net-next/c/c8349639324a
  - [net-next,v4,4/4] net: lan966x: Update FDMA to change MTU.
    https://git.kernel.org/netdev/net-next/c/2ea1cbac267e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


