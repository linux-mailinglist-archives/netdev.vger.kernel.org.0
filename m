Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3633FAA5
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCQVud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhCQVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 17:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8579C64F38;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616017809;
        bh=d5XtjcSHPJQtfeGqj7s0touWla4+OK5+RPh/lhmpCTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lFYiCnVqDZyL2NPtffi0K/PajR1wAiQdBgkSUYfG+fUniayNZgL9qkYByOPuPnRcl
         xlL0KW7y6cUm6pWkmSL2BQxfIuaEoCV2di6bUjf3N2/zY74dbAF8x3gcHLePUscEUd
         KcR79DR2gFpg47RFzRiO3Y05DyXsfIcO5tNlsRJplSX2UwXdgbwcvJWa3xbfLmtHFP
         aHU66pFBOBiwJXUhy8XkNb5ZfIVy/yfTJBvpI2UQexFKNL91yIBgmsaGKpZ1SGGSBj
         31mQSJ7UJXbZEJZKAkWeYEY3rOMCWjOwpuUm1CgNF0A/S+p7oAAXlAJOMBfANAGqsy
         gPsrkvj7MfHZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81FB560A60;
        Wed, 17 Mar 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ethernet/microchip:remove unneeded variable: "ret"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601780952.9052.14053371260452183669.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 21:50:09 +0000
References: <20210317123030.70808-1-dingsenjie@163.com>
In-Reply-To: <20210317123030.70808-1-dingsenjie@163.com>
To:     None <dingsenjie@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 20:30:30 +0800 you wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> remove unneeded variable: "ret".
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> ---
>  drivers/net/ethernet/microchip/encx24j600.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [v2] ethernet/microchip:remove unneeded variable: "ret"
    https://git.kernel.org/netdev/net-next/c/ac1bbf8a81d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


