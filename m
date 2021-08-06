Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8483E31EA
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245592AbhHFWuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232199AbhHFWuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 18:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 81A3961158;
        Fri,  6 Aug 2021 22:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628290205;
        bh=+veC6O9A+A1Jr8yW7O4HZa9d3V82QULRT9YwF4duKGw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pwv9GkZ/LBLpnpLrJH+ms95r8Qr30VO2PPgwvjmpI0g6MqC4hgt/nQw2Mhut0fLlD
         tG9jHtpHwwFSDFaD0FZyBkjk9GhCzmpI/BbWJ8dr23ca+OlQqRB/WFUpmq+62baJ11
         rZRIVHyBcrYbjopruEBAJD9Uhl3PL1L4FVTBzv7DIa759SH+pDLYsCFoNWsC6X6chi
         eKdiWv8wgIHmflfqkJSYQZR/dkR7z/fI7SKi1nfMTMl/TEhMa6UpCFi6urOzYs7pnF
         jAhgEZGQ3E9nH2tHo6AJrhtb/z1bSlNZgg7xHwZJAXTO3aJTD7TpqkVC4CVV/VSt50
         mAchoz903gAig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7676A60A7C;
        Fri,  6 Aug 2021 22:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vrf: fix NULL dereference in vrf_finish_output()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162829020548.2223.7594444447207533817.git-patchwork-notify@kernel.org>
Date:   Fri, 06 Aug 2021 22:50:05 +0000
References: <20210806150435.GB15586@kili>
In-Reply-To: <20210806150435.GB15586@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     dsahern@kernel.org, vvs@virtuozzo.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 6 Aug 2021 18:04:35 +0300 you wrote:
> The "skb" pointer is NULL on this error path so we can't dereference it.
> Use "dev" instead.
> 
> Fixes: 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/vrf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] vrf: fix NULL dereference in vrf_finish_output()
    https://git.kernel.org/netdev/net-next/c/06669e6880be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


