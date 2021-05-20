Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1238B9E5
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhETXBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232251AbhETXBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 19:01:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BA69613B0;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621551611;
        bh=ozt4sB+JiVGg7DqJwb8bcbFBgyLr/F9kdV8B8ptc4f4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=riEvOljNOAwKQIr3Y/h41N6xlBf/M8HJldkq72wpD3YQP8yy5GJBPKR4rpI8SA3dJ
         8YU1go1H8kq3TVnvjlXyB3Gde8VwpALamz9zNWY1qCJFkpfDI1S5KXELIWkARk7mea
         TwxI3nDIyVKoNhp1r3yPzJ2jw/3hzmf8cy/Rm7PVLo1y44QOrCCSwaK1XhJQAVaGwF
         k1SSkaLtdRP/GbFVRFbetnTX7HsrxUZ9ScwU+5scRR/bm64QGdPBR4GlwqxCTJ2I8X
         ElvESUjF8rdBYbkVPrj04xh6zQhopLFyCygl06cNk9Cw8iME/dVOjUJJ3b4m4Ubfq0
         p9oshUYf2Xi0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 127A9609F6;
        Thu, 20 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: hso: use DEVICE_ATTR_RO macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162155161107.31527.485096899823907681.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 23:00:11 +0000
References: <20210520134116.36872-1-yuehaibing@huawei.com>
In-Reply-To: <20210520134116.36872-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 20 May 2021 21:41:16 +0800 you wrote:
> Use DEVICE_ATTR_RO helper instead of plain DEVICE_ATTR,
> which makes the code a bit shorter and easier to read.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/usb/hso.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: usb: hso: use DEVICE_ATTR_RO macro
    https://git.kernel.org/netdev/net-next/c/7567d603b3f1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


