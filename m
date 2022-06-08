Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B72E542824
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiFHHW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242646AbiFHFyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCFC38C099;
        Tue,  7 Jun 2022 20:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99084618C8;
        Wed,  8 Jun 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBE05C341C7;
        Wed,  8 Jun 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654660214;
        bh=zvc5dPjGHLIiwFXIyn4yFbXnGs9Wvp4EGzk9Sq+ECTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Suh1aCUnML21wTTwN7/s0gDbthDB/Poe+oLcd4nRcThht78KCex97FxLOtRUVDv++
         P9CVfwGcYyE25JSTBxH0/hkadAO8/Bt90Al5n9P9qElvHr0930NXRgemyzdCrCQ3q7
         LhJxEIOEP7g6D8qldGZaP9FXIh20RFmUFv6k6C/4iBaGfn7x5ieyVkS3GynWGrLygZ
         sTtfo0uV5o3ED1cAad5QrRaQclgu4otXt9Pc8JbYGa0gQdOBKYOIV9FyG17O261B5Z
         WunFHf+oNHxoT/+fZ6CK2PR6XqOVslkprp/u9mtQVBRyrBfxYgTD/dQArXTzFpNqkM
         7GGjn4DjVNTiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6688E737F4;
        Wed,  8 Jun 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: microchip: ksz8xxx: Replace kernel.h with the
 necessary inclusions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165466021387.10912.5607242798001878048.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 03:50:13 +0000
References: <41d99ef8629e1db03d4f2662f5556611e0b94652.1654323308.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <41d99ef8629e1db03d4f2662f5556611e0b94652.1654323308.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  4 Jun 2022 08:15:21 +0200 you wrote:
> When kernel.h is used in the headers it adds a lot into dependency hell,
> especially when there are circular dependencies are involved.
> 
> Replace kernel.h inclusion with the list of what is really being used.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: dsa: microchip: ksz8xxx: Replace kernel.h with the necessary inclusions
    https://git.kernel.org/netdev/net-next/c/67074ae6af59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


