Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CFA6BAAA0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjCOIU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCOIUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B8F1A64C;
        Wed, 15 Mar 2023 01:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F30961C06;
        Wed, 15 Mar 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E48FEC433D2;
        Wed, 15 Mar 2023 08:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868420;
        bh=T3IP+fhPBj/Uguzw4H58V6oNktuwYLOa2oeYjb8iGYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H/HURorHz/x7wm4z1A/UBIVFxLoB1ZesZdMR+QJQjbYPM65Cn3B1N0D8zbX1Qkh36
         QERizrZnvkoUhOQEaJxP5YA/76v9foEMZv4qo/FtePBlYOdq9onMS+RgWTdDuKIKvA
         YJSdlYKSNpeI3wy6y8PQ9N+xOdp1m92Znu4X1P6dsq+A2Iwnghi7nGDpVXR+THHUs2
         Vf+vvXtawcVoLh8sqs7V/78ri2eKdbdyBddoVfeAelP8bKrWbNbI1Xi6lnTig6qBqR
         ZUp/neM0RMrpFbsRVGynQGO1ZjexibU9WRyduTUzjeprEGzlRpN8/l8Mg4k1SiEEv6
         XiZOUZ0h7AxHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFE0FE66CBA;
        Wed, 15 Mar 2023 08:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as maybe
 unused
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886842083.29094.15777402773268782712.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:20:20 +0000
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hauke@hauke-m.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, colin.foster@in-advantage.com,
        michael.hennerich@analog.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, miquel.raynal@bootlin.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Mar 2023 18:32:52 +0100 you wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/net/dsa/lantiq_gswip.c:1888:34: error: ‘xway_gphy_match’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> [...]

Here is the summary with links:
  - [01/12] net: dsa: lantiq_gswip: mark OF related data as maybe unused
    https://git.kernel.org/netdev/net-next/c/6ea1e67788f3
  - [02/12] net: dsa: lan9303: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/ced5c5a0a2ea
  - [03/12] net: dsa: seville_vsc9953: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/1eb8566dd08d
  - [04/12] net: dsa: ksz9477: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/00923ff2e1ba
  - [05/12] net: dsa: ocelot: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/0f17b42827ae
  - [06/12] net: phy: ks8995: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/b0b7d1b6260b
  - [07/12] net: ieee802154: adf7242: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/3df09beef650
  - [08/12] net: ieee802154: mcr20a: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/3896c40b7824
  - [09/12] net: ieee802154: at86rf230: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/32b7030681a4
  - [10/12] net: ieee802154: ca8210: drop of_match_ptr for ID table
    https://git.kernel.org/netdev/net-next/c/cdfe4fc4d946
  - [11/12] net: ieee802154: adf7242: drop owner from driver
    https://git.kernel.org/netdev/net-next/c/059fa9972340
  - [12/12] net: ieee802154: ca8210: drop owner from driver
    https://git.kernel.org/netdev/net-next/c/613a3c44a373

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


