Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABE154EFD6
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 05:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379784AbiFQDua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 23:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379732AbiFQDu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 23:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B943663D8;
        Thu, 16 Jun 2022 20:50:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9709961D94;
        Fri, 17 Jun 2022 03:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E88F1C3411E;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655437827;
        bh=G8FqeFlbr8AAA/rkEUoKjC5eW6kixgmtoNWc8L0rPQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AxweH+TTpIVz9baFp5kK1+gZSKy6CYuW6OMp3JKJH67GTAtvKMGlzQkjhp4YzyTcl
         JWUzys+EYAdsuNUukDcVJoY/8m6DY52NRCpFkW5kImrhe4FV/pYcuIvOrXGUCv6I+1
         kktEmQWMFkANlb/r/jzTiSU7LR2v0kaRWPHIlOpzO6+uRekSC9dQn4iWzpxz3szsLC
         +/JRSuPGVHZT1YTiVfgzcbhaO6nD1sebtykrYbttZjgh7FtdXBxbu76nsby0kQwmY2
         A1M8J4WAN5RbsqTcfjPTzFQp8aksW5GxOortUJNxV+Br21qPXi1qJr5j2yFoW1oblp
         p52aB6SjCB3sA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C56EBFD99FF;
        Fri, 17 Jun 2022 03:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/4] net: lan743x: PCI11010 / PCI11414 devices
 Enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165543782680.2027.11331513198206749241.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Jun 2022 03:50:26 +0000
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
In-Reply-To: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrew@lunn.ch,
        lxu@maxlinear.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, bryan.whitehead@microchip.com,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 09:42:22 +0530 you wrote:
> This patch series continues with the addition of supported features
> for the Ethernet function of the PCI11010 / PCI11414 devices to
> the LAN743x driver.
> 
> Raju Lakkaraju (4):
>   net: lan743x: Add support to LAN743x register dump
>   net: lan743x: Add support to Secure-ON WOL
>   net: lan743x: Add support to SGMII 1G and 2.5G
>   net: phy: add support to get Master-Slave configuration
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/4] net: lan743x: Add support to LAN743x register dump
    https://git.kernel.org/netdev/net-next/c/9aeb87d2b5a1
  - [net-next,V2,2/4] net: lan743x: Add support to Secure-ON WOL
    https://git.kernel.org/netdev/net-next/c/6b3768ac8e2b
  - [net-next,V2,3/4] net: lan743x: Add support to SGMII 1G and 2.5G
    https://git.kernel.org/netdev/net-next/c/46b777ad9a8c
  - [net-next,V2,4/4] net: phy: add support to get Master-Slave configuration
    https://git.kernel.org/netdev/net-next/c/311abcdddc00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


