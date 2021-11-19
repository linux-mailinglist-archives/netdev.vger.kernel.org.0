Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8807B456E7F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhKSLxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234088AbhKSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4036861B43;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637322616;
        bh=gp97nb2RlJJlMvJCwaTKRcKGIP37BXkPGh57Fk+RSCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KY8Jvn+J/I+7xJMUTnthiX9U7AnxXFarbcRAsw2xEqH/woTF8A9+ko+Ov0JZpbYWe
         yCYckqciRzqN6NV5EYDA9J/CuXqC61D1FKsfiKCDxt0InaBqVX/mrhFjOjUG4F2TTr
         MbJptm4usUVhi2Lt1QG+OfozbAutwc1m5M1vdzjJgAO/NbCQBpMezTYBVvz7S/rj1z
         QFPJ5wISBR/8HisIYqU0CBhrZfT/rkVmRDFYN/Jwy5R7RYmCbYfmClnw7JeTQtgZ6y
         bnGVuamSMcN8nkF9RR0nG4qR/wAig39aoHGfd9mB4EZQz0O6hA4pBOYdXt/wrotm1Z
         NwziQXYx5yOLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3B1596096E;
        Fri, 19 Nov 2021 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipa: Use 'for_each_clear_bit' when possible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732261623.10547.16818255966892357494.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:50:16 +0000
References: <07566ce40d155d88b60c643fee2d030989037405.1637264172.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <07566ce40d155d88b60c643fee2d030989037405.1637264172.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 20:37:15 +0100 you wrote:
> Use 'for_each_clear_bit()' instead of hand writing it. It is much less
> version.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ipa/ipa_mem.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net: ipa: Use 'for_each_clear_bit' when possible
    https://git.kernel.org/netdev/net-next/c/a6366b13c165

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


