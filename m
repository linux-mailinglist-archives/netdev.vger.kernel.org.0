Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FD2516785
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 21:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352937AbiEATnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 15:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237507AbiEATno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 15:43:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C3F1126;
        Sun,  1 May 2022 12:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B646B80EF2;
        Sun,  1 May 2022 19:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AC8FC385A9;
        Sun,  1 May 2022 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651434013;
        bh=Eaf475SVp08eFN0aQeF8QT7km8wrzXM1X7kUmOZNM5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CLL+klXKc5DDOTrTKCpzUToUiU2w9trMLtHmUPs36LP/G+Oa1POeOeWtKxzjSLD9g
         BlS6FEPJddpnNSce1YveNUKy0QeO2wKcMkP24+wIyj8AvXxdTFhfSP9nbdvhuNsAEZ
         p+6f/bf7Kiw7u2Fhxo012qXaqIJPKSimBaPDckmaJf3DLopxM1VMqVxzNYcXHblbMa
         bUjpr+5BespW/mdIgkNk+M/Hf9NIcrQqmG8PqB26qIAVVWl4f9prm1oJvV1YtTgztf
         YnM3fBIer+UmcruZu+cjsRmO1E2OhdtL8BhyaQc0bFAN3opZJ67mSFAgv1+oo1+t1v
         wtjVvXTPtAxqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CAC7E85D90;
        Sun,  1 May 2022 19:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 0/7] net: phy: adin1100: Add initial support for ADIN1100
 industrial PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165143401304.26026.480568891228725285.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 19:40:13 +0000
References: <20220429153437.80087-1-alexandru.tachici@analog.com>
In-Reply-To: <20220429153437.80087-1-alexandru.tachici@analog.com>
To:     Alexandru Tachici <alexandru.tachici@analog.com>
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Apr 2022 18:34:30 +0300 you wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> industrial Ethernet applications and is compliant with the IEEE 802.3cg
> Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> 
> The ADIN1100 uses Auto-Negotiation capability in accordance
> with IEEE 802.3 Clause 98, providing a mechanism for
> exchanging information between PHYs to allow link partners to
> agree to a common mode of operation.
> 
> [...]

Here is the summary with links:
  - [v7,1/7] ethtool: Add 10base-T1L link mode entry
    https://git.kernel.org/netdev/net-next/c/3254e0b9eb56
  - [v7,2/7] net: phy: Add 10-BaseT1L registers
    https://git.kernel.org/netdev/net-next/c/909b4f2bf764
  - [v7,3/7] net: phy: Add BaseT1 auto-negotiation registers
    https://git.kernel.org/netdev/net-next/c/1b020e448e0f
  - [v7,4/7] net: phy: Add 10BASE-T1L support in phy-c45
    https://git.kernel.org/netdev/net-next/c/3da8ffd8545f
  - [v7,5/7] net: phy: adin1100: Add initial support for ADIN1100 industrial PHY
    https://git.kernel.org/netdev/net-next/c/7eaf9132996a
  - [v7,6/7] net: phy: adin1100: Add SQI support
    https://git.kernel.org/netdev/net-next/c/48f20f902119
  - [v7,7/7] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
    https://git.kernel.org/netdev/net-next/c/49714461b797

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


