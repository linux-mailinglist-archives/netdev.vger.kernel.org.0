Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976E04B3074
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343869AbiBKWaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:30:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbiBKWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2356D4E;
        Fri, 11 Feb 2022 14:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F29A9616A6;
        Fri, 11 Feb 2022 22:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57BE1C340ED;
        Fri, 11 Feb 2022 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644618609;
        bh=Oh3Ph71U3ezvR+Wc6X3tNqhALI2EQqisG/DbWX+fF6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZbG9y0UagBdv8q3/0+qYAnsFRvf5ygFhhDXm27maHl3wh3KjZrO/5n3SlnwAyO/rb
         5n9mWxqbwEfg9N+y1D6AUnDrVigQNPlHzrrysoXUgHWSDoL++xyKoDEvPu85eb3dwA
         TWAqD3802GrpJHP32FzUyLk/eYO+kx1SUAL8qTgMlDe1UM6csgzjdWgrOvWnyi5ovV
         4xKCRvL5RM4wCkW5rpTAyWXN+jcwabEURyFWlHZfcIfrrM9zRGZ85u6Ut09h0CYUK2
         7yC6XCmEXkJawDq5KkA+ThkKujhLbc8DaKJInlMa7YUh19kdWlOSZiaehcjk9DSCsI
         OSbWGf3REcpig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44B7DE6BBD2;
        Fri, 11 Feb 2022 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164461860927.9558.10227182875750222171.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 22:30:09 +0000
References: <20220209145454.19749-1-mans@mansr.com>
In-Reply-To: <20220209145454.19749-1-mans@mansr.com>
To:     =?utf-8?b?TcOlbnMgUnVsbGfDpXJkIDxtYW5zQG1hbnNyLmNvbT4=?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, olteanv@gmail.com, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Feb 2022 14:54:54 +0000 you wrote:
> The reset input to the LAN9303 chip is active low, and devicetree
> gpio handles reflect this.  Therefore, the gpio should be requested
> with an initial state of high in order for the reset signal to be
> asserted.  Other uses of the gpio already use the correct polarity.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: lan9303: fix reset on probe
    https://git.kernel.org/netdev/net/c/6bb9681a43f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


