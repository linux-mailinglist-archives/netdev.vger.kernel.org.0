Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA2B61F20A
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 12:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbiKGLk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 06:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiKGLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 06:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68B51A070;
        Mon,  7 Nov 2022 03:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4034F60FF4;
        Mon,  7 Nov 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D5F4C4314E;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667821215;
        bh=XfbVfm9EpoHTBtJzLiBIXZhBJafn0HjdTGDXDXzBkwE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mm5D1JhkFHYU62PVv5LjCUCogWlpwiIpZg8gaHl8Gc3EqPVen+yPQRS2A892d1wCq
         jrNgtpabgKx2ju45gf9UgHeHMVNWnJbqx3ta8XiL45XWsH/dr0qJ7APXIMHsHhxGT3
         c4PQS5zGO+fNLO4BicAyLVApVgtX7+yk6d7+usVUtaD+75GvhmQ6M1+1+miz42KxYN
         zkFK/X6GpGNc6y396xDj38o7rb3OG6mhNNQyQmj003B6jmlgrT5l4u7dBs6ZMTLYoH
         J/KaLTEy84QuWp9yWNFTetgf4pNx+Y7wCSXHHEA/2XWAT7mor+5YSA4Q0vEAkz7wTI
         qVWI1WGKiYQsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77583C73FFC;
        Mon,  7 Nov 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: fix yt8521 duplicated argument to & or
 |
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166782121548.20740.16373780918347642964.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 11:40:15 +0000
References: <20221104084441.1024-1-Frank.Sae@motor-comm.com>
In-Reply-To: <20221104084441.1024-1-Frank.Sae@motor-comm.com>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkp@intel.com, julia.lawall@lip6.fr
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
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Nov 2022 16:44:41 +0800 you wrote:
> cocci warnings: (new ones prefixed by >>)
> >> drivers/net/phy/motorcomm.c:1122:8-35: duplicated argument to & or |
>   drivers/net/phy/motorcomm.c:1126:8-35: duplicated argument to & or |
>   drivers/net/phy/motorcomm.c:1130:8-34: duplicated argument to & or |
>   drivers/net/phy/motorcomm.c:1134:8-34: duplicated argument to & or |
> 
>  The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: fix yt8521 duplicated argument to & or |
    https://git.kernel.org/netdev/net-next/c/4e0243e7128c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


