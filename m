Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA95A33EE
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244422AbiH0CuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbiH0CuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11244D3444;
        Fri, 26 Aug 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D1A61DC5;
        Sat, 27 Aug 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 068D0C43140;
        Sat, 27 Aug 2022 02:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568616;
        bh=DY1Ejznvc5AO1wHyc7a3avQ4Y4qfoQ9e9vVxGeu0WGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=njlougVG84oNuAfcMef78r48jMuEb4yG3w+ix4g0ClU5C5eNYBwmAUwpnCjRGkUNW
         UswwGR1Tx1O2QZsJ7lPGhb5qLfntowe92uu9ufDxDUSWdlRtXT/9qviz1aK3eIWw1s
         NXGVvrV5Fr/38cAhnSCxRabMSwXDUcv5FTf7TEErCf5ryzLf6W6Qc0qJl7TizhTT2/
         aSHuFWziRZRtv4ICG0cORv4OeobPx3+n/rB7RPsXTH564TOzBYCtoJy1uOyBfakIir
         XJ5w0dWUK8Gr3AGGflVhaKKdSTom+TSRIOVQPhgzhT3h9YRm7cBMg3FbGI6zQuJoY5
         nhmAXRM5rJ1Mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF3B7E2A041;
        Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fman: memac: Uninitialized variable on error
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156861591.29832.2298883839760907736.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:50:15 +0000
References: <Ywd2X6gdKmTfYBxD@kili>
In-Reply-To: <Ywd2X6gdKmTfYBxD@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     madalin.bucur@nxp.com, sean.anderson@seco.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        camelia.groza@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 16:17:19 +0300 you wrote:
> The "fixed_link" is only allocated sometimes but it's freed
> unconditionally in the error handling.  Set it to NULL so we don't free
> uninitialized data.
> 
> Fixes: 9ea4742a55ca ("net: fman: Configure fixed link in memac_initialization")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: fman: memac: Uninitialized variable on error path
    https://git.kernel.org/netdev/net-next/c/931d0a8b201a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


