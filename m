Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD56E623ABE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 05:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbiKJEAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 23:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiKJEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 23:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F36B303D1
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 20:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09A8EB820BC
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8EB98C433C1;
        Thu, 10 Nov 2022 04:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668052816;
        bh=TjPhICEm7Fdv22lTxTn5WXZYwmeWh/wUaUhjCFTVEJY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kUiGIEVFLdRGlO1h6DUnr5lGBkhBDVCrUmdJaQCJbwLifBwoETLo8uFRxA57gH5zT
         MQNHjWrXTLkNDdgCtHCaaNNMVgr8Sh/7T77y6L3VzqmIWLINYWzwE+M4Qg6U9a7Zgj
         5sT04H8YDeea87wxXXOJLPCZrV/mt1qv+ude9VeheWkWgY/pYgGtGtvUZhvNlriEkv
         Z0aYpJHcpNLsBA7I3zyEn7p13tO2oVGchOsYwhCLAIrbBe5IK32AWy+O4tp8ZVb1AP
         7zzeZ7bhbuSQtTeSO52WgC6o/QUtNDu3OQ3DlVzr6XMmgMIFJpvl8cz/rXJx3lsCzm
         SezJzJ7x0LcKw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C674E21EFF;
        Thu, 10 Nov 2022 04:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Clean up pcs-xpcs accessors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805281644.8987.3565993328738914616.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 04:00:16 +0000
References: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
In-Reply-To: <Y2pm13+SDg6N/IVx@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     Jose.Abreu@synopsys.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
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

On Tue, 8 Nov 2022 14:25:27 +0000 you wrote:
> Hi,
> 
> This series cleans up the pcs-xpcs code to use mdiodev accessors for
> read/write just like xpcs_modify_changed() does. In order to do this,
> we need to introduce the mdiodev clause 45 accessors.
> 
>  drivers/net/pcs/pcs-xpcs.c | 10 ++--------
>  include/linux/mdio.h       | 13 +++++++++++++
>  2 files changed, 15 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: mdio: add mdiodev_c45_(read|write)
    https://git.kernel.org/netdev/net-next/c/f6479ea4e599
  - [net-next,2/2] net: pcs: xpcs: use mdiodev accessors
    https://git.kernel.org/netdev/net-next/c/85a2b4ac3444

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


