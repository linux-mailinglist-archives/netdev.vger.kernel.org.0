Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3524CFD2A
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiCGLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiCGLlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:41:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467194D9C1;
        Mon,  7 Mar 2022 03:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA42960BC3;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33100C340F7;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646653210;
        bh=rxeOOZ8tZjGQBKqFglb5rX0ZEAGwo8hhabmVkZ7sMgA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nZ7moAqYKFVGaucsnRi8+ARWpI864vVX8vbW+0y0Hca43BfQoGO7xSzs4YNfKbY/7
         eZ/o/5xx6A7X2yK2G4A2U/kqkmtKaWOVhOD7OrHO1FfR1ZOQjl5tdhqXpkZ7aLOFy+
         mtGqCVSt97uJvRhrdx854IAmnzRg719OqjKIWq5eGf3jQbuZjiAk89M5sCOnaAZdvK
         9AuRRklfi5QgVAoAC/lTOxEV0ZdtrXrmoMisgs/gdawHPX1it2W9lTEkVTAg4GdXtC
         k1ivRpsraJZFH23jE6A0C7j5905qQ+jNECiUI4rUY9mOoWvrc5jWaOCskzeauHQPrd
         PgtsTu41p0wRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E03AF0383A;
        Mon,  7 Mar 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: sun: Free the coherent when failing in probing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164665321005.12267.18228725622047635566.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 11:40:10 +0000
References: <1646492104-23040-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1646492104-23040-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Mar 2022 14:55:04 +0000 you wrote:
> When the driver fails to register net device, it should free the DMA
> region first, and then do other cleanup.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
> ---
>  drivers/net/ethernet/sun/sunhme.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - ethernet: sun: Free the coherent when failing in probing
    https://git.kernel.org/netdev/net/c/bb77bd31c281

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


