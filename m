Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093FA6749A8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjATDAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjATDAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CF59EE3F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 19:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 691B061DF2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1A90C433F0;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674183618;
        bh=P3XR91MbG9XJCJSi6ppTdS9Zw6HM89e783DELJ99GCE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dDtNAvMYG036U2iCRtPDTqRoyt23eYlSoY4XVuCH1N2eiEq2N0n0MAgcJqCSYncKu
         /oAcIt/tn/UvnZHPFk2zlCXvIvex/UP/FtliVehrLTtHzPVPIln5Oua+3SGumzZCBf
         1X7UsR2oqWFIIIAN8S8Zo3lGzeI+o7P+TxyPw5sXctF7SmO+32BnmVg0ip4VGajVOg
         d74K5HirEiXYxsMyz6IV3VsHJDWXk/6RHhf6s0xmqk3ECGuZ8nMv76a6bgDdTBx8fX
         5/4Ef9SV2pkZ/6kJ5UmTtnHieVkU8nYZX80Tm+lj33PXp6rbz5NLDLpzKB4uOFNHJk
         9hSZ23n34pDIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A23ABC4167B;
        Fri, 20 Jan 2023 03:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: sfp: cleanup i2c / dt / acpi / fwnode /
 includes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418361865.28289.5707285801925994167.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 03:00:18 +0000
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
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

On Wed, 18 Jan 2023 10:20:41 +0000 you wrote:
> Hi,
> 
> This series cleans up the DT/fwnode/ACPI code in the SFP cage driver:
> 
> 1. Use the newly introduced i2c_get_adapter_by_fwnode(), which removes
> the need to know about ACPI handles to find the I2C device.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: sfp: use i2c_get_adapter_by_fwnode()
    https://git.kernel.org/netdev/net-next/c/ff31a0c496b8
  - [net-next,2/5] net: sfp: use device_get_match_data()
    https://git.kernel.org/netdev/net-next/c/b71dda81123f
  - [net-next,3/5] net: sfp: rename gpio_of_names[]
    https://git.kernel.org/netdev/net-next/c/f35cb547865c
  - [net-next,4/5] net: sfp: remove acpi.h include
    https://git.kernel.org/netdev/net-next/c/1154261ef0fb
  - [net-next,5/5] net: sfp: remove unused ctype.h include
    https://git.kernel.org/netdev/net-next/c/f8f24a524114

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


