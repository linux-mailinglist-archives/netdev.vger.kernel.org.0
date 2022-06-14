Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183E354A958
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 08:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350248AbiFNGUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 02:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiFNGUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 02:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4449D37A3A
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB537B8179F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94429C36B0A;
        Tue, 14 Jun 2022 06:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655187613;
        bh=73CMROdZ3xz+8GPRG+cyYo0ddkY+491w9BKJbEgM5mo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YJfy7/nwOSpOPumdHCLAMg/XjzWk27Am70tUIaGdqteGsOqK6/cn6HZ0lCYmhpCjq
         A6GXRm5GB76TRaLc8UAdxir76Of+rxDgkNo/Uz9vx8EdsdODCf3EhrFIbqbwzAP2pm
         xNo/gzJp5Er/B1+rKWlYO7CeGwYbR2ivIkIMBiwnyUij7BTxHcbjINL/KQzTiwvLU1
         p9s9AkpP/qfENoTkYW1VmGmVqC/TCSFKT9aIhqYv3VNwt0I2TMuNsXyiS3V5zt2aco
         Mh728tv9nqjWy1wl8gcWvKGwJswJhR/1vzy71rmCyZQ+y3Ro3cDs8Rhz8kep5o8UUW
         n79IsVC2+xZbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7948CE7385C;
        Tue, 14 Jun 2022 06:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] amd-xgbe: Use platform_irq_count()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165518761349.22663.18034388116300493715.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Jun 2022 06:20:13 +0000
References: <20220609161457.69614-1-jean-philippe@linaro.org>
In-Reply-To: <20220609161457.69614-1-jean-philippe@linaro.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh@kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com, maz@kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 17:14:59 +0100 you wrote:
> The AMD XGbE driver currently counts the number of interrupts assigned
> to the device by inspecting the pdev->resource array. Since commit
> a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
> core") removed IRQs from this array, the driver now attempts to get all
> interrupts from 1 to -1U and gives up probing once it reaches an invalid
> interrupt index.
> 
> [...]

Here is the summary with links:
  - amd-xgbe: Use platform_irq_count()
    https://git.kernel.org/netdev/net/c/884c65e4daf3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


