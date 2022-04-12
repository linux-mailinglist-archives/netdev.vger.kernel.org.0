Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80C4FCD5F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbiDLECy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbiDLECe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:02:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042DB2E086;
        Mon, 11 Apr 2022 21:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B725B81B1B;
        Tue, 12 Apr 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36F10C385AF;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649736015;
        bh=TY7gGfJs5euHlBN2b6zVY5B8FHjRyu0Gz1a+MlarEaA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cY2XZHv2+GSYnMXVNtFw/9vrLQ6cmsBuoxO4Fu7reUiFQdrV70gDI6LjslCYkF9Cl
         R1TQsTYvyfcUcdfYRHjWoataXhMhxvW7S2Yzv8lUz/RgwMbftqTvNsjMcbu9ID2Dsk
         OzzSFI4rnGUJdHfSqmkNQdlflMBAtbjzHBLFUbga8cAweFlD5Flc4NKf1VJIG+ukxF
         +lx6ukYGCr5cK/Che6GN77iHcDtVFVXOX9vfj/zMb0d6oczpnn2XGzY8lJyUv8fRSW
         FXr+ogwYb2fwlqlLO24eqW4hRPVSOmA426pO/wKPdVRGM+DPhem0igyb+cI30XnK1N
         /kRONJbEFNAQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 224AEE85D15;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: calxedaxgmac: Fix typo (doubled "the")
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973601513.30868.4142850711416395196.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 04:00:15 +0000
References: <20220409182147.2509788-1-j.neuschaefer@gmx.net>
In-Reply-To: <20220409182147.2509788-1-j.neuschaefer@gmx.net>
To:     =?utf-8?q?Jonathan_Neusch=C3=A4fer_=3Cj=2Eneuschaefer=40gmx=2Enet=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, shenyang39@huawei.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat,  9 Apr 2022 20:21:45 +0200 you wrote:
> Fix a doubled word in the comment above xgmac_poll.
> 
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  drivers/net/ethernet/calxeda/xgmac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - net: calxedaxgmac: Fix typo (doubled "the")
    https://git.kernel.org/netdev/net-next/c/d6967d04145e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


