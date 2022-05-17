Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DCD5296A3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiEQBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiEQBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311F11FCEF;
        Mon, 16 May 2022 18:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4628B816C3;
        Tue, 17 May 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E325C34113;
        Tue, 17 May 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652750411;
        bh=cn8ab4tcHLG2clAhzQCHceYS2l/6DzAN09QERtSLn3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UVHOjXKcG5uUQdn+j/TwcTZDcSaASl4It1ISvookQ9RCxJ2rsPeBBLlKOHXrc0Iem
         e9csfgwCTjaTmTPl5N3d0t6KPftmkDZeSWF+jk6Pt8i5HQXk90ZzoMq558b6I0pR2o
         UGN+0FTcVvgozt3ekCK/tW+7R0T/IYxhbNr7c9O1R/I3nYu4TvzJKrHYyQegOoyRKj
         0iIsYAtDRoP9b09YIpusyi02bTyeiZGCtU9JNvdSpUYKm/lHlFBWNcW72xQ2p7+2/M
         jJ9JsX/rP0L9mDu2S7ysuyKd6Keeh/W2YEWCm63OZHkq0iL8UjZUhVTlr3ZdEK/SX/
         jF73lLg8DXRJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6261AF0392C;
        Tue, 17 May 2022 01:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: Fix unmet direct dependencies
 detected for NVMEM_SUNPLUS_OCOTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165275041139.25385.13288823924404480266.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 01:20:11 +0000
References: <1652443036-24731-1-git-send-email-wellslutw@gmail.com>
In-Reply-To: <1652443036-24731-1-git-send-email-wellslutw@gmail.com>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wells.lu@sunplus.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 May 2022 19:57:16 +0800 you wrote:
> Removed unnecessary:
> 
> 	select COMMON_CLK_SP7021
> 	select RESET_SUNPLUS
> 	select NVMEM_SUNPLUS_OCOTP
> 
> from Kconfig.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: Fix unmet direct dependencies detected for NVMEM_SUNPLUS_OCOTP
    https://git.kernel.org/netdev/net-next/c/6251264fedde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


