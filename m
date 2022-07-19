Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA157953C
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiGSIaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiGSIaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5F3DFC6;
        Tue, 19 Jul 2022 01:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F37D56176F;
        Tue, 19 Jul 2022 08:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48510C341CA;
        Tue, 19 Jul 2022 08:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658219413;
        bh=koUyRogOb8/XGYRkZ5KPvNyt9AV4U9ouxNM/bk4OUyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BY/acaY+1OSOk3Qk2Mt1ClPeVvRHomEWR/JihTKXsmKo1eqpnCdGws6/Esf2PQI8s
         3tfmcz8u5mG+Fip9sq2pIo6n1yRX87matJ/xog2bbXMVMcXvJmgM18C2axJozdXNQp
         Hh2NzHKcKE3Llwz0g9vLreFJB86ZjPft9FrPFnKJUqqAJqMnfNDPiIY2mCsqNxcAEc
         bePu5bilAadSH4grZI3yF28Zp10evabI0NCTakPeBLwB5+KREOe9DBKDdjsa8cBCRJ
         V4TcxMfNh0GqTjnbThF7Pce6S5v6EkoQn0vPkAdY86bzhIuJ01jW99sBznP0xEX4oA
         BcGtK76LHidXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2574EE451B0;
        Tue, 19 Jul 2022 08:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: prestera: acl: add support for 'police' action
 on egress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165821941314.8123.328737475337569054.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 08:30:13 +0000
References: <20220714083541.1973919-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220714083541.1973919-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, volodymyr.mytnyk@plvision.eu
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 14 Jul 2022 11:35:41 +0300 you wrote:
> Propagate ingress/egress direction for 'police' action down to hardware.
> 
> Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_flower.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: prestera: acl: add support for 'police' action on egress
    https://git.kernel.org/netdev/net-next/c/3c6aca333362

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


