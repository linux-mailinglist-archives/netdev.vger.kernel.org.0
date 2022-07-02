Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7548563DB7
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 04:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiGBCUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 22:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 22:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABB020BEB;
        Fri,  1 Jul 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A47B83276;
        Sat,  2 Jul 2022 02:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8B18C341C6;
        Sat,  2 Jul 2022 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656728413;
        bh=AON+13+ZPoYRvs8sCTx6Mp1b+TAgQ6pvxHFwCjai2hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mLgmzLYsK3nJbqNJvDq2Mj61U5s5k9VsM71Wb63tL6DA+hO8dcDHBdzgPfDYPoH6q
         Kfg/MwYHxodJVx052UpXz+Ku29XtyjRjlYl2vqGtrVnfsBJHBj2htyQEBzpiuRLs10
         iWnWJQc1tIYJmJ3Hsn5M4Hw10gvyFqIYQW1MhKoqAiqneyv19UGDMwWQG54C75frJt
         qqowpSnM6fOnMuiuRhpYrnQzfwTUGsxt8I2XPNLWT4QXJPu2ndHqASXxHS7D5U9ajm
         YqlXkxCe3J1/14iwESV3hnEr2APp3vi/rfCUtGFXFU3nkDBd9tWKcJsKh2hUJH+y9/
         f5QwjHNbagBKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B964CE49BBC;
        Sat,  2 Jul 2022 02:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] octeontx2-af: fix operand size in bitwise operation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165672841375.15723.1718388216419233811.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 02:20:13 +0000
References: <f4fba33fe4f89b420b4da11d51255e7cc6ea1dbf.1656586269.git.sthotton@marvell.com>
In-Reply-To: <f4fba33fe4f89b420b4da11d51255e7cc6ea1dbf.1656586269.git.sthotton@marvell.com>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     arno@natisbad.org, herbert@gondor.apana.org.au,
        bbrezillon@kernel.org, linux-crypto@vger.kernel.org,
        jerinj@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 30 Jun 2022 16:24:31 +0530 you wrote:
> Made size of operands same in bitwise operations.
> 
> The patch fixes the klocwork issue, operands in a bitwise operation have
> different size at line 375 and 483.
> 
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2] octeontx2-af: fix operand size in bitwise operation
    https://git.kernel.org/netdev/net-next/c/b14056914357

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


