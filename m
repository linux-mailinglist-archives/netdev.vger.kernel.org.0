Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D58F2CFFB8
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgLEXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEXVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:21:04 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607210424;
        bh=pehPkJa7Os4jpeZhw6SlrD3BC+I4x7t0lldxs+Y6drA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s8dgANVEMvKVxV4jxLOmtj/EPfH/3w9t5fqliUhMCwoqj+prK3HljuevaJ8BbLGk5
         +gVwVyEficYr8re9zbVfep6bKLZhLULTGJo9Ik+ck+ZIrJSckltJlbmyYg3P4fbJxI
         QACBIOHx6yE4F6LbvSALVB8BOaojQXF3ETrHcRNzzJDPLxdIG/JehVpo3bTjAwGhY4
         eZx/gXHpBf56F3CX+iNWe++mKfNhwXQ/d6baegGMYI7X0anpv2YgcB3q8tXHGg9x75
         xH2XMFYdtfNi0M8KgmkmcysOsekmClbPnCd8GjoyewIY770BGmzeF5aeOv7H4sviBs
         d3ABcJJ4OcH7Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix spelling mistake "wil" -> "will" in Kconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160721042413.21881.7276554148145917327.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Dec 2020 23:20:24 +0000
References: <20201204194549.1153063-1-colin.king@canonical.com>
In-Reply-To: <20201204194549.1153063-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Dec 2020 19:45:49 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in the Kconfig help text. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: fix spelling mistake "wil" -> "will" in Kconfig
    https://git.kernel.org/netdev/net-next/c/00649542f1ba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


