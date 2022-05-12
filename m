Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5AD525501
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357730AbiELSkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357756AbiELSkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B10F270CBB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 11:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBFB961ADD
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5490DC34119;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652380813;
        bh=LSZBBekRDFwdU3Bll4IM2B2S4u474sKZP5PB0plDK44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YySfoPVcgDI0inyJIoyzaqsHibR2Nb93GBmXB7YJqHUZ2gCvSraqDghxvPuppUoHu
         oZVceQSj7SuX1/8BC2qOHFfWnEw5BooMsvxtHOKL8Xs9YA8vZ2k9FH6BbhyH6RHFG8
         FW2rKd9eWwRCwEflycAWZh3oWIUnj4z3+zePguqYEwcZmDhI3f0zu20oywFyZ/Z3FZ
         m0XNTcW7AuP5mgpNK9o/L59QDjGTDJDrUndRMJqA9BTEsSI5g26/KWm8e2rPuv08PA
         bnm2dH3LyqAF76yqHjFuijnUF6xn4pHa0tfeyGNxyffN2cWaHULiuymKezxaw/8rKy
         xAOgODQtbplvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C3A7F0393C;
        Thu, 12 May 2022 18:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sfc: ef10: fix memory leak in
 efx_ef10_mtd_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165238081317.29516.14087255795387151044.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 18:40:13 +0000
References: <20220512054709.12513-1-ap420073@gmail.com>
In-Reply-To: <20220512054709.12513-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
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

On Thu, 12 May 2022 05:47:09 +0000 you wrote:
> In the NIC ->probe() callback, ->mtd_probe() callback is called.
> If NIC has 2 ports, ->probe() is called twice and ->mtd_probe() too.
> In the ->mtd_probe(), which is efx_ef10_mtd_probe() it allocates and
> initializes mtd partiion.
> But mtd partition for sfc is shared data.
> So that allocated mtd partition data from last called
> efx_ef10_mtd_probe() will not be used.
> Therefore it must be freed.
> But it doesn't free a not used mtd partition data in efx_ef10_mtd_probe().
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()
    https://git.kernel.org/netdev/net/c/1fa89ffbc045

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


