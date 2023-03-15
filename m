Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 969B16BA967
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjCOHdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCOHcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:32:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7B85C9FB;
        Wed, 15 Mar 2023 00:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B70C4B81CC0;
        Wed, 15 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4C4D6C433A7;
        Wed, 15 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678865419;
        bh=7zGI6N4tHJK845F9zP3r7bSEDP0Q4Lzfdush2LqEOqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rTVU/6Ndc8uBFrp4oC4ooc+KQN8OdtuQg6mHhVjKFU93+xqx21cGanDp4FIdtd74W
         z8RmnCTe7cwwEIM6ywi8Tr26B8vCrMhN5rhrpzEQ5R8CefVwgRm0SaNepd0A7PeAGi
         MYF0kgGrvuL5gxOp/xWZUhrzSLGoU95K7DZskLsO+kOKXhTL5Mp7cOufP02bRBwWXe
         sPfpZHzaY9vhJc6BhDuP1kQJ9nOzT/j0flHSSipIxV1WRr/1ydl65a0KSKGMREKOeT
         hL33Zrhpl1+XGEF1QhRpZL1sSzXtI+XoiiqfktCuc+Keppwke63yJ6jbGnDeeD5x2b
         DqAUjZcMnE8hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32180E66CBA;
        Wed, 15 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: Change lan966x_police_del return type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886541919.32297.4150082080810118759.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:30:19 +0000
References: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 12 Mar 2023 20:51:55 +0100 you wrote:
> As the function always returns 0 change the return type to be
> void instead of int. In this way also remove a wrong message
> in case of error which would never happen.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/lan966x_police.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: lan966x: Change lan966x_police_del return type
    https://git.kernel.org/netdev/net-next/c/68a84a127bb0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


