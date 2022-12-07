Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C064589E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 12:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLGLL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 06:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiLGLKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 06:10:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B092B24E;
        Wed,  7 Dec 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529A0614C9;
        Wed,  7 Dec 2022 11:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA884C433D7;
        Wed,  7 Dec 2022 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670411416;
        bh=0jJul38H7b6a7pV+bfmeR+4Ek1fomNZg73Xrsb1RXkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pJ6XI7BMgdLF7pbXMNKMeE+3OyMfv0EYiGj7jtqHx9+sgD6d0NndLbanc/FC/GcyV
         igII75xYk3rMZXMUU0aZHBZqFq1r8spBs/XJpbbaXMiW7TCJM84f3fdqi1Ml+pMScM
         hB3Hf7yw3xaeUEeJ5+D996SJbog/eR+kyT8FHl8WKSRrbxLicZuqMwcwsAnORhlJlp
         vK2o8yjkWZfBeoNRdr2VOmZr1nKcwu4eq6SmbnmZxtH7Tl5fEidvOPwDj3Z6yF954s
         /iRUX0jxR2EiDIlMUI0TcxYKDPvOA4pCKOzeg3IODrZ2H8vFTtLO/U/voG5QUPOlTi
         gbCwkKjeYiGbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C286E270CF;
        Wed,  7 Dec 2022 11:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/6] net: dsa: microchip: add MTU support for KSZ8
 series
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167041141656.12492.16254467680010942896.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 11:10:16 +0000
References: <20221205052232.2834166-1-o.rempel@pengutronix.de>
In-Reply-To: <20221205052232.2834166-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
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

On Mon,  5 Dec 2022 06:22:26 +0100 you wrote:
> changes v7:
> - add Acked-bys and Reviewed-bys
> 
> changes v6:
> - move dsa configuration to ksz8_setup
> 
> changes v5:
> - add mtu normalization patch
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/6] net: dsa: microchip: move max mtu to one location
    https://git.kernel.org/netdev/net-next/c/838c19f89454
  - [net-next,v7,2/6] net: dsa: microchip: do not store max MTU for all ports
    https://git.kernel.org/netdev/net-next/c/1d0a1a6d0d63
  - [net-next,v7,3/6] net: dsa: microchip: add ksz_rmw8() function
    https://git.kernel.org/netdev/net-next/c/6f1b986a43ce
  - [net-next,v7,4/6] net: dsa: microchip: ksz8: add MTU configuration support
    https://git.kernel.org/netdev/net-next/c/29d1e85f45e0
  - [net-next,v7,5/6] net: dsa: microchip: enable MTU normalization for KSZ8795 and KSZ9477 compatible switches
    https://git.kernel.org/netdev/net-next/c/6b30cfa86ee7
  - [net-next,v7,6/6] net: dsa: microchip: ksz8: move all DSA configurations to one location
    https://git.kernel.org/netdev/net-next/c/55a952eef70a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


