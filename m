Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF705B9887
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIOKKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiIOKKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA293C141;
        Thu, 15 Sep 2022 03:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE1D622AD;
        Thu, 15 Sep 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41E6EC433C1;
        Thu, 15 Sep 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663236616;
        bh=UmEtwZDOaen1UdKO/8gEYBqlgnDqzVeqxYoHhayxdhc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JgV5I9FcoITZTCecM0XxZKizoTv2Bx2NOKgMNdCF8zcT/QxdHNxAzOj5JU3SFUZC+
         uGPisbjWDta4yTWM5Xcen19Z/EutA1iIxQdW5LLyRwQ0Zq2zZxrvCDf7otsSgpjOI8
         8QvZMKE1D5/wkjDshWDjAhxs70CV8VLrkqCHZm1vPS3dAiHN9My8MNnAmRPFajKSje
         iA4iWNP2iwb1jE1KVxtPolvl+8/eH1uh1zSw21ADhSKLNEM9ltPtiz0zL1gOtuHz+z
         FgcNETrkFxdy0sXvN+WDODG8an+X2Mh8ly828IcgPH++bIt2Hx21Hn+xpQ9QBT0OwZ
         DyYxxt357Jmvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16E7CC73FFC;
        Thu, 15 Sep 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166323661608.10818.10249854681669693704.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Sep 2022 10:10:16 +0000
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
In-Reply-To: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, hkallweit1@gmail.com,
        linus.walleij@linaro.org, brgl@bgdev.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue,  6 Sep 2022 13:49:20 -0700 you wrote:
> This patch switches the driver away from legacy gpio/of_gpio API to
> gpiod API, and removes use of of_get_named_gpio_flags() which I want to
> make private to gpiolib.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/net/ethernet/davicom/dm9000.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [1/3] net: davicom: dm9000: switch to using gpiod API
    https://git.kernel.org/netdev/net-next/c/db49ca38579d
  - [2/3] net: ks8851: switch to using gpiod API
    https://git.kernel.org/netdev/net-next/c/7b77bb5c8130
  - [3/3] net: phy: spi_ks8895: switch to using gpiod API
    https://git.kernel.org/netdev/net-next/c/006534ec2804

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


