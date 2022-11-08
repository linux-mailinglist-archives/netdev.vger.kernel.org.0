Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9536206C8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiKHCaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiKHCaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51061A054
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CC8B81899
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D9B6C43145;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874616;
        bh=qNsRnVygBwuhqiMUwxaRjyN6TJWv+oRrKbBhAI8xwDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W1JKX5Za6qu76kNj5TVdGC0vI0o0hwmOsjm/jZmMR5jS6fV7w94EzoAGsR2HYFgyH
         CvsS95HJc1A/aqY9lCcLNNVeAj7THHOu8ltk1gJd6hwMqjmj1X+Ep3iCtjLHJY6+nD
         U042sznhLJ3ChWh+arPjBKZGqsFserzWmaM+h8t1WIaRw3ywIIE0oN49FridJpOd2u
         nFYtFTDsaaJ3SXR+kPTUG3PeqWn8q639ZrWaDo224bsTlVG6/4LH2Fl66LqdoCanLE
         mm3zSXNAwwbG3ial1234OXpigaYHz23oIrmf4CxIyKY/+Y2Cp/hnM65365QWugOmjp
         pJAR7qpKpl1ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2857DE4D000;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: move unnecessary linux/sfp.h include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461616.16737.10230794068624693236.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:16 +0000
References: <E1oqzx9-001r9g-HV@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oqzx9-001r9g-HV@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 04 Nov 2022 16:53:59 +0000 you wrote:
> lan966x_phylink.c doesn't make use of anything from linux/sfp.h, so
> remove this unnecessary include.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: lan966x: move unnecessary linux/sfp.h include
    https://git.kernel.org/netdev/net-next/c/7ea8104d9e3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


