Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C85671E32
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjARNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjARNlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:41:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F9AA6C48;
        Wed, 18 Jan 2023 05:10:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84A5FB81CE9;
        Wed, 18 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 096A8C43398;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674047418;
        bh=ZjUASydz7Gcshr3yBAP5rGbkt3uJUSn+CqNygpWGjlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LRipYjMCwNL09w96bX73Zb4Hg6mpPHfTCjTw3KJ9aR+TvAyMpAoto634j/C2MOi1P
         od9+JT7xtxHPHeHLdAji50vbQxWjROIIUdLvIyMG9shWKLlIU/AYH+iy4OIIuNT6Fy
         5/wU+7U0M3gkT/Wr6P3rf7P/A3giOI3z2i2G6ZIXZljbb2qvIJ6/lDCiXwa/CcRJro
         sEwqDEyKPMGP1kP29owKQb8k9LXe/K4o/sUr6pJwHEFKNbr4tv3YnB7oKTK4TvlQTP
         4E0PBCQgqk14Fv39KiUqZ7zHa0zQoI/SxVI6fVLoddfIQqtzF8KJ7X3jTjUHDnYL4K
         xtVSem2mP+39A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4A74C5C7C4;
        Wed, 18 Jan 2023 13:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] Add PPS support to am65-cpts driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167404741786.5923.11609204629264354932.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 13:10:17 +0000
References: <20230116085534.440820-1-s-vadapalli@ti.com>
In-Reply-To: <20230116085534.440820-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vigneshr@ti.com, rogerq@kernel.org, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
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
by David S. Miller <davem@davemloft.net>:

On Mon, 16 Jan 2023 14:25:31 +0530 you wrote:
> The CPTS hardware doesn't support PPS signal generation. Using the GenFx
> (periodic signal generator) function, it is possible to model a PPS signal
> followed by routing it via the time sync router to the CPTS_HWy_TS_PUSH
> (hardware time stamp) input, in order to generate timestamps at 1 second
> intervals.
> 
> This series adds driver support for enabling PPS signal generation.
> Additionally, the documentation for the am65-cpts driver is updated with
> the bindings for the "ti,pps" property, which is used to inform the
> pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
    https://git.kernel.org/netdev/net-next/c/2b76af68d8e5
  - [net-next,v2,2/3] net: ethernet: ti: am65-cpts: add pps support
    https://git.kernel.org/netdev/net-next/c/b6d787123427
  - [net-next,v2,3/3] net: ethernet: ti: am65-cpts: adjust pps following ptp changes
    https://git.kernel.org/netdev/net-next/c/eb9233ce6751

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


