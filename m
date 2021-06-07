Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3A39E8EF
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhFGVMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D3EC961285;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=kiwHjZ3QKuBG5ZUBTzsJ5Le0xj4BnsP8DYmPkYRhtcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=APOjaoL9SQcOVEj8KPl90qBN6eSzaUxB656U6uLdprFanGVC+B+OmJOpwuu7lesA+
         Hg7XM4ZKH9hTKaVwrSmsFxevlfjls8J/ETlIVb1QUjw7w6Cvh1osnJmYsRg8Z+5k2q
         7z88nyGhehVJxeD2ZSoC5jKw3T+Swn01t1KhH00k/Qhf1FnKH2jgNdSnAi7kjw+rsT
         v2oBTReIjPqzOF63yZW+pdGISNsJ3fFCpU+ge6eVczUOGO5/MhCmclEEPBx+uc2PB3
         qp2frx5OIA1d3Dxwv6ORFddRCmLQjJd10JS4Dlvifv54dXpTXDK8CizBGV77bTOX90
         3X5Za36MfwHlA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9DB8609B6;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: macb: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020582.31357.1378865773916440113.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <20210607134354.3582182-1-yangyingliang@huawei.com>
In-Reply-To: <20210607134354.3582182-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nicolas.ferre@microchip.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 21:43:54 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: macb: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/809660cbc82d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


