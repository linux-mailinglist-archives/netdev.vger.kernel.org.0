Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1880F6957B5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjBNEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjBNEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027917CE0
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 20:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 578C36140F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1D14C433EF;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347818;
        bh=4fjkDMRrzB3vI7RPysL2qMkgf4eLgrhwGlBnf8QbxAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kgRn2GSS334ZIqTAEjPrsceVR38aJvDwfARNHGJW0MVWWxp4vTXNwjx77cNgc5Lor
         fhNSeORIHiUgaAq0bxuOSwfx2tPXJu7aj/kK1JBv+JkGufAtEWIGzIqpigPou3gbCT
         uxk7t6OQpY1R+gF3Wa9eLjYL9Bjcsmk47eOjhI8V5F0MvhKAAxUfENL1l3yW2GHVFa
         yn/mg08FndNkEwSzIHCuUyOZpKNFJHJcsFHTX0Ub9u5rsv4aH/lWeXhr8dS23s3SYv
         yrJer8sBKtkFfClKXKRibmS1pPgujqMxUfbH/pcbArsBM5ciT9HTozKSJGMDRbFQoz
         Gckx27B2gWDvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96181C41672;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: stmmac: Make stmmac_dvr_remove() return void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781860.18399.10618008698033755860.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:18 +0000
References: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230211112431.214252-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
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

On Sat, 11 Feb 2023 12:24:30 +0100 you wrote:
> The function returns zero unconditionally. Change it to return void instead
> which simplifies some callers as error handing becomes unnecessary.
> 
> This also makes it more obvious that most platform remove callbacks always
> return zero.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [1/2] net: stmmac: Make stmmac_dvr_remove() return void
    https://git.kernel.org/netdev/net-next/c/ff0011cf5601
  - [2/2] net: stmmac: dwc-qos: Make struct dwc_eth_dwmac_data::remove return void
    https://git.kernel.org/netdev/net-next/c/1a940b00013a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


