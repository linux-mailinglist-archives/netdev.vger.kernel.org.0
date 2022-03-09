Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE4D4D2EEF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiCIMVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiCIMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:21:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DCE17582B;
        Wed,  9 Mar 2022 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34836195D;
        Wed,  9 Mar 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 168F3C36AEA;
        Wed,  9 Mar 2022 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646828411;
        bh=kJaF+ry8ZeG8rywYXUAcA39LdaW+YS/y+1HyUP/75+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rli28Qea+ZJ/Nj5BsiFsrccdIR49lRnwxs8MGEjMZxT3Gm9BJs8W0g6d4h2fdgMMQ
         hPSkCTTEuD32aW5yUu5qStHE+aSinZjulWtAzSfqB1npsksLaLXhfcX9cDkrIFOdiq
         CBfp+pMydP3N/68KiaTDgfrF4dsMg6gdeBHazhgBol86DFxKMOUO/TODP65FaLk9vS
         TS2+FFhErYbYDFLplJVtw98XCI5q5gHimfjtuUZbP1IrDzUOxfco7P9XaLBYSbG65R
         1EoZ3aMr0F60QNJb0YlGXUOW414hdiX/oBcAsdrGq8BkQla+vml1Z9Ley6xU1KbPCJ
         9OIj8CmUbmvMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2F66F0383B;
        Wed,  9 Mar 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpts: Handle error for clk_enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682841099.19405.11150136599486334013.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 12:20:10 +0000
References: <20220308064007.1043691-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220308064007.1043691-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue,  8 Mar 2022 14:40:07 +0800 you wrote:
> As the potential failure of the clk_enable(),
> it should be better to check it and return error
> if fails.
> 
> Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpts: Handle error for clk_enable
    https://git.kernel.org/netdev/net/c/6babfc6e6fab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


