Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7400B34D960
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhC2VAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 17:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229762AbhC2VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A25A61976;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051609;
        bh=EBOtmOVyNY9wgSCREQmI2L9JyqnDwj6iv73uzlExZ7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kKj442M74vkz4o/Cwq0ld6dFDwnFgOg6aScc74Oc2jC5FMrTBazjcnxZ5UWTnYdwZ
         w8yfrwT9cixZbfIiyy5wKXndKcEjmdi9MJPYJzQa9EVZkqBGvP30lsq30zS8gIXmd7
         Pvlozs56FjXArhHCISr7nIY5I7BxQFcVWFdQiIwJATLAuRBotd0U/FwnSaSL/t9tsZ
         ku1xit25QGRGAIdnSqzm9jdhcJjd62Hbw/0Ws9YwC6JTyWpLKpkUQmY2rMl7IMKO+8
         x03fEdi+ljTHQ8ZLQ1CgOLEyn470ZtvlQOqIMoOcoOY25IsAWkNraHIcqqCcCIjgZz
         7N8OlC12eXFLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3AE2660A3B;
        Mon, 29 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gianfar: Handle error code at MAC address change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705160923.24062.8684530701412024464.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 21:00:09 +0000
References: <20210329140847.23110-1-claudiu.manoil@nxp.com>
In-Reply-To: <20210329140847.23110-1-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 17:08:47 +0300 you wrote:
> Handle return error code of eth_mac_addr();
> 
> Fixes: 3d23a05c75c7 ("gianfar: Enable changing mac addr when if up")
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/gianfar.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] gianfar: Handle error code at MAC address change
    https://git.kernel.org/netdev/net/c/bff5b6258512

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


