Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7703546DC
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbhDETAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234586AbhDETAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 15:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EC6686138A;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617649209;
        bh=4O7mjTSpK7QNsAYztga00ulbQ4Td8MSNgvfS/mFXdic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTU/fOruK+GFZ70DokETF5qV4WVp/X1A0legXqJSdQ80e7LjdybQO03QaJGNVpVYY
         kWyy4oGEmrivA5sOWByuR0T6ngrEwRwm5zfvYiJ/zK4CYZOn6txqi2z42qrpF21DHq
         UImpmTVkGx/+wtKTzWbx+2LI9QpHjEEWN+vCTIsiNgG7kJN1A2NhkvgbV9PnyxX+I/
         UD5N1ECJzXinq1yAsvbpw7NI6jyVPmDAUzIv1yQ44YU4ZrNxPYXmEeivOwNMxk1tOz
         gfSP501JqHZwEKMZ/y7Gj3C4y4Cfxgj5GoXyYw9UKuVDhhFD9hBSZ7WCV6xdSRWypC
         8kcDLClLHwzGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E134560A38;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ag71xx: Slightly simplify 'ag71xx_rx_packets()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161764920891.15280.12104715179440980483.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 19:00:08 +0000
References: <7fadf8e80b7fea5e5bc8ce606f3aec8cd7bd60e8.1617517935.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7fadf8e80b7fea5e5bc8ce606f3aec8cd7bd60e8.1617517935.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  4 Apr 2021 08:33:44 +0200 you wrote:
> There is no need to use 'list_for_each_entry_safe' here, as nothing is
> removed from the list in the 'for' loop.
> Use 'list_for_each_entry' instead, it is slightly less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: ag71xx: Slightly simplify 'ag71xx_rx_packets()'
    https://git.kernel.org/netdev/net-next/c/0282bc6ae86d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


