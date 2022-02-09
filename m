Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBB14AF15B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiBIMWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiBIMWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:22:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D98BC076859
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D870D61800
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EB9FC340EB;
        Wed,  9 Feb 2022 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644409209;
        bh=8KBLJhIZR4akoo0mHv8cKFpRdN0RPoLkFd/gVVTr/u0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S9GgMbVD8dWdF8waLh23wcpIrOP2oWSwhhAHhjsd4Z5H9Gs4ctC3Ep1UelumJHL0u
         OTblZGtM7KhtnPEJGhB6oKF1AKx1DT8nysM3LcnWhjaqQiCB/ndSGuaXPx6Q01aa4y
         U1zqhQ2aIGJSJOaRG1XaLqVsaA3I2BzbcMbZAtFoG9p9E6nPcrM86+rwdXEB+hRSpd
         w+HYjc8LkqKhrfIMirumhOJ0jT0TzFx3YK0jDnnLBZEaI3HQ41xERF2J4vVapjkUGP
         5kANOofBzxvgZjlETFIRXAG3Oh3ay/FjeLfdHjJUP+GIWvLphLcAph7KB6w87qTGqw
         53135soDt0hDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28D65E5D084;
        Wed,  9 Feb 2022 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440920916.21838.3965616722762050917.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:20:09 +0000
References: <20220209000359.372978-1-joel@jms.id.au>
In-Reply-To: <20220209000359.372978-1-joel@jms.id.au>
To:     Joel Stanley <joel@jms.id.au>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        andrew@aj.id.au, netdev@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 10:33:59 +1030 you wrote:
> Fix loading of the driver when built as a module.
> 
> Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>  drivers/net/mdio/mdio-aspeed.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
    https://git.kernel.org/netdev/net/c/bc1c3c3b10db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


