Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6286C02CD
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjCSPaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 11:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCSPaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 11:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5A2132F2;
        Sun, 19 Mar 2023 08:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B38AB80BFE;
        Sun, 19 Mar 2023 15:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09450C433EF;
        Sun, 19 Mar 2023 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679239818;
        bh=jBR4aMqv1NdR/E1JYKapG8/ecNeQTgFeDlQG9WqP/2M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZTn4wsvVeO1Y7fS5CvpYQs15fbk7jKtzy61nwRdE6NFC9LCupFHXgjCPj1aPuLf2O
         38UAOXRG6HN4WcRChAF+509aZQUzmeMaMUDq112Z12CPJyTk5c6cluWNiHvnnZJ2DY
         0Zm8mlqftr+8+GwzMYTsQUCeeTiHI3Ajieznu7JnwhzQY4MlJJBPq83R2L9CIjyRlf
         nsW7wzloQhItE4TuRb5wVkYAXf2rcSx3pyLtLZQ6t6extYnE37xlORp+bo9n5ufRJp
         rJjp21auzZ9kVGxxqLET/CRkeRn4WjYInF6dJE/aL+EvHj/upeS8obeYiVrFWKRh7d
         YGM5PNkFTLF/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E97ADC43161;
        Sun, 19 Mar 2023 15:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: lan966x: Improve TX/RX of frames from/to
 CPU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167923981795.9440.2717535586927944786.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 15:30:17 +0000
References: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, david.laight@aculab.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 16:27:11 +0100 you wrote:
> The first patch of this series improves the RX side. As it seems to be
> an expensive operation to read the RX timestamp for every frame, then
> read it only if it is required. This will give an improvement of ~70mbit
> on the RX side.
> The second patch stops using the packing library. This improves mostly
> the TX side as this library is used to set diffent bits in the IFH. If
> this library is replaced with a more simple/shorter implementation,
> this gives an improvement of more than 100mbit on TX side.
> All the measurements were done using iperf3.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: lan966x: Don't read RX timestamp if not needed
    https://git.kernel.org/netdev/net-next/c/ff89ac704e2c
  - [net-next,v2,2/2] net: lan966x: Stop using packing library
    https://git.kernel.org/netdev/net-next/c/fd7627833ddf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


