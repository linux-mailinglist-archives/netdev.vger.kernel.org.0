Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFAA48090E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhL1MUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhL1MUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA041C061574;
        Tue, 28 Dec 2021 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 144F1B811B1;
        Tue, 28 Dec 2021 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B936FC36AEC;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640694009;
        bh=iPBOC5m38ihZvBIPoYMUWAU/kG5+XClii37JKBUCglo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ujQhoDOgVL/h+FgWynRjAuMgeyYJvigsBlNaoWkuT8hIlSSXbMjOUB5X+yFlCmsEa
         1mxDj50+/futzJJY0WQD/IYBq7udx4WgN4lFK2ChJJwNY3qgUqP9MuyoNUjsiO5aaZ
         RhaTB6TP1c0vkia9KBxUOLLOBLhQafHulCOmVPtV2Kwu1zGM8BouvCfYcIRcp7yY4w
         vJdYM7tTwtcKxu4ACWmIoZfa00mzSfcXXLcjQYRTVhzMfprXcxx1PX2kscDi3A6fD3
         Hl4PJOtMCOGdLyH9DxMabjzBMJUQ3Agvr+J7sdopLdkmEwOyWfhNmgClcVmc51yeW1
         LON+AeTYdmn/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 925B3C395DE;
        Tue, 28 Dec 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lantiq_xrx200: fix statistics of received bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069400958.26128.1711789977057542079.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 12:20:09 +0000
References: <20211227162203.5378-1-olek2@wp.pl>
In-Reply-To: <20211227162203.5378-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Dec 2021 17:22:03 +0100 you wrote:
> Received frames have FCS truncated. There is no need
> to subtract FCS length from the statistics.
> 
> Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_xrx200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: lantiq_xrx200: fix statistics of received bytes
    https://git.kernel.org/netdev/net/c/5be60a945329

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


