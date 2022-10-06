Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4545F5FD7
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJFEA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJFEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFBB5A2D3;
        Wed,  5 Oct 2022 21:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47212B81FEF;
        Thu,  6 Oct 2022 04:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1A57C433C1;
        Thu,  6 Oct 2022 04:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028817;
        bh=DJLxU4j1X+1uqUatLNAefSLk4w7fStRUBFQ/AJn8sjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anfMgjXKlA3xiJCe0K8bp4tVezkzPLoZkbfhZEu5t6HP3W0ckH0huXq5nd/HkeVRk
         HVhlvR7/Y8aeQi7TxaUOiLgJtjd+hf5rIZDnmjRwWG2auQABweviCqNfJi63OPhOtr
         7NCvMQBL52k3u7iaZ/Ch1j9irjTilG2WUeS+HdRTUiaN4h6seXt/gAu9IQkSRNRLDb
         XP0lqHAsyg//Z9k0Xg9mQ9DWq+CeqM0/hxwHNtTuxGTooaPYuW62FklrfyqNqFBjOg
         Dp4oeNrW6qRd+12SfykzXeG1XWVZX6PvBcCZ9nNvWalFwYGpmEVb7acYKPBnc8ag0h
         ex6vtRNpYCFQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6123E49F62;
        Thu,  6 Oct 2022 04:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166502881687.31263.6976520056901404265.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 04:00:16 +0000
References: <20221004073242.304425-1-casper.casan@gmail.com>
In-Reply-To: <20221004073242.304425-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Oct 2022 09:32:42 +0200 you wrote:
> Missing space between "pins'" and "strength"
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
>  Documentation/networking/phy.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] docs: networking: phy: add missing space
    https://git.kernel.org/netdev/net/c/229a0027591c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


