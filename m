Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F1262B286
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiKPFAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiKPFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A93F3204E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52D3BB81BD2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4D3EC433B5;
        Wed, 16 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668574820;
        bh=T2zGLyymWNjKFylVkNhXJH+RcEMl+7WVEBFmQJFXfx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f1UHMPL5HWEgzwDKxPzRuSyC99S2eZXyvEPkLL3pLARbaB0R3ISMQHDy75EN6Ucnx
         n9xFeS+DLbIJYVqcui9wShK2coFKVLqsgT//dGpWJ1UZ0sQKQm1SiRcl16qVhpf/IS
         BZVvSkyqYF2G49yKYqvg4Dsp5IaDqkidM96B73UYzMvIVW8lx5bSieBEAk6N7T7kUw
         ZC4C7or+9PTnUaisj9EPrXRw0yPcb6g1BYNbKTsABnFpoGnraw0Va11g/ngFTHut1I
         ZvVPBSPYz+mRifcByxyDHqVVbrijFuE58IgJXnHLUr30Vg2AFRaQl7pNF/uFnCFWOi
         G2JY4f9F5HVxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2865C395F6;
        Wed, 16 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] Remove phylink_validate() from Felix DSA
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857481979.8148.8505709877128649985.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 05:00:19 +0000
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        sean.anderson@seco.com, colin.foster@in-advantage.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Nov 2022 19:07:26 +0200 you wrote:
> v1->v2: leave dsa_port_phylink_validate() for now, just remove
>         ds->ops->phylink_validate()
> 
> The Felix DSA driver still uses its own phylink_validate() procedure
> rather than the (relatively newly introduced) phylink_generic_validate()
> because the latter did not cater for the case where a PHY provides rate
> matching between the Ethernet cable side speed and the SERDES side
> speed (and does not advertise other speeds except for the SERDES speed).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: phy: aquantia: add AQR112 and AQR412 PHY IDs
    https://git.kernel.org/netdev/net-next/c/973fbe68df39
  - [v2,net-next,2/4] net: dsa: felix: use phylink_generic_validate()
    https://git.kernel.org/netdev/net-next/c/3e7e783291b4
  - [v2,net-next,3/4] net: mscc: ocelot: drop workaround for forcing RX flow control
    https://git.kernel.org/netdev/net-next/c/de8586ed4311
  - [v2,net-next,4/4] net: dsa: remove phylink_validate() method
    https://git.kernel.org/netdev/net-next/c/53d04b981110

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


