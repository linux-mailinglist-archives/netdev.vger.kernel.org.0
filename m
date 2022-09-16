Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0BF5BA840
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiIPIa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiIPIa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:30:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832A62E9E5;
        Fri, 16 Sep 2022 01:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7FCF7CE1CF8;
        Fri, 16 Sep 2022 08:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CD0FC433D6;
        Fri, 16 Sep 2022 08:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663317016;
        bh=1hsF0yr8Si/QZDG4KHFd1sAOKRxM1QR0+z10YtMCKX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K9B8lGUiF32tJWXcIIoRwLwbTqUVuS1IwIeU/LE8d7AyNbekCPP+3g+uUg/AtfQnA
         vBAoL0L4dbHW7zx9nBiy6tgFOPkGEyqg1fQrXWjXoOBxCYt99sGLaTdeTulufoabe6
         Sobhn6JMPO8ZhY1Z2VdCqTEZG9T/1B0Am9zfnXNMCWhpDyvycKJFybHnCuaFjaee9k
         uqWs21FgTN6yjR9KGLpbAi+h5tXV84lYB1IuHOglcDWdS7HXEis7O3Fl2yNQPw7DLh
         3S0UmPP5eXA6DSPiy40t5GsqJU64vKt0DGR+PNfgSmV9Nxo/P3S9sXYju2v1y+V6u4
         W/SxLtlcUEd/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1795BC59A58;
        Fri, 16 Sep 2022 08:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fec: add pm runtime force suspend and resume
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166331701608.6675.17275606963812958254.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 08:30:16 +0000
References: <20220906083923.3074354-1-wei.fang@nxp.com>
In-Reply-To: <20220906083923.3074354-1-wei.fang@nxp.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue,  6 Sep 2022 16:39:23 +0800 you wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Force mii bus into runtime pm suspend state during device suspends,
> since phydev state is already PHY_HALTED, and there is no need to
> access mii bus during device suspend state. Then force mii bus into
> runtime pm resume state when device resumes.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fec: add pm runtime force suspend and resume support
    https://git.kernel.org/netdev/net-next/c/da970726ea87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


