Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B60164A91B
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiLLVBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbiLLVBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84934192A2;
        Mon, 12 Dec 2022 13:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FA976122B;
        Mon, 12 Dec 2022 21:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78769C43398;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670878816;
        bh=RMq3AD22OYoexvImEs266yswHOHC82u2cq5fk+kj2Dg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gy8Kq+0gAuj8rMzIr7QRZDqN4b28uTEjjvsiTUQ/cW+jesYrXOEJOQveDNWQmuo8o
         bwWTEDHWYT4mgx6JeerDotWQRs+2KSvZdZpERyFLVZRGnB80hiXj+8L2oMGJ57upu3
         WsySsIr9HFhWbZt5Jk/GcJz3mHQAUWjHzgmwJaG6iHqpydEdvvhT/BTZz8c5evw1vf
         K58pnJa5kEuI/vbHU2AObSt3dr6lDLf1Je2eDMSHYfL8reg4TKF82EUpoSHZSIDssv
         Ta08L1U3ldRJIOzG7g61rh2mWaw7c+lQmsm3RQLCKJDfNYMlMj/xnByAGJ9idwmQKf
         Yvr3XdfuLrzjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F0B8E21EF1;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: lan9303: Fix read error execution path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087881638.21711.9597600817396950705.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:00:16 +0000
References: <20221209153502.7429-1-jerry.ray@microchip.com>
In-Reply-To: <20221209153502.7429-1-jerry.ray@microchip.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jbe@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
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

On Fri, 9 Dec 2022 09:35:02 -0600 you wrote:
> This patch fixes an issue where a read failure of a port statistic counter
> will return unknown results.  While it is highly unlikely the read will
> ever fail, it is much cleaner to return a zero for the stat count.
> 
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: lan9303: Fix read error execution path
    https://git.kernel.org/netdev/net/c/8964916d2060

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


