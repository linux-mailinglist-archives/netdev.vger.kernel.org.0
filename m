Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070166918B5
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 07:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjBJGuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 01:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjBJGuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 01:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C2C38EA0;
        Thu,  9 Feb 2023 22:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D1861C9C;
        Fri, 10 Feb 2023 06:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EECEC4339B;
        Fri, 10 Feb 2023 06:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676011819;
        bh=N3J4gxBPtZKekdqplWUM7YgmSJZN4Y8o0sfXXnzzLiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FI1HEJ5gJayihbY3Y+8xgt7+ipDJmiX+jBzZ4K4gsYxzmyHZjA3LwsAfTBzshrzIg
         xpWFAvr5bC8JMqwIaz7PMtmLsVHbrJ3Sa0bBAXNe73JgKnl2HZMOe8lmVyWeS8KYeu
         8Hcs7e220gO7gNPcBqlslFiXuzBJmTPot5acrOG4yT8KtXz7rlTJNz6UpyHgYlzTeG
         wFVcTUyLSpb1ZRrYcliJ6UsDEUjzfUlK6qDtHLY5q2LJCk4w9TmEkugKrm5dqAAZIs
         ++CfqK4K4so7+PnbYjssxhqL+wgyjB56fkQWH+onr5cNws7fqpvNArmhI/Vh2Db2iZ
         lbxaWxBLHBUyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 044F1E55EFD;
        Fri, 10 Feb 2023 06:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pcs: rzn1-miic: remove unused struct members
 and use miic variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167601181900.8112.12999373938379161015.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Feb 2023 06:50:19 +0000
References: <20230208161249.329631-1-clement.leger@bootlin.com>
In-Reply-To: <20230208161249.329631-1-clement.leger@bootlin.com>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2VyIDxjbGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 17:12:49 +0100 you wrote:
> Remove unused bulk clocks struct from the miic state and use an already
> existing miic variable in miic_config().
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/pcs/pcs-rzn1-miic.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: pcs: rzn1-miic: remove unused struct members and use miic variable
    https://git.kernel.org/netdev/net-next/c/dc8c41320130

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


