Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F349410B7E
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhISMLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhISMLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7410261284;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632053408;
        bh=CCmY0DXt8tsabY/K5nuBfQ4udwppfLMUdVteoXnO+PI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OIe+qsSuZ/eALWDkg09tfLdOgrDoe1HvCZxE7+JFUwarTzTuamcAuzQIiW3Ce7lxj
         BNPIunKsUvxUxhFamMB7BDmvlRyyQYKBLnajftOH4hwpOAdVZbE4AvropfkqIVl5b2
         83D3o1OfHMjGZEKj1yNf1Mi+8+NndwGTVE0bR9OVCIBnOiy7p2y34IRhOYl1HEOnrp
         Uf73NtUyw3gilnKXSB8PxP8wcjfL/oWF5FNYz/4i19C7/Q50O0ZVCk2SsLNcxmxH74
         ZO+rLIYs93fTyqBkwmUXINM7Es8/n2sglzPEQu3iG4AEIZuguPH1WgASGwBBE3FZD0
         kngx++JQYoIfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C13A60A2A;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: freescale: drop unneeded MODULE_ALIAS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205340837.3254.218063855879635135.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:10:08 +0000
References: <20210917092058.19420-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210917092058.19420-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-kernel@vger.kernel.org, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 11:20:58 +0200 you wrote:
> The MODULE_DEVICE_TABLE already creates proper alias for platform
> driver.  Having another MODULE_ALIAS causes the alias to be duplicated.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: freescale: drop unneeded MODULE_ALIAS
    https://git.kernel.org/netdev/net/c/fdb475838539

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


