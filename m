Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F955797CE
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiGSKkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiGSKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC7764DC;
        Tue, 19 Jul 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A5A6145D;
        Tue, 19 Jul 2022 10:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A82F1C341CA;
        Tue, 19 Jul 2022 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658227213;
        bh=qvhkpMRddHvQfPRFR7U/uabTs0X5ItLi4j1JcUHmutI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sYchI28UbpiDE9EOH/ie7swZlbgVOOfsddPEHu2On87HRIsPrl3w7y+TFwG6fYVIx
         VrDyX8R56yxqqDuur6p4tiG2Ixc18/AH4cT20Mu2H5G1m9X4J0oLjgI0UGXJjB8dfC
         cWQFqMW7tJEMGP8AQCmQ+RGEw2if7wwvqfdRJxHvvCLV73AKD98qVL2kKZUK6a5kGH
         13C3mHGIfYI0tiyqiM4NOjGDuGWioOF5AOHdFsjSO4QhdIj7XguQV+sUR9waH5qVBJ
         hFnurIVISTZ8i5c6YLSAbzoIX4EySdUvMWozPpsYxtKFQTtxeeA6hM+Y6uEFHUy7xi
         AO36y+Gr9knrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D902E451BA;
        Tue, 19 Jul 2022 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] net: dsa: sja1105: silent spi_device_id warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165822721357.28275.6504175351310430939.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 10:40:13 +0000
References: <20220717135831.2492844-1-o.rempel@pengutronix.de>
In-Reply-To: <20220717135831.2492844-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 17 Jul 2022 15:58:30 +0200 you wrote:
> Add spi_device_id entries to silent following warnings:
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105e
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105t
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105p
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105q
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105r
>  SPI driver sja1105 has no spi_device_id for nxp,sja1105s
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110a
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110b
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110c
>  SPI driver sja1105 has no spi_device_id for nxp,sja1110d
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: dsa: sja1105: silent spi_device_id warnings
    https://git.kernel.org/netdev/net/c/855fe49984a8
  - [net,v2,2/2] net: dsa: vitesse-vsc73xx: silent spi_device_id warnings
    https://git.kernel.org/netdev/net/c/1774559f0799

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


