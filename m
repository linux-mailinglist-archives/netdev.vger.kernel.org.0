Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8F63A71B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiK1LWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 06:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiK1LVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 06:21:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DA41C12C
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 03:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70914CE0CE8
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62FF6C433B5;
        Mon, 28 Nov 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669634415;
        bh=uphY64DwV7qxH3NsDOViDZ0+GytyTD+rsYTlwRYngJ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D9Zu/1ai8Lq9Jka90O9k4YvCYtDjwMdmt0Ookc4jaXZV0Gw4ofKHGJYd6KbWGTY6N
         bxJ/i7KMA3zix2bddnKLhSvx7Md0rWAS3efWEdGRrhW5WQT+x7G2W+YqclYPOUhdYX
         ujQFLUufchHSqhWKmRFhKsmropBJGwDLpDXTfabkObqpHefpe1HqE9Dsa4sq5nX+ce
         dYo0G1WVHUpXfFk5CylA7v06CoICFD2hvStWAYkhGJwXAPEIqgS7E7cvr3by6OXK0J
         g35M1dOipUmasXwyfqzKxLYneIn71sth/lEsVTmY8XNxLuZoDXq66CIAA4RMBmBU63
         cPHNJZp2B/kVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42F88E21EF6;
        Mon, 28 Nov 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylink: fix PHY validation with rate adaption
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166963441526.28920.8220394633887964984.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Nov 2022 11:20:15 +0000
References: <E1oy8C0-007VtS-NX@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oy8C0-007VtS-NX@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     tharvey@gateworks.com, sean.anderson@seco.com, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Thu, 24 Nov 2022 09:06:48 +0000 you wrote:
> Tim Harvey reports that link modes which he does not expect to be
> supported are being advertised, and this is because of the workaround
> we have for PHYs that switch interface modes.
> 
> Fix this up by checking whether rate matching will be used for the
> requested interface mode, and if rate matching will be used, perform
> validation only with the requested interface mode, rather than invoking
> this workaround.
> 
> [...]

Here is the summary with links:
  - [net] net: phylink: fix PHY validation with rate adaption
    https://git.kernel.org/netdev/net/c/7642cc28fd37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


