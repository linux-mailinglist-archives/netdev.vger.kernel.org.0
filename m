Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06F932F66C
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCEXKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:10:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhCEXKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 18:10:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 15291650A7;
        Fri,  5 Mar 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614985811;
        bh=yFKMPzG5kWJn0aHjATAiZbWKkeVB9hf5JPJ2fHOGdt8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=acJics5CMChP9r0lJ154TIvfjBOqf9Uo7nxh2/KAyCE02RBeYzBooEOMSu7FRtGkO
         2A3vU4BufYp17p4R1nzcSviKWn9soCcGvjLvQ1O6T71aSlV5oPfQrxtBZv1VHuSCW2
         /VSO3ld0RgHLE1zo/xIPZ1bpirb3r5QbnfIPvSljGphvVuZYTVM6L9cmcZ0GPr1rT/
         uImQErP/56++5UR/jxws45Oeq6jJfEETakBeaOutkFDVTtkcK6YpHgl5W+QiGdNzJv
         GZTMKaTAciSdWO3iDtFrvTiIyM3sz6GwTU5NeTxeQCrg9An6Vw14D1l6cfKtTIrRAH
         jLrsVh2tc1hbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0FF3D609D4;
        Fri,  5 Mar 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] lan743x: trim all 4 bytes of the FCS; not just 2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161498581106.14945.12506796771360832279.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 23:10:11 +0000
References: <20210305222445.19053-1-george.mccollister@gmail.com>
In-Reply-To: <20210305222445.19053-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, thesven73@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 16:24:45 -0600 you wrote:
> Trim all 4 bytes of the received FCS; not just 2 of them. Leaving 2
> bytes of the FCS on the frame breaks DSA tailing tag drivers.
> 
> Fixes: a8db76d40e4d ("lan743x: boost performance on cpu archs w/o dma cache snooping")
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] lan743x: trim all 4 bytes of the FCS; not just 2
    https://git.kernel.org/netdev/net/c/3e21a10fdea3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


