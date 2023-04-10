Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34DF6DC29E
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 04:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDJCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjDJCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 22:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547DB1FC4;
        Sun,  9 Apr 2023 19:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C8A60F85;
        Mon, 10 Apr 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41FCBC433D2;
        Mon, 10 Apr 2023 02:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681093219;
        bh=BN2B0mTIIibvkjrxXG0dZV9T4ql1YRSxPcqNig5X/yw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CwhkRgyN9WOhKBknjL6ShqoCUge0mz8SruJLejdLb+5OtIZCe5IMlNx5gldrgRV9g
         N1Qvqj346tZLQGz0OvWIZ0p9mZI+hxF6drj/E8ecMV9ANRm+31eJFMTXXKJorBn1Re
         Esl8hvIR3MepU2cV35DmqWLshu1Cd2+BHq3i47GKcZwer0zCjqHgarP1FGETDiGWQz
         7GeIPHGnW/NbfRlSrsf8My4Meuq5CltaR6LAknVCqP2S9XKpeNtSJ1U42IG1lmQoAY
         cd9iG86vL2rKmlCkP14bhb7USMBABe51M4Pkjh0cePQFF8/UzDMlytqMOea1MrILyM
         ogxcEdrc2yflA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B876E21EEE;
        Mon, 10 Apr 2023 02:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to hwmon_channel_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168109321910.29680.18338473238737964479.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Apr 2023 02:20:19 +0000
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        kabel@kernel.org, lxu@maxlinear.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        jdelvare@suse.com, linux@roeck-us.net, linux-hwmon@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Apr 2023 16:59:04 +0200 you wrote:
> Statically allocated array of pointed to hwmon_channel_info can be made
> const for safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> [...]

Here is the summary with links:
  - [1/8] net: netronome: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/87f1c15e8759
  - [2/8] net: aquantia: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/bc1585f611b2
  - [3/8] net: phy: aquantia: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/234d79a5f826
  - [4/8] net: phy: bcm54140: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/211f70be2577
  - [5/8] net: phy: marvell: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/ff0805e2bde0
  - [6/8] net: phy: mxl: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/2ed84c0c6f75
  - [7/8] net: phy: nxp-tja11xx: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/0e76f1dcf487
  - [8/8] net: phy: sfp: constify pointers to hwmon_channel_info
    https://git.kernel.org/netdev/net-next/c/490fde262f17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


