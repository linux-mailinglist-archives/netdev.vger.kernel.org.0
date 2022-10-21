Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4530606F33
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJUFLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJUFKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FB1181954;
        Thu, 20 Oct 2022 22:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF29361DD1;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B926DC43141;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329020;
        bh=fAl4fpRSHA7TY4cscfYXpG3I2q0TOJ4NCxgV3cR0hZY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q3SJUCfn7e5Qi6CSxBgeVTpZtUXcAK3OQVIleXcmhhawJ3yRLonDqCh4SQih16uhB
         uSxhMrUkDqMai/bu4GDcnJFFO295L0Dj5reZ2cltmnZcFWYw6iAesxko3svxLlBkz1
         8mWZ37XMCH19u7+fMEtvEhTqXXHKGLpo/JGcUGjCzZPOMelJfP0LNEy+pj7GtxSojW
         BslMNUtLc0NaYPpBsnYf4t3RyiIjTdQ4cH0OjGQQT7/+McroVbBU82QH9ix4xAmzTN
         tjSDKjb24hhDx6xjvexv8gCPf6qYrd7SSCLzBE6TSN7R2ZYfBMLkC4zCLRl+OJOe6t
         7xnrtVWbaEF/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A06ABE270E1;
        Fri, 21 Oct 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: macb: Specify PHY PM management done by MAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902065.25874.11806120795361484101.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:20 +0000
References: <20221019120929.63098-1-sergiu.moga@microchip.com>
In-Reply-To: <20221019120929.63098-1-sergiu.moga@microchip.com>
To:     Sergiu Moga <sergiu.moga@microchip.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        tudor.ambarus@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Oct 2022 15:09:32 +0300 you wrote:
> The `macb_resume`/`macb_suspend` methods already call the
> `phylink_start`/`phylink_stop` methods during their execution so
> explicitly say that the PM of the PHY is done by MAC by using the
> `mac_managed_pm` flag of the `struct phylink_config`.
> 
> This also fixes the warning message issued during resume:
> WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148
> 
> [...]

Here is the summary with links:
  - [v2] net: macb: Specify PHY PM management done by MAC
    https://git.kernel.org/netdev/net/c/15a9dbec631c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


