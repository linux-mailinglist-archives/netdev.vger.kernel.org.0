Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DC96194FF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiKDLA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiKDLAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:00:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58B4B5B;
        Fri,  4 Nov 2022 04:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 86FA4CE2B97;
        Fri,  4 Nov 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EBA95C433D7;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667559617;
        bh=WGnSvs8S5bKiv0ZS/C088gnBIaFidQAdW46MQGm+R5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f6IbIC7x5CB4A2g+XaZzZC0kUeWZKC5RhtQ1bb6PrVS2dw88vtw26R3/ugOSmYe4P
         fcy/3HlHwzDrGDd7jhIJgqXZ4iay9Cg/vzohy4udhBHqUTq/xaR/Ak3R5ttcxXegzd
         FfyWuKRS4l6YwZdPengb5SSVj2yAN0f4mEWjp/qGjJfuBQpYh1ZoCyeoJUB3bxxB8B
         vKJC230XVjn9wVS7d/6Y1DttrLzmzg9YHwpTAWcSOnZtlTLGy02kRyKBVyG4KenOQc
         Y7z7xVET4JBl3wsxXtOiMEFA+V8pPvp8SwlCcX27+xaNS3Id5XyDkxkLwDYy8gObrZ
         ce1/96hop3eig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1180E29F4C;
        Fri,  4 Nov 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755961684.11617.12431050208677706811.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 11:00:16 +0000
References: <20221102031113.1919861-1-rkannoth@marvell.com>
In-Reply-To: <20221102031113.1919861-1-rkannoth@marvell.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 2 Nov 2022 08:41:13 +0530 you wrote:
> In scenarios where multiple errors have occurred
> for a SQ before SW starts handling error interrupt,
> SQ_CTX[OP_INT] may get overwritten leading to
> NIX_LF_SQ_OP_INT returning incorrect value.
> To workaround this read LMT, MNQ and SQ individual
> error status registers to determine the cause of error.
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]
    https://git.kernel.org/netdev/net/c/51afe9026d0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


