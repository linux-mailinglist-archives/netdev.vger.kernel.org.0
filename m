Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32F56C93E
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGILkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 07:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGILkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 07:40:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F8A691CB
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 04:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB9E1CE02BE
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C217EC341CB;
        Sat,  9 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657366813;
        bh=APp7GaJiWIfxc16muxhr0XkfGvxsDXImwwEyoJWnTjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UyFDTy+YCjX96FXJ66cu5F9dy0m/44GYIBZuV7PaBHXLPhP9LxV2X8vBbwwbeeHV2
         PXfHxVk9ewM6l+fR6i0sp5ZT1agmwT68Qp2Z/QDW8Hy84hZt7ok2eZtgAox63vsh0n
         uiT2/FbjbcCgq6+7wyz2aFoIJGkseWJyg1ObkEmDlq2ETcdxJbK1qEo/ssEjBuGhKV
         eCuQLex5/833ciXyPzNb+3yhjijV1kdFv0IE03bb8ID4vL6K8GbA9ehBkGyD3Fxdy9
         aADM/oHda2B24W3tONMsZ/3KsKp5ZBPve+8Nh0k6dHgTJ+3W+SDPc0PLMRANm6TFxk
         5daF3/3/HD+lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6C76E45BE1;
        Sat,  9 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] ixp4xx_eth: Fall back to random MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165736681367.32617.4249591359664472585.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 11:40:13 +0000
References: <20220708235530.1099185-1-linus.walleij@linaro.org>
In-Reply-To: <20220708235530.1099185-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kaloz@openwrt.org,
        khalasa@piap.pl
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Jul 2022 01:55:29 +0200 you wrote:
> If the firmware does not provide a MAC address to the driver,
> fall back to generating a random MAC address.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,1/2] ixp4xx_eth: Fall back to random MAC address
    https://git.kernel.org/netdev/net-next/c/b3ba206ce84d
  - [net-next,2/2] ixp4xx_eth: Set MAC address from device tree
    https://git.kernel.org/netdev/net-next/c/877d4e3cedd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


