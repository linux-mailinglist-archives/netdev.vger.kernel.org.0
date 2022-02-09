Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED774AF2BD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiBINaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiBINaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:30:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE55C05CB9E;
        Wed,  9 Feb 2022 05:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85256CE20F8;
        Wed,  9 Feb 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5798C340F2;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644413411;
        bh=bk0rG3oK09ieja9UH5Clt/Uh9t30U3MGsnok4wltk9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F4xTSNgzKiTDt6BBFqnDWjNHif5/Jttpntx2pigcuffGgNARtww3z4TPyLGAD9Mig
         cFiYIWpuRj9GhE0P8zhKjBKvLDgsU1TY/24jhgG/IVdcGiY26VzmgqF/vRVpjYUNaG
         BNUsBd1Ruuy5YrOsBm7Bm1xrsCX5Lh6ylBpcY2ZuPqVnHwqvpcV1llu6s7v93s0Bc4
         73CXzbyu91OWUc7JGqUfS9DzYBSyt4fz0BD4RNN1gh90kjSJ1BC/ImLdvOXoSe+V/5
         5Pg5LYcYZgp+deThHwN6u9hRdh/1E6srUuxswYtVzeROWjs8hmk0QTEBUYV4ru7RUS
         PlMfBJL7Qm10g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF703E6D4A2;
        Wed,  9 Feb 2022 13:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] net: usb: smsc95xx: add generic selftest support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164441341171.22778.5411489210672986734.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 13:30:11 +0000
References: <20220209124256.3019116-1-o.rempel@pengutronix.de>
In-Reply-To: <20220209124256.3019116-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 13:42:55 +0100 you wrote:
> Provide generic selftest support. Tested with LAN9500 and LAN9512.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/Kconfig    |  1 +
>  drivers/net/usb/smsc95xx.c | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)

Here is the summary with links:
  - [net-next,v1] net: usb: smsc95xx: add generic selftest support
    https://git.kernel.org/netdev/net-next/c/1710b52d7c13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


