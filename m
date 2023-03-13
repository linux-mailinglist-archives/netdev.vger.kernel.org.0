Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B8D6B85CB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 00:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCMXBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 19:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCMXB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 19:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75676F62D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 16:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55FB361551
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8151C4339B;
        Mon, 13 Mar 2023 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748417;
        bh=Pnh6bZZbAGLF/Ss4maXq1i4uVCSifXU3XHMNX4+knAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bAjWbnraDdoO0YS+daSWit3WnXyH1CG51TaW5t3DGZqAHBS4fCH6IsxI3wGSS4wbr
         n2/MkbLx0gDJGKLes+7t/xfGNjPkMzExtel52fgc1dec9Z4Xl1uelvnAucwmvIBaki
         /fSN1qoahpbl6MGFEjlFGqu9r7UtIB52whhJbDgB9ARYOn1migMwL2YpdWtkcPyvpM
         SWj2928akMg6X8h/NfqL4R4qasmKn6LIYJK2iv6OLV6IGALE20skOGJ6pwnKUZPw6U
         H4tFt+YQqXK8W/jg87daNWL77UhCQnx2N2VelEaN81IYdM67UzGLgYX3M55TLfdz98
         5JLwUtOZLBVUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 858B8E66CBF;
        Mon, 13 Mar 2023 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] net: phy: dp83867: Disable IRQs on suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167874841754.13753.8786201464743030350.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Mar 2023 23:00:17 +0000
References: <20230310074500.3472858-1-alexander.stein@ew.tq-group.com>
In-Reply-To: <20230310074500.3472858-1-alexander.stein@ew.tq-group.com>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 08:45:00 +0100 you wrote:
> Before putting the PHY into IEEE power down mode, disable IRQs to
> prevent accessing the PHY once MDIO has already been shutdown.
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> Changes in v2:
> * Directly call dp83867_config_intr
> * Call genphy_resume after enabling IRQs again
> * Removed superfluous empty line
> 
> [...]

Here is the summary with links:
  - [v2,1/1] net: phy: dp83867: Disable IRQs on suspend
    https://git.kernel.org/netdev/net-next/c/c5a8027de26e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


