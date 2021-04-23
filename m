Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03F1369BF8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244059AbhDWVUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232686AbhDWVUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:20:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8C6161410;
        Fri, 23 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212809;
        bh=OcpDgDkpPtnHmUzLDXqi18uM+c/TDTteiMZYs9bdpQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tGWWM1TNNokqr09cwfKeePQ0KfnQ0i+py8Lv9p9EydsTAwpe+GkVp4A57YTlpOVU5
         uHUhi8JgREn5zmnScNPlifUBh8jyNjLlNRBlVgyKpInoeUqbP9m2zweKcxBZwJKket
         G0UkC5bI6Gj5R7Wgic/ig89RujUOgCzHFcuvOhGVAULPUZahigUpOMgRD7vcUfIZkI
         8j67w6KqNrRQFEV0RLNdukokhQ8Mr4ie7KzF5l8olXYzyBrNshXr1IHjN25xJJ3zZM
         KhsYWBN7HKACBdz9mrPHopNEucTw5Et1jD0kmVZgeE1FlkO1X0OJlO4a946eM/jZZl
         HR9NEJUpXscIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFADE60A53;
        Fri, 23 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/atm: Fix spelling mistake "requed" -> "requeued"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921280971.29384.7741105435384068175.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:20:09 +0000
References: <20210423132836.338763-1-colin.king@canonical.com>
In-Reply-To: <20210423132836.338763-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 14:28:36 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a printk message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/atm/iphase.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/atm: Fix spelling mistake "requed" -> "requeued"
    https://git.kernel.org/netdev/net-next/c/cbbd21a47f83

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


