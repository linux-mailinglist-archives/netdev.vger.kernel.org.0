Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0464D4015
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiCJEBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiCJEBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:01:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE5812CC07
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D0D5B8248B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DCE6C340F4;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884811;
        bh=6i4u6KwyCnCdAs0K5LYXId3Xf41NoIA1ge2xN62Ie18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UTbkDwlRsthrC+p2lEF62kZHiIWjE94JnFTZ3tygRL7/qhslJbY+bl+hLqL4g0CxF
         MCVyz8xk3YMWuFkgx+Uuq7Y3PhI0pFqru2QmXw0ml3t3lDPRNxfpibCGl2+gqZWkGR
         n8TwKClhrpigm1CTsIZwhfu8QDfiaGJqWYAy0I6BxPQpaE2HP7680CTjoenKtnnB/E
         ubFvZOPfUcyI9rc04yap76L187yp5XCtxyAZXK47RRXPbMu10Dz2NjYb92iAzE7K+N
         ycCUX0eozR/BJ8VBAXTMUVPm7L3oxUiMrhe+iVDgjius/omRwVF2kV/LzBQVw8F2u1
         GSOGGUMlXWKLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12A51E6D3DE;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: switch no PTP HW support message to
 info level
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688481107.32652.14646023342949413674.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:00:11 +0000
References: <ee685745-f1ab-e9bf-f20e-077d55dff441@gmail.com>
In-Reply-To: <ee685745-f1ab-e9bf-f20e-077d55dff441@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com, kuba@kernel.org,
        davem@davemloft.net, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 8 Mar 2022 19:42:57 +0100 you wrote:
> If HW doesn't support PTP, then it doesn't support it. This is neither
> a problem nor can the user do something about it. Therefore change the
> message level to info.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: stmmac: switch no PTP HW support message to info level
    https://git.kernel.org/netdev/net-next/c/1a21277190c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


