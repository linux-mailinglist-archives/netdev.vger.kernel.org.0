Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577F9630B32
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKSDaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiKSDaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D5BA6596;
        Fri, 18 Nov 2022 19:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4A406235B;
        Sat, 19 Nov 2022 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DCD6C433B5;
        Sat, 19 Nov 2022 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668828617;
        bh=Pzsmj63t6Cj8oZLmswtjovlP2S56HXIvYjwwjzS/mTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJMPLyPnL7ohRdxen4DPDicAXEuh3YuhXASXuTv0KjYZqOkQpa6Tbartzx4CpcwzB
         xpxM5pChHPy2OhHjPfGpH9TpjwVsxlixDq74b7TAVNzam1PVJArNFw+1LY0pOcY5Wk
         4Eom984CXp3h9JUoBz5HrgFMqByBbbWGSQU9gnIZzqNhg7qxTE3eQJI1/0jGtyjU+e
         Kpy1HYA5xEY1g9txNbEwOgC7FYy8m97LsoVBaXUOeiESY78M9iX9ZnD68SnNSnujUu
         zRpt2qMtVQPWr4lWYpvweS4S2UV93h7LnRfKTB0+MhvQc0MizAmzfhhuOgtY+pColu
         NI9Qz6tyZpT+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14C03E4D017;
        Sat, 19 Nov 2022 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fman: remove reference to non-existing config PCS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166882861708.17876.6578588278157386208.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Nov 2022 03:30:17 +0000
References: <20221116102450.13928-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20221116102450.13928-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     sean.anderson@seco.com, madalin.bucur@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Nov 2022 11:24:50 +0100 you wrote:
> Commit a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver") makes the
> Freescale Data-Path Acceleration Architecture Frame Manager use lynx pcs
> driver by selecting PCS_LYNX.
> 
> It also selects the non-existing config PCS as well, which has no effect.
> 
> Remove this select to a non-existing config.
> 
> [...]

Here is the summary with links:
  - net: fman: remove reference to non-existing config PCS
    https://git.kernel.org/netdev/net-next/c/dbc4af768ba1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


