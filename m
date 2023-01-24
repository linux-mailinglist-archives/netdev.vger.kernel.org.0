Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDD167943C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjAXJaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjAXJae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:30:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC22E2;
        Tue, 24 Jan 2023 01:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D60060ABE;
        Tue, 24 Jan 2023 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62B26C4339B;
        Tue, 24 Jan 2023 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674552617;
        bh=cD1moLzej/81XGLGXb1R5ArFd4+6+mHy9yDcyptJzp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuxJhyuu/DWD4gD4602jIrCAD4XA7ttB77Qkxa2Z4pupuV4tfuh+DW4pGJ5DmXp36
         jYIYnxxFXdvT+AN2f0BxUYUO9p5NAJuSRSWho+S4afdeNSSGhga1Sl/UjdkimuJMK6
         kKZl6I5orJ1b3xuGaFaefCkSxMset12C5Gwvz/7FJScdMOVygPnpiKpg7y/yLxEoai
         fBNUL/nPyJ+ssFWPCdXv+VXHqkOLhLdnv/EzBuXrzquuM60HentMiqsEswtd04VJjm
         PdcCJ1O47PCIjP6p6RYx7P07npoB+7nu/0pXsn1hgYbQ4EZAc85YGDMR7YM0lKWHjj
         aV52bkNELrf5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48021E52508;
        Tue, 24 Jan 2023 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/2] Fix CPTS release action in am65-cpts driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167455261729.23317.12594121288407375351.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 09:30:17 +0000
References: <20230120070731.383729-1-s-vadapalli@ti.com>
In-Reply-To: <20230120070731.383729-1-s-vadapalli@ti.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux@armlinux.org.uk, pabeni@redhat.com, rogerq@kernel.org,
        leon@kernel.org, leonro@nvidia.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Jan 2023 12:37:29 +0530 you wrote:
> Delete unreachable code in am65_cpsw_init_cpts() function, which was
> Reported-by: Leon Romanovsky <leon@kernel.org>
> at:
> https://lore.kernel.org/r/Y8aHwSnVK9+sAb24@unreal
> 
> Remove the devm action associated with am65_cpts_release() and invoke the
> function directly on the cleanup and exit paths.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/2] net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
    https://git.kernel.org/netdev/net-next/c/0a974b1fff7f
  - [net-next,v5,2/2] net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action
    https://git.kernel.org/netdev/net-next/c/4ad8766cd398

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


