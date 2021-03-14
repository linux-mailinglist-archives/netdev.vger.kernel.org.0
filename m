Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6567D33A255
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhCNCKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231597AbhCNCKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 21:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 285E564EC6;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615687808;
        bh=fODh4fAvon0PXwSNrLSf7Hk+/GlHcFCPcM4HkyIZ9m0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HlFtVUGEdAKZ0/N7igOcLrQR3xAMR+gLcxEUHCxMgJmd/265Yu14wo6jpxCFX7VlZ
         3dsmu1E6TlUeUOZSgKskopzN2rVDL26SIZqC/JgRjJhUR1f6BNN9Fc3h+bTR5L3AjG
         TxpmUHwSBEvuuupsOqQfoIqDNmlgn4tj7j+eZoEkd8ze4Q4tg0DlPhLBTy1G7sL5/l
         2FaljgYCQQ//bwXiALyjj8cuur/xIdbA2c70iIl9AIcavKAWCo+dGIcAW6b+KtrT2j
         tjcPb4Jl6Vw16LumeSvxN3FaafvH0IwGdNq5nagzfOsMaSMiJoVPDFOKXcMKe3Ot7U
         pG3roQIoPmL8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17C4A60A57;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: marvell: Fixed typo in the file sky2.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161568780809.10930.4741967763676695069.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 02:10:08 +0000
References: <20210313054536.1182-1-unixbhaskar@gmail.com>
In-Reply-To: <20210313054536.1182-1-unixbhaskar@gmail.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Mar 2021 11:15:36 +0530 you wrote:
> s/calclation/calculation/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/marvell/sky2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - net: ethernet: marvell: Fixed typo in the file sky2.c
    https://git.kernel.org/netdev/net-next/c/65c7bc1b7a66

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


