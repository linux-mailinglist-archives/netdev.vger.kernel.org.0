Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EFA679002
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjAXFke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjAXFkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5949305FE
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:40:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99F97B81056
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B1A4C4339B;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674538826;
        bh=lyKiK4G++mrNagR8WlzfJh+HIAOQ8WpeGpfbiXIe+O0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gvJwW9RdErYiTwLq9pQUoJIlNqhI/qRj4AH3XsBtYwQumnZz8kRal1xtxXe8eH20V
         YaHnJ1TciR0azTJJsbBoRL31XfR9ZaTE+QR/ialr+T4DbeyzZKve8XmAhDhZ7C2tuW
         gvFHcDixieySrVu3ucsVM9aDWykITpF/zoF6mySOuniSQo7uNlC/7+Cos0votqJz6u
         HTEn8UNaNmmMyUSPZLWWWNcLDPNiynz1XNh7r2hI/IvB2A6UZ4LZCboN8im/lYn2Rx
         BLiBmabt+4UV78iaSdqvHCLOa3tcshdHlmt/NivId5Dmwww/l3Wft+QH58ae/2nDHY
         /ygI6aebukbWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3404BE4522B;
        Tue, 24 Jan 2023 05:40:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: warn once if addr parameter is invalid in
 mdiobus_get_phy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453882620.30916.3675834508955539490.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:40:26 +0000
References: <daec3f08-6192-ba79-f74b-5beb436cab6c@gmail.com>
In-Reply-To: <daec3f08-6192-ba79-f74b-5beb436cab6c@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
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

On Fri, 20 Jan 2023 23:18:32 +0100 you wrote:
> If mdiobus_get_phy() is called with an invalid addr parameter, then the
> caller has a bug. Print a call trace to help identifying the caller.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/mdio_bus.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: mdio: warn once if addr parameter is invalid in mdiobus_get_phy()
    https://git.kernel.org/netdev/net-next/c/8a8b70b3f2cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


