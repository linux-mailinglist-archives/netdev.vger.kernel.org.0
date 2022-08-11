Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEFA590605
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbiHKRkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234907AbiHKRkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FD5BC18
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 10:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB67361743
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AAC3C433D7;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660239614;
        bh=893VgyxvcmxuG1mTEMqVDH7C32HGE87KnLHgL1VyaT0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q02tE53rQPtRoe3vo+BC+tbWKpPkB61uuEGtIIsBuBQlqqZcUfM31jvSmcmnkNDrK
         yEPx0g8dk5rNp7JauFzo8Fxbr0pfYGflg+8uw6sze+XMEN4UeY6GYIPftPikb1iHqc
         zU6a+lckAdItZUlBd5AVn6ywMVmjuQvlh0YQc0kswD2rFKVc1uMxuAP2Ozj1WeJYYc
         rPPw4mYQ+qiqYpu3U2UP55KES7bkNv+uxZLDPVhmxW3CCDha6CCdW45XAIMgYGwtSX
         GeoyP5tIWuxWTYuVZTNkDJNzebPnqGDwdy7jA430rY0TYWgfpkawUd07Z08FVWJzWI
         onwrK/06OtHFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E333C43142;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: atm: bring back zatm uAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023961411.31756.18114632222519401235.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 17:40:14 +0000
References: <20220810164547.484378-1-kuba@kernel.org>
In-Reply-To: <20220810164547.484378-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jirislaby@kernel.org, arnd@arndb.de
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Aug 2022 09:45:47 -0700 you wrote:
> Jiri reports that linux-atm does not build without this header.
> Bring it back. It's completely dead code but we can't break
> the build for user space :(
> 
> Reported-by: Jiri Slaby <jirislaby@kernel.org>
> Fixes: 052e1f01bfae ("net: atm: remove support for ZeitNet ZN122x ATM devices")
> Link: https://lore.kernel.org/all/8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: atm: bring back zatm uAPI
    https://git.kernel.org/netdev/net/c/c2e75634cbe3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


