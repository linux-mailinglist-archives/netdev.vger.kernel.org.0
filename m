Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFED4CD478
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbiCDMvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiCDMvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:51:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085461B1DDB;
        Fri,  4 Mar 2022 04:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F88561E34;
        Fri,  4 Mar 2022 12:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C44B0C36AE3;
        Fri,  4 Mar 2022 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646398211;
        bh=8E590hgOzdtfm609w/+T6E0nCXsdC+UBFBK7EOHlaDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L276cVRzbdP66ujtroJKO66aO08fumiEFmuk+yQyLruRfAFOjSPvB9DXDjaEhttSs
         i0xoD+kxd/nKvGruMIh0rxnhP9XfcM9EtZi5+/URy64atVOl2E9fvn2FM4/Lo6BXKp
         jiFdm7jQESOh7ZiSQnMWwNT931ox58t6JaAfD1jj24W7CNFUa+p56CbUempM+/dPcj
         7ULp+XEMJJG0zD5cUGOeBUynnwRiIlYXuRtzADCDi1vID0hZJ1znzYqtoJzhSA85H+
         Tt4d24YOk2r1SZSZQuDg5suPbNhepAiiTnXQqUhJX1bVtt98/eOZKgERNqtIhnjOgA
         V2ehjDUA4yGYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8833EAC09D;
        Fri,  4 Mar 2022 12:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 12:50:11 +0000
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
In-Reply-To: <20220304093418.31645-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 4 Mar 2022 15:04:15 +0530 you wrote:
> The following patch series contains:
> - Fix for concurrent register access, which provides
>   atomic access to extended page register reads/writes.
> - Provides dt-bindings related to latency and timestamping
>   that are required for LAN8814 phy.
> - 1588 hardware timestamping support in LAN8814 phy.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: phy: micrel: Fix concurrent register access
    https://git.kernel.org/netdev/net-next/c/4488f6b61480
  - [net-next,2/3] dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
    https://git.kernel.org/netdev/net-next/c/2358dd3fd325
  - [net-next,3/3] net: phy: micrel: 1588 support for LAN8814 phy
    https://git.kernel.org/netdev/net-next/c/ece19502834d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


