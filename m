Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3C488CC8
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237242AbiAIWKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiAIWKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E0EC06173F;
        Sun,  9 Jan 2022 14:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F56C60FB0;
        Sun,  9 Jan 2022 22:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58CAEC36AEF;
        Sun,  9 Jan 2022 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766210;
        bh=Dij7jpNAgwwFkc+7/+wtr0/+iMyJ+ZotBJhoIy0UwbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7oropML/8dW6y50UJYQ6kv3iG3nMskwPthJETKq3chiANNleMO/ygGas3Jo5oYQZ
         9AfPoJiA147pH82R7LMm2kTalqQOjxjIiKjCMQHe7uXoPeuwCBZnSfjQOzhXIqpbgf
         mJ00ZgrL0H1LAMkJxfFlXEKX0q95BNT/uT6llbbPeXzIsGM/6J0oGLf5u17Ag3DoAd
         jlmD8p1Yvd+vRMmWQj2ZTnv16rAzB0+xgVfZ+Yj2jgKOHy7SIsWiuLa6Ka9NMBe2Ih
         AIpw9iGOmKAxHBsicxUu77ZcE+djGe5APFcUONtxqsIlYk40NQBHjUr+AnkYQy6yLb
         Sh/XDA0gqL6XQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41326F7940D;
        Sun,  9 Jan 2022 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] can: softing_cs: softingcs_probe(): fix memleak on
 registration failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164176621026.2545.7181216847383250912.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Jan 2022 22:10:10 +0000
References: <20220109134040.1945428-2-mkl@pengutronix.de>
In-Reply-To: <20220109134040.1945428-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, johan@kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sun,  9 Jan 2022 14:40:36 +0100 you wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> In case device registration fails during probe, the driver state and
> the embedded platform device structure needs to be freed using
> platform_device_put() to properly free all resources (e.g. the device
> name).
> 
> [...]

Here is the summary with links:
  - [net,1/5] can: softing_cs: softingcs_probe(): fix memleak on registration failure
    https://git.kernel.org/netdev/net/c/ced4913efb0a
  - [net,2/5] can: softing: softing_startstop(): fix set but not used variable warning
    https://git.kernel.org/netdev/net/c/370d988cc529
  - [net,3/5] can: xilinx_can: xcan_probe(): check for error irq
    https://git.kernel.org/netdev/net/c/c6564c13dae2
  - [net,4/5] can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device
    https://git.kernel.org/netdev/net/c/72b1e360572f
  - [net,5/5] can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}
    https://git.kernel.org/netdev/net/c/89d58aebe14a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


