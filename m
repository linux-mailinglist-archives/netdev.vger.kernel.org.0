Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCD72E03F4
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgLVBks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:40:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbgLVBkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1700722BF3;
        Tue, 22 Dec 2020 01:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601207;
        bh=R785V0urPXPwLqkECV7yGs/HgD6QEAYsE8KtRflOpAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FsHOn9FK7QcNgJawEfyRXMvR3XzTZit3zJl9igi4vfrvq4mwdXEkeaUcoALEHZcUC
         xKQqx1F/6J2TjUp67pgB/y+KHFkaFHnXliLw9zDf999XnginsepCm4rOm3cbftswOM
         TcxXuc1e+yvosJOfIFJSuyKg4D53iNC32pBQrPQLiAs3Kb9Jx1qb7D/tukg7hoW3s3
         MfOQkB5CQJ/Mv65Vx9Li4gO3tWAQysymO6WqR6p33V+t2+nZGBLp8TC3MbUSwGkUKI
         buB7f4cmiVonpQzTRZpdqtE7fVnoEcymIh5/zN+aI/fsbKJTAE1xTFTsrcwwtYeOwc
         PB6Kw97NACB3Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 0CF2460507;
        Tue, 22 Dec 2020 01:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ionic: account for vlan tag len in rx buffer len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160860120704.2677.4636861122031207886.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Dec 2020 01:40:07 +0000
References: <20201218215001.64696-1-snelson@pensando.io>
In-Reply-To: <20201218215001.64696-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Dec 2020 13:50:01 -0800 you wrote:
> Let the FW know we have enough receive buffer space for the
> vlan tag if it isn't stripped.
> 
> Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] ionic: account for vlan tag len in rx buffer len
    https://git.kernel.org/netdev/net/c/834698932042

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


