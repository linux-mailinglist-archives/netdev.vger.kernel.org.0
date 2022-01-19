Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D27493BD9
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355110AbiASOUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34108 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354883AbiASOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456D161329;
        Wed, 19 Jan 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A411DC340E5;
        Wed, 19 Jan 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642602010;
        bh=9IvT5m3a05gpEh4OyI0qS+R5mnS4dxfb12vkk6NfIeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XGmcIuoGIv9Vgzh5s6Y0TYkbmS2Qfw/etG1CuaJp9+6ecv2gryOySWPGWrOKSGcMw
         FyCDZmrzTyp0j3RVcsNuF+JYNJVisdtG/ccuBXKFCPCywT8PWRInbLXsCNd5D1XeZD
         F7xhhaUmz9iiXEn4KE3IXC+bb17eqXd9SJTamwg7UsNd24hQNGtMNZ7wpLBwLlM1bJ
         GyU/7tdOXXxBhvz1UmzHa8xyxP4za6PkdOU1gGUL36V9qI8xvp6RpnZEzQR1kvUmtb
         1GKZxMt6/sI7VqUeIHMDmVj8vXg6mrDa1HM9AU3HUYW+5FkP3Z0Mo7EM+ZC08UuOjq
         tsl/LGSwK3Jcg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D031F60795;
        Wed, 19 Jan 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN
 into account
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164260201057.5270.6115220828314624622.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Jan 2022 14:20:10 +0000
References: <20220118102204.1258645-1-ardb@kernel.org>
In-Reply-To: <20220118102204.1258645-1-ardb@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     netdev@vger.kernel.org, linux-omap@vger.kernel.org, arnd@arndb.de,
        davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com,
        ilias.apalodimas@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 11:22:04 +0100 you wrote:
> Both versions of the CPSW driver declare a CPSW_HEADROOM_NA macro that
> takes NET_IP_ALIGN into account, but fail to use it appropriately when
> storing incoming packets in memory. This results in the IPv4 source and
> destination addresses to appear misaligned in memory, which causes
> aligment faults that need to be fixed up in software.
> 
> So let's switch from CPSW_HEADROOM to CPSW_HEADROOM_NA where needed.
> This gets rid of any alignment faults on the RX path on a Beaglebone
> White.
> 
> [...]

Here is the summary with links:
  - [net] net: cpsw: avoid alignment faults by taking NET_IP_ALIGN into account
    https://git.kernel.org/netdev/net/c/1771afd47430

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


