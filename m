Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EB73FEC51
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245067AbhIBKlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244445AbhIBKlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1BF1610D2;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579206;
        bh=3lo67td5noyQzNkNhoNLS8lIqLNaUptUZ3ae7Bgj2AQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lqf5lwd/3bk9oMkzfD2Z98kk0yi6FeHckbIn4K2XRcuHIfQP6+TU8tDVwnun3j3Sl
         MS9kTg93wp4XhK1CdK/3aPIPOnEYMxEQ3ceQdHT/iptMyIcyStPEQacSeIDIV+m1Vv
         R5GbmxAXPC+VlXmjpW/zCyP5VZPb31ggtuUGxXpoTc2ze8lOHm1tJ6SwMWpOwwCEcZ
         Dc4HHkZypa/daljODeONx5ipWM9/RB6uBupBgcBD2AKmth/oGNQnUUitqTsYoM9m3M
         1H9LTXB2PDMCfnkkvpn6SVPTfOM9n1rifmHSL/VOkzsTf+7Y6h1EEfq+YhoLq9bsA1
         MLxaoOxWBklPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B792B60A3E;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sun3_82586: Fix return value of sun3_82586_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057920674.13463.427574638900568513.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:40:06 +0000
References: <20210901121735.2477588-1-geert@linux-m68k.org>
In-Reply-To: <20210901121735.2477588-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     arnd@arndb.de, davem@davemloft.net, kuba@kernel.org,
        sammy@sammy.net, netdev@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 14:17:35 +0200 you wrote:
> drivers/net/ethernet/i825xx/sun3_82586.c: In function ‘sun3_82586_probe’:
> drivers/net/ethernet/i825xx/sun3_82586.c:317:9: warning: returning ‘struct net_device *’ from a function with return type ‘int’ makes integer from pointer without a cast [-Wint-conversion]
>   317 |  return dev;
>       |         ^~~
> 
> The return type of sun3_82586_probe() was changed, but one return value
> was forgotten to be updated.
> 
> [...]

Here is the summary with links:
  - net/sun3_82586: Fix return value of sun3_82586_probe()
    https://git.kernel.org/netdev/net/c/66abf5fb4cf7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


