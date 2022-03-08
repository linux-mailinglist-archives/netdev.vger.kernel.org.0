Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14274D1A93
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241359AbiCHObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiCHObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:31:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FBA4BFD1;
        Tue,  8 Mar 2022 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C54860F19;
        Tue,  8 Mar 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99A3AC340F4;
        Tue,  8 Mar 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646749810;
        bh=BuOyZy4iBLoBVu61r8rC76BuAwaWVN9Dl1tsNCf623A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LIHQ6bTVARtbvhDFmCwYFL+31F1SE9l23hWzfn6fGeVDBhlT7H6o638jptxlj0mlN
         yrvBrtvABM2Djta2oRU65LuLRZU1Y9CWzbUsKwno0BERMyLv8cnkrQWV2BSWwc6A7D
         J9HpsoLgU+9Bz4xuxhKU+gn38/nn/3ipQ8Zb5XSNS3osmLp9lvib+IWXROYr4pF7rG
         Fdb+b1GiQ0t6XHgq8Uwd+IXMDlBVyWDIAD7SipSoNgijzR6rpwDnGGFPQ4iMEWilJo
         cfaZopQVyx8x36JQWjp99qsn5GTZP3/rQgsqLpm7KgM2LuPhqH63LzGCvSg5QCiZp1
         9oPecnhJiqHGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D221E6D3DD;
        Tue,  8 Mar 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: phy: lan87xx: use genphy_read_master_slave
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164674981050.5894.8714803108771369458.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 14:30:10 +0000
References: <20220307161515.14970-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220307161515.14970-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, davem@davemloft.net, UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 7 Mar 2022 21:45:13 +0530 you wrote:
> LAN87xx T1 Phy has the same register field as gigabit phy for reading the
> master slave configuration. But the genphy_read_master_slave function has a
> check of gigabit phy. So refactored the function in such a way, moved the speed
> check to the genphy_read_status function. Analyzed the nxp-tja11xx function for
> refactoring, but the register for configuring master/slave is nxp specific
> which is not extended phy register.
> And analyzed the reusing genphy_setup_master_slave, but for LAN87xx
> MASTER_ENABLE is always 1 and Preferred state is always 0. So, I didn't try to
> change it.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: exported the genphy_read_master_slave function
    https://git.kernel.org/netdev/net-next/c/64807c232151
  - [net-next,2/2] net: phy: lan87xx: use genphy_read_master_slave in read_status
    https://git.kernel.org/netdev/net-next/c/f1f3a674261e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


