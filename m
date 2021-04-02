Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D773530CC
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 23:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhDBVkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 17:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhDBVkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 17:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FE7361179;
        Fri,  2 Apr 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617399608;
        bh=ZRkEpPL3j0p7XjCIG30V0V2yYRJfMj39CJ/mPQQh938=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dlWwzdYUH6MGK7YHhVbjAGdAGz/EoNbJwrZrabi1k6DDGZOiLqpNLFXBs5teDuSYZ
         nz71sx6v4jBpAmC5tRBrD6pnNlrQoMeXEfLHbZ+T4jU0F42lFXxbjvSbJ62uveNPVq
         jd866KM7XcFp33E0yb1t//ML2awytrPivoi9pQJR4jg/n2emr+A9iMvmcYCAvg35Hj
         DVUMfcgM6zmKPSwK6i5fhpoxPx/jBcMIaOGy5rRPaf7EuauuIoTD0JN8KxZpf1RYPP
         aFRUfolTg4YU3ajjdkXKW98LlhNdopMThn2szDcwCacJi9xGH3l4eC6LXA/RCXeUKQ
         yV5pBEpuCuXUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F0A3609D3;
        Fri,  2 Apr 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: macb: restore cmp registers on resume path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161739960851.5485.6193757213761249921.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 21:40:08 +0000
References: <20210402124253.3027-1-claudiu.beznea@microchip.com>
In-Reply-To: <20210402124253.3027-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 2 Apr 2021 15:42:53 +0300 you wrote:
> Restore CMP screener registers on resume path.
> 
> Fixes: c1e85c6ce57ef ("net: macb: save/restore the remaining registers and features")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
>  1 file changed, 7 insertions(+)

Here is the summary with links:
  - [1/1] net: macb: restore cmp registers on resume path
    https://git.kernel.org/netdev/net/c/a14d273ba159

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


