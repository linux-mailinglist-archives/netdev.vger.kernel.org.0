Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515A669C846
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBTKKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjBTKKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF786CC22
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759C1B80B9E
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 10:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C570C433A1;
        Mon, 20 Feb 2023 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676887817;
        bh=qdDhHCnzWaLiwJPka8aq/J8O/7jY0cOghGaESA23BAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hwuYDBOrQDIazFA/7twnYUMTxth/3V0XGtXk5lKJhsp29b1U5jblzDYuPHGjeDiZV
         WgSqL9mBhIuhU3mONGbeOycEYY5WwuH2QnhIlNjJtWPiO+s7ALuF3KYsVier1f6Oqy
         T2WDybdKCQr8XgaWC+4BKoGILlc8d64j32C0VdsyK4WsnfBsgpOWzv5bN2fHlniAXk
         bA2j2cz95xNLm1z1wd7HQCwx4J8VbJJHTRTDjU5W2MDWvKMdsIqJ+fe+kaNmx7ocFg
         UaWB1e0wQMdhznP9/GC9SDAHPxZF5XB2vsfcBL2WErOD4SEf6d+uq01hRPIm1svoiU
         ++gEDrtDpgeXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3B01E68D20;
        Mon, 20 Feb 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: Read EEE abilities when using .features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688781698.25409.17357364742742816654.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:10:16 +0000
References: <20230217031520.1249198-1-andrew@lunn.ch>
In-Reply-To: <20230217031520.1249198-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, f.fainelli@gmail.com, linux@rempel-privat.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 04:15:20 +0100 you wrote:
> A PHY driver can use a static integer value to indicate what link mode
> features it supports, i.e, its abilities.. This is the old way, but
> useful when dynamically determining the devices features does not
> work, e.g. support of fibre.
> 
> EEE support has been moved into phydev->supported_eee. This needs to
> be set otherwise the code assumes EEE is not supported. It is normally
> set as part of reading the devices abilities. However if a static
> integer value was used, the dynamic reading of the abilities is not
> performed. Add a call to genphy_c45_read_eee_abilities() to read the
> EEE abilities.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: Read EEE abilities when using .features
    https://git.kernel.org/netdev/net-next/c/c2a978c171a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


