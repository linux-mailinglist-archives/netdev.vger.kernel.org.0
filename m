Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C840571755
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiGLKaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGLKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC57AB7E8;
        Tue, 12 Jul 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8CCECE1A76;
        Tue, 12 Jul 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13F93C341CB;
        Tue, 12 Jul 2022 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657621813;
        bh=8xNdbx2x9z3+FCymDB8bRRrF/+5GApnrzAoBLRnQ7Ho=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KhYcw3scmbSvlBcYa6UiJXOGmyshOb97hIbUHJ5jboeYgttebj662wL2tfZ118oS+
         TMUaxgS+LwJqiNUwsn3W5+IYUQr/gMlndTUR44guzkXO0eEdGLzoUSvW5K1jwBtvhj
         JPXNsTHuffOgcfYlNYVW0DpI+qiZ4Y0IaHub616aqtTq0F14XuM3eIsX82zSDvZKDR
         1Ev+j7TEThdG5AhNEwTEdcD0LZ7/mhFAI6rx3c8DQyw+jRaRvBc6JWziI1TS865vec
         lzcQPB9RTxA7dIGLCwoze6cymYG/crbwJjLm3yQCnvO39BBwbvCYpnmV/JbG79+qEW
         cgXO4KZP+m0cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E128FE45227;
        Tue, 12 Jul 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix missed deinit sequence
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165762181291.1149.3411312892886484418.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jul 2022 10:30:12 +0000
References: <20220710122021.7642-1-yevhen.orlov@plvision.eu>
In-Reply-To: <20220710122021.7642-1-yevhen.orlov@plvision.eu>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org, volodymyr.mytnyk@plvision.eu,
        taras.chornyi@plvision.eu, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, tchornyi@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, oleksandr.mazur@plvision.eu,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 10 Jul 2022 15:20:21 +0300 you wrote:
> Add unregister_fib_notifier as rollback of register_fib_notifier.
> 
> Fixes: 4394fbcb78cf ("net: marvell: prestera: handle fib notifications")
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_router.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: marvell: prestera: fix missed deinit sequence
    https://git.kernel.org/netdev/net/c/f946964a9f79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


