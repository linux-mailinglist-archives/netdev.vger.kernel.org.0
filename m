Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1D556FFA
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiFWBkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiFWBkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E554161F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8291660AAF
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E272EC341CE;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655948413;
        bh=5albo3QQzYJ5xil3jRusH4CdPR0cY8+DiDXFHsKqr3M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u7t4V5v9pXGhGAgp1GJcS+zH4D3XGMrEWfhyF1ZP2aCzKHvCwi5S/Ew22iIZwQVBJ
         SanX3bsNxuztmSf3a7bqraLgJr3J73xUdzd+FzQsxabsVAtE1hEwI7TH4o12k1iuum
         B2tfcy/lPmchj8rGZ1pl9qj4JQLL9d3xr1RF+/UP42AwaHkk5ebvLVkWhN+mCvcWQK
         mEaccs5pqqzcmHus73LqpAt3LI+fL4wC5W5qktUKHKUYsyoX9PiL/CNtD8DkW/pKdE
         HxCtgKZpdtSZR4N11ZsmfycyB3jToFxfToL94ZA+WPYF6zx/5Wn4eIiT4IDhJ2rqga
         JTLdsDVZZ7jHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC408E574DA;
        Thu, 23 Jun 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pcs: lynx: use mdiodev accessors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594841383.25849.9692740188151309994.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:40:13 +0000
References: <E1o3Zd8-002yHI-G2@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1o3Zd8-002yHI-G2@rmk-PC.armlinux.org.uk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     ioana.ciornei@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 21 Jun 2022 09:53:02 +0100 you wrote:
> Use the recently introduced mdiodev accessors for the lynx PCS.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-lynx.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)

Here is the summary with links:
  - [net-next] net: pcs: lynx: use mdiodev accessors
    https://git.kernel.org/netdev/net-next/c/a8236dfd8104

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


