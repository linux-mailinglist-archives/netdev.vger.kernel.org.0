Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E3038DE61
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhEXAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhEXAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A1E66134F;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816211;
        bh=n9xGNETJ3pjQQDebyFGZ9/yBWEytIQ9rSEvdDNWz3fY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pYPvLfHnPxRK1tQgI9nUIcXUrhInQAeymxzdfJ0ccquY8lquo0htYNi64TW0EiWi+
         HROMjydXK81jGn/Me9Hml1S6glCgJKG2wGvVzePgvAuHuCOa48Qfxz6+GBbKA/iGj5
         tHhDDuYiOcSa8pfKLK2gKsVQT67lLLGTTcnj140iior6BkibhIHmIo7xM1noEkmT1i
         aPuDUpGoBDdGzX90Jsdl+3L8QvpXVHTV/dix1RMQIxsiMtrjS8WWj+rY0A1RdjcofR
         a9PPxzwww/lsUHWRGHiyyw7M+QsTs4zMJjpA+/9naXLHMAM6dfPXvs0+eCfWxX72Q5
         sAlv6D6iyffNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53D6960CD1;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sfc: falcon: use DEVICE_ATTR_*() macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621133.30453.2456779748887719312.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:11 +0000
References: <20210523032409.47076-1-yuehaibing@huawei.com>
In-Reply-To: <20210523032409.47076-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 23 May 2021 11:24:09 +0800 you wrote:
> Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/sfc/falcon/efx.c           |  4 ++--
>  drivers/net/ethernet/sfc/falcon/falcon_boards.c | 10 +++++-----
>  2 files changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next] sfc: falcon: use DEVICE_ATTR_*() macro
    https://git.kernel.org/netdev/net-next/c/4934fb7dc409

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


