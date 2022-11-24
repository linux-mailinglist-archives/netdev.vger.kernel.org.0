Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A772963733D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiKXIAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiKXIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:00:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C5FC6064;
        Thu, 24 Nov 2022 00:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD21ECE298C;
        Thu, 24 Nov 2022 08:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB2C6C433B5;
        Thu, 24 Nov 2022 08:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669276815;
        bh=/qNBsDTaHcljjq9Gf7eJCqP+uBYQ5t64e+CpE/i6I5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ghBksp+74vVxbhckgvG5nHjA+GjvFODlr+2daLfaRTto6cTD9As/y6m515dAlXv8o
         yI48mc6EeVA4AA7mE5YMzc8JfSRqI2QXkZZydrO8sLxXdOSjVySvMaCC42Dlj+HqxK
         NH5zo1xVyZKU7CS+Z9lDZmg2Dq3kw035OWrzJkcBVJ+dwC0eKWBkiVVVvKuHCn73bd
         hDt30jwiajc1os9lRrCFtNOs1LNlnpqbUIOVI/Jb1GOvad6DhvcUP+INIYE073mVsW
         o/UAdJ7o4EjOcLcb7d7mRnkmDegkTsrZTiCZSYjPsj2v8iUpaijaXbpr7Yr9QaRa1A
         IH2TQv/wJjgIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 877CFE29F53;
        Thu, 24 Nov 2022 08:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Add check for devm_kcalloc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166927681554.9063.5857727937448326747.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 08:00:15 +0000
References: <20221122055449.31247-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20221122055449.31247-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 22 Nov 2022 13:54:49 +0800 you wrote:
> As the devm_kcalloc may return NULL pointer,
> it should be better to add check for the return
> value, as same as the others.
> 
> Fixes: e8e095b3b370 ("octeontx2-af: cn10k: Bandwidth profiles config support")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Add check for devm_kcalloc
    https://git.kernel.org/netdev/net/c/cd07eadd5147

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


